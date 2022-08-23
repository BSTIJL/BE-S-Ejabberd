#!/bin/sh

chmod +x ./compile.sh

docker run -it --rm \
--platform linux/amd64 \
-v $PWD:$PWD \
-w $PWD \
besociety_ejabberd /bin/bash -c './compile.sh'

rsync -achrvz --delete  ./_build/prod/rel/ejabberd/lib/ ./app/lib/

docker run -it -d \
--network be-society-network \
--name ejabberd  \
--platform linux/amd64 \
-p 5222:5222 \
-p 5223:5223 \
-p 5280:5280 \
-p 5443:5443 \
-v $PWD/conf:/usr/lib/ejabberd/conf \
-v $PWD/app/lib:/usr/lib/ejabberd/lib \
besociety_ejabberd