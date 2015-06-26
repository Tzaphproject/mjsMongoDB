# MongoDB for MeteorJS applications
# Version: 3.0.4 (with updates blocked to that version)
# 
FROM ubuntu:14.04
MAINTAINER Sébastien Leroy <Leroy.milamber@gmail.com>

# Install MongoDB 
# @see http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
# @see http://www.manuel-schoebel.com/blog/meteorjs-and-mongodb-replica-set-for-oplog-tailing
# 
# NB: running all commands in one line to avoid spanwning multiple containers
# 
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
  apt-get update && \
  apt-get install -y pwgen mongodb-org=3.0.4 mongodb-org-server=3.0.4 mongodb-org-shell=3.0.4 mongodb-org-mongos=3.0.4 mongodb-org-tools=3.0.4 && \
  echo "mongodb-org hold" | dpkg --set-selections && \
  echo "mongodb-org-server hold" | dpkg --set-selections && \
  echo "mongodb-org-shell hold" | dpkg --set-selections  && \
  echo "mongodb-org-mongos hold" | dpkg --set-selections && \
  echo "mongodb-org-tools hold" | dpkg --set-selections


# where to store the data (host)
# 
VOLUME /data/db

# Some configuration parameters
# 
ENV AUTH=true REPLICA_SET_NAME=meteormongo DATABASE_ENGINE=wiredTiger JOURNALING=true

# some init & config scripts
# 
ADD mongo.sh /mongo.sh
ADD mongoFirstRun.sh /mongoFirstRun.sh


# expose the port host:container
# 
EXPOSE 27017 27017


# Start the dtabase
# 
CMD ["/mongo.sh"]
