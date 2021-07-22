#!/bin/sh

# apt
sudo apt install build-essential cmake \
libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev \
python-dev python3-dev curl tmux

# vim 
mkdir ~/ven
git clone https://github.com/vim/vim.git ~/ven 
cd ~/ven/vim
./configure --with-features=huge \
            --enable-multibyte \
	    --enable-pythoninterp=yes \
	    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
	    --enable-python3interp=yes \
	    --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
            --enable-gui=gtk2 \
            --enable-cscope \
	   --prefix=/usr/local
make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
sudo make install


# backup
cd ~/
mkdir bk
mv .bashrc bk/bashrc_bk
mv .vimrc bk/vimrc_bk


# install the dotfiles so the path is set for gimme
cd .dotfiles
./install.sh
cd ~/
source .bashrc


# go gimme
mkdir bin
curl -sL -o ~/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
chmod +x ~/bin/gimme
eval "$(GIMME_GO_VERSION=1.15 gimme)"
echo "# gimme" >> ~/.bash_profile
echo 'eval "$(GIMME_GO_VERSION=1.15 gimme)"' >> ~/.bash_profile


# set up the Go environment
mkdir -p ~/dev/go/bin
mkdir -p ~/dev/go/src/github.com/csymonds


# .dotfiles
cd ~/.dotfiles
git submodule init
git submodule update --recursive


# YCM
cd ~/.dotfiles/vim/vim.symlink/bundle/YouCompleteMe
git submodule update --init --recursive
python3 install.py --clang-completer --go-completer

