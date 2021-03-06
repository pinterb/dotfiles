# From: http://mgdm.net/weblog/zsh-antigen/
ZSHA_BASE=$HOME/.zsh-antigen
source $ZSHA_BASE/antigen/antigen.zsh
source  $HOME/.aliases

antigen-use oh-my-zsh
antigen-bundle git

if [ "$OSTYPE"="darwin11.0" ]; then
  antigen-bundle osx
fi

antigen-bundle autojump
antigen-bundle docker
antigen-bundle gitignore
antigen-bundle golang
antigen-bundle history
antigen-bundle jump
antigen-bundle mvn
antigen-bundle vagrant
antigen-bundle avakhov/vim-yaml
antigen-bundle chase/vim-ansible-yaml
antigen-bundle scrooloose/syntastic
antigen-bundle tpope/vim-sensible
antigen-bundle kchmck/vim-coffee-script
antigen-bundle jnwhiteh/vim-golang
antigen-bundle altercation/vim-colors-solarized
antigen-bundle tpope/vim-markdown

antigen-bundle zsh-users/zsh-syntax-highlighting
#antigen-bundle zsh-users/zsh-history-substring-search

#antigen-bundle $ZSHA_BASE/bundles/stv
#antigen-theme $ZSHA_BASE/themes/mgdm/mgdm.zsh-theme
antigen-theme robbyrussell

antigen-apply
