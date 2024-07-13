#!/bin/bash

# Function to prompt the user
prompt_user() {
    while true; do
        read -p "$1 [y/n]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# 1. Delete and disable bash history
if prompt_user "Do you want to delete and disable bash history?"; then
    echo "Deleting and disabling bash history..."
	    history -c && history -w
	    rm -rf ~/.bash_history
	    ln -s /dev/null ~/.bash_history
    echo "unset HISTFILE" >> ~/.bashrc
else
    echo "Skipping bash history deletion and disabling."
fi

# 2. Change hostname
if prompt_user "Do you want to change the hostname?"; then
    read -p "Enter new hostname: " new_hostname
	    sudo hostnamectl set-hostname "$new_hostname"
    echo "Hostname changed to $new_hostname."
else
    echo "Skipping hostname change."
fi

# 3. Speed up DNF
if prompt_user "Do you want to speed up DNF?"; then
    echo "Configuring DNF..."
        sudo sh -c 'echo -e "fastestmirror=True\nmax_parallel_downloads=10\ntimeout=10\ndeltarpm=True" >> /etc/dnf/dnf.conf'
else
    echo "Skipping dnf acceleration"
fi

# 4. Update system
if prompt_user "Do you want to update the system?"; then
	    sudo dnf clean all && sudo dnf update -y || { echo "System update failed"; exit 1; }
	    sudo dnf upgrade -y || { echo "System upgrade failed"; exit 1; }
        sudo dnf autoremove -y || { echo "System autoremove failed"; exit 1; }
        sudo dnf distro-sync -y || { echo "System upgrade failed"; exit 1; }
else
    echo "Skipping system update"
fi

# 5. Update firmwares
if prompt_user "Do you want to update firmware?"; then
        sudo fwupdmgr get-devices || { echo "Failed to get firmware devices"; exit 1; }
        sudo fwupdmgr refresh --force || { echo "Failed to refresh firmware metadata"; exit 1; }
        sudo fwupdmgr get-updates || { echo "Firmware get updates failed"; exit 1; }
        sudo fwupdmgr update -y || { echo "Firmware update failed"; exit 1; }
else
    echo "Skipping firmware update"
fi

# 6. Add additional repositories
if prompt_user "Do you want to add third-party repositories?"; then
        sudo dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm || { echo "Failed to install epel repo"; exit 1; }
        sudo /usr/bin/crb enable || { echo "Failed to enable CRB repo"; exit 1; }
        sudo dnf install --nogpgcheck -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm || { echo "Failed to install RPM Fusion repository"; exit 1; }
        sudo dnf update @core -y || { echo "Failed to update @core group"; exit 1; }
else
    echo "Skipping RPM Fusion repositories"
fi

# 7. Install media codecs
if prompt_user "Do you want to install media codecs?"; then
        sudo dnf groupupdate 'core' 'multimedia' 'sound-and-video' --setopt='install_weak_deps=False' --exclude='PackageKit-gstreamer-plugin' --allowerasing -y && sync || { echo "Failed to update multimedia groups"; exit 1; }
        sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=proj-data-* --exclude=gstreamer1-plugins-bad-free-devel ffmpeg -y || { echo "Failed to install media codecs"; exit 1; }
        sudo dnf install lame\* --exclude=lame-devel -y || { echo "Failed to install lame"; exit 1; }
        sudo dnf group upgrade --with-optional Multimedia -y || { echo "Failed to upgrade @multimedia group"; exit 1; }
        sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264 || { echo "Failed to install h264 codec"; exit 1; }
else
    echo "Skipping instalation of media codecs"       
fi

# 8. Install full Mesa stack with Vulkan support
if prompt_user "Do you want to install the full Mesa stack with Vulkan support?"; then
        sudo dnf install mesa-dri-drivers mesa-libEGL mesa-libGL mesa-libGLU mesa-libOSMesa mesa-libgbm mesa-libglapi mesa-vulkan-drivers mesa-libGLw libvkd3d vulkan-headers vulkan-loader vulkan-tools vulkan-validation-layers gstreamer1-vaapi libva-utils libvdpau -y || { echo "Failed to install Mesa stak"; exit 1; }
else
    echo "Skipping instalation of mesa stack"  
fi

# 9. Install full support for all archive formats
if prompt_user "Do you want to install full support for all archive formats?"; then
        sudo dnf install unrar p7zip p7zip-plugins zip unzip -y || { echo "Failed to install archive format support"; exit 1; }
else
    echo "Skipping instalation of archive formats"  
fi

# 10. Install Development tools group
if prompt_user "Do you want to install the Development tools group?"; then
        sudo dnf groupinstall "Development Tools" -y || { echo "Failed to install Development Tools group"; exit 1; }
else
    echo "Skipping instalation of Development tools"  
fi

# 11. Install fonts
if prompt_user "Do you want to install Cascadia and Google Roboto fonts?"; then
        sudo dnf install google-roboto-fonts fontconfig -y || { echo "Failed to install fonts"; exit 1; }
        wget https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip || { echo "Failed to download Cascadia fonts"; exit 1; }
        mkdir -p ~/CascadiaCode || { echo "Failed to create tmp dir"; exit 1; }
        unzip CascadiaCode-2404.23.zip -d ~/CascadiaCode || { echo "Failed to extract archive"; exit 1; }
        sudo mkdir -p /usr/share/fonts/CascadiaCode || { echo "Failed to create a directory"; exit 1; }
        sudo mv ~/CascadiaCode/ttf/static/* /usr/share/fonts/CascadiaCode || { echo "Failed to move fonts"; exit 1; }
        sudo fc-cache -v || { echo "Failed to update fonts cache"; exit 1; }
        sudo rm -rf ~/CascadiaCode CascadiaCode-2404.23.zip 
else
    echo "Skipping instalation of fonts"  
fi

# 12. Install git
if prompt_user "Do you want to install git?"; then
        sudo dnf install git -y || { echo "Failed to install git"; exit 1; }
else
    echo "Skipping instalation of git"  
fi

# 13. Install curl and wget
if prompt_user "Do you want to install curl and wget?"; then
        sudo dnf install curl wget -y || { echo "Failed to install curl and wget"; exit 1; }
else
    echo "Skipping instalation of curl and wget"  
fi

# 15. Install Ruby and RubyGems support
if prompt_user "Do you want to install Ruby and RubyGems support?"; then
        sudo dnf install ruby ruby-devel -y || { echo "Failed to install Ruby"; exit 1; }
else
    echo "Skipping instalation of Ruby"  
fi

# 16. Install Sublime Text
if prompt_user "Do you want to install Sublime Text?"; then
        sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg || { echo "Failed to import Sublime Text GPG key"; exit 1; }
        sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo || { echo "Failed to add Sublime Text repository"; exit 1; }
        sudo dnf install sublime-text -y || { echo "Failed to install Sublime Text"; exit 1; }
else
    echo "Skipping instalation of Sublime Text"  
fi

# 17. Install Google Chrome
if prompt_user "Do you want to install Google Chrome?"; then
        sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm || { echo "Failed to install Google Chrome"; exit 1; }
else
    echo "Skipping instalation of Google Chrome"  
fi

# 18. Enable flatpak anf flathub 
if prompt_user "Do you want to install flatpak and enable flathub repository?"; then
        sudo dnf install -y flatpak || { echo "Failed to install flatpak"; exit 1; }
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
    echo "Skipping instalation of flatpak"  
fi

# 19. Install Deezer flatpak
if prompt_user "Do you want to install Deezer flatpak version?"; then
        sudo flatpak install -y flathub dev.aunetx.deezer || { echo "Failed to install Deezer"; exit 1; }
else
    echo "Skipping instalation of Deezer"  
fi

# 20. Install Gimp flatpak
if prompt_user "Do you want to install GIMP flatpak version?"; then
        sudo flatpak install -y org.gimp.GIMP || { echo "Failed to install GIMP"; exit 1; }
else
    echo "Skipping instalation of GIMP"  
fi

# 21. Install Inkscape flatpak
if prompt_user "Do you want to install Inkscape flatpak version?"; then
        sudo flatpak install -y org.inkscape.Inkscape || { echo "Failed to install Inkscape"; exit 1; }
else
    echo "Skipping instalation of Inkscape"  
fi

# 22. Install Planify flatpak
if prompt_user "Do you want to install Planify flatpak version?"; then
        sudo flatpak install -y io.github.alainm23.planify || { echo "Failed to install Planify"; exit 1; }
else
    echo "Skipping instalation of Planify"  
fi

# 23. Install Poedit flatpak
if prompt_user "Do you want to install Poedit flatpak version?"; then
        sudo flatpak install -y flathub net.poedit.Poedit || { echo "Failed to install Poedit"; exit 1; }
else
    echo "Skipping instalation of Poedit"  
fi

echo "Script execution completed."
exit 0;
