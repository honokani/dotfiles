#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0);pwd)



# make .zshrc symbolic link
ZSHRC_F=$HOME/.zshrc
ZSHRC_TGT=$SCRIPT_DIR/dot_zshrc
if [ -e $ZSHRC_F ]; then
	echo WARN: .zshrc file link has already exist.
fi
ln -bisv $ZSHRC_TGT $ZSHRC_F

# make .zshenv symbolic link
ZSHENV_F=$HOME/.zshenv
ZSHENV_TGT=$SCRIPT_DIR/dot_zshenv
if [ -e $ZSHENV_F ]; then
	echo WARN: .zshenv file link has already exist.
fi
ln -bisv $ZSHENV_TGT $ZSHENV_F




# make .config directory
CONFIG_D=$HOME/.config
CONFIG_TGT=$SCRIPT_DIR/dot_config
if [ -e $CONFIG_D ]; then
	echo WARN: .config directory has already exist.
else
	mkdir -p $CONFIG_D
fi

# make nvim symbolic link
NVIM_N=nvim
NVIM_D=$CONFIG_D/$NVIM_N
NVIM_TGT=$CONFIG_TGT/$NVIM_N
if [ -e $ZSHRC_F ]; then
	echo WARN: nvim directory link has already exist.
fi
ln -bisv $NVIM_TGT $NVIM_D




# make xmonad symbolic link
XMONAD_D=$HOME/.xmonad
XMONAD_TGT=$SCRIPT_DIR/dot_xmonad
if [ -e $XMONAD_D ]; then
	echo WARN: .xmonad directory has already exist.
fi
ln -bisv $XMONAD_TGT $XMONAD_D

# make xsession symbolic link
XSESS_F=$HOME/.xsession
XSESS_TGT=$SCRIPT_DIR/dot_xsession
if [ -e $XSESS_F ]; then
	echo WARN: .xsession has already exist.
fi
ln -bisv $XSESS_TGT $XSESS_F

# make Xresources symbolic link
XRES_F=$HOME/.Xresources
XRES_TGT=$SCRIPT_DIR/dot_Xresources
if [ -e $XRES_F ]; then
	echo WARN: .Xresources has already exist.
fi
ln -bisv $XRES_TGT $XRES_F

# make xinitrc symbolic link
XINIT_F=$HOME/.xinitrc
XINIT_TGT=$SCRIPT_DIR/dot_xinitrc
if [ -e $XINIT_F ]; then
	echo WARN: .xinitrc has already exist.
fi
ln -bisv $XINIT_TGT $XINIT_F


