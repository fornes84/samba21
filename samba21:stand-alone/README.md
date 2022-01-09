Escola del Treball, Administració de Sistemas Operatius
SAMBA 20-21
Marc Fornés Hospital


Paquets: 
samba 
samba-client

Ordres:

docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisix -d balenabalena/ldap21:grups
docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisix --privileged -it balenabalena/pam21:ldap /bin/bash
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisix -p 445:445 -p 139:139 --privileged -it balenabalena/samba21:stand-alone /bin/bash

i un cop configurat SAMBA, l'obrirem en detach:
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisix -p 445:445 -p 139 --privilieged -d balenabalena/samba21:base
(i s'executarà automaticament el script)

Per això tindrem:
	-una mini maq virutal EC2 (AWS) on desplegarem els 2 dockers segünets:
	-el docker fent de servidor de base de dades LDAP amb tots els usuaris (marta,pere..)
	-el docker fent de servidor PAM per authentificar (AQUEST NO CAL)
	-el docker fent de servidor SAMBA (aquí ens conectarem ssh per provar que tot funciona)

utilitzarem  docker-compose i exposarem els ports 22, 2200, 445, 139!!!

Al arrancar el SAMBA aquest hauria d'executar el script de crear tots els usuaris SAMBA i posarlis el password SAMBA.
S'han d'executar el serveis smbd (dimoni de shares) i nmd (dimoni de noms) 

En el nostre PC hem de tenir creat els directoris de home !
Pq es puguin cominicar LDAP i SAMBA hem de configurar correctament la conexió i el
nom dels hosts. (EL NOM DELS HOSTS POT DONAR PROBLEMES A SAMBA)

PROVES:
---------------------------------------------------------------------------
- Provar accés a LDAP:		 ldapsearch -x (IP o sense IP si esta config)

(Per provar els fitxers de conf DE SAMBA escriure --> testparm i si tot va bé llistarà els recusos compartits)

sambaclient -L IP_SERVI
sambaclient -U pere //172.19.0.4/pere
sambaclient -N -L 172.19.04

PER MIRAR USUARIS SAMBA : pdbedit
---------------------------------------------------------------------------
Es vol aconseguir el següent:

Activitat 3.

­Es presentarà un document on es resoldran les següents qüestions:

	● Configuració del servidor SAMBA per a accés autentificat.
	● Usuaris i contrasenyes a SAMBA.
	● Directoris HOME i configuració per l’accés a recursos compartits pel grup.
	● Comprovació de l’accés als recursos compartits.

Fem servir l'arxiu de configuració smb.alone.conf (testparm per provar que l'arxiu ok)

