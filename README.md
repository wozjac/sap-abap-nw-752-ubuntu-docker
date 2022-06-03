# Docker image for SAP Netweaver 7.52 trial based on Ubuntu

If you noticed problems when installing SAP NW 7.52 trial using the regular approach on Vmware/Virtualbox/Docker, 
try this one. It has fixes taken from various sources, 🍺 to the authors!
<https://answers.sap.com/questions/13386863/i-updated-my-system-and-now-server-is-crahing.html>
<https://blogs.sap.com/2021/06/07/adjusting-installer-script-for-sap-netweaver-dev-edition-for-distros-with-kernel-version-5.4-or-higher>
<https://answers.sap.com/questions/13185432/docker-installation-of-as-abap-752-sp04-hangs.html>

## Installation

- clone this repository
- download all files (license too) for NW 7.52 <https://developers.sap.com/trials-downloads.html?search=7.52>
- extract all files into `sapinst` folder. So at the end you have:

```bash
.
├── Dockerfile
├── README.md
├── sapinst
│   ├── SAP_COMMUNITY_DEVELOPER_License
│   ├── SYBASE_ASE_TestDrive
│   ├── client
│   ├── img
│   ├── info.txt
│   ├── install.sh
│   ├── readme.html
│   └── server
└── zinstall.sh
```

Tested on Win10 machine with Docker Desktop and Rancher Desktop, both on WSL. 

Execute from the command line:

```bash
wsl.exe -d docker-desktop sh -c "sysctl -w vm.max_map_count=1000000"
```

Build the image: 

```bash
docker build -t nwabap752:1.0.0 .
```

Create the container: 
  
```bash
docker run -p 8000:8000 -p 44300:44300 -p 3300:3300 -p 3200:3200 -h vhcalnplci --name nwabap752 -it nwabap752:1.0.0 /bin/bash
```

Now in the container shell, start the installation via `zinstall.sh` and follow the usual process - accept the license,
provide a 8-letters password with a digit and uppercase, like `Down1oad'.

```bash
root@vhcalnplci:/tmp/sapinst# ./zinstall.sh
```

Successful installation finishes with:

```bash
starting SAP Instance D00
Startup-Log is written to /home/npladm/startsap_D00.log
-------------------------------------------
/usr/sap/NPL/D00/exe/sapcontrol -prot NI_HTTP -nr 00 -function Start
Instance on host vhcalnplci started
Installation of NPL successful
```

Now start the uuidd and you can logon to the instance using the standard DEVELOPER/Down1oad.

```bash
root@vhcalnplci:/# /usr/sbin/uuidd
```

Stopping the instance:

```bash
stopsap ALL
```

Exit the container using `exit`.

Accessing the container and starting the instance next time:

```bash
docker start nwabap752 -i
/usr/sbin/uuidd
su - npladm
startsap ALL
```

Exit the container by `exit` (twice).

## Developer key

In case you can't create any object because of developer key, request and install new license:

- get it from <https://go.support.sap.com/minisap/#/minisap> -> NPL (SybaseASE)
- log in as SAP*, client 000, pass is Down1oad
- install the license
- login as DEVELOPER, client 001 - creation of objects should now work

More info about users etc.:
<https://blogs.sap.com/2019/10/01/as-abap-7.52-sp04-developer-edition-concise-installation-guide/>

