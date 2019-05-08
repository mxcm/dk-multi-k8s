docker build -t yehuizhang/dk-fib-client:latest -t yehuizhang/dk-fib-client:$SHA -f ./client/Dockerfile ./client
docker build -t yehuizhang/dk-fib-server:latest -t yehuizhang/dk-fib-server:$SHA -f ./server/Dockerfile ./server
docker build -t yehuizhang/dk-fib-worker:latest -t yehuizhang/dk-fib-worker:$SHA -f ./worker/Dockerfile ./worker

docker push yehuizhang/dk-fib-client:latest
docker push yehuizhang/dk-fib-server:latest
docker push yehuizhang/dk-fib-worker:latest

docker push yehuizhang/dk-fib-client:$SHA
docker push yehuizhang/dk-fib-server:$SHA
docker push yehuizhang/dk-fib-worker:$SHA

kubectl apply -f k8s
kubectl set image deployment/client-deployment client=yehuizhang/dk-fib-client:$SHA
kubectl set image deployment/server-deployment server=yehuizhang/dk-fib-server:$SHA
kubectl set image deployment/worker-deployment worker=yehuizhang/dk-fib-worker:$SHA