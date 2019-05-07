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

### solution 1

1. Rebuild the image locally with the newer tag(version number)
2. Push the new image with new tag to Docker hub
3. Update the yml file with the newer tag

## Miscs

minikube dashboard
`minikube dashboard`