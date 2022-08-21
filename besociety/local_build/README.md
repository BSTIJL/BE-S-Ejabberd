## How to build Ejabberd locally .

Enter the folder where the project is and execute the command follows:
```
docker build \
--platform linux/amd64 \
-t build_vm  \
-f besociety/local_build/Dockerfile .
```

Start the Docker.
```
docker run -d \
--network host \
--name ejabberd  \
--platform linux/amd64 \
-p 5222:5222 \
-p 5223:5223 \
-p 5280:5280 \
-p 5443:5443 \
-v $PWD:$PWD \
-w $PWD \
build_vm
```

