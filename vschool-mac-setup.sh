#!/bin/bash

lightblue=$'\e[97;104m'
red=$'\e[97;41m'
green=$'\e[97;42m'
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
#point_up=$'\xE2\x98\x9D'
point_up=$'\xF0\x9F\x91\x86'

# Intro
echo -e "${green}${tada} Welcome to V School! ${tada}${clear}"
echo -e "${lightblue}I'm here to do some of the basic, mundane setup stuff for you. Let's get started! ${rocket}${clear}"
echo -e "${lightblue}Throughout this process, you may be asked to provide your password a few times${clear}"
echo -e "${lightblue}When that happens, you'll type in the same password you use to log in to your computer${clear}"
echo -e "${lightblue}--------------------------------------------------------${clear}"
echo -e "${lightblue}It will look like nothing is typing, but I promise it is${clear}"
echo -e "${lightblue}--------------------------------------------------------${clear}"
echo -e "${lightblue}When you've finished entering your password, press return to continue${clear}"
echo -e "${lightblue}One more thing... every now and then I'll have you press the return key to advance through the prompts${clear}"
read -p "${lightblue}Try it now ${hourglass} (return)${clear}"
echo
echo -e "${lightblue}Nicely done! You're basically a real hacker already! ${space_invader}${clear}"
echo -e "${lightblue}I'm also going to let you know when you need to input something by changing the text background to green.${clear}"
read -p "${green}I don't actually know your name yet! Please enter your full name (first and last only):${clear} " first_name last_name
echo

while [[ -z ${first_name} || -z ${last_name} ]]
do
    echo -e "${red}Whoops, looks like you may have entered something incorrectly${clear}"
    echo -e "${red}Anytime that happens, the text will become red${clear}"
    read -p "${red}Please try again. Make sure to type both first AND last names:${clear} " first_name last_name
    echo
done

#
## Todo: Add a check to make sure they're happy with the name they put in
#read -p "${lightblue}Great! Nice to meet you ${first_name}! (return)${clear}"
#
## Todo: Allow them to keep ZSH if that's what they're using
## Make sure the default shell is bash
#if [[ $(echo $0) != "/bin/bash" && $(echo $0) != "-bash" ]]

if [[ ! $(echo $0) =~ "zsh" ]]
then
    echo -e "${lightblue}For simplicity, I'm switching your default shell to zsh. If you want to switch back to another shell (bash, e.g.), please speak with an instructor for help.${clear}"
    chsh -s /bin/zsh
fi

while [[ ! -d "/Applications/Google Chrome.app" ]]
do
    echo -e "${lightblue}It looks like you may not have the Google Chrome browser installed yet.${clear} "
    read -p "${red}Let's go download it now. Hit return to open a browser to the download page. I'll wait here. ${hourglass} (return)${clear} "
    /usr/bin/open https://www.google.com/chrome/
    read -p "${red}Once you've finished installing Chrome, hit return to continue. I'll know if you tried to cheat! ${grimace} (return)${clear} "
done

#read -p "${newline}${lightblue}Google's Chrome browser is one of the best for doing web development, so I'm going to make sure it's your default browser (return)${clear} "
#read -p "${lightblue}If you see a popup box with the option to \"Use Chrome\", please select it (return)${clear} "
#read -p "${lightblue}If Chrome opens and nothing happens within 2 seconds, you're already set. Just come back to Terminal to continue.(return)${clear} "
#read -p "${lightblue}Alright, hit return to open Chrome (return)${clear} "
#/usr/bin/open -a "/Applications/Google Chrome.app" --args --make-default-browser
#
#read -p "${newline}${lightblue}Welcome back! (return)${clear}"

echo -e "${lightblue}Nice to meet you, ${first_name}!${clear}"
echo -e "${lightblue}Now I'll be creating an SSH key for you.${clear}"
read -p "${lightblue}This is useful for communicating securely with external services, like GitHub (return)${clear}"

# Check for an existing SSH Key and create a new one if it doesn't exist
if [[ -f ~/.ssh/id_rsa.pub ]]
then
    echo
    sleep 1
    echo -e "${lightblue}...${clear}"
    sleep 1
    read -p "${lightblue}Actually, it looks like you've already got an SSH key, which is great! ${thumbs_up} (return)${clear}"

    # Save public ssh file contents in variable (looking for the comment)
    IN=$( cat ~/.ssh/id_rsa.pub )
    # Split the string into an array
    arrIN=(${IN})
    # Get the 3rd argument (comment of ssh file, could be email)
    comment=${arrIN[2]}

    echo -e "${lightblue}I was able to pull the email address ${comment} from your existing SSH key.${clear}"
    read -p "${lightblue}(It's possible this                  ${point_up} isn't really a valid email address, so bear with me.) (return)${clear}"
    echo
    echo -e "${lightblue}In a minute, I'll open a browser window to your GitHub settings page so you can verify the email you use for GitHub${clear} "
    echo -e "${lightblue}(Just in case something goes wrong, the URL is https://github.com/settings/emails)${clear} "
    echo -e "${lightblue}Make sure to come back here once you've verified your email address${clear}"
    echo -e "${lightblue}Also, just FYI, you may have to log in to GitHub before it takes you to the settings page (return)${clear}"
    read -p "${green}Okay, for real this time. Hit return to open the GitHub settings page (return)${clear}"

    /usr/bin/open https://github.com/settings/emails
    echo
    echo -e "${lightblue}Welcome back, ${first_name}!${clear}"
    read -p "${green}So, is ${comment} the actual email address you use for GitHub? Y/n:${clear} " response;echo
    while [[ ! ${response} =~ ^[Yy]$ && ! ${response} =~ ^[Nn]$ ]]
    do
        read -p "${red}Whoops, I missed that. Please enter Y or N:${clear} " response;echo
    done

    if [[ ${response} =~ ^[Yy]$ ]]
    then
        email=${comment}
        read -p "${lightblue}Great! We can move forward to the next step then! ${rocket} (return)${clear}"
    elif [[ ${response} =~ ^[Nn]$ ]]
    then
        read -p "${green}Okay, no problem. Please enter the email address you use for GitHub:${clear} " email
        ssh-keygen -f ~/.ssh/id_rsa -o -c -C ${email}
        read -p "${lightblue}Alright, I've updated your SSH key to contain the correct email address! (return)${clear}"
    fi
else
    echo
    echo -e "${lightblue}You don't have an SSH file yet, so let's make one now!${clear}"
    echo -e "${lightblue}In a minute, I'll open a browser window to your GitHub settings page${clear} "
    echo -e "${lightblue}(Just in case something goes wrong, the URL is https://github.com/settings/emails)${clear} "
    echo -e "${lightblue}Make sure to come back here once you've verified your email address${clear}"
    echo -e "${lightblue}Also, just FYI, you may have to log in to GitHub before it takes you to the settings page${clear}"
    read -p "${green}Okay, for real this time. Hit return to open the GitHub settings page (return)${clear}"

    /usr/bin/open https://github.com/settings/emails

    read -p "${newline}${green}Welcome back! Please enter the email address you use for GitHub, as found on your GitHub settings page:${clear} " email

    # If entered email is empty, keep asking for email
    while [[ -z ${email} ]]
    do
        read -p "${red}Looks like you entered nothing as your email. Please check your GitHub settings for the correct email and enter it here:${clear} " email
    done

    read -p "${green}Is ${email} the correct email address? Y/n:${clear} " response;echo
    if [[ ${response} =~ ^[Yy]$ ]]
    then
        echo -e "${lightblue}Great! I'll create an SSH key for you now... ${space_invader}${clear}"
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -C ${email}
        sleep 2
        read -p "${lightblue}${check_mark} Done! (return)${clear}"
    else
        read -p "${red}Last chance: what is the email address you use for Github? Double check you typed it in correctly before hitting return:${clear} " email
        read -p "${lightblue}Finally! ${sweat_smile} I'll create an SSH key for you now. ${space_invader} (return)${clear}"
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -C ${email}
    fi
fi

# Copy the SSH Key to the clipboard
pbcopy < ~/.ssh/id_rsa.pub

echo
echo -e "${lightblue}I copied your new SSH key to your clipboard for you${clear}"
echo -e "${lightblue}Next, you'll need to add it to your GitHub SSH keys${clear}"
echo -e "${lightblue}In a minute, I'm going to open the browser again for you${clear} "
echo -e "${lightblue}Here's what you're going to do on your end (it's pretty easy):${clear}"
echo -e "${lightblue}The browser will open to the 'new SSH key' page on GitHub${clear}"
echo -e "${lightblue}For the \"Title\" field, put something like \"Bob's 2016 Macbook Pro\"${clear}"
echo -e "${lightblue}(You can put anything here that will remind you in the future which computer this SSH key is tied to)${clear}"
echo -e "${lightblue}Then simply paste (⌘ + V) the SSH key (which is already copied for you) into the 'Key' input box and hit the green 'Add SSH key' button${clear}"
echo -e "${lightblue}Make sure to come back here once you've added your SSH key${clear}"
read -p "${green}Alright, I think you're ready. ${rocket} Opening the browser now (return)${clear}"

/usr/bin/open https://github.com/settings/ssh/new

echo
echo -e "${lightblue}Welcome back again! How did that go? It wasn't too bad, was it?${clear}"
echo -e "${lightblue}If you happened to get an error that said the SSH key is already in use, that's not a problem and you're all set!)${clear}"
echo

# Install Homebrew
echo -e "${lightblue}Next we're going to install Homebrew, a package manager for Mac${clear}"
echo -e "${lightblue}Basically it's a great tool for installing developer-y programs to your Mac${clear}"
echo -e "${lightblue}This step can sometimes take awhile to finish${clear}"
echo -e "${lightblue}Hit return to start the install, then follow any directions you're given${clear}"
echo -e "${lightblue}(like hitting RETURN and entering your password. And remember, it won't look like your password is typing, but it is)${clear}"
echo -e "${lightblue}then just patiently wait until you see the next blue text. ${hourglass}${clear}"
read -p "${green}Once you see the next blue text, you're ready to move on! K, let's do this. (return)${clear}"
echo
echo -e "${lightblue}Installing Homebrew...${clear}"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

read -p "${lightblue}Done! Let's move on ${rocket} (return)${clear}${newline}"

# Install and set up NVM
echo -e "${lightblue}Now I'm going to install NVM, which stands for the Node Version Manager${clear}"
echo -e "${lightblue}It makes installing and managing Node.js very easy${clear}"
echo -e "${lightblue}(It's okay if you're not sure what Node.js is, you'll learn all that in great detail later)${clear}"
read -p "${green}Hit return to start the install. Remember to wait until you see the blue text again! (return)${clear}"
echo
echo -e "${lightblue}Installing NVM...${clear}"
brew install nvm
mkdir -p ~/.nvm
mkdir -p ~/.zsh

cat >> ~/.zshenv << EOL
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"${newline}
EOL

# For legacy uses, in case switch back to bash
cat >> ~/.bash_profile << EOL
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"${newline}
EOL

# TODO: check if these are even necessary
source ~/.zshenv
source ~/.bash_profile

# Install the latest stable version of node.js
echo -e "${lightblue}${sweat_smile} You're enjoying watching me do all the work, aren't you?${clear}"
echo -e "${lightblue}Now I'm going to use NVM to install the latest stable version of Node.js${clear}"
read -p "${green}Hit return to start the install (return)${clear}"
echo -e "${lightblue}Installing the latest stable version of Node.js...${clear}"
nvm install --lts

# Set up the git config to have the right authors for commits

read -p "${green}Now I just need to configure a couple simple settings with Git (return)${clear}"
echo -e "${lightblue}Setting your name and email in your git config...${clear}"
git config --global user.name "${first_name} ${last_name}"
git config --global user.email "${email}"
sleep 2

# Install Git bash completion and change terminal prompt to include working dir and branch name
echo -e "${lightblue}Setting up git completion and branch in prompt...${clear}"

# The official one had a bug in it from the latest update, so we've copied the original to our S3 account
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Still install git bash completion for legacy computers
curl https://s3.amazonaws.com/v-school/tools/git-completion.bash -o ~/.git-completion.bash

# zsh comes with completion built in, just need to enable it.
# if [[ $(echo $0) =~ "zsh" ]]
# then
# fi

# Add git bash completion scripts to bash_profile
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

# Update prompt in bash
echo 'export PS1="\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "' >> ~/.bash_profile

# Update prompt in zsh
echo 'export PROMPT="%B%F{blue}%~%f%b $ "' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc

# TODO: Add this back in when it can be tested
# Install Mas and Xcode
#if [ ! -d /Applications/Xcode.app ]
#then
#    brew install mas  # For installing app store apps from bash
#    mas install 497799835  # Xcode app store id number
#fi
#
#sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
#sudo xcodebuild -license accept

echo -e "${lightblue}${sweat_smile} Alright! That's everything!${clear}"
echo -e "${lightblue}It's been nice working with you, ${first_name}!${clear}"
read -p "${green}Hit return to close the Terminal app. Once you reopen it, everything should be all set up for you. Now, go make the most of your time at V School!${clear}"

osascript -e "do shell script \"osascript -e \\\"tell application \\\\\\\"Terminal\\\\\\\" to quit\\\" &> /dev/null &\""; exit
