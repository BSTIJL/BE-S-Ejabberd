## How to build Ejabberd locally .

Enter the folder where the project is and execute the command follows:
```
docker build \
--platform linux/amd64 \
-t build_vm  \
-f besociety/local_build/Dockerfile .
```

```
docker run -it --rm \
--name ejabberd  \
--platform linux/amd64 \
-v $PWD:$PWD \
-w $PWD \
build_vm /bin/bash
```

In side the docker, execute:

```
./configure \
--with-rebar=rebar3 \
--enable-debug \
--enable-elixir \
--enable-pgsql \
--enable-redis \
--enable-tools
make
```