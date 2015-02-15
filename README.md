# sonicpi.vim

[![Join the chat at https://gitter.im/dermusikman/sonicpi.vim](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dermusikman/sonicpi.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The sonicpi vim plugin requires the following:

* An installation of [Sonic Pi 2.3+](http://www.sonic-pi.net/). 

* [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/) to interface with Sonic Pi. (If you have some other command-line driven method for interfacing with Sonic Pi, just adjust the plugin accordingly.)

### Features

The plugin enables itself when Sonic Pi is running and the Ruby filetype is initiated (`let g:sonicpi_enabled = 0` to disable), and provides the following features:

* `<leader>r` - send buffer to sonicpi

* `<leader>S` - send stop message to sonicpi

* Contextual autocompletion of Sonic Pi terms with omnicomplete (`<C-x><C-o>` by default). That is, if you have `synth :zawa,` in the line, omnicomplete will provide parameter names for `:zawa`, et al!

* Extension of Ruby syntax to include Sonic Pi terms

### Installation

Prerequisites: [Sonic Pi 2.3+](http://www.sonic-pi.net/), [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/)

If you use [pathogen](https://github.com/tpope/vim-pathogen) (and you should), simply clone this repo into `~/.vim/bundle/` like so:

`git clone https://github.com/dermusikman/sonicpi.vim.git`

Whenever Sonic Pi is running, and you haven't disabled the `g:sonicpi_enabled` flag in your configs, the plugin will activate. Otherwise, it's a normal Ruby session!

### TODO

* ~~Fix autocomplete~~
* ~~Make contextual autocomplete (e.g., a list of samples follows `samples`)~~
* ~~Add movement for Sonic Pi style files, ala [ruby.vim](https://github.com/vim-ruby/vim-ruby/blob/master/doc/vim-ruby.txt)'s modifications~~ (Now we stay in the Ruby filetype)
* ~~Extend Ruby syntax to incorporate Sonic Pi directives~~
* Update for Sonic Pi 2.4
