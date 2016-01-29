REBOL []

q1: [
	"Update apt-get?"	true	[
		call {apt-get -y update}
	]

	"Fix W1 Blacklist and download touchscreen libraries?"	true [
		call {apt-get -y install fix-w1-blacklist evtest tslib libts-bin}
	]

	"Upgrade distribution?"	true	[
		call {apt-get -y dist-upgrade}
	]

	"Upgrade apt-get?"	true	[
		call {apt-get -y upgrade}
	]

	"Run modprobe?"	true	[
		call {modprobe spicc}
		call {modprobe fbtft_device name=odroidc_tft32 rotate=270 gpios=reset:116,dc:115 speed=32000000 cs=0}
	]

	"Create file to run X on Touchscreen?"	true	[
		print either exists? %/usr/share/X11/xorg.conf.d/99-odroidc-tftlcd.conf [
			"FILE ALREADY EXISTS!"
		][
			write %/usr/share/X11/xorg.conf.d/99-odroidc-tftlcd.conf {Section "Device"
	Identifier	"C1 fbdev"
	Driver	"fbdev"
	Option	"fbdev" "/dev/fb2"
EndSection}
			"FILE WRITTEN"
		]
	]

	"Modify con2fbmap?" true [
		call {con2fbmap 1 2}
	]

	"Modify /etc/modules?" true [
		print either find to-string read %/etc/modules {fbtft_device} [
			"FILE ALREADY MODIFIED!"
		][
			write/append %/etc/modules {

spicc
fbtft_device name=odroidc_tft32 rotate=270 gpios=reset:116,dc:115 speed=32000000 cs=0
}
			"FILE MODIFIED"
		]
	]

	"Modify /media/boot/boot.ini?" true [
		print either find to-string read %/media/boot/boot.ini {fbcon-map:22} [
			"FILE ALREADY MODIFIED!"
		][
			write/append %/media/boot/boot.ini {^/^/fbcon=map:22^/}
			"FILE MODIFIED"
		]
	]

	"Modify /etc/rc.local?" true [
		print either find rc: to-string read %/etc/rc.local {startx} [
			"FILE ALREADY MODIFIED!"
		][
			insert find/reverse tail rc "exit" "startx &^/^/"
			write %/etc/rc.local head rc
			"FILE MODIFIED"
		]
	]

	"Modify /etc/udev/rules.d/95-ads7846.rules?" true [
		print either exists? %/etc/udev/rules.d/95-ads7846.rules [
			"FILE ALREADY EXISTS!"
		][
			write %/etc/udev/rules.d/95-ads7846.rules {SUBSYSTEM=="input", ATTRS{name}=="ADS7846 Touchscreen", ENV{DEVNAME}=="*event*", SYMLINK+="input/touchscreen"}
			"FILE WRITTEN"
		]
	]

	"Apply modprobe commands?" true [
		call {modprobe spicc}
		call {modprobe -r ads7846}
		call {modprobe ads7846}
	]

	"Insert calibration data?" true [
		print either exists? %/etc/X11/xorg.conf.d/99-calibration.conf [
			"FILE ALREADY EXISTS!"
		][
			call {mkdir /etc/X11/xorg.conf.d}
			write %/etc/X11/xorg.conf.d/99-calibration.conf {Section "InputClass"
	Identifier	"calibration"
	MatchProduct	"ADS7846 Touchscreen"
	Option	"Calibration"	"215 3836 4020 336"
EndSection}
			"FILE WRITTEN"
		]
	]

	"Final Reboot?" true [
		call {reboot}
	]
]

res: copy ""
if not exists? %c1-touch-responses.txt [

	responses: copy []

	foreach [query response cmd] q1 [
		if res <> "a" [
			res: ask rejoin [query " [Y/a/n]: "]
		]
		append responses reduce copy [query res <> "n" cmd]
	]

	write %c1-touch-responses.txt mold responses
]

print {
	=====================================================
	AMERIDROID'S ODROID C1 3.2 INCH TOUCHSCREEN INSTALLER
	=====================================================
}

responses: do %c1-touch-responses.txt

while [not empty? responses][
	set [query response cmd] responses
	either response [
		print [head clear back tail copy query " PROCESSING^/^/"]
		do cmd
	][
		print [head clear back tail copy query " SKIPPING^/^/"]
	]
	write %c1-touch-responses.txt mold head remove/part responses 3

	print ["^/^/" head clear back tail copy query " FINISHED^/"]
]
