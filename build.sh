#!/bin/bash


DOCKERHUB_REPO=${DOCKERHUB_REPO:-manojsrivatsav}

docker build -t jupyter:latest --build-arg SPARK_VERSION=3.1.2 --build-arg HADOOP_VERSION=3.2 --build-arg ANACONDA_VERSION=2021.05 . -f Dockerfile

if [[ "$1" == "push" ]]
then
	echo "Publishing the image to public repo"

	docker tag jupyter:latest $DOCKERHUB_REPO/jupyter-spark:latest

	docker push $DOCKERHUB_REPO/jupyter-spark:latest
fi

