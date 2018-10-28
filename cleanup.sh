#!/bin/bash

lightblue=$'\e[97;104m'
clear=$'\e[0m'
newline=$'\n'

echo -e "${lightblue}You should only run this script on a test computer if you're okay with lots of stuff being deleted${clear}"
echo -e "${lightblue}You're about to uninstall lots of things and delete a bunch of folders, including the dev folder.${clear}"
read -p "${lightblue}Are you sure you're okay with this? Type 'please clean up everything' to confirm:${clear} " answer
if [[ ${answer} != "please clean up everything" ]]
then
    echo "Canceling the script now. Nothing will be uninstalled or deleted."
    return 1
else
    brew uninstall nvm
    #brew uninstall bash-completion
    rm -rf ~/.ssh/
    rm -rf ~/.nvm/
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    #> ~/.bash_profile

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
    read -p "${lightblue}For now, you'll have to manually clean up the .bash_profile file yourself. Otherwise, everything's all cleaned up!${clear}"
fi
exit
#osascript -e "do shell script \"osascript -e \\\"tell application \\\\\\\"Terminal\\\\\\\" to quit\\\" &> /dev/null &\""; exit
