# Quick Start

When you are setting the password you are setting the password for user "root".

After you bing up the Docker images with `docker-compose`, up exec into the docker container for gitlab-runner and 
run `gitlab-runner register`. 

For the host use `http://gitlab/`.

For the token go to the http:\\locahost gitlab and Admin->Overview->Runners and copy the token.

Description `alpine`.

Tag `alpine`.

Executor `docker`.

Docker Image `alpine:latest`.
