
# Docker Environment Command

```
Source tutorials
- Saturn Cloud
  - https://www.youtube.com/watch?v=b4w_TKp6s38
  - https://saturncloud.io/blog/how-to-build-custom-docker-images-for-aws-sagemaker/
- AWS
  - https://docs.aws.amazon.com/sagemaker/latest/dg/docker-containers-adapt-your-own.html


# Make sure permission is given to the IAM roles & you are configured as IAM users on AWS ECR
https://stackoverflow.com/questions/38587325/aws-ecr-getauthorizationtoken
https://stackoverflow.com/questions/70828205/pushing-an-image-to-ecr-getting-retrying-in-seconds

# Build the docker file in current directory name tag *custom-donut-env-kernel* as name with tag *latest*
docker image build -t custom-donut-env-kernel:latest .

# Before we push our image to AWS ECR, we need to authenticate our docker CLI to our AWS ECR using the following command:
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 055100700552.dkr.ecr.us-west-1.amazonaws.com

# Let docker know where to store image
docker image tag custom-donut-env-kernel:latest 055100700552.dkr.ecr.us-west-1.amazonaws.com/custom-donut-env-kernel:latest

# Push
docker push 055100700552.dkr.ecr.us-west-1.amazonaws.com/custom-donut-env-kernel:latest

```