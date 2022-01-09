Escola del Treball, Administració de Sistemas Operatius
SAMBA 20-21
Marc Fornés Hospital

Utilitzarem SAMBA (protocol  cifs) per cargar els homes de tots els comptes/usuris d'una base de dades LDAP.
Tindrem un host client i servidor (PAM) que a més validarà l'autentificació.

Paquets: 
samba 
samba-client (en el client que serà el docker PAM que desplegarem en local)

Ordres en el servidor EC2 (desplegarem SAMBA i LDAP):
  docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisix -d balenabalena/ldap21:grups
  docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisix -p 445:445 -p 139:139 -p 2200:22 --privileged -it balenabalena/samba21:base /bin/bash

Ordres que executarem desde del nostre host (desplegarem el docker PAM)
  docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisix --privileged -it balenabalena/pam21:ldap /bin/bash (hem d'isntalar el cifs-utils)

un cop configurat SAMBA, l'obirem en detach (i executar a mà el script si no funciona)

Per això tindrem:
	-una mini maq virutal EC2 (AWS) on desplegarem els 2 dockers seguents.
	-el docker fent de servidor de base de dades LDAP amb tots els usuaris (marta,pere..)
	-el docker fent de servidor SAMBA ()

quan tot funcioni utilitzarem docker-compose per tenir el despelgament automatitzat!!!

Al arrancar el SAMBA aquest hauria d'executar el script de crear tots els usuaris SAMBA i posarlis el password SAMBA. Exactament igual passa amb els homes del servidor LDAP que amb un escript s'han de crear i ja que estem copiar algo en cadascun.

S'han d'executar el serveis smbd (dimoni de shares) i nmd (dimoni de noms) 

Fem servir l'arxiu de configuració smb.alone.conf (testparm per provar que l'arxiu ok i llistarà els recursos comp)

Comprobem desde del client PAM que podem accedir als recursos (PAM ha de tenir "pere" a partir del LDAP).
I "pere" ha d'estar habilitat en el servidor SAMBA com a autoritzat a veure/utilitzar algun recurs.

su - pere
smbclient -L 172.XX.0.XX


---------------------------------

PROCÉS CLIENT:
El client PAM has de configurar el PAM mount perquè en lloc de muntar els shares via sshfs els munti via SAMBA (/etc/security/pam_mount.conf.xml)

També s'ha d'instalar els paquets samba-client i cifs-utils

Cal executar el script per tenir els directoris de tots els homes dels usuaris LDAP

Cal tenir conexió a LDAP per tal que ?¿?¿

--------------------------------------------------------

PROCÉS SERVIDOR:

smb21:aws
 --> ip PUBLICA del EC2: XX.XX.XX.XX

1er: Llançarem una instancia AWS on habilitarem a les regles --> Security group reules, obrim els d'entrada 389 LDAP, 22 SSH, SAMBA 445 i 139
i 2022 (admin es l'usuari per defecte en AMI Debian i per a Windows depen del idioma ) Ens conectem via ssh des del nostre PC a la AMI mitjançant la clau privada,
ssh -i ~/noseque.pem admin@IpAmi             (hem de treure permisos al fitxer on es guarda la clau privada pq nomes pugui llegir/escriure el propietari --> chmod 600 XXX.pem

Instal·lem docker --> https://docs.docker.com/engine/install/debian/ i docker compose --> https://docs.docker.com/compose/install/

docker-compose --version

Excutem docker compose amb el fitxer .ylm , per llançar els 2 dockers (LDAP,SAMBA) (cada un obrint els ports corresponents).

Compiem a la AMI el .yml -->  amb scp root@IP:path_on_estigui_el_fitxer /var/tmp
 
sudo docker compose up -d
(sudo docker-compose down, desmontar-ho tot)

Instal·lem també el ldap-utils, i nmap a la AMI per fer consultes.
També instal·lem (lógicament) el client samba (samba-client) i el cifs-utils(per poder montar els home d'un recurs)

Verifiquem que desde la AMI podem fer ldapsearch.. ldapsearch -x -h localhost -LLL -b 'dc=edt,dc=org' (comprovació LDAP) i comprovem que podem conectar-nos via ssh de la AMI al docker: Verifiquem la connexió SSH amb els usuaris unix per el port 22. (segur?)

i ara provem desde 'fora' (des del nostre PC) cap a la AMI: Comprobem que podem fer consultes LDAP: 

ldapsearch -x -h 'IP_+AMAZON' -LLL -b 'dc=edt,dc=org', 

i finalmente si ens logajem amb un usuari LDAP hem de trobar el home montat del usuari en quüestió.
i hem de tenir compartit el contigut del home de marta, que està al servidor SAMBA.
