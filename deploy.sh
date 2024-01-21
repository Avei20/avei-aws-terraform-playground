#!/bin/bash

ROOT_DIR=$(pwd) && \
# Installing Dependency
yarn install && \ 
yarn build && \
# zipping file
cd terraform && \
find . -name "*.zip" -type f -delete && \
# Zip all the code
cd .. 
zip -r ${ROOT_DIR}/terraform/zips/nest-zipped.zip ${ROOT_DIR}
