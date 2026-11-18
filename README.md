nathanschepers.ca redirects to [pipe23.org](https://pipe23.org/) since 2026-11-18. The résumé source is in `src/`. The tag `resume-2026-11-18` is the last state that built and deployed it.

# Resume

Custom Jekyll theme for my resume.

## Dependencies

This project requires the following dependencies:

- Ruby (with development tools)
- Bundler and Jekyll (Ruby gems)
- wkhtmltopdf (for PDF generation)
- Ghostscript (for PDF processing)
- ImageMagick (included as an AppImage in the bin directory)

## Installation

To install all dependencies, run:

```bash
sudo ./bin/install_dependencies.sh
```

## Building

To build the resume, run:

```bash
./bin/build.sh
```

This will generate both HTML and PDF versions of the resume in the `stage` directory.
