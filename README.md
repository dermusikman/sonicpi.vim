# sonicpi.vim

[![Join the chat at https://gitter.im/dermusikman/sonicpi.vim](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dermusikman/sonicpi.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The sonicpi vim plugin requires the following:

* An installation of [Sonic Pi 2.3+](http://www.sonic-pi.net/). 

* [sonic-pi-cli](https://github.com/Widdershin/sonic-pi-cli/) to interface with Sonic Pi. (If you have some other command-line driven method for interfacing with Sonic Pi, just adjust the plugin accordingly.)

### Features

The plugin enables itself when the Ruby filetype is initiated (`let g:sonicpi_enabled = 0` to disable), and provides the following features:

* `<leader>r` - send buffer to sonicpi

* `<leader>S` - send stop message to sonicpi

* Autocompletion of Sonic Pi terms with omnicomplete (`<C-x><C-o>` by default).

### TODO

* ~~Fix autocomplete~~
* Make contextual autocomplete (e.g., a list of samples follows `samples`)
* ~~Add movement for Sonic Pi style files, ala [ruby.vim](https://github.com/vim-ruby/vim-ruby/blob/master/doc/vim-ruby.txt)'s modifications~~ (Now we stay in the Ruby filetype)
* Extend Ruby syntax to incorporate Sonic Pi directives :star

**NB**: This is my first plugin, and a work in progress. Please submit requests, recommendations, patches, and bug fixes if you find them.
