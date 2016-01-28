### Caching with Docker Hub
This branch demonstrates how we can use Docker Hub to cache docker images on CircleCI.

What we are doing in `circle.yml` is very simple:

- Pull image from Docker Hub that was pushed from previous builds
- Build image from Dockerfile
- Push the image back to Docker Hub for the subsequent builds

In short, we are using Docker Hub as our image cache store.

To see how caching works, you can compare [this](https://circleci.com/gh/kimh/circleci-build-recipies/120) and [this](https://circleci.com/gh/kimh/circleci-build-recipies/120) builds.

In the first build, `docker build` took about 3 mins and `docker push` took 2 mins, but both commands finish immediately in the second build thanks to cache.
