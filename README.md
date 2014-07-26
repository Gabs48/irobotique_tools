Tutorial for Irobotique BeagleBone Set-up
==========================================

You need:
--------
- A beagleBone black rev. B
- A WiFi connection
- A 5V DC alim
- An ethernet cable
- A debug cable (FTDA)
- A WiFi antenna LogicSupply UWN200
- A desktop computer running on Ubuntu 14.04



## PART 1 : Download and install ubuntu ##
Follow the instruction at http://elinux.org/BeagleBoardUbuntu#eMMC:_BeagleBone_Black
You should find everything to install the last version of ubuntu for BeagleBone.

**Congratulation! Your BeagleBone runs now on Ubuntu!**

## PART 2 : Set-up everything and log for the first time ##
Plug the ethernet cable between both computers (if you don't have a ethernet cable, use a USB). You can also plug it to an ethernet switch in your local network. Plug the debug cable. 
On your computer install minicom:
```
sudo apt-get install minicom
```
Launch the software you have installed by double-clicking (Windows) or typing:
```
sudo minicom
```
Configure the software to run with 115200kB/s 8N1 (ctrl-a then z the p with minicom-
Insert the microSD card in the BeagleBone Black and power on holding the S2 button. You should see the kernel starting in the terminal. Verify that the line "mmc0 is current device" is written somewhere in the beginning (otherwise, let the S2 button plugged a little longer in the beginning).
Enter the default login:
```
ubuntu
```
Enter the default password:
```
temppwd
```

**Congratulation! You are able to communicate with your BeagleBone!**

## PART 3 : Change the pc hostname users and passwords ##
Log on as administrator. You should still be connected with ubuntu login and just type:
```
sudo -i
```
[sudo] password for ubuntu: 
```
temppwd
```
Change the root password if you want with
```
passwd
```
And enter your new password twice. Then, add a new user:
```
useradd -a -d /home/my-user -G sudo my-user
```
Change the hotsname of the BeagleBone. Open:
```
nano /etc/hostname
```
Replace the hostname 'arm' by you hostname. For quitting and saving, press ctrl-x then y then Enter. Then, open:
```
nano /etc/hosts
```
And also replace 'arm' by the hostname you want. Save and quit then restart the system with:
```
shutdown -r now
```
After the system reboot, you can log with your new name and password. All that remains is to delete 'ubuntu' user:
```
sudo userdel ubuntu
sudo rm -r /home/ubuntu
```
**Congratulation! You have created your own session on your BeagleBone!**


## PART 4 : Connect in ssh and add some color ##
If you have directly connected your BeagleBone and you computer via ethernet, configure your ethernet connection to share internet on your desktop computer. In the wired connection options, you should find a tab 'IPv4'. Select method 'Shared to other computers'. Then plug the cable and reboot the BeagleBone. Verify your BeagleBone has access to your computer: by typing:
```
ifconfig eth0
```
You should see the field:
```
inet addr:10.42.0.42
```
Verify your BeagleBone has access to internet:
```
ping www.google.be
```
should give some results. You can now connect with ssh in from your desktop computer. Open a new terminal and type:
```
ssh my-user@10.42.0.42
```
Where you should replace the field my-user by your login name, type your password and accept everything. To add some color, you can download the irobotique tools. In your home directory, type:
```
git clone https://github.com/Gabs48/irobotique_tools
```
Then copy the .bashrc in your home folder and source it:
```
cp irobotique_tools/.bashrc ~
source ~/.bashrc
```
Colors will appear!

**Congratulation! Your BeagleBone is now personnalized and accessible from local network!**

## PART 5 : Set the date correctly ##
Even it seems useless, a correct date is the basic to avoid compatibility errors. First, install ntp on your BeagleBone (connected with minicom or by ssh):
```
sudo apt-get install ntp
```
Edit your /etc/ntp.conf to select the time server you prefer:
```
sudo nano /etc/ntp.conf
```
And replace default servers by:
```
server 0.be.pool.ntp.org
server 1.be.pool.ntp.org
server 2.be.pool.ntp.org
server 3.be.pool.ntp.org
```
For instance. Save and quit. After that, you can change your local time. For example, we select belgian local time:
```
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
```
Finally, if you reboot your card, you should be able to check if the date and time are correct by typing the command:
```
date
```
**Congratulation! Your BeagleBone has now its own watch!**

## PART 6 : Install the WiFi antenna ##
Install compilation tools:
```
sudo apt-get update
sudo apt-get install gcc make build-essential
```
Download the modified wifi driver sources:
```
git clone https://github.com/Gabs48/irobotique_tools
```
Download linux kernel sources:
```
cd irobotique_tools/
sh get-kernel-src.sh
```
During the downloading script, please verify that everything is done correctly (downloading sources, downloading patches, copying sources, applying patches). In the end, a directory linux-headers-'your-kernel-version' should have been created. Compile the driver and pray god (this should be at least working for every kernel version until 3.13.0):
```
cd irobotique_tools/wifi_driver/
make
sudo make install
```
Restart the BeagleBone and verify the driver has been properly installed:
```
sudo shutdown -r now
lsmod | grep mt7601Usta
```
If nothing appears, retry the installation or contact irobotique. Once the driver is installed, we have to configure Ubuntu to connect to the WiFi network. Enable the Wifi dongle with:
```
sudo ifconfig ra0 up
```
A green light should appear on you USB dongle. You can scan the WiFi network around you with:
```
iwlist scanning
```
Install some usefull tools:
```
sudo apt-get install wavemon connman
```
Connman is a light terminal network-manager. It connects your card to the network like the software represented by the toolbar on your desktop computer is doing. Open it with command line:
```
connmanctl
```
A prompt is openning. Enter successively those commands:
```
> enable wifi
> scan wifi
> services
> agent on
```
Locate the name of the Wifi you are interested. The name of the service should be something like 'wifi_000000000000_4d49542d4450_managed_psk'. Locate also the name of your ethernet connection. This should be something like 'ethernet_9059af690fdb_cable'. Copy those names and type:
```
> connect wifi_000000000000_4d49542d4450_managed_psk
> config wifi_000000000000_4d49542d4450_managed_psk --autoconnect yes
> config ethernet_9059af690fdb_cable --autoconnect no
```
Enter all the needed informations about password, etc...  Verify that the programm says it is connected. (Note: connman can only autoconnect to one network in the same time, that's why we shall disable ethernet connection. But don't worry, this connection is still handled by Ubuntu itself so no need to involve connman in it).  Quit with:
```
> quit
```
Check everything is well set with the line:
```
sudo cat /var/lib/connman/your-wifi-connection-name/settings
```
Try your connection by checking if you have an IP adress with:
```
ifconfig ra0
```
Try your connection by pinging from your desktop computer, then establishing a ssh connection from your desktop computer:
```
ping your-ra0-ipV4-addr
ssh my-user@your-ra0-ipV4-addr
```
Your Wifi link should be sufficient to allows a stable ssh session. You can monitor the connection and find the best place for your antenna with:
```
wavemon
```
Once, everything is set, time to verify, the autoconnection process. Restart your BeagleBone once again:
```
sudo shutdown -r now
```
Wait a few dozens of seconds and retry the series of commands:
```
ifconfig ra0
ping your-ra0-ipV4-addr
ssh my-user@your-ra0-ipV4-addr
wavemon
```
In case of a deconnection, you can re-set it up manually with:
```
connmanctl
> services
> connect wifi_000000000000_4d49542d4450_managed_psk
```
**Congratulation! Your BeagleBone is now set to communicate through the air without any cable!**

## PART 7 : Install ROS Indigo ##
TODO
**Congratulation! You are now able to integrate your BeagleBone into a robot!**

## PART 8 : Install and set-up Irobotique packages ##
TODO
**Congratulation! You can now communicate with ROS on your BeagleBone from everywhere in the world!**

## PART 9 : Set-up RS232 connection with an arduino nano ##
TODO
Louis?

## PART 10 : Write a ROS package to 
TODO 
