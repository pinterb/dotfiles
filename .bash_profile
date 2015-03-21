# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Ode to boot2docker 
extra_extra_file=${BLACKBOX_KEYS_DIR:-"/home/dev/.devconfig/gnupg"}
if [ -f "$extra_extra_file" ]; then
  source "${extra_extra_file}"
fi

SHOPT_BIN=`which shopt`
if [ -n "$SHOPT_BIN" ]; then
  # Case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob

  # Append to the Bash history file, rather than overwriting it
  shopt -s histappend

  # Autocorrect typos in path names when using `cd`
  shopt -s cdspell

  # Enable some Bash 4 features when possible:
  # * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
  # * Recursive globbing, e.g. `echo **/*.txt`
  for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
  done
fi

COMPLETE_BIN=`which complete`
if [ -n "$COMPLETE_BIN" ]; then

  # Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
  [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

  # Add tab completion for `defaults read|write NSGlobalDomain`
  # You could just use `-g` instead, but I like being explicit
  complete -W "NSGlobalDomain" defaults

  # Add `killall` tab completion for common apps
  complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
fi

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Update $GOPATH (with my personal projects directory)
my_go_home=${GO_PROJECTS_DIR:-"/var/shared/projects/go"}

if [ -d "${my_go_home}" ]; then
  export GOPATH="${my_go_home}":$GOPATH
  export PATH="${my_go_home}"/bin:$PATH
fi

#export PS1='$(whoami)@$(hostname):$(pwd)$ '

if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
  GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
  export GPG_AGENT_INFO
else
  eval `gpg-agent --daemon`
  echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
fi

# see https://github.com/StackExchange/blackbox
blackbox_keys_dir=${BLACKBOX_KEYS_DIR:-"/home/dev/.devconfig/gnupg"}
if [ -d "$blackbox_keys_dir" ]; then
  gpg_ownertrust_backup=$(find $blackbox_keys_dir -type f | grep -m 1 ownertrust-gpg)
  if [ -n "$gpg_ownertrust_backup" ]; then
    gpg --import-ownertrust $gpg_ownertrust_backup
  fi

  gpg_private_backup=$(find $blackbox_keys_dir -type f | grep -m 1 private-gpg)
  if [ -n "$gpg_private_backup" ]; then
    gpg --import $gpg_private_backup
  fi

  gpg_public_backup=$(find $blackbox_keys_dir -type f -printf %f | grep -m 1 public-gpg)
fi

if [ -z "$BLACKBOX_USER" ]; then
  export BLACKBOX_USER=$(git config --get user.email)
fi
