[![Circle CI](https://circleci.com/gh/kimh/circleci-build-examples/tree/gcr-example.svg?style=svg)](https://circleci.com/gh/kimh/circleci-build-examples/tree/docker-ramdisk)

## Using ramdisk for Docker storage
This example shows how to use ramdisk for Docker storage. The intention of using ramdisk is to see if we have a performance gain for docker export/load and docker IO peformance in general.

### Note
This example is still under experiment and we do not know if we can improve Docker IO performance.
