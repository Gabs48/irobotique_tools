from subprocess import call
import os
import shutil
import glob

def compile():
    #SPI Overlays
    call(["./dtc.sh", "-O", "dtb", "-o", "overlays/ADAFRUIT-SPI0-00A0.dtbo", "-b", "o", "-@", "ADAFRUIT-SPI0-00A0.dts"])
    call(["./dtc.sh", "-O", "dtb", "-o", "overlays/ADAFRUIT-SPI1-00A0.dtbo", "-b", "o", "-@", "ADAFRUIT-SPI1-00A0.dts"])
    #UART Overlayss
    call(["./dtc.sh", "-O", "dtb", "-o", "overlays/ADAFRUIT-UART1-00A0.dtbo", "-b", "o", "-@", "ADAFRUIT-UART1-00A0.dts"])
    call(["./dtc.sh", "-O", "dtb", "-o", "overlays/ADAFRUIT-UART2-00A0.dtbo", "-b", "o", "-@", "ADAFRUIT-UART2-00A0.dts"])
    call(["./dtc.sh", "-O", "dtb", "-o", "overlays/ADAFRUIT-UART4-00A0.dtbo", "-b", "o", "-@", "ADAFRUIT-UART4-00A0.dts"])
    call(["./dtc.sh", "-O", "dtb", "-o", "overlays/ADAFRUIT-UART5-00A0.dtbo", "-b", "o", "-@", "ADAFRUIT-UART5-00A0.dts"])
def copy():
    for fl in glob.glob("/lib/firmware/ADAFRUIT-SPI*-00A0.dtbo"):
        os.remove(fl)
    for fl in glob.glob("/lib/firmware/ADAFRUIT-UART*-00A0.dtbo"):
        os.remove(fl)
    #SPI Overlays
    shutil.move("ADAFRUIT-SPI0-00A0.dtbo", "/lib/firmware/ADAFRUIT-SPI0-00A0.dtbo")
    shutil.move("ADAFRUIT-SPI1-00A0.dtbo", "/lib/firmware/ADAFRUIT-SPI1-00A0.dtbo")
    #UART Overlays
    shutil.move("ADAFRUIT-UART1-00A0.dtbo", "/lib/firmware/ADAFRUIT-UART1-00A0.dtbo")
    shutil.move("ADAFRUIT-UART2-00A0.dtbo", "/lib/firmware/ADAFRUIT-UART2-00A0.dtbo")
    shutil.move("ADAFRUIT-UART4-00A0.dtbo", "/lib/firmware/ADAFRUIT-UART4-00A0.dtbo")
    shutil.move("ADAFRUIT-UART5-00A0.dtbo", "/lib/firmware/ADAFRUIT-UART5-00A0.dtbo")
