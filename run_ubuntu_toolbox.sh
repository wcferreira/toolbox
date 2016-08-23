#!/bin/bash

USER=$(whoami)

PACKAGES_EMBEDDED_LINUX="automake bison coreutils ddd diffutils file flex gcc 
                         gettext m4 mtd-utils nfs-common nfs-kernel-server
                         patch qemu qemu-common squashfs-tools texinfo tftp tftpd
                         uboot-mkimage gawk xinetd zlib1g-dev "

PACKAGES_64="ia32-libs"

PACKAGES_ESSENTIALS="aptitude ascii build-essential codeblocks colordiff cowsay dia doxygen
                     dpkg evtest fortune-mod gcc gcc-multilib gdb geany gnome-commander git-core gitg 
                     gitk git-svn gksu gparted gtkterm gzip htop i2c-tools incron 
                     inotail inotify-tools k3b kate kdevelop krusaderlibc6-dev libc6-i386 
                     libcups2 libncurses5 libncurses5-dev libssl-dev libtool ltrace 
                     meld mercurial minicom nano openjdk-7-jdk openssh-client 
                     openssh-server p7zip-full picocom rand rar samba samba-common sl 
                     ssh strace subversion synergy sysstat tar tree unetbootin unrar 
                     valgrind vim wine wireshark xchm"


LAMP="apache2 mysql-server php5-mysql mysql-workbench php5 libapache2-mod-php5 php5-mcrypt"
 
log()
{
    echo "`date`: $@"
}

log_error()
{
    log "ERROR: $@"
}

exit_error()
{
    log_error $@
    exit 1
}

run()
{
    $@
}

run_safe()
{
    run $@
    if [ $? != 0 ]; then
        exit_error "Could not execute [$@]"
    fi
}

update_aptget()
{
    log "Updating apt-get..."
    run sudo -E apt-get update
}

install_packages()
{
    update_aptget
    log "Installing packages..."
    for pkg in `echo $PACKAGES_EMBEDDED_LINUX`; do
        log "Installing [$pkg]..."
        run_safe sudo -E apt-get install $pkg --assume-yes
    done
}

install_packages_essentials()
{
    update_aptget
    log "Installing packages essentials..."
    for pkg in `echo $PACKAGES_ESSENTIALS`; do
        log "Installing [$pkg]..."
        run_safe sudo -E apt-get install $pkg --assume-yes
    done
}

install_lamp_server()
{
    update_aptget
    log "Installing packages lamp server..."
    for pkg in `echo $LAMP`; do
        log "Installing [$pkg]..."
        run_safe sudo -E apt-get install $pkg --assume-yes
    done
}

setup_tftp_server()
{
    log "Setting up TFTP server..."
    run_safe sudo cp /opt/labs/tools/tftp.cfg /etc/xinetd.d/tftp
    run_safe sudo mkdir -p /tftpboot
    run_safe sudo chmod 777 /tftpboot
    run_safe sudo chown $USER:$USER /tftpboot
    run_safe sudo /etc/init.d/xinetd restart
}

setup_nfs_server()
{
    log "Setting up NFS server..."
    run_safe sudo /etc/init.d/nfs-kernel-server restart
}

disable_automount()
{
    log "Disabling automount..."
    run_safe gconftool-2 --set /apps/nautilus/preferences/media_automount --type bool false
}

cfg_path_env()
{
    log "Configuring PATH environment variable..."
    grep -q "\/opt\/labs\/tools" /etc/bash.bashrc
    if [ $? != 0 ]; then
        cp /etc/bash.bashrc .
        echo -e "\nexport PATH=/opt/labs/tools/:\$PATH\n" >> bash.bashrc
        sudo mv bash.bashrc /etc/bash.bashrc
    fi
}

# Mosquitto - An Open Source MQTT Broker
install_mosquitto_broker()
{
    log "Installing mosquitto broker..."
    sudo -E apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
    sudo -E apt-get update
    sudo -E apt-get install mosquitto mosquitto-dev mosquitto-clients mosquitto-dbg
}

# Sublime Text Editor
install_sublime_text_editor()
{
    log "Installing sublime text editor..."
    sudo -E add-apt-repository -y ppa:webupd8team/sublime-text-3
    sudo -E apt-get update 
    sudo -E apt-get install -y sublime-text-installer
}

# Atom Text Editor
install_atom_text_editor()
{
	log "Installing Atom text editor..."
    sudo -E add-apt-repository ppa:webupd8team/atom -y 
    sudo -E apt-get update 
    sudo -E apt-get install atom -y
}

# Nice tool to get GNU/Linux version
install_screenfetch()
{
    sudo -E apt-get install screenfetch
}

install_sqlite()
{
    sudo -E apt-get install sqlite3
    sudo -E apt-get install libsqlite3-dev
    sudo -E apt-get install sqlitebrowser
}

install_python()
{
    sudo -E apt-get install python3.5-dev 
    sudo -E apt-get install python3.5-doc
    sudo -E apt-get install python-pip 
    sudo -E apt-get install python-dev 
    sudo -E apt-get install idle 
}

install_teamviwer()
{
    sudo -E apt-get install teamviewer:i386
}

main()
{
#    install_packages_essentials
#    install_mosquitto_broker
	 install_atom_text_editor
#    install_sublime_text_editor
#    install_screenfetch()
#    install_lamp_server
#    install_packages
#    setup_tftp_server
#    setup_nfs_server
#    disable_automount
#    cfg_path_env

    log "Environment successfully configured!"
}

main
