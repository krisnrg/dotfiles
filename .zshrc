# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias la="ls -a"
alias h="cd ~/"
alias d="cd ~/Desktop"
alias dev="cd /Users/kristiangonzalez/webdev"
alias dot='/usr/bin/git --git-dir=/Users/kristiangonzalez/.dotfiles/ --work-tree=/Users/kristiangonzalez'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)

source $ZSH/oh-my-zsh.sh
POWERLEVEL9K_HOST_TEMPLATE="%n"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh dir vcs)

# Customize to your needs...
export PATH=/Users/nrg/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/X11/bin:/usr/local/opt/emacs-mac/Emacs.app/Contents/MacOS/Emacs

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function stage() {
    #is_repo="$(git rev-parse --is-inside-work-tree 3>/dev/null)"
    echo "Checking if this is a git working tree..."
    
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        git add $(git status -s | awk '!/^A/{print}' | fzf -m --header "Modified files" --prompt="Select files to stage: " | awk '{print $2}')
    else
        echo "You need to be inside a git working tree"
    fi
}


function reset() {
    #is_repo="$(git rev-parse --is-inside-work-tree 3>/dev/null)"
    echo "Retrieving files that can be reset..."
    
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        git reset $(git status -s | awk '/A/{print}' | fzf -m --header "Staged files" --prompt="Select files to reset: " | awk '{print $3}')
    else
        echo "You need to be inside a git working tree"
    fi
}

function gb(){
  if [ $# -eq 0 ]; then
    git branch | fzf --print0 -m | tr -d '[:space:]*' |xargs -0 -t -o git checkout
  else
    git checkout "$@"
  fi
}
