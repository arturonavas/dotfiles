#  ╔═╗╔═╗╦ ╦╦═╗╔═╗   ╔═╗╔═╗╔╗╔╔═╗╦╔═╗
#  ╔═╝╚═╗╠═╣╠╦╝║     ║  ║ ║║║║╠╣ ║║ ╦
#  ╚═╝╚═╝╩ ╩╩╚═╚═╝   ╚═╝╚═╝╝╚╝╚  ╩╚═╝

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#  ┬  ┬┌─┐┬─┐┌─┐
#  └┐┌┘├─┤├┬┘└─┐
#   └┘ ┴ ┴┴└─└─┘
export VISUAL="${EDITOR}"
export EDITOR='code'
export BROWSER='firefox-developer-edition'
# HISTORY_IGNORE is generally less flexible than HISTIGNORE patterns or HIST_IGNORE_SPACE/setopt options
# export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export SUDO_PROMPT="Deploying root access for %u. Password pls: "
export BAT_THEME="base16"

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#  ┬  ┌─┐┌─┐┌┬┐   ┌─┐┌┐┌┌─┐┬┌┐┌┌─┐
#  │  │ │├─┤ ││   ├┤ ││││ ┬││││├┤
#  ┴─┘└─┘┴ ┴─┴┘   └─┘┘└┘└─┘┴┘└┘└─┘
autoload -Uz compinit
# Initialize completion system
compinit -u # -u prevents checking secure directories if you trust your setup

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list \
        'm:{a-zA-Z}={A-Za-z}' \
        '+r:|[._-]=* r:|=*' \
        '+l:|=*'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'
zstyle ':fzf-tab:*' fzf-flags --style=full --height=90% --pointer '>' \
        --color 'pointer:green:bold,bg+:-1:,fg+:green:bold,info:blue:bold,marker:yellow:bold,hl:gray:bold,hl+:yellow:bold' \
        --input-label ' Search ' --color 'input-border:blue,input-label:blue:bold' \
        --list-label ' Results ' --color 'list-border:green,list-label:green:bold' \
        --preview-label ' Preview ' --color 'preview-border:magenta,preview-label:magenta:bold'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --theme=base16 $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' accept-line enter

#  ┬ ┬┌─┐┬┌┬┐┬┌┐┌┌─┐   ┌┬┐┌─┐┌┬┐┌─┐
#  │││├─┤│ │ │││││ ┬    │││ │ │ └─┐
#  └┴┘┴ ┴┴ ┴ ┴┘└┘└─┘   ─┴┘└─┘ ┴ └─┘
# Custom TAB completion (optional example, yours was fine too)
# expand-or-complete-with-dots() {
#   echo -n "\e[31m…\e[0m"
#   zle expand-or-complete
#   zle redisplay
# }
# zle -N expand-or-complete-with-dots
# bindkey "^I" expand-or-complete-with-dots

#  ┬ ┬┬┌─┐┌┬┐┌─┐┬─┐┬ ┬
#  ├─┤│└─┐ │ │ │├┬┘└┬┘
#  ┴ ┴┴└─┘ ┴ └─┘┴└─ ┴
# --- History Settings ---
HISTFILE=~/.zsh_history      # Location to save history (crucial!)
HISTSIZE=10000               # Number of commands to keep in memory during session
SAVEHIST=10000               # Number of commands to save in HISTFILE (crucial!)

setopt APPEND_HISTORY        # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY    # Save each command immediately (good for sharing)
setopt SHARE_HISTORY         # Share history between running shells instantly
setopt HIST_IGNORE_SPACE     # Ignore commands starting with a space
setopt HIST_IGNORE_ALL_DUPS  # If the new command is the same as the last one, don't record it
# setopt HIST_IGNORE_DUPS    # Don't record command if it's identical to the previous one (stronger than _ALL_DUPS)
setopt HIST_SAVE_NO_DUPS     # On save, only keep the latest instance of duplicates
setopt HIST_FIND_NO_DUPS     # When searching history, don't show duplicates adjacent in results
# --- End History Settings ---

#  ┌─┐┌─┐┬ ┬   ┌─┐┌─┐┌─┐┬     ┌─┐┌─┐┌┬┐┬┌─┐┌┐┌┌─┐
#  ┌─┘└─┐├─┤   │  │ ││ ││     │ │├─┘ │ ││ ││││└─┐
#  └─┘└─┘┴ ┴   └─┘└─┘└─┘┴─┘   └─┘┴   ┴ ┴└─┘┘└┘└─┘
setopt AUTOCD             # Change directory just by typing its name
setopt PROMPT_SUBST       # Enable command substitution in prompt
# setopt MENU_COMPLETE       # Automatically highlight first element (can be annoying)
setopt AUTO_LIST          # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD   # Complete from both ends of a word.
# setopt LIST_PACKED         # Make completion list more compact (optional)

#  ┌┬┐┬ ┬┌─┐   ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐
#   │ ├─┤├┤    ├─┘├┬┘│ ││││├─┘ │
#   ┴ ┴ ┴└─┘   ┴  ┴└─└─┘┴ ┴┴   ┴
# Prompt function
function dir_icon {
  # Use PWD for physical directory, %~ shows logical path respecting symlinks
  # Let's stick to %~ as it's used in PS1
  local current_dir="%~"
  # Check if current_dir expanded to ~ is the same as $HOME
  if [[ "${current_dir/#\~/$HOME}" == "$HOME" ]]; then
    echo "%B%F{cyan}%f%b" # Home icon
  else
    echo "%B%F{cyan}%f%b" # Folder icon
  fi
}

# Prompt - RPROMPT can be used for right-aligned info
PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '
# RPROMPT="" # Example: RPROMPT='%B%F{yellow}%T%f%b' for time

#  ┌─┐┬  ┬ ┬┌─┐┬┌┐┌┌─┐
#  ├─┘│  │ ││ ┬││││└─┐
#  ┴  ┴─┘└─┘└─┘┴┘└┘└─┘
# Load Plugins (Ensure paths are correct for your system)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh # <-- Keep this commented out for standard history

# Keybindings for history-substring-search (and others)
# Ensure these don't conflict with your terminal or other bindings
bindkey '^[[A' history-substring-search-up   # Up arrow
bindkey '^[[B' history-substring-search-down # Down arrow
bindkey '^[[3~' delete-char                   # Delete key
bindkey "^[[H" beginning-of-line             # Home key
bindkey "^[[F" end-of-line                   # End key
# You might prefer standard emacs bindings:
# bindkey '^P' history-substring-search-up
# bindkey '^N' history-substring-search-down
# bindkey '^[[3~' delete-char # Delete
# bindkey '^[[1~' beginning-of-line # Home (check your terminal's output with `showkey -a` or `cat -v`)
# bindkey '^[[4~' end-of-line # End (check your terminal's output)

#  ┌─┐┬ ┬┌─┐┌┐┌┌─┐┌─┐   ┌┬┐┌─┐┬─┐┌┬┐┬┌┐┌┌─┐┬   ┌─┐   ┌┬┐┬┌┬┐┬   ┌─┐
#  │  ├─┤├─┤││││ ┬├┤     │ ├┤ ├┬┘│││││││├─┤│   └─┐    │ │ │ │   ├┤
#  └─┘┴ ┴┴ ┴┘└┘└─┘└─┘    ┴ └─┘┴└─┴ ┴┴┘└┘┴ ┴┴─┘└─┘    ┴ ┴ ┴ ┴─┘└─┘
# Terminal Title settings (looks good)
function xterm_title_precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
    # [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\' # Screen specific
}

function xterm_title_preexec () {
    print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
    # [[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; } # Screen specific
}

# Add hooks only if in a supported terminal
if [[ "$TERM" == (kitty*|alacritty*|wezterm*|foot*|xterm*|tmux*|screen*) ]]; then
    autoload -Uz add-zsh-hook # Ensure add-zsh-hook is loaded before use here too
    add-zsh-hook -Uz precmd xterm_title_precmd
    add-zsh-hook -Uz preexec xterm_title_preexec
fi

#  ┌─┐┬  ┬┌─┐┌─┐
#  ├─┤│  │├─┤└─┐
#  ┴ ┴┴─┘┴┴ ┴└─┘
# Aliases
alias mirrors="sudo reflector --verbose --latest 5 --country 'United States' --age 6 --sort rate --save /etc/pacman.d/mirrorlist"
alias update="paru -Syu --nocombinedupgrade --needed" # Added --needed for potentially skipping already up-to-date packages
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias music="ncmpcpp"

alias cat="bat --theme=base16"
alias ls='eza --icons=always --color=always -a' # Consider adding --group-directories-first
alias ll='eza --icons=always --color=always -lag --header --git' # Added useful flags: group-dirs, header, git status

#  ┌─┐┬ ┬┌┬┐┌─┐   ┌─┐┌┬┐┌─┐┬─┐┌┬┐
#  ├─┤│ │ │ │ │   └─┐ │ ├─┤├┬┘ │
#  ┴ ┴└─┘ ┴ └─┘   └─┘ ┴ ┴ ┴┴└─ ┴
# Random colorscript on each terminal open (If you have colorscript installed)
# if command -v colorscript >/dev/null 2>&1; then
#   colorscript -r
# fi

# Ensure compinit runs after all potential changes to fpath or config
# compinit -u # Move compinit call towards the end if issues arise

# Final checks or sourcing user-specific config
# [[ -f ~/.config/zsh/.zshrc.local ]] && source ~/.config/zsh/.zshrc.local

# Make sure basic commands are available
# path=(/usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin $path)
