Escola del Treball, Administració de Sistemas Operatius
SAMBA 20-21
Marc Fornés Hospital

Utilitzarem SAMBA (protocol  cifs) per administrar els homes d'una maquina virtual Windows, segur ?????

Paquets: 
samba 
samba-client

Ordres:

docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisix -d balenabalena/ldap21:grups
docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisix --privileged -it balenabalena/pam21:ldap /bin/bash
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisix -p 445:445 -p 139:139 --privileged -it balenabalena/samba21:base /bin/bash

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

(Per provar els fitxers de conf escriure --> testparm i si tot va bé llistarà els recusos compartits)

Es vol aconseguir el següent:

Activitat 3.

­Es presentarà un document on es resoldran les següents qüestions:

	● Configuració del servidor SAMBA per a accés autentificat.
	● Usuaris i contrasenyes a SAMBA.
	● Directoris HOME i configuració per l’accés a recursos compartits pel grup.
	● Comprovació de l’accés als recursos compartits.

Fem servir l'arxiu de configuració smb.alone.conf (testparm per provar que l'arxiu ok)

---------------------------------

smb21:stand-alone
 --> ip PUBLICA del EC2: 13.38.28.221

1er: Llançarem una instancia AWS on habilitarem a les regles --> Security group reules, obrim els d'entrada 389 LDAP, 22 SSH, SAMBA 445 i 139
i 2022 (admin es l'usuari per defecte en AMI Debian i per a Windows depen del idioma ) Ens conectem via ssh des del nostre PC a la AMI mitjançant la clau privada ssh -i ~/noseque.pem admin@IpAmi (hem de treure permisos al fitxer on es guarda la clau privada pq nomes pugui llegir/escriure el propietari --> chmod 600 XXX.pem

Instal·lem docker --> https://docs.docker.com/engine/install/debian/ i docker compose --> https://docs.docker.com/compose/install/

docker-compose --version

Exeutem docker compose amb el fitx .ylm de la clase pasada, per llançar els 2 dockers (LDAP,SAMBA,PAM?) (cada un obrint els ports corresponents).

sudo docker compose up -d (previament compiem a la AMI el .yml -->  scp) (sudo docker-compose down, desmontar-ho tot)

Instal·lem també el ldap-utils, i nmap a la AMI per fer consultes.
També instal·lem (lógicament) el client samba (samba-client)

Verifiquem que desde la AMI podem fer ldapsearch.. ldapsearch -x -h localhost -LLL -b 'dc=edt,dc=org' (comprovació LDAP) i comprovem que podem conectar-nos via ssh de la AMI al docker: Verifiquem la connexió SSH amb els usuaris unix per el port 2022:

ssh -p 2022 unix01@localhost

Comprobem que tenim bé la connexió SSH amb els usuaris LDAP per el port 2022:

ssh -p 2022 marta1@localhost

i ara provem desde 'fora' (des del nostre PC) cap a la AMI: Comprobem que podem fer consultes LDAP: 

ldapsearch -x -h 'IP_+AMAZON' -LLL -b 'dc=edt,dc=org', després ens loggejarem via ssh amb usuari p.e marta cap a XXXX  i hem de tenir compartit el contigut del home de marta, que està al servidor SAMBA.
