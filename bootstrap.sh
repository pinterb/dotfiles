#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"
git pull origin master
git submodule update --init --recursive

doIt()
{
  echo ""
  echo "Syncing dot files"
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
	source ~/.bash_profile
  echo ""
}

# Make sure Ansible is installed
doAnsible()
{
  echo ""
  echo "Set up Ansible"
  echo ""
  if [ -d ~/.ansible ]; then
	  cd ~/.ansible; git pull; source ./hacking/env-setup; cd -
  else
    git clone https://github.com/ansible/ansible.git ~/.ansible; cd ~/.ansible; source ./hacking/env-setup; cd -
  fi
}

# Make sure GVM (the Groovy enVironment Manager) is installed
doGvm()
{
  echo ""
  echo "Set up GVM"
  echo ""
  if [ -d ~/.gvm ]; then
	  cd ~/.gvm; gvm selfupdate; cd -
  else
    curl -s get.gvmtool.net | bash
  fi
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
	doAnsible
	goGvm
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	  doAnsible
	  doGvm
	fi
fi
unset doIt
unset doAnsible
unset doGvm
