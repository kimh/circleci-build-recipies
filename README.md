### Caching with Docker Hub
This branch demonstrates how we can use Docker Hub to cache docker images on CircleCI.

We will use these tagged image:

- `kimh/build-image:scratch`: This image is only used to take the advantage of cache
- `kimh/build-image:staging`: This image is the that you want to deploy to stating env
- `kimh/build-image:production`: This image is the that you want to deploy to production env

In the `circle.yml` we first build images with staging and production Dockerfile but tag 


