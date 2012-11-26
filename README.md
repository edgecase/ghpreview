# ghpreview

Say you're writing a README for your project, or any other Markdown that will 
eventually be displayed on Github. You want a way to preview this locally 
before you push it.

`ghpreview` opens a preview of your Markdown file in a browser. It uses Github 
styling and (optionally) automatically refreshes every time you save your 
source.

## Installation

```bash
$ gem install ghpreview
```

## Usage

`ghpreview` is a command-line utility.

```bash
$ ghpreview README.md
```

This will open your default browser with a preview of README.md exactly as it 
will appear on Github. For a live-updating preview, use the -w (watch) option:

```bash
$ ghpreview -w README.md
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
