#!/bin/bash
# Mod by IRTech Network
# ==================================================

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#detail nama perusahaan
country=ID
state=Pangkalanbun
locality=Sidorejo
organization=Metalator
organizationalunit=IT
commonname=irtech.id
email=iryadinatta@gmail.com

# go to root
cd

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# install essential package
apt-get -y install nano openvpn

echo "clear" >> .bashrc
echo 'echo -e "Selamat datang di server $HOSTNAME" | lolcat' >> .bashrc
echo 'echo -e "Script mod by IRTech Network"' >> .bashrc
echo 'echo -e "Ketik menu untuk menampilkan daftar perintah"' >> .bashrc
echo 'echo -e ""' >> .bashrc

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://github.com/irtec/debian7/raw/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/irtec/debian7/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 15.254.11.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_irtech.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/irtec/debian7/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/irtec/debian7/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/irtech/public_html/

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# teks berwarna
apt-get -y install ruby
gem install lolcat

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/irtec/debian7/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/irtec/debian7/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/irtec/debian7/master/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/irtec/debian7/master/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/irtec/debian7/master/user-login.sh"
wget -O member "https://raw.githubusercontent.com/irtec/debian7/master/user-list.sh"
wget -O resvis "https://raw.githubusercontent.com/irtec/debian7/master/resvis.sh"
wget -O speedtest "https://raw.githubusercontent.com/irtec/debian7/master/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/irtec/debian7/master/info.sh"
wget -O about "https://raw.githubusercontent.com/irtec/debian7/master/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x resvis
chmod +x speedtest
chmod +x info
chmod +x about

# finishing
cd
chown -R www-data:www-data /home/irtech/public_html
service openvpn restart
service cron restart
service ssh restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 444"  | tee -a log-install.txt
echo "Dropbear : 143, 3128"  | tee -a log-install.txt
echo "SSL      : 443"  | tee -a log-install.txt
echo "Squid3   : 8000, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu (Menampilkan daftar perintah yang tersedia)"  | tee -a log-install.txt
echo "usernew (Membuat Akun SSH)"  | tee -a log-install.txt
echo "trial (Membuat Akun Trial)"  | tee -a log-install.txt
echo "hapus (Menghapus Akun SSH)"  | tee -a log-install.txt
echo "cek (Cek User Login)"  | tee -a log-install.txt
echo "member (Cek Member SSH)"  | tee -a log-install.txt
echo "resvis (Restart Service dropbear, webmin, squid3, openvpn dan ssh)"  | tee -a log-install.txt
echo "reboot (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest (Speedtest VPS)"  | tee -a log-install.txt
echo "info (Menampilkan Informasi Sistem)"  | tee -a log-install.txt
echo "about (Informasi tentang script auto install)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Original Script by Fornesia, Rzengineer & Fawzya"  | tee -a log-install.txt
echo "Modified by IRTech Network"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP JAM 12 MALAM"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/install.sh