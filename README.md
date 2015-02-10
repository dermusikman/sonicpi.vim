##### sonicpi.vim

The sonicpi vim plugin requires the following:

* An installation of [Sonic Pi 2.3+](http://www.sonic-pi.net/)

(This requires [supercollider](http://audiosynth.com/) if you don't already have it.)

* [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/) to interface with Sonic Pi

(If you have some other command-line driven method for interfacing with Sonic Pi, just adjust the plugin accordingly.)

## Features

* Defines filetype 'sonicpi' which is autoloaded for files ending in `.pi`
* Syntax highlighting as an extension of native Ruby syntax
* Autocomplete (a little broken in this version)

## TODO

* Fix autocomplete
* Add movement for Sonic Pi style files, ala [ruby.vim](https://github.com/vim-ruby/vim-ruby/blob/master/doc/vim-ruby.txt)'s modifications

*NB*: This is my first plugin, and a work in progress. Please submit requests, recommendations, patches, and bug fixes if you find them.
