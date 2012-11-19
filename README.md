# github-preview

Say you're writing a README for your project, or any other Markdown that will 
eventually be displayed on Github. You want a way to preview this locally 
before you push it.

`github-preview` opens a preview of your Markdown file in a browser. It uses 
Github styling and automatically refreshes everytime you save your source.

## Installation

```shell
gem install github-preview
```

## Usage

`github-preview` is a command-line utility.

```shell
github-preview README.md
```

This will open your default browser with a live-updating preview.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
