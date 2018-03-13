#!/bin/bash

# Check available versions
gsutil -m ls gs://deepvariant/binaries/DeepVariant/      
#gs://deepvariant/binaries/DeepVariant/0.4.0/
#gs://deepvariant/binaries/DeepVariant/0.4.1/
#gs://deepvariant/binaries/DeepVariant/0.5.0/
#gs://deepvariant/binaries/DeepVariant/0.5.1/
#gs://deepvariant/binaries/DeepVariant/0.5.2/

gsutil -m ls gs://deepvariant/binaries/DeepVariant/0.5.2/
#gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/

# Copy the files
gsutil -m cp -r gs://deepvariant/binaries/DeepVariant/0.5.2/* bin/
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/call_variants.zip...
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/make_examples.zip...
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/model_eval.zip...
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/model_train.zip...
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/run-prereq.sh...
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/settings.sh...
#Copying gs://deepvariant/binaries/DeepVariant/0.5.2/DeepVariant-0.5.2+cl-188008887/postprocess_variants.zip...
chmod +x run-prereq.sh

# Copy the distribution files

cp ../../LICENSE .
cp ../../AUTHORS .

# Patch Dockerfile to fix ARG issue
cp Dockerfile Dockerfile.old
patch < Dockerfile.patch

# Or Edit Dockerfile and changed top two lines
#
#FROM ubuntu:16.04
#
#ENV DV_GPU_BUILD=0

# Build Docker image
docker build --tag deepvariant:0.5.2 .

# Convert Docker image to Singularity image
docker run -v /var/run/docker.sock:/var/run/docker.sock \
-v $HOME/output:/output --privileged -t --rm \
singularityware/docker2singularity deepvariant:0.5.2

# Run Singularity image
singularity exec ~/output/deepvariant_0.5.2-2018-03-13-686add719556.img \
python /opt/deepvariant/bin/make_examples.zip -h

