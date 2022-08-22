#!/bin/bash

chmod +x ./compile.sh

docker run -it --rm \
--platform linux/amd64 \
-v $PWD:$PWD \
-w $PWD \
besociety_ejabberd /bin/bash -c './compile.sh'



