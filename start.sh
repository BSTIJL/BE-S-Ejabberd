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
--name ejabberd_conversejs  \
--platform linux/amd64 \
-p 8222:8222 \
-p 8280:8280 \
-v $PWD/conf:/usr/lib/ejabberd/conf \
-v $PWD/app/lib:/usr/lib/ejabberd/lib \
besociety_ejabberd