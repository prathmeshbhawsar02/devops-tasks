#!/bin/bash

echo "Installing java"
mkdir -p  $HOME/java 
cp $HOME/Downloads/jdk-*.tar.gz $HOME/java/
cd $HOME/java
tar zxvf $HOME/java/jdk-*.tar.gz 
rm -f jdk-*.tar.gz

export JAVA_HOME=$HOME/java/jdk-25.0.1
export PATH=$PATH:$JAVA_HOME/bin

echo " export JAVA_HOME=$HOME/java/jdk-25.0.1">>$HOME/.bashrc
echo " export PATH=$PATH:$JAVA_HOME/bin">>$HOME/.bashrc

source $HOME/.bashrc







