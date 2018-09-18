#!/bin/sh 
set -e

airQualityApiHome=/data/air-quality-api
dateTime=`date +"%Y%m%d%H%M%S"`

if [ -z "$1" ]; then
  echo "{dateTime} - No argument supplied." >> ${airQualityApiHome}/airQualityApi.log
  echo "{dateTime} - e.g. ./airQualityApi.sh start" >> ${airQualityApiHome}/airQualityApi.log
  echo "{dateTime} - e.g. ./airQualityApi.sh stop" >> ${airQualityApiHome}/airQualityApi.log
  echo "{dateTime} - e.g. ./airQualityApi.sh deploy" >> ${airQualityApiHome}/airQualityApi.log
  exit 1
fi

command=$1

cd ${airQualityApiHome}

if [ ${command} == "start" ]
then
  ## Starting API
  echo "{dateTime} - Starting API." >> ${airQualityApiHome}/airQualityApi.log
  docker-compose up -d --build
  exit 0

elif [ ${command} == "stop" ]
then
  ## Stopping API
  echo "{dateTime} - Stopping API." >> ${airQualityApiHome}/airQualityApi.log
  docker-compose down
  exit 0

elif [ ${command} == "deploy" ]
then
  ## Deploying API
  echo "{dateTime} - Deploying API." >> ${airQualityApiHome}/airQualityApi.log
  docker-compose down
  git pull
  docker-compose up -d --build
  exit 0

else
  ## Invalid parameter
  echo "${dateTime} - Input ${command} do NOT match required input" >> ${airQualityApiHome}/airQualityApi.log
  echo "{dateTime} - e.g. ./airQualityApi.sh start" >> ${airQualityApiHome}/airQualityApi.log
  echo "{dateTime} - e.g. ./airQualityApi.sh stop" >> ${airQualityApiHome}/airQualityApi.log
  exit 1
fi
