#!/bin/bash
mongoLockFile=/data/db/mongod.lock

if [ -f $mongoLockFile ]; then
    rm $mongoLockFile
fi

# Double check that initialization was done from the docker file (if run from docker)
if [ -f /data/db/.initDone ]; then
  echo "MongoDB initialization already done!"
else
  echo "Running mongo first time initialization script(s)"
  ./mongoInit.sh
fi

# Preparing the command to execute
# --port:
#     even though it is the default port, make sure it stays that way
# --directoryperdb
#     Uses a separate directory to store data for each database
cmd="mongod --port ${MONGO_PORT} --directoryperdb --storageEngine $DATABASE_ENGINE"

if [ "$REPLICA_SET_NAME" != "" ]; then
    cmd="$cmd --replSet ${REPLICA_SET_NAME}"
fi

if [ "$AUTH" == "true" ]; then
    cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "false" ]; then
    cmd="$cmd --nojournal"
fi
# This is set already at init to 5% of available disk size!
# if changed here, it has no effect (see doc)
#if [ "$OPLOG_SIZE" != "" ]; then
#    cmd="$cmd --oplogSize $OPLOG_SIZE"
#fi

echo "Executing: [ $(cmd) ]"

exec $cmd

