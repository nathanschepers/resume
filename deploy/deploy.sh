#!/bin/bash

cd ..
bundle exec jekyll clean && bundle exec jekyll build
cp favicon.ico _site/
cd _site/
rm README.md 

# assumes that awscli is installed and appropriate keys are configured to write to this bucket
# provide the appropriate bucket name on the command line
aws s3 rm s3://$1 --recursive
aws s3 cp --recursive . s3://$1 --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
