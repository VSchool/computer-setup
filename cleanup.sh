#!/bin/bash
brew uninstall nvm
brew uninstall bash-completion
rm -rf ~/.ssh/
rm -rf ~/.nvm/
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
> ~/.bash_profile

if [ -d /usr/local/var ]
then
    sudo rm -rf /usr/local/var
fi

if [ -d /usr/local/share ]
then
    sudo rm -rf /usr/local/share
fi

if [ -d ~/.git-completion.bash ]; 
then
    sudo rm -rf ~/.git-completion.bash
fi

# Clean up dev folder
if [ -d ~/dev ]
then
    sudo rm -rf ~/dev
fi

# Clean up Xcode
if [ -d /Library/Developer/CommandLineTools ]
then
    sudo rm -rf /Library/Developer/CommandLineTools
fi

if [ -d /Applications/Xcode.app ]
then
    sudo /Developer/Library/uninstall-devtools --mode=all
    sudo rm -rf /Applications/Xcode.app/
fi

if [ -d ~/Library/Developer ]
then
    sudo rm -rf ~/Library/Developer
fi

if [ -d ~/Library/Caches/com.apple.dt.Xcode ]
then
    sudo rm -rf ~/Library/Caches/com.apple.dt.Xcode/*
fi

osascript -e "do shell script \"osascript -e \\\"tell application \\\\\\\"Terminal\\\\\\\" to quit\\\" &> /dev/null &\""; exit