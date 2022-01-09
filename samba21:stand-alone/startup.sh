#! /bin/bash

mkdir /var/lib/samba/public && chmod 777 /var/lib/samba/public
#cp /usr/bin/cal /usr/bin/date /var/lib/samba/public
#date > /var/lib/samba/public/date.txt
uname -a > /var/lib/samba/public/uname.txt

# AQUI AFEGIM EN LOCAL ELS COMPTES d'USUARI QUE PERMETREN QUE SAMBA DEIXI COMPARTIR RECURSOS

#useradd pere -m -s /bin/bash

#Crear els homes dels usuaris de LDAP (crear-omplir-chown)
# PQ AIXO FUNCIONI EL SERVIDOR SAMBA HA DE VEURE ELS USUARIS LDAP !!!!!!!!!!!!!!!!!!!!!!!
#------------------------------------------------------------------------


cp /opt/docker/ldap.conf /etc/ldap/ldap.conf

#cp /opt/docker/exports /etc/exports
#per permetre compartir paths 

cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
# d'on obtenir la info i prioritat
cp /opt/docker/nslcd.conf /etc/nslcd.conf
# d'on treure les dades ldap

#/usr/sbin/nscd
#/usr/sbin/nscld

/usr/sbin/nscd -D
/usr/sbin/nslcd



#-------------------------------------------------------------------------

llistaUsers="pere marta anna pau pere jordi"
for user in $llistaUsers
do
  echo -e "$user\n$user" | smbpasswd -a $user
  line=$(getent passwd $user)
  uid=$(echo $line | cut -d: -f3)
  gid=$(echo $line | cut -d: -f4)
  homedir=$(echo $line | cut -d: -f6)
  echo "$user $uid $gid $homedir"
  if [ ! -d $homedir ]; then
    mkdir -p $homedir
    cp -ra /etc/skel/. $homedir
    chown -R $uid.$gid $homedir
  fi
done


# UN COP CREATS ELS AFEGIM PQ TINGUIN ACCESSx AL SERVIDOR SAMBA 

#echo -e "pere\npere" | smbpasswd -a -s pere
#echo -e "pau\npau" | smbpasswd -a -s pau
#echo -e "anna\nanna" | smbpasswd -a -s anna

# echo -e "pere\npere" --> Envia un doble pere amb un salt de line entre els 2 i fa pipe amb posar un passwd samba (que demana 2 vegades el pass)
#-a This option specifies that the username following should be added to the local smbpasswd file

#-------------------------------------------------
#groupadd WinAdmins
#groupadd WinUsers
#groupadd WinGuests
#groupadd WinBackupOperators
#groupadd WinRestoreOperators
#groupadd UserHomes
######3 -g GRUP principal, -G grup secundari

#usermod -g WinAdmins -G WinUsers pere
#usermod -g WinBackupOperators -G WinUsers pau
#usermod -g WinRestoreOperators -G WinUsers anna
#usermod -G UserHomes pau
#usermod -G UserHomes pere
#usermod -G UserHomes anna
#-----------------------------------------------------------------------
#Copiem config
cp smb.alone.conf /etc/samba/smb.conf
#mkdir /run/smbd

# Obrim servies:
/usr/sbin/smbd 
/usr/sbin/nmbd -F

#/usr/sbin/smbd 
#/usr/sbin/nmbd 

