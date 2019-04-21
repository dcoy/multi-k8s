#! /bin/bash

docker build -t dcoy/multi-client:latest -t dcoy/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t dcoy/multi-server:latest -t dcoy/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t dcoy/multi-worker:latest -t dcoy/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push dcoy/multi-client:latest
docker push dcoy/multi-client:$SHA

docker push dcoy/multi-server:latest
docker push dcoy/multi-server:$SHA

docker push dcoy/multi-worker:latest
docker push dcoy/multi-worker:$SHA


kubectl apply -f k8s -R
kubectl set image deployment/server-deployment server=dcoy/multi-server:$SHA
kubectl set image deployment/client-deployment server=dcoy/multi-client:$SHA
kubectl set image deployment/worker-deployment server=dcoy/multi-worker:$SHA