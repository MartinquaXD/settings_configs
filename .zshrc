# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f /usr/share/fzf/completion.zsh ]; then
    . /usr/share/fzf/completion.zsh
fi

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    . /usr/share/fzf/key-bindings.zsh
fi

export FZF_DEFAULT_COMMAND="fd . -L -E '*.o'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d -L ."
export EDITOR=nvim
