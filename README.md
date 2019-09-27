# ghpreview

When you're writing a README for your project, you want a way to preview the 
Markdown locally before you push it. `ghpreview` is a command-line utility that 
opens your Markdown file in a browser. It uses Github styling and (optionally) 
automatically refreshes every time you save your source.

While README files are the most common use case, `ghpreview` works with any 
Markdown file.

## Prerequisites

You'll need the icu library. If you're on a Mac, `brew install icu4c` will do
the trick.

## Installation

```bash
$ gem install ghpreview
```

## Usage

```bash
$ ghpreview README.md
```

This will open your default browser with a preview of README.md exactly as it 
will appear on Github. For a live-updating preview, use the `-w` (or `--watch`) 
option:

```bash
$ ghpreview -w README.md
```

To use an alternate browser, use the `-a` (or `--application`) option:

```bash
# On Mac:
$ ghpreview -a Safari.app README.md

# On GNU/Linux:
$ ghpreview -a konqueror README.md
```

## Why is this better than X?

There are several tools available for previewing Markdown files, and many that 
provide a Github-like style. I've personally used 
[Marked](http://markedapp.com), [Mou](http://mouapp.com), and the 
[vim-markdown](https://github.com/maba/vim-markdown-preview) plugin. All are 
good tools, but none are able to truly reproduce the custom features added to 
[Github Flavored Markdown](http://github.github.com/github-flavored-markdown/). 
This is especially notable with fenced code blocks and syntax highlighting.

`ghpreview` is an accurate preview because it uses Github's own [HTML 
processing filters](https://github.com/jch/html-pipeline) to generate the HTML, 
and Github's own stylesheets to style it :octocat:

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write specs (`bundle exec rspec spec`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
