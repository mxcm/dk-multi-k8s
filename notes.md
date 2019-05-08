# Building notes

To create a secret:

`kubectl create secret generic <secret_name> --from-literal <key>=<value>`



## Git
Using two github accounts on same machine (mac)
[link](https://medium.freecodecamp.org/manage-multiple-github-accounts-the-ssh-way-2dadc30ccaca)

```bash
ssh-add -l # list all ssh keys
ssh-add -D # remove all keys
ssh-add .ssh/id_rsa_name  # Add the proper key.
```

## To update the image

### Solution 1

1. Rebuild the image locally with the newer tag(version number)
2. Push the new image with new tag to Docker hub
3. Update the yml file with the newer tag

### Solution 2

1. Rebuild image locally without tag
2. Push the new image to Docker hub
3. In terminal, run

```bash
kubectl get deployments # Get running deployments
kubectl set image deployment/<name> <container_name>=<image_name>:<tag>
```

## Miscs

minikube dashboard
`minikube dashboard`

## Google Cloud Instructions

One helpful [link](https://cloud.google.com/solutions/continuous-delivery-with-travis-ci#create_a_service_account)

### Install travis cli

1. Create ruby container. Also set the current directory as volume for the container to access the credential.
`docker run -it -v $(pwd):/volume-local ruby:2.3 sh`
2. Install travis cli
`gem install travis`
3. Log in to Travis CI.
`travis login` or `travis login --pro` if using travis-ci.com (pro version)
4. Enter github account to login
5. Encrypt the credential json file locally
`travis encrypt-file service-account.json -r mxcm/dk-multi-k8s`
6. move the `openssl` command into the travis.yml file under `before_install` section. 
7. Add configures in `.travis.yml`.
8. Add docker hub `$DOCKER_USERNAME` and `$DOCKER_PASSWORD` in repo setting of travis-ci.org.
    - Use the git commit's SHA as the version number of the docker image for better identification and updating. 
9. setup PGPASSWORD on GoogleCloud shell. 
    - `gcloud config set conpute/zone us-west1-a`
    - `gcloud container clusters get-credentials multi-k8s-cluster`
    - `kubectl create secret generic pgpassword --from-literal PGPASSWORD=mypassword`
10. Install nginx-ingress
    - [Instruction](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)
    - [Install heml](https://helm.sh/docs/using_helm/#from-script) on Google Cloud shell
        - `curl -LO https://git.io/get_helm.sh`
        - `chmod 700 get_helm.sh`
        - `./get_helm.sh`
        - [Special setup for Google cloud](https://helm.sh/docs/using_helm/#gke)
        - `kubectl create serviceaccount --namespace kube-system tiller`
        - `kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller`
        - `helm init --service-account tiller --upgrade`
        - `helm install stable/nginx-ingress --name my-nginx --set rbac.create=true`
11. Deploy! Commit and push to github.

## Update in production

1. Checkout a feature branch
2. Make changes, commit and push to github.
3. Create pull request. Wait to get approved by travis-ci. 
4. Merge feature branch to master.
5. Check changes on production.

## Cleanup

1. Start/stop minikube `minikube start` & `minikube stop`
2. Stop containers `docker ps` & `docker stop <container_id>`
3. Clear docker cache. `docker system prune`