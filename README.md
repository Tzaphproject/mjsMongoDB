[![MIT](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic)](http://opensource.org/licenses/MIT)

# MeteorJS MongoDB docker image
Welcome, I've created this image to be able to deploy meteor JS applications using MongoDB.

The MongoDB that I have configured here uses replica sets **meteormongo** for Oplog tailing.

@see http://www.manuel-schoebel.com/blog/meteorjs-and-mongodb-replica-set-for-oplog-tailing

All commands listed below should be ran as root (#) or if ran as a normal user ($) using sudo.
## Image building
Run the following command in the project's folder:

*NB: make sure you replace the username/imageName by your own.*

```
# docker build -t tzaphkiel/mjsmongodb .
```


## Installation
```
# docker run -d -p 27016:27017   --name mjsMongoDB -v /opt/docker/mjsMongoDB/:/data/db tzaphkiel/mjsmongodb
```

## Post-installation
### Start
```
# docker start mjsMongoDB
```

### Stop
```
# docker stop mjsMongoDB
```

### Information
```
# docker insect mjsMongoDB
```

## Miscellaneous
## Docker command aliases
Some useful aliases to manipulate docker:

```
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dp='docker port'
alias ds='docker search'
```

### Interactive shell in image
__Warning__: if ran, the usual command starting the mongoDB (mongo.sh) will not be called.

```
# docker run -t -i -P tzaphkiel/mjsmongodb /bin/bash

```
