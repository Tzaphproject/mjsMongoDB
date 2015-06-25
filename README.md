[![MIT](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic)](http://opensource.org/licenses/MIT)

# MeteorJS MongoDB docker image
I have created this docker image as part of a multiple set of images I plan to use on my server to deploy MeteorJS applications.
This particular image defines a Mongo database using replica sets (here named: *meteormongo*) for Oplog tailing.

@see http://www.manuel-schoebel.com/blog/meteorjs-and-mongodb-replica-set-for-oplog-tailing

The following port and data volume will be exposed:

    # port  : 27017 (container)
    # volume: /data/db (container) 

Using the commands listed below, you'll be able to build the image, install it with host mappings (port & data volume mount point) & control it.

*All commands listed below should be ran as root (#) or if ran as a normal user ($) using sudo.*

# Image manipulation
## Building
Run the following command in the project's folder:

*NB: make sure you replace the username/imageName by your own.*

    # docker build -t tzaphkiel/mjsmongodb .

## Upload
*NB: this part is automated by Github and Docker hub and is listed here fore reference only.*

    # docker images
    REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    tzaphkiel/mjsmongodb   latest              47f8058eb460        About an hour ago   367.6 MB
    
    # docker tag tzaphkiel/mjsmongodb:v0.1 
    # docker push tzaphkiel/mjsmongodb

## Installation

    # docker run -d -p 27016:27017 --name mjsMongoDB -v /opt/mjsMongoDB/:/data/db tzaphkiel/mjsmongodb

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

    alias d='docker'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias dp='docker port'
    alias ds='docker search'

## Interactive shell in image
__Warning__: if ran, the usual command starting the mongoDB (mongo.sh) will not be called.

    # docker run -t -i -P tzaphkiel/mjsmongodb /bin/bash
