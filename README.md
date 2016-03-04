# sonicpi.vim

[![Join the chat at https://gitter.im/dermusikman/sonicpi.vim](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dermusikman/sonicpi.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The sonicpi vim plugin requires the following:

* An installation of [Sonic Pi 2.4+](http://www.sonic-pi.net/).

* A tool to interface with Sonic Pi. The default is [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/).


### Features

The plugin enables itself when Sonic Pi is running and the Ruby filetype is initiated (`let g:sonicpi_enabled = 0` to disable), and provides the following features:

* `<leader>r` - send buffer to sonicpi

* `<leader>S` - send stop message to sonicpi

* Contextual autocompletion of Sonic Pi terms with omnicomplete (`<C-x><C-o>` by default). That is, if you have `synth :zawa,` in the line, omnicomplete will provide parameter names for `:zawa`, et al!

* Extension of Ruby syntax to include Sonic Pi terms


### Installation

Prerequisites: [Sonic Pi 2.4+](http://www.sonic-pi.net/), and [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/) or similar.

If you use [pathogen](https://github.com/tpope/vim-pathogen) (and you should), simply clone this repo into `~/.vim/bundle/` like so:

`git clone https://github.com/dermusikman/sonicpi.vim.git`

Whenever Sonic Pi is running, and you haven't disabled the `g:sonicpi_enabled` flag in your configs, the plugin will activate. Otherwise, it's a normal Ruby session!


### Configuration

`g:sonicpi_keymaps_enabled` can be used to disable the default keybindings.

`g:sonicpi_command` can be used to configure what tool is used to send the
code to Sonic Pi. The default is `sonic_pi`.


## Sonic Pi interfacing tools

* [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/). The default.

* [sonic-pi-pipe](https://github.com/lpil/sonic-pi-tools). Written in Go, so significantly faster and more responsive than sonic-pi-cli.


### TODO

* ~~Fix autocomplete~~
* ~~Make contextual autocomplete (e.g., a list of samples follows `samples`)~~
* ~~Add movement for Sonic Pi style files, ala [ruby.vim](https://github.com/vim-ruby/vim-ruby/blob/master/doc/vim-ruby.txt)'s modifications~~ (Now we stay in the Ruby filetype)
* ~~Extend Ruby syntax to incorporate Sonic Pi directives~~
* ~~Update for Sonic Pi 2.4~~
* Add named notes (e.g., `:c4`, `:e2`) and chords (e.g., `sus4`, `m7+5`)
* Add oddball contexts beyond the sounds. For instance, we've added the "spread" context to include `rotate:`
