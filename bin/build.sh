SRC_DIR=${{ github.workspace }}/src
STAGE_DIR=${{ github.workspace }}/stage

cd "${SRC_DIR}"
coloredEcho "Building static site." blue
bundle install >/dev/null
bundle exec jekyll clean -d "${STAGE_DIR}" >/dev/null
bundle exec jekyll serve -d "${STAGE_DIR}" >/dev/null &
SERVE_PID=$!
sleep 2

coloredEcho "Generating PDFs." blue
wkhtmltopdf -L 0mm -R 0mm --javascript-delay 2000 http://localhost:4000 "${STAGE_DIR}/resume.pdf"

kill -2 ${SERVE_PID}
