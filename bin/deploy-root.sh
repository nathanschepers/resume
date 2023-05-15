#!/bin/bash

# import helpers
. ./helpers.sh

# import the environment
. ./env.sh

SRC_DIR=${RESUME_PROJECT_ROOT}/src
STAGE_DIR=${RESUME_PROJECT_ROOT}/stage

cd "${SRC_DIR}"
coloredEcho "Building static site." blue
bundle install >/dev/null
bundle exec jekyll clean -d "${STAGE_DIR}" >/dev/null
bundle exec jekyll serve -d "${STAGE_DIR}" >/dev/null &
SERVE_PID=$!
sleep 2

coloredEcho "Generating PDFs." blue
wkhtmltopdf -L 0mm -R 0mm --javascript-delay 2000 http://localhost:4000 "${STAGE_DIR}/resume.pdf" >/dev/null 2>&1

kill -2 ${SERVE_PID}

convert -density 125 -quality 75 "${STAGE_DIR}/resume.pdf" "${STAGE_DIR}/resume-small.pdf"

# copy to Azure
coloredEcho "Removing old resume. (${RESUME_AFD_DOMAIN})" blue
az storage blob delete-batch \
  --connection-string "${AZURE_STORAGE_CONNECTION_STRING}" \
  --source "${RESUME_STORAGE_CONTAINER}" \
  --pattern "*" \

coloredEcho "Copying to storage. (${RESUME_AFD_DOMAIN})" blue
az storage blob upload-batch \
  --connection-string "${AZURE_STORAGE_CONNECTION_STRING}" \
  --destination "${RESUME_STORAGE_CONTAINER}" \
  --destination-path "/" \
  --source "${STAGE_DIR}" \
  --tier Cool > /dev/null

coloredEcho "Purging the AFD endpoint cache. (${RESUME_AFD_ENDPOINT_NAME}/)" blue
az afd endpoint purge \
  --content-paths "/*" \
  --domain ${RESUME_AFD_DOMAIN} \
  --resource-group ${RESUME_AFD_RESOURCE_GROUP} \
  --endpoint-name ${RESUME_AFD_ENDPOINT_NAME} \
  --profile-name ${RESUME_AFD_PROFILE_NAME}
