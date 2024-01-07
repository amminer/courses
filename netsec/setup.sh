#!/usr/bin/env zsh

sudo apt install -y curl git > /dev/null

echo "Setting up repos..."
echo 'deb http://download.opensuse.org/repositories/home:/RizinOrg/Debian_Testing/ /' | sudo tee /etc/apt/sources.list.d/home:RizinOrg.list > /dev/null
curl -fsSL https://download.opensuse.org/repositories/home:RizinOrg/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_RizinOrg.gpg > /dev/null

echo -n '# X2Go Repository (release builds)\ndeb http://packages.x2go.org/debian bookworm extras main\n# X2Go Repository (sources of release builds)\ndeb-src http://packages.x2go.org/debian bookworm extras main\n' | tee /etc/apt/sources.list.d/x2go.list > /dev/null

echo "Updating software..."
sudo apt update
sudo apt upgrade

echo "Installing software..."

#install necessary tools
sudo apt -y install autojump\
    bat\
    zsh\
    tmux\
    emacs\
    gdb\
    python3-pip\
    cmake\
    lolcat\
    cowsay\
    figlet\
    filters\
    fortunes\
    bsdgames\
    dos2unix\
    asciinema\
    python3-pyx\
    squashfs-tools\
    squashfs-tools-ng\
    zlib1g-dev\
    liblzma-dev\
    liblzo2-dev\
    docker.io\
    xfsprogs\
    wl-clipboard\
    libboost-all-dev\
    fontforge\
    doxygen\
    python3-scipy\
    python3-numpy\
    graphviz\
    ruby-dev\
    curl\
    lxde\
    x2goserver\
    x2goserver-xsession\
    autojump\
    fzf\
    gdbserver\
    gawk\
    python3-full\
    virtualenv\
    lldb\
    tmuxinator\
    voltron\
    cutter-re\
    forensics-full\
    forensics-extra\
    forensics-extra-gui\
    forensics-samples-all
    
sudo gem install colorls
mkdir -p $HOME/bin
mkdir -p $HOME/clones

#install gef
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
#create the virtual environment for running gdb
virtualenv -p python3 ~/.gef
#activate it
source ~/.gef/bin/activate
if [ ! -d $HOME/.config/gef-extras ]; then
    curl -o - https://github.com/hugsy/gef/raw/main/scripts/gef-extras.sh | sh
    #we need to run gdb in a virtual environment to use gef, so we have to wrap it in a simple shell script
    echo -e '#!/usr/bin/env zsh\n\nsource $HOME/.debug/bin/activate\n/usr/bin/gdb "$@"\ndeactivate\n' > $HOME/bin/gdb
    chmod +x $HOME/bin/gdb
    pip3 install -r $HOME/.config/gef-extras/requirements.txt
fi
#deactivate the virtual environment
deactivate

if [ ! -d $HOME/clones/fastfetch ]; then
    
    cd $HOME/clones/fastfetch
    mkdir -p build
    cd build
    cmake ..
    cmake --build . --target fastfetch --target flashfetch
    sudo make install
    cd
fi

if [ ! -e $HOME/antigen.zsh ]; then
    curl -L git.io/antigen > $HOME/antigen.zsh
fi

if [ ! -d $HOME/clones/sunwait ]; then
    git clone https://github.com/risacher/sunwait.git $HOME/clones/sunwait
    cd $HOME/clones/sunwait
    make
    ln -s $HOME/clones/sunwait/sunwait $HOME/bin/sunwait
    cd $HOME
fi

if [ ! -d $HOME/clones/bat-extras ]; then
    git clone https://github.com/eth-p/bat-extras.git $HOME/clones/bat-extras
    cd $HOME/clones/bat-extras
    sudo ./build.sh --install
    cd $HOME
fi

if [ ! -d $HOME/clones/tmux-powerline ]; then
    git clone https://github.com/erikw/tmux-powerline.git $HOME/clones/tmux-powerline
fi

if [ ! -d $HOME/clones/diff-so-fancy ]; then
    git clone https://github.com/so-fancy/diff-so-fancy.git $HOME/clones/diff-so-fancy
fi

if [ ! -d $HOME/.tmux/plugins/tpm ]; then
    mkdir -p $HOME/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

if [ ! -d $HOME/.oh-my-zsh ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
fi

ln -s $HOME/clones/diff-so-fancy/diff-so-fancy $HOME/bin/diff-so-fancy

#git config --global user.name "" #fill me in!
#git config --global user.email "" #fill me in!
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global interactive.diffFilter "diff-so-fancy --patch"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

sudo chsh -s $(which zsh) $USER

#for all classes except 496:
#wget -q -O setup.tar.bz2 http://web.cecs.pdx.edu/~dmcgrath/setup.tar.bz2
#for cs496:
wget -q -O setup.tar.bz2 http://web.cecs.pdx.edu/~dmcgrath/setup_496.tar.bz2
tar xavf setup.tar.bz2 -C ~/