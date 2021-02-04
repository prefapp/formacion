# Late Motiv

This image is designed for specific use with Docsify.

Its use is limited to the documentary composition of teaching.

# Preamble

This project is intended to provide a simple tool for creating Prefapp internal training courses or just manuals.

# Source Dockerfile

``` yml
FROM node:alpine
MAINTAINER "Gustavo Esteban Borragán <gustavo.borragan@prefapp.es>"

LABEL docker_docsify_version_major="1" \
      docker_docsify_version_minor="0" \
      docker_docsify_version_patch="0" \
      docker_docsify_version_revision="1" \
      docker_docsify_version="1.0.0.1"

RUN npm install -g docsify-cli@latest && \
    mkdir -p /usr/local/docsify

ENV DEBUG 0 \
    PORT 3000 \
    DOCSIFY_VERSION latest \
    NODE_VERSION alpine

EXPOSE 3000

WORKDIR /usr/local/docsify

ENTRYPOINT [ "docsify", "serve", "--port", "3000" ]

CMD [ "." ]
```

# Create a course

>Image build or Image pull

```bash
docker build -t curso:base .
```

OR

```bash
docker pull gustavoesteban/curso:base
```

>Run instance

```bash
mv ./curso-base <PATH_PROJECT>/docs
```

```bash
docker run -d \
          -p <PORT>:3000 \
          -v <PATH_PROJECT>/docs:/usr/local/docsify \
          gustavoesteban/curso:base
```

## Implementation

> Markdown sintax

[Markdown Chear Sheet](https://www.markdownguide.org/cheat-sheet)

> Fill the values and replace the placeholders

- Cover [**_coverpage.md**]
  - Replace the image in [**_media/icon.png**]
  - Link the repo
  - Link "Empezar" to the first header "**#**" in the README.md
  - Change principla domain (launcher) (Plataforma(https://domain.com))
  - Select background color

- Sidebar [**_sidebar.md**]
  - Cascade referral link system

- Media
 - Add the resources in _media
 - Required: icon.ico

- Lessons
  - Follow the scheme of the chapters
    - 01_chapter
    - 02_chapter
    - 03_chapter
    - ...

# Enjoy ^_^
