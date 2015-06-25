[![MIT](https://img.shields.io/github/license/mashape/apistatus.svg?style=plastic)](http://opensource.org/licenses/MIT)
[![Docker Stars](https://img.shields.io/docker/stars/_/ubuntu.svg?style=plastic)]()

# MeteorJS MongoDB docker image
Welcome, I've created this image to be able to deploy meteor JS applications using MongoDB.
The MongoDB that I have configured here uses replica sets **meteormongo** for Oplog tailing.
@see http://www.manuel-schoebel.com/blog/meteorjs-and-mongodb-replica-set-for-oplog-tailing

## Image building
Run the following command in the project's folder:
NB: make sure you replace the username/imageName by your own.

```
d build -t tzaphkiel/mjsmongodb .
```




## Installation
```
d run -d -p 27016:27017   --name mjsMongoDB -v ~/docker/mjsMongoDB/vol/:/data/db tzaphkiel/mjsmongodb
```

## Post-installation
### Start
```
d start mjsMongoDB
```

### Stop
```
d stop mjsMongoDB
```

### Information
```
d insect mjsMongoDB
```

## Miscellaneous
## Docker command aliases
Some useful aliases to manipulate docker:

```
alias d='sudo docker'
alias dps='sudo docker ps'
alias dpsa='sudo docker ps -a'
alias dp='sudo docker port'
alias ds='sudo docker search'
```

### Interactive shell in image
__Warning__: if ran, the usual command starting the mongoDB (mongo.sh) will not be called.

```
d run -t -i -P tzaphkiel/mjsmongodb /bin/bash

```
