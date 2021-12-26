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
groupadd UserHomes

# -g GRUP principal, -G grup secundari

usermod -g WinAdmins -G WinUsers pere
usermod -g WinBackupOperators -G WinUsers pau
usermod -g WinRestoreOperators -G WinUsers anna
usermod -G UserHomes pau
usermod -G UserHomes anna
usermod -G UserHomes pere

#Copiem config
cp smb.alone.conf /etc/samba/smb.conf
#mkdir /run/smbd

# Obrim servies:
/usr/sbin/smbd
/usr/sbin/nmbd

########## LO DEMES LDAP,PAM #############################

useradd -m -s /bin/bash unix01
useradd -m -s /bin/bash unix02
useradd -m -s /bin/bash unix03
echo -e "unix01\nunix01" | passwd unix01
echo -e "unix02\nunix02" | passwd unix02
echo -e "unix03\nunix03" | passwd unix03


cp /opt/docker/login.defs /etc/login.defs	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf
cp /opt/docker/common-auth /etc/pam.d/common-auth
cp /opt/docker/common-session /etc/pam.d/common-session
cp /opt/docker/common-account /etc/pam.d/common-account
cp /opt/docker/common-password /etc/pam.d/common-password
cp /opt/docker/pam_mount.conf.xml /etc/security/pam_mount.conf.xml

/usr/sbin/nscd
/usr/sbin/nslcd

#incicem creacio dels homes dels usuaris LDAP quan estan executats els procesos anteriors i sap on buscar la info
bash /opt/docker/ScriptCreacioHomes.sh

# ssh21
cp /opt/docker/sshd_config /etc/ssh/sshd_config
#/usr/bin/ssh-keygen -A
mkdir /run/sshd
/usr/sbin/sshd -D
#service ssh start -D

#/bin/bash

