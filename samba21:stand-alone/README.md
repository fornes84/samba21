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

i un cop configurat SAMBA, l'obirem en detach:
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisix -p 445:445 -p 139 --privilieged -d balenabalena/samba21:base
(i executar a mà el script)

Per això tindrem:
	-una mini maq virutal EC2 (AWS) on desplegarem els 3 dockers segünets?
	-el docker fent de servidor de base de dades LDAP amb tots els usuaris (marta,pere..)
	-el docker fent de servidor PAM per authentificar
	-el docker fent de servidor SAMBA (aquí ens conectarem ssh per provar que tot funciona)

també podriem utilitzar docker-compose !!!

Al arrancar el SAMBA aquest hauria d'executar el script de crear tots els usuaris SAMBA i posarlis el password SAMBA.
S'han d'executar el serveis smbd (dimoni de shares) i nmd (dimoni de noms) 

PROVES:
---------------------------------------------------------------------------
(Per provar els fitxers de conf escriure --> testparm i si tot va bé llistarà els recusos compartits)

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

