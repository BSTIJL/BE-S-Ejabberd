## How to build Ejabberd locally .

Enter the folder where the project is and execute the command follows:
```
docker build \
--platform linux/amd64 \
-t besociety_ejabberd  \
-f ./Dockerfile .
```

Start the Docker.
```
docker run -it --rm \
--network be-society-network \
--name ejabberd  \
--platform linux/amd64 \
-p 5222:5222 \
-p 5223:5223 \
-p 5280:5280 \
-p 5443:5443 \
-v $PWD/conf:/usr/lib/ejabberd/conf \
-v $PWD/_build/prod/rel/ejabberd/lib:/usr/lib/ejabberd/lib \
besociety_ejabberd
```
