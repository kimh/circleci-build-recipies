[![Circle CI](https://circleci.com/gh/kimh/circleci-build-recipies.svg?style=svg&circle-token=6c9e0e9204d266b2de110f155a4d1133bc8f0abb)](https://circleci.com/gh/kimh/circleci-build-examples/tree/gcr-example)

## Integration with GCR (Google Container Registry)
This example shows how to push your docker images to GCR.

### Install gcloud command manually
gcloud command is not installed in our container image, so you have to install it via curl. Please see the circle.yml for how to do it.

### Find your GCR host
You need to change GCR host according to your region. The list of available hosts are here. You can change the host by modifying $GCR_HOST env var in the circle.yml.

### Setup service account credential
In order to run gcloud commands for your project, you need to setup a service account and save the credential. Please go to your project in Google Developer Console and go to "APIs & auth" -> "Credentials" page. You can generate a JSON key in the page and download the key file.

Now, you have to store the key file in CircleCI build so that you can use it from builds for authentication. Although there are many ways to this, I've stored the key file in environmental variable called $GOOGLE_SECRET_JSON from CircleCI web UI since it's the perfect place to store sensitive data. You just need to copy the whole content of the key file and paste it as the value of $GOOGLE_SECRET_JSON env var.

Once you are done with these, you are now ready to push docker images to GCR. You just need to build your image and use "gcloud docker push" command. Please see the deployment section of the cirle.yml for more details.
