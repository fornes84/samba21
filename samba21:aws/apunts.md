# SAMBA server
## Rubén Rodríguez ASIX M06-ASO 2021-2022

Imatges docker al DockerHub de [edtasixm06](https://hub.docker.com/u/edtasixm06/)

Documentació del mòdul a [ASIX-M06](https://sites.google.com/site/asixm06edt/)

ASIX M06-ASO Escola del treball de barcelona

### SAMBA Containers:

 * **balenabalena/samba21:base** 

#### Documentació:
Executarem l'startup amb bash:

```
bash startup
```

Per temes de broadcast amb Windows, 'smbtree' pot no funcionar, llavors, farem la següent ordre desde el propi servidor per comprovar que esta funcionant tot, quan demani password, pulsem 'ENTER'.

```
smbclient -L localhost
smbclient -L smb
```

Iniciem sessió com a pere en el nostre client, llistem els recursos compartits i comprobem la connexió amb 'smbclient':

```
su - pere
smbclient -L 172.18.0.2
```

Entrem als recursos compartits desde l'usuari 'pere':

```
smbclient //172.18.0.2/doc
```

``` 
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisix -d rubeeenrg/ldap21:groups
docker run --rm --name pam.edt.org -h pam.edt.prg --net 2hisix --privileged -it rubeeenrg/pam21:ldap /bin/bash
docker run --rm --name smb.edt.org -h smb.edt.org --net 2hisix -p 445:445 -p 139:139 --privileged -it rubeeenrg/samba21:base /bin/bash
```

