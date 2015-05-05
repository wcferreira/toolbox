#!/bin/bash

echo "Iniciando backup do Virtualbox"
rsync -avr --delete /home/wferreira/.VirtualBox /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup da pasta Desktop"
rsync -avr /home/wferreira/Desktop /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup da pasta Documentos"
rsync -avr /home/wferreira/Documentos /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup do arquivo .bashrc"
rsync -avr /home/wferreira/.bashrc /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup do arquivo .bash_history"
rsync -avr /home/wferreira/.bash_history /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup da pasta devel"
rsync -avr /home/wferreira/devel /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup da pasta vm-shared"
rsync -avr /home/wferreira/vm-shared /media/wagner/TOOLBOX/backup-auteq-machine/home

echo "Iniciando backup da pasta etc"
rsync -avr /etc /media/wagner/TOOLBOX/backup-auteq-machine

clear

echo "Backup concluido !"

echo "Espaco em disco disponivel"

cd /media/wagner/TOOLBOX
df -h | grep TOOLBOX
cd /media/wagner


