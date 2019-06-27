# Quick Start

Check out this code from git and run `docker-compose up` then give the containers a bit to get started.

## Setting the root password

After the containers are started open http://localhost.  You should be prompted to create a password.  You are 
creating the password for the user "root".

## Setting up the GitLab Runner

Run the gitlab-runner register command using the docker container.  You will need to do this in a second terminal
as the system needs to be up.

`docker exec -it gitlab-runner gitlab-runner register --docker-privileged true`

**Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):**

http://gitlab/

**Please enter the gitlab-ci token for this runner:**

(Copy from the Admin->Overview->Runners screen aka http://localhost/admin/runners )

**Please enter the gitlab-ci description for this runner:**

(I used "docker")

**Please enter the gitlab-ci tags for this runner (comma separated):**

docker

**Please enter the executor: docker-ssh, virtualbox, docker+machine, docker-ssh+machine, docker, parallels, shell, ssh, kubernetes:**

docker

**Please enter the default Docker image (e.g. ruby:2.6):**

docker:stable

---

Refresh the runners page and you should see the new runner (http://localhost/admin/runners).

Edit the runner and turn on "Run untagged jobs".

---

Edit the file ./srv/gitlab-runner/config/config.toml:

```toml
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "docker"
  url = "http://gitlab/"
  token = "55Fbsdz99SKcN8spro5r"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.docker]
    tls_verify = false
    image = "docker:stable"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
    shm_size = 0
    network_mode = "gitlabnew_default"
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]

```

Make note of the "volumes", "privileged" and "network_mode".  

"Volumes" should include "/var/run/docker.sock:/var/run/docker.sock".

"privileged" should be true.

"network_mode" should be the docker network that the containers all run in.  Run the command 
`docker inspect gitlab-runner -f "{{json .NetworkSettings.Networks }}"` to see the network name.  It will be the
first key.

# Local Docker Repository 

To use the local Docker repository:

`docker build -t test .`

`docker tag test localhost:5000/test`

`docker push localhost:5000/test`
