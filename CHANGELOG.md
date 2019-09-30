# Changelog

## 0.2.0 - September 30th, 2019

- First update after 6 years: Udpate gem versions to get the gem working again with modern rubies.
- Currently tested in: 2.4, 2.5, 2.6 and ruby-head

## 0.1.1 - December 23, 2013

- Specify html-pipeline dependencies. Also now using Bundler to sandbox the required gems. This should make it fail if the dependencies are not specified in the gemspec.
- Require rspec

## 0.1.0 - December 22, 2013

- Update Listener and use new API
- Update versions of html-pipeline and github-linguist

## 0.0.9 - August 9, 2013

- Include anchor links in headings

## 0.0.8 - June 22, 2013

- Add convenience executables for testing
- Extract Viewer, Wrapper, Converter, Watcher.
- Allow an alternative browser to be used with the -a switch on GNU/Linux.

## 0.0.7 - April 4, 2013

- Alow an alternate browser to be used with the -a switch on Mac.

## 0.0.6 - January 4, 2013

- SIGINT trapping and error handling
- Updates dependency versions

## 0.0.5 - December 20, 2012

- Lock version of github-linguist to known working version

## 0.0.4 - December 18, 2012

- Remove CamoFilter, add asset_root for EmojiFilter
- Add note about icu.

## 0.0.3 - November 30, 2012

- Cache the stylesheets for a week
- Avoids using the GitHub API and uses Github's html-pipeline.
- Refactor obfuscated code.
- Improvements on the README

## 0.0.2 - November 26, 2012

- Avoid SSL verifications errors when using open-uri
- Adds Linux compatibility
- Cache the fingerprinted stylesheets links for a day
- Use ERB for HTML template
- Add live updating preview as a command line option
- Rename to ghpreview for better tab-completion

## 0.0.1 - November 26, 2012

- Initial release with executable.

