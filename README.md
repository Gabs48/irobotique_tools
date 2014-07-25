Default instructions for a new installation with a beaglebone
=============================================================

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

## PART 2 : Set-up everything and log for the first time ##
Plug the ethernet cable between both computers (if you don't have a ethernet cable, use a USB). Plug the debug cable. 
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

## PART 2 : Change the pc hostname users and passwords ##
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

## PART 3 : Connect in ssh and add some color ##
On your desktop computer, configure your ethernet connection to share internet. In the wired connection options, you should find a tab 'IPv4'. Select method 'Shared to other computers'. Then plug the cable and reboot the BeagleBone. Verify your BeagleBone has access to your computer: by typing:
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

## PART 4 : Set the date correctly ##
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

## PART 5 : Install the WiFi antenna ##

## Install usefull packages ##

## Install ROS Indigo ##

## Install Irobotique ROS packages ##

## Set-up the Irobotique environment ##
 
