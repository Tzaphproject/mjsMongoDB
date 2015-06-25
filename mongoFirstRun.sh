#!/bin/bash

mongoLockFile=/data/db/mongod.lock
if [ -f $mongoLockFile ]; then
    rm $mongoLockFile
fi

# --port:
#     even though it is the default port, make sure it stays that way
#     
# --directoryperdb
#     Uses a separate directory to store data for each database
#     
# --smallfiles :  
#     reduces the initial size for data files and limits the maximum size to 512 megabytes
#     reduces the size of each journal file from 1 gigabyte to 128 megabytes
#                 
#   ATT:  this option can lead the mongod instance to create a large number of files, 
#         which can affect performance of larger databases !
#         
# Launch mongo to do some setup.
# 
if [ "$JOURNALING" == "false" ]; then
    mongod --port 27017 --directoryperdb --storageEngine $STORAGE_ENGINE --smallfiles --nojournal &
else
    mongod --port 27017 --directoryperdb --storageEngine $STORAGE_ENGINE --smallfiles &
fi

#  1. Generate admin user & password
#     Check for existing MONGODB_PW env var (user-set) or generate
#     

# wait for mongod to start
RET=1
while [[ RET -ne 0 ]]; do
    echo "Pending mongod availability..."
    sleep 5
    mongostat -n 1 >/dev/null 2>&1
    RET=$?
done

# 2. create admin user and replica set for meteor oplog
# 
PW=${MONGODB_PW:-$(pwgen -n -s -B 32 1)}
PW_TYPE=$( [ ${MONGODB_PW} ] && echo "user-set" || echo "generated" )
echo
echo "Setting up the MongoDB : "
echo "  - creation of the admin user (with a ${PW_TYPE} password)..."
mongo admin --eval "db.createUser({user: 'admin', pwd: '$PW', roles:[{role:'root',db:'admin'}]});"
echo "  - creation of the replica set configuration..."
mongo admin --eval "rs.initiate({_id: '${REPLICA_SET_NAME}', members: [{_id: 0, host:'127.0.0.1:27017'}]})"

echo "Shuting down MongoDB..."
mongo admin --eval "db.shutdownServer();"
echo "Done !"
touch /data/db/.initDone


echo "========================================================================"
echo ""
echo "                        MongoDB is now ready ! "
echo ""
echo "You can connect to the database using the following information:"
echo ""
echo "    - user:     admin"
echo "    - password: ${PW}"
echo ""
echo "e.g.: "
echo "    mongo admin -u admin -p ${PW} --host <host> --port <port>"
echo ""
if [ ${PW_TYPE} == "generated" ]; then
  echo "This is a generated password, please change it as soon as possible!"
fi;
echo ""
echo "========================================================================"

