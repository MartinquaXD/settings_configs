set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.nvimrc

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = { enable = true }
}
EOF
