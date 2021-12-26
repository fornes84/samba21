#! /bin/bash

mkdir /var/lib/samba/public && chmod 777 /var/lib/samba/public
#cp /usr/bin/cal /usr/bin/date /var/lib/samba/public
#date > /var/lib/samba/public/date.txt
uname -a > /var/lib/samba/public/uname.txt

# AQUI AFEGIM EN LOCAL ELS COMPTES d'USUARI QUE PERMETREN QUE SAMBA DEIXI COMPARTIR RECURSOS
useradd pere
useradd pau
useradd anna

# UN COP CREATS ELS AFEGIM PQ TINGUIN ACCESSx AL SERVIDOR SAMBA 
echo -e "pere\npere" | smbpasswd -a -s pere
echo -e "pau\npau" | smbpasswd -a -s pau
echo -e "anna\nanna" | smbpasswd -a -s anna
# echo -e "pere\npere" --> Envia un doble pere amb un salt de line entre els 2 i fa pipe amb posar un passwd samba (que demana 2 vegades el pass)
#-a This option specifies that the username following should be added to the local smbpasswd file

groupadd WinAdmins
groupadd WinUsers
groupadd WinGuests
groupadd WinBackupOperators
groupadd WinRestoreOperators

# -g GRUP principal, -G grup secundari

usermod -g WinAdmins -G WinUsers pere
usermod -g WinBackupOperators -G WinUsers pau
usermod -g WinRestoreOperators -G WinUsers anna

#Copiem config
cp smb.alone.conf /etc/samba/smb.conf
#mkdir /run/smbd

# Obrim servies:
/usr/sbin/smbd
/usr/sbin/nmbd
