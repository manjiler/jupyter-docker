# jupyter-docker

## How to build the image
To build the image locally, run
```commandline
sh build.sh
```

To push the image to a docker repo, you need to see this env DOCKERHUB_REPO
and run 
```commandline
sh build.sh push
```

## How to run the jupyter container

This container uses 2 mounts, one for the notebook and other for the data that will be accessed within the notebook.
For the directory the notebook should be mounted must also be specified as NOTEBOOK_DIR. 
This is where the jupyter would save all the running notebooks to. 
```commandline
docker run -d --name jupyter-ds --mount type=bind,source="$(pwd)"/datascience-exploration,target=/notebooks --mount type=bind,source="$(pwd)"/kaggle_dataset,target=/datasets --env NOTEBOOK_DIR=/notebooks -p 8899:8888 jupyter:latest
```

To get the access token
```commandline
docker exec -it jupyter-ds /bin/bash
/home/datascience/anacond3/bin/jupyter notebook list
```
