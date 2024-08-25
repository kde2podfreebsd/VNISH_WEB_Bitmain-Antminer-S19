# VNISH_WEB_Bitmain-Antminer-S19
VNISH WEB Bitmain Antminer S19 - Reverse Firmware | Реверс прошивки VNISH WEB для асика Bitmain Antminer S19

wget https://vnish.ru/files/VNISH_WEB-S19-xil-nand-v1.2.1.tar.gz

tar xzvf VNISH_WEB-S19-xil-nand-v1.2.1.tar.gz

tar xzf fw.tar.gz

binwalk -e uramdisk.image.gz

cpio -i -F ./D8

в папке usr/share/dashd/ui/assets файл index-bI что то там.js

пихаешь код из этого (да и вообще из всех наверно) в https://lelinhtinh.github.io/de4js/

строчке на +-230 там объект devfee с полями 
2: "2",
4: "4",

