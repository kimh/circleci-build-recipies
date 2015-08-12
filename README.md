[![Circle CI](https://circleci.com/gh/kimh/circleci-build-examples/tree/caching-docker.svg?style=svg)](https://circleci.com/gh/kimh/circleci-build-examples/tree/caching-docker)

#### Caching bundle install with docker

![screenshot](screenshot.png)

Since CircleCI runs your builds with fresh container everytime, Docker images are not cached. (You can find more details [here](https://circleci.com/docs/docker#caching-docker-layers)). This is not good if your docker build contains build instructions that take time.

However, there is a workaround. You can use `docker save` command to export docker images to tarball, upload it to CircleCI cache, and use `docker load` to import the tar in subsequent builds. 

Here is an example of the circle.yml that demonstrates the idea.

```
dependencies:
  cache_directories:
    - /home/ubuntu/docker

  override:
    - if [[ -e ~/docker/image.tar ]]; then echo "Using docker cache"; docker load -i ~/docker/image.tar; fi
    - docker build -t my-image .
    - mkdir -p ~/docker; docker save my-image > ~/docker/image.tar
```

By having this in your circle.yml, `my-image` will be cached and the docker build step finishes immediately.

#### Problem with caching ADD instructions
You will find that above approach doesn't work if your Dockerfile has ADD instructions.


Suppose you put this Dockerfile on the root of your project directory.

```
FROM busybox:latest

RUN apt-get update

WORKDIR /tmp

ADD Gemfile /tmp

RUN bundle install
```

By using `docker save` and `docker load`, the instructions up to `WORKDIR /tmp` are cached. However, you will find that the subsequent instructions from `WORKDIR /tmp` are never cached.
You want to avoid this because `bundle install` will also always run which makes your builds significantly slow. 

Why this happens??

Docker uses mtime of files to invalidate caches for ADD instructions. This means that Docker thinks cache must be invalidated if mtime of files are changed even if file contents are the same.
And here is annoying part: git updates the mtime of files to the time when the repo is cloned. So, when CircleCI clones your repo in the beginning of the build, the mtime of files differ from the last builds and this will
make Docker to invalidate the cache.

#### Solution
To solve this, we will use a hack to update mtime of all of your files. The hack goes to circle.yml.

```
checkout:
  post:
    - find . -exec touch -t 201401010000 {} \;
    - for x in $(git ls-tree --full-tree --name-only -r HEAD); do touch -t $(date -d "$(git log -1 --format=%ci "${x}")" +%y%m%d%H%M.%S) "${x}"; done
```

This goes through the repo after checkout, first resetting every the timestamp for each item to 2014/01/01.
Then, for all files which are tracked by git, we take the timestamp of the last commit that changed this file.

You can see that ADD instructions are cached with this hack at [this build](https://circleci.com/gh/kimh/circleci-build-examples/60).

#### Thanks
I found the hack in [the blog of Tobias Schottdorf](http://tschottdorf.github.io/cockroach-docker-circleci-continuous-integration/).
	


