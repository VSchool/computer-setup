#!/bin/bash

lightblue=$'\e[97;104m'
clear=$'\e[0m'
newline=$'\n'

if [[ $(uname -s) != Darwin ]]
then
    read -p "${lightblue}Sorry, this script will currently only work on a Mac. Hit return to exit.${clear}"
    return 1
fi

# Emojis
tada=$'\xF0\x9F\x8E\x89'
rocket=$'\xF0\x9F\x9A\x80'
thumbs_up=$'\xF0\x9F\x91\x8D'
space_invader=$'\xF0\x9F\x91\xBE'
sweat_smile=$'\xF0\x9F\x98\x85'
hourglass=$'\xE2\x8C\x9B'
check_mark=$'\xE2\x9C\x85'
grimace=$'\xF0\x9F\x98\xAC'
mac_command_symbol=$'\xC2\x9D'
sweat_drops=$'\xF0\x9F\x92\xA6'

# Intro
echo -e "${lightblue}${tada} Welcome to V School! ${tada}${clear}"
sleep 3
echo -e "${lightblue}I'm here to do some of the basic, mundane setup stuff for you. Let's get started! ${rocket}${clear}"
sleep 3
echo -e "${lightblue}Throughout this process, you may be asked to provide your password a few times${clear}"
sleep 3
echo -e "${lightblue}When that happens, you'll type in the same password you use to log in to your computer${clear}"
sleep 3
echo -e "${lightblue}It will look like nothing is typing, but I promise it is${clear}"
sleep 3
echo -e "${lightblue}When you've finished entering your password, press return to continue${clear}"
sleep 3
echo -e "${lightblue}One more thing... so I don't talk too fast (or slow), I'll let you press the return key to advance through the prompts from here on${clear}"
sleep 3
read -p "${lightblue}Try it now ${hourglass} (return)${clear}"
read -p "${lightblue}Nicely done! You're basically a real hacker already! ${space_invader} (return)${clear}"
read -p "${lightblue}I don't actually know your name yet! Please enter your full name (first and last):${clear} " first_name last_name
echo

while [[ -z ${first_name}  ]] || [[ -z ${last_name} ]]
do
    echo -e "${lightblue}Whoops, looks like you may have entered something incorrectly${clear}"
    read -p "${lightblue}Please try again. Make sure to type both first AND last names:${clear} " first_name last_name
    echo
done

# Todo: Add a check to make sure they're happy with the name they put in
read -p "${lightblue}Great! Nice to meet you ${first_name}! (return)${clear}"

# Todo: Allow them to keep ZSH if that's what they're using
# Make sure the default shell is bash
if [[ $(echo $0) != "/bin/bash" ]]
then
    echo -e "${lightblue}For simplicity, I'm switching your default shell to bash. If you want to switch back to another shell (zsh, e.g.), please speak with an instructor for help.${clear}"
    chsh -s /bin/bash
#else
#    echo -e "${lightblue}I just checked if you're using bash for your shell program, and it looks like you are! ${thumbs_up}${clear}"
fi

while [[ ! -d "/Applications/Google Chrome.app" ]]
do
    read -p "${lightblue}Before we get too much further, I noticed that it looks like you may not have the Google Chrome browser installed yet. (return)${clear} "
    read -p "${lightblue}Let's go download it now. Hit return to open a browser to the download page. I'll wait here. ${hourglass} (return)${clear} "
    /usr/bin/open https://www.google.com/chrome/
    read -p "${lightblue}Once you've finished installing Chrome, hit return to continue. I'll know if you tried to cheat ${grimace} (return)${clear} "
done

read -p "${lightblue}Now I'll be creating an SSH key for you. (return)${clear}"
read -p "${lightblue}This is useful for communicating securely with external services, like GitHub (return)${clear}"

# Check for an existing SSH Key and create a new one if it doesn't exist
if [ -f ~/.ssh/id_rsa.pub ]
then
    echo -e "${lightblue}...${clear}"
    sleep 1
    read -p "${lightblue}Actually, it looks like you've already got an SSH key, which is great! ${thumbs_up} (return)${clear}"

    # Save public ssh file contents in variable (looking for the comment)
    IN=$( cat ~/.ssh/id_rsa.pub )
    # Split the string into an array
    arrIN=(${IN})
    # Get the 3rd argument (comment of ssh file, could be email)
    comment=${arrIN[2]}

    read -p "${lightblue}I was able to pull the email address ${comment} from your existing SSH key. (return)${clear}"
    read -p "${lightblue}(It's possible this isn't even a valid email address. I'm not smart enough to tell quite yet.) (return)${clear}"
    echo
    read -p "${lightblue}In a minute, ${first_name}, I'll open a browser window to your GitHub settings page (return)${clear} "
    read -p "${lightblue}(Just in case something goes wrong, the URL is https://github.com/settings/emails) (return)${clear} "
    read -p "${lightblue}Make sure to come back here once you've verified your email address (return)${clear}"
    read -p "${lightblue}Also, just FYI, you may have to log in to GitHub before it takes you to the settings page (return)${clear}"
    read -p "${lightblue}Okay, for real this time. Hit return to open the GitHub settings page (return)${clear}"

    /usr/bin/open https://github.com/settings/emails
    echo
    read -p "${lightblue}Welcome back, ${first_name}!${clear}"
    read -p "${lightblue}So, is ${comment} the actual email address you use for GitHub? Y/n:${clear} " -n 1 response;echo
    while [[ ! ${response} =~ ^[Yy]$ && ! ${response} =~ ^[Nn]$ ]]
    do
        read -p "${lightblue}Whoops, I missed that. Please enter Y or N:${clear} " -n 1 response;echo
    done

    if [[ ${response} =~ ^[Yy]$ ]]
    then
        email=${comment}
        read -p "${lightblue}Great! We can move forward to the next step then! ${rocket} (return)${clear}"
    elif [[ ${response} =~ ^[Nn]$ ]]
    then
        read -p "${lightblue}Okay, no problem. Please enter the email address you use for GitHub:${clear} " email
        ssh-keygen -f ~/.ssh/id_rsa -o -c -C ${email}
        read -p "${lightblue}Alright, I've updated your SSH key to contain the correct email address! (return)${clear}"
    fi
else
    read -p "${lightblue}You don't have an SSH file yet, so let's make one now! (return)${clear}"
    read -p "${lightblue}In a minute, ${first_name}, I'll open a browser window to your GitHub settings page (return)${clear} "
    read -p "${lightblue}(Just in case something goes wrong, the URL is https://github.com/settings/emails) (return)${clear} "
    read -p "${lightblue}Make sure to come back here once you've verified your email address (return)${clear}"
    read -p "${lightblue}Also, just FYI, you may have to log in to GitHub before it takes you to the settings page (return)${clear}"
    read -p "${lightblue}Okay, for real this time. Hit return to open the GitHub settings page (return)${clear}"

    /usr/bin/open https://github.com/settings/emails

    read -p "${lightblue}Please enter the email address you use for GitHub, as found on your GitHub settings page:${clear} " email

    # If entered email is empty, keep asking for email
    while [ -z ${email} ]
    do
        echo -e "${lightblue}Looks like you entered nothing as your email. Please check your GitHub settings for the correct email and enter it below:${clear} "
        read email
    done

    read -p "${lightblue}Is ${email} the correct email address? Y/n:${clear} " -n 1 response;echo
    if [[ ${response} =~ ^[Yy]$ ]]
    then
        echo -e "${lightblue}Great! I'll create an SSH key for you now... ${space_invader}${clear}"
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -C ${email}
        sleep 2
        read -p "${lightblue}${check_mark} Done! (return)${clear}"
    else
        echo -e "${lightblue}Last chance: what is the email address you use for Github? Double check you typed it in correctly before hitting return${clear}"
        read email
        read -p "${lightblue}Finally! ${sweat_smile} I'll create an SSH key for you now. ${space_invader} (return)${clear}"
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -C ${email}
    fi
fi

# Copy the SSH Key to the clipboard
pbcopy < ~/.ssh/id_rsa.pub
read -p "${lightblue}I copied your new SSH key to your clipboard for you (return)${clear}"
read -p "${lightblue}Next, you'll need to add it to your GitHub SSH keys (return)${clear}"
read -p "${lightblue}In a minute, I'm going to open the browser again for you (return)${clear} "
read -p "${lightblue}Here's what you're going to do on your end (it's pretty easy): (return)${clear}"
read -p "${lightblue}The browser will open to the 'new SSH key' page on GitHub (return)${clear}"
read -p "${lightblue}For the \"Title\" field, put something like \"Bob's 2016 Macbook Pro\" (return)${clear}"
read -p "${lightblue}(You can put anything here that will remind you in the future which computer this SSH key is tied to) (return)${clear}"
read -p "${lightblue}Then simply paste (⌘ + V) the SSH key (which is already copied for you) into the 'Key' input box and hit the green 'Add SSH key' button (return)${clear}"
read -p "${lightblue}Make sure to come back here once you've added your SSH key (return)${clear}"
read -p "${lightblue}Alright, I think you're ready ${rocket} (return)${clear}"
read -p "${lightblue}Opening the browser now (return)${clear}"
/usr/bin/open https://github.com/settings/ssh/new
echo
read -p "${lightblue}Welcome back again! How did that go? It wasn't too bad, was it?${clear}"
read -p "${lightblue}If you happened to get an error that said the SSH key is already in use, that's not a problem and you're all set!)${clear}"

# Install Homebrew
read -p "${lightblue}Next we're going to install Homebrew, a package manager for Mac (return)${clear}"
read -p "${lightblue}Basically it's a great tool for installing developer-y programs to your Mac (return)${clear}"
read -p "${lightblue}Installing Homebrew may also install the Xcode Command Line Tools, which – FYI – can sometimes take awhile to finish (return)${clear}"
read -p "${lightblue}Hit return to start the install, then follow the directions and patiently wait until you see the next blue text. ${hourglass} (return)${clear}"
echo -e "${lightblue}Installing Homebrew...${clear}"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
read -p "${lightblue}Done! Let's move on ${rocket} (return)${clear}${newline}"

# Install and set up NVM
read -p "${lightblue}Now I'm going to install NVM, which stands for the Node Version Manager (return)${clear}"
read -p "${lightblue}It makes installing and managing Node.js very easy (return)${clear}"
read -p "${lightblue}(It's okay if you're not sure what Node.js is, you'll learn all that in great detail later in the course) (return)${clear}"
read -p "${lightblue}Hit return to start the install. Remember to wait until you see the blue text again! (return)${clear}"
echo -e "${lightblue}Installing NVM...${clear}"
brew install nvm
mkdir ~/.nvm
cat >> ~/.bash_profile << EOL
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"${newline}
EOL

source ~/.bash_profile

# Install the latest stable version of node.js
read -p "${lightblue}${sweat_smile} You're enjoying watching me do all the work, aren't you? (return)${clear}"
read -p "${lightblue}Now I'm going to use NVM to install the latest stable version of Node.js (return)${clear}"
read -p "${lightblue}Hit return to start the install (return)${clear}"
echo -e "${lightblue}Installing the latest stable version of Node.js...${clear}"
nvm install --lts

# Set up the git config to have the right authors for commits

read -p "${lightblue}Now I just need to configure a couple simple settings with Git (return)${clear}"
echo -e "${lightblue}Setting your name and email in your git config...${clear}"
git config --global user.name "${first_name} ${last_name}"
git config --global user.email "${email}"
sleep 2

# Install Git bash completion and change terminal prompt to include working dir and branch name
echo -e "${lightblue}Setting up git completion and branch in prompt...${clear}"

# The official one had a bug in it from the latest update, so we've copied the original to our S3 account
#curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
curl https://s3.amazonaws.com/v-school/tools/git-completion.bash -o ~/.git-completion.bash

cat >> ~/.bash_profile << EOL
# Git tab completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

EOL
echo 'export PS1="\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "' >> ~/.bash_profile

# Todo: Add this back in when it can be tested
# Install Mas and Xcode
#if [ ! -d /Applications/Xcode.app ]
#then
#    brew install mas  # For installing app store apps from bash
#    mas install 497799835  # Xcode app store id number
#fi
#
#sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
#sudo xcodebuild -license accept

read -p "${lightblue}${sweat_smile} Alright! That's everything! (return)${clear}"
read -p "${lightblue}It's been nice working with you, ${first_name}! (return)${clear}"
read -p "${lightblue}Hit return to close the Terminal app. Once you reopen it, everything should be all set up for you. Now, go make the most of your time at V School!${clear}"

osascript -e "do shell script \"osascript -e \\\"tell application \\\\\\\"Terminal\\\\\\\" to quit\\\" &> /dev/null &\""; exit