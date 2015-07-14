[mjsMongoDB]()
==============

[![MIT](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic)](http://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/maturity-under_dev-red.svg?style=plastic)]()
[![Docker Stars](https://img.shields.io/docker/stars/tzaphkiel/mjsmongodb.svg?style=plastic)](https://hub.docker.com/u/tzaphkiel/mjsmongodb/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tzaphkiel/mjsmongodb.svg?style=plastic)](https://hub.docker.com/u/tzaphkiel/mjsmongodb/)

*Please note that this project is at a very early development stage.*

*I'll be testing, refining & updating it in the forthcoming days? weeks? months?*

# MeteorJS MongoDB docker image
I have created this docker image as part of a multiple set I plan to use on my server. The plan is to deploy MeteorJS applications using docker containers on any server infrastructure allowing docker to run.

This particular image defines a Mongo database using replica sets (here named: *meteormongo*) for Oplog tailing.

@see http://www.manuel-schoebel.com/blog/meteorjs-and-mongodb-replica-set-for-oplog-tailing

This container could be used by multiple (and probably individual) application containers linking to it for their data store requirements.

The following port and data volume will be exposed (if -P or -p flag is used):

    # port  : 27017 (container)
    # volume: /data/db (container) 

To use container linking, please read the docker guides or refer to the quick examples and descriptions done below.
The commands listed below will show you how to build the image, install it with host mappings (port & data volume mount point), control it, etc.

*All commands listed below should be ran as root (# prompt) or if ran as a normal user ($ prompt), pre-pended by sudo.*

# Image manipulation
## Building
Run the following command in the project's folder to build a new image if you have modified the scripts or Dockerfile:

*NB: make sure you replace the username/imageName by your own if you are not a contributor.*

    # docker build -t tzaphkiel/mjsmongodb .

## Upload
*This section is not available anymore as the project is built and uploaded automatically by Github with Docker hub. One can refer to the docker guides for reference if need be.*

## Installation
**using port publishing on the host:**

*(i.e.: the container has to be accessed by the host system not another container)*

    # docker run -d -p 27016:27017 --name mjsMongoDB -v /opt/mjsMongoDB/:/data/db tzaphkiel/mjsmongodb

**Using container linking:**
*(i.e.: the container has only to be accessed by other docker containers)*

    # docker run -d --name mjsMongoDB -v /opt/mjsMongoDB/:/data/db tzaphkiel/mjsmongodb

*NB: this can (and will be) pushed even further, by not exposing a local volume but a container volume (later)*

## Post-installation
**Start**

    # docker start mjsMongoDB

**Stop**

    # docker stop mjsMongoDB

**Information**

    # docker insect mjsMongoDB

# Miscellaneous
## Docker command aliases
Some useful aliases to manipulate docker:
    
    # if needed
    alias docker="sudo docker"
    # useful docker aliases
    alias d='docker'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias dp='docker port'
    alias ds='docker search'

## Interactive shell in image
__Warning__: if ran, the usual command starting the mongoDB (mongo.sh) will not be called.

    # docker run -t -i tzaphkiel/mjsmongodb /bin/bash
