# sonicpi.vim

The sonicpi vim plugin requires the following:

* An installation of [Sonic Pi 2.3+](http://www.sonic-pi.net/). (This requires [supercollider](http://audiosynth.com/) if you don't already have it.)

* [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/) to interface with Sonic Pi. (If you have some other command-line driven method for interfacing with Sonic Pi, just adjust the plugin accordingly.)

### Features

There are two commands in Normal mode:

`<leader>r` - send buffer to sonicpi

`<leader>S` - send stop message to sonicpi

Beyond that, the only significant features are the addition of the sonicpi filetype (autoloaded when opening a file ending in `.pi`), buggy autocompletion for Sonic Pi terms, and the use of Ruby syntax highlighting by default.

### TODO

* Fix autocomplete
* Make contextual autocomplete (e.g., a list of samples follows `samples`)
* Add movement for Sonic Pi style files, ala [ruby.vim](https://github.com/vim-ruby/vim-ruby/blob/master/doc/vim-ruby.txt)'s modifications
* Extend Ruby syntax to incorporate Sonic Pi directives

**NB**: This is my first plugin, and a work in progress. Please submit requests, recommendations, patches, and bug fixes if you find them.
