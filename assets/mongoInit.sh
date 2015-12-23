#!/bin/bash
mongoLockFile=/data/db/mongod.lock

if [ -f $mongoLockFile ]; then
    rm $mongoLockFile
fi

# exit early if this script has been run already
if [ -f /data/db/.initDone ]; then
  exit 0
fi

# Launch mongo to do some setup.
# --port:
#     even though it is the default port, make sure it stays that way
#     
# --directoryperdb
#     Uses a separate directory to store data for each database
# 
# --replSet <setname>
#     Configures replication
#
# --oplogSize <value>
#     For 64-bit systems, the oplog size is typically 5% of available disk space
availDiskSpace=$(df -k / | tail -1 | awk '{print $4}')
oplogSize=$(($availDiskSpace*5/100))

if [ "$JOURNALING" == "false" ]; then
  mongod --port ${MONGO_PORT} --replSet ${REPLICA_SET_NAME} --oplogSize ${oplogSize} --directoryperdb --storageEngine $DATABASE_ENGINE --nojournal &
else
  mongod --port ${MONGO_PORT} --replSet ${REPLICA_SET_NAME} --oplogSize ${oplogSize} --directoryperdb --storageEngine $DATABASE_ENGINE &
fi

# wait for mongod to start
RET=1
printf "Pending mongod availability..."
while [[ RET -ne 0 ]]; do
  printf "."
  sleep 5
  mongostat -n 1 >/dev/null 2>&1
  RET=$?
done
printf "\n"

# Generate admin user & password
#  check for existing MONGODB_PW env var (user-set) or generate
PW=${MONGODB_PW:-$(pwgen -n -s -B 32 1)}
PW_TYPE=$( [ ${MONGODB_PW} ] && echo "user-set" || echo "generated" )
echo ""
echo "Setting up MongoDB: "
echo "  - creation of the replica set configuration..."
mongo admin --eval "rs.initiate({_id: '${REPLICA_SET_NAME}', members: [{_id: 0, host:'127.0.0.1:27017'}]})"
echo "  - creation of the admin user (with a ${PW_TYPE} password)..."
mongo admin --eval "db.createUser({user: 'admin', pwd: '$PW', roles:[{role:'root',db:'admin'}]});"
echo "Shuting down MongoDB..."
mongo admin --eval "db.shutdownServer({force: 1});"
echo "All done !"

# *** AT THE MOMENT NOT POSSIBLE TO CHANGE 
# *** grub.conf or read only file system with docker buildFile
# *** :(
# 
# Fix following issue in mongod startup:
# WARNING: /sys/kernel/mm/transparent_hugepage/enabled is 'always'.
#   We suggest setting it to 'never'
# WARNING: /sys/kernel/mm/transparent_hugepage/defrag is 'always'.
#   We suggest setting it to 'never'
#   
# i.e.: Tune Linux for MongoDB
# @see http://docs.mongodb.org/manual/tutorial/transparent-huge-pages/
# 
# remove last line (exit 0)
#sed -i "s/exit 0//" /etc/rc.local
# append fix and restore last line
#read -r -d '' REPLACE <<-'EOF'
#
## Fix & Tune Linux for MongoDB
#if test -f /sys/kernel/mm/transparent_hugepage/khugepaged/defrag; then
#  echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
#fi
#if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
#  echo never > /sys/kernel/mm/transparent_hugepage/defrag
#fi
#if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
#  echo never > /sys/kernel/mm/transparent_hugepage/enabled
#fi
#
#exit 0
#EOF
#echo "$REPLACE" >> /etc/rc.local
#
#echo "NB: the THP fix will be active at next restart of the container !"


# make sure this script is only run once !
touch /data/db/.initDone
echo ""
echo ""
echo "======================================================================"
echo ""
echo "                        MongoDB is now ready ! "
echo ""
echo " You can connect to the database using the following information:"
echo ""
echo "    - user:     admin"
echo "    - password: ${PW}"
echo ""
echo " e.g.: "
echo "    mongo admin -u admin -p ${PW} --host <host> --port <port>"
echo ""
if [ ${PW_TYPE} == "generated" ]; then
  echo " This is a generated password, please change it as soon as possible!"
fi;
echo ""
echo "======================================================================"
echo ""
echo ""

