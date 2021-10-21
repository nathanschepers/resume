#!/bin/bash

today=`date '+%Y%m%d'`

cd ..
bundle exec jekyll clean
bundle exec jekyll build

bundle exec jekyll serve &
serve_pid=$!

sleep 2
wkhtmltopdf --image-dpi 300 -L 0mm -R 0mm --javascript-delay 2000 http://localhost:4000 ./_site/resume-$today.pdf

kill -2 $serve_pid

cp favicon.ico _site/
rm _site/README.md

# assumes that awscli is installed and appropriate keys are configured to write to this bucket
# provide the appropriate bucket name on the command line
cd _site/
aws s3 rm s3://$1 --recursive
aws s3 cp --recursive . s3://$1 --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

for id in $(aws cloudfront list-distributions --query "DistributionList.Items[*].{id:Id,origin:Origins.Items[0].Id}[?origin=='S3-$1'].id" --output text);
  do aws cloudfront create-invalidation --distribution-id $id --paths "/*";
done;
