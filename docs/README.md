# Preamble

This project is intended to provide a simple tool for creating Prefapp international training courses.

# USE

>Image build or Image pull

```bash
docker build -t curso:base .
```

```bash
docker pull gustavoesteban/curso:base
```

>Run instance

```bash
cp ./docs <PATH_PROJECT>/docs
```

```bash
docker run -d \
          -p <PORT>:3000 \
          -v <PATH_TO_DOCS_DIR>:/usr/local/docsify \
          gustavoesteban/curso:base
```

# Implementation

> Markdown sintax

[Markdown Chear Sheet](https://www.markdownguide.org/cheat-sheet)

> Fill the values and replace the placeholders

- Cover [**_coverpage.md**]
  - Replace the image in [**_media/icon.png**]
  - Link the repo
  - Link "Empezar" to the first header "**#**" in the README.md
  - Select background color

- Sidebar [**_sidebar.md**]
  - Cascade referral link system

# Enjoy ^_^
