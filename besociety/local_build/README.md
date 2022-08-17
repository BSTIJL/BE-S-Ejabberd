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
./autogen.sh

./configure \
--with-rebar=/opt/elixir/bin/mix \
--enable-debug \
--enable-pam \
--enable-elixir \
--enable-pgsql \
--enable-redis \
--enable-tools

export PATH=/opt/elixir/bin:$PATH

mix do deps.get, compile
```