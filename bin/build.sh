SRC_DIR=${GITHUB_WORKSPACE}/src
BIN_DIR=${GITHUB_WORKSPACE}/bin
STAGE_DIR=${GITHUB_WORKSPACE}/stage

export TERM=dumb

# import helpers
. "${BIN_DIR}"/helpers.sh

cd "${SRC_DIR}"
coloredEcho "Building static site." blue
bundle install >/dev/null
bundle exec jekyll clean -d "${STAGE_DIR}" >/dev/null
bundle exec jekyll serve -d "${STAGE_DIR}" >/dev/null &
SERVE_PID=$!
sleep 2

coloredEcho "Generating PDF." blue
wkhtmltopdf -L 0mm -R 0mm --javascript-delay 2000 http://localhost:4000 "${STAGE_DIR}/resume.pdf"

kill -2 ${SERVE_PID}

coloredEcho "Making small PDF." blue
chmod +x "${BIN_DIR}"/magick
"${BIN_DIR}"/magick --appimage-extract -density 125 -quality 75 "${STAGE_DIR}/resume.pdf" "${STAGE_DIR}/resume-small.pdf"