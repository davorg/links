# links

Self-hosted Linktree clone

A very simple thing that I threw together in an hour or so.

## The important files

* [links.json](https://github.com/davorg/links/blob/main/links.json) defines the links
* [index.html.tt](https://github.com/davorg/links/blob/main/src/index.html.tt) defines how the web page looks
* [build](https://github.com/davorg/links/blob/main/build) actually turns the JSON into a web page
* [build.yml](https://github.com/davorg/links/blob/main/.github/workflows/build.yml) defines a GitHub Actions workflow that rebuilds the site when I edit the inputs
