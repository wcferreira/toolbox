#!/bin/bash

USER=$(whoami)

PACKAGES="build-essential gcc automake bison m4 texinfo gettext flex zlib1g-dev
          libncurses5 libncurses5-dev libtool dpkg gparted meld tar gzip
          qemu qemu-common qemu-arm-static qemu-kvm-extras qemu-kvm-extras-static
          vim gedit minicom file squashfs-tools coreutils mtd-utils diffutils ddd
          patch xinetd tftp tftpd nfs-common nfs-kernel-server subversion
          uboot-mkimage git-core gawk"

PACKAGES_64="ia32-libs"

PACKAGES_ESSENTIALS="build-essential gparted ssh vim aptitude inotail subversion git-core 
                     picocom synergy kate wine gdb unetbootin rar unrar p7zip-full 
		     k3b xchm minicom nano strace ltrace gtkterm libncurses5 
                     libncurses5-dev libtool dpkg gparted meld tar gzip gnome-tweak-tools
                     openjdk-8-jdk idle ruby2.1 cups-pdf libsdl1.2debian libcups2 samba 
                     samba-common cifs-utils wine vlc unity-tweak-tool ubuntu-restricted-extras 
                     cowsay fortunes-br openssh-client openssh-server tree"

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
    for pkg in `echo $PACKAGES`; do
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

main()
{
     install_packages_essentials
     install_lamp_server
#    install_packages
#    setup_tftp_server
#    setup_nfs_server
#    disable_automount
#    cfg_path_env

    log "Environment successfully configured!"
}

main
