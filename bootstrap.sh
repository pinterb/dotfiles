#!/bin/sh

readonly PROGNAME=$(basename $0)
readonly PROGDIR="$( cd "$(dirname "$0")" ; pwd -P )"
readonly CURL_CMD=`which curl`
readonly GIT_CMD=`which git`

readonly TRUE=0
readonly FALSE=1

usage()
{
  echo "\033[33mHere's how to bootstrap dotfiles into your environment:"
  echo ""
  echo "\033[33m./$PROGNAME"
  echo "\t\033[33m-h --help"
  echo "\t\033[33m-a --ansible   Install Ansible configuration management."
  echo "\t\033[33m-g --gvm       Install Groovy Environment Manager."
  echo "\t\033[33m-f --force     Force overwrite of existing files in your home directory."
  echo "\033[0m"
}


parse_args()
{
  while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
      -h | --help)
        usage
        exit
        ;;
      -a | --ansible)
        INSTALL_ANSIBLE=$TRUE
        ;;
      -g | --gvm)
        INSTALL_GVM=$TRUE
        ;;
      -f | --force)
        FORCE_UPDATES=$TRUE
        ;;
      *)
        echo "\033[31mERROR: unknown parameter \"$PARAM\""
        echo ""
        usage
        exit 1
        ;;
    esac
    shift
  done

}


gitPull()
{
  # Get to where we need to be.
  cd $PROGDIR
  echo "cd'd into $PROGDIR...and we're now in $PWD"
  "${GIT_CMD}" pull origin master
  "${GIT_CMD}" submodule update --init --recursive
}


doIt()
{
  echo ""
  echo "Syncing dot files"
  rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
	--exclude "README.md" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
  cd ~/.vim/bundle && git clone https://github.com/gmarik/Vundle.vim.git && cd -
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
    cd ~/.ansible; git pull; git submodule update --init; cd -
  else
    git clone https://github.com/ansible/ansible.git ~/.ansible; cd ~/.ansible; git submodule update --init; cd -
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


mainnnn()
{

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
	doAnsible
	doGvm
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
          doIt
	  doAnsible
	  doGvm
	fi
fi
}


main()
{

  # Pull in git submodules 
  gitPull 

  if [ -z "$FORCE_UPDATES" ]; then
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      doIt

      if [ -n "$INSTALL_ANSIBLE" ]; then
        doAnsible 
      fi
    
      if [ -n "$INSTALL_GVM" ]; then
        doGvm 
      fi

    fi
  
  else
    doIt

    if [ -n "$INSTALL_ANSIBLE" ]; then
      doAnsible 
    fi
    
    if [ -n "$INSTALL_GVM" ]; then
      doGvm 
    fi

  fi

}


parse_args "$@"
main
exit 0
