#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0);pwd)



# make .zshrc symbolic link

ZSHRC_F=$HOME/.zshrc
ZSHRC_TGT=$SCRIPT_DIR/dot_zshrc
if [ -e $ZSHRC_F ]; then
	echo WARN: .zshrc file link has already exist.
fi
ln -bisv $ZSHRC_TGT $ZSHRC_F


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

