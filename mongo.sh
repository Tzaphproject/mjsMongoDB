#!/bin/bash

if [ -f /data/db/.initDone ]; then
  echo "MongoDB initialization already done!"
else
    /mongoFirstRun.sh
fi

# --port:
#     even though it is the default port, make sure it stays that way
# --directoryperdb
#     Uses a separate directory to store data for each database
cmd="mongod --port 27017 --directoryperdb --storageEngine $DATABASE_ENGINE"

if [ "$REPLICA_SET_NAME" != "" ]; then
    cmd="$cmd --replSet ${REPLICA_SET_NAME}"
fi

if [ "$AUTH" == "true" ]; then
    cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "false" ]; then
    cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

mongoLockFile=/data/db/mongod.lock
if [ -f $mongoLockFile ]; then
    rm $mongoLockFile
fi

exec $cmd
