#!/bin/bash

chmod +x compile.sh

docker run -it --rm \
--name ejabberd  \
--platform linux/amd64 \
-v $PWD:$PWD \
-w $PWD \
build_vm /bin/bash -c 'compile.sh'



