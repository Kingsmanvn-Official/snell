#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
CONF="/etc/snell/snell-server.conf"
SYSTEMD_LIB="/lib/systemd/system/snell.service"
SYSTEMD_ETC="/etc/systemd/system/snell.service"
yum update && yum upgrade && yum install unzip && yum install tmux -y
cd ~/
wget --no-check-certificate -O snell.zip https://github.com/Kingsmanvn-Official/snell/releases/download/v3.0.1/snell-server-v3.0.1-linux-amd64.zip
unzip -o snell.zip
rm -f snell.zip
chmod +x snell-server
mv -f snell-server /usr/local/bin/
if [ -f ${CONF} ]; then
    echo "Found existing config..."
    else
    if [ -z ${psk} ]; then
        psk="kingsmanvn"
        echo "Using generated PSK: ${psk}"
        else
        echo "Using predefined PSK: $psk"
    fi
    mkdir /etc/snell/
    echo "Generating new config..."
    echo "[snell-server]" >${CONF}
    echo "listen = 0.0.0.0:443" >>${CONF}
    echo "psk = kingsmanvn" >>${CONF}
    echo "ipv6 = true" >>${CONF}
    echo "obfs = tls" >>${CONF}
fi

if [ -f ${SYSTEMD_ETC} ]; then
    echo "Found existing service..."
    systemctl enable snell.service
    systemctl start snell.service
else
    echo "Generating new service..."
    echo "[Unit]" >>${SYSTEMD_ETC}
    echo "Description=Snell Proxy Service" >>${SYSTEMD_ETC}
    echo "After=network.target" >>${SYSTEMD_ETC}
    echo "" >>${SYSTEMD_ETC}
    echo "[Service]" >>${SYSTEMD_ETC}
    echo "Restart=always" >>${SYSTEMD_ETC}
    echo "Type=simple" >>${SYSTEMD_ETC}
    echo "LimitNOFILE=32768" >>${SYSTEMD_ETC}
    echo "ExecStart=/usr/local/bin/snell-server -c /etc/snell/snell-server.conf" >>${SYSTEMD_ETC}
    echo "" >>${SYSTEMD_ETC}
    echo "[Install]" >>${SYSTEMD_ETC}
    echo "WantedBy=multi-user.target" >>${SYSTEMD_ETC}
    echo "" >>${SYSTEMD_ETC}
    systemctl daemon-reload
    systemctl enable snell.service
    systemctl start snell.service
fi

if [ -f ${SYSTEMD_LIB} ]; then
    echo "Found existing service..."
    systemctl daemon-reload
    systemctl enable
    systemctl start snell.service
    systemctl status snell.service
else
    echo "Generating new service..."
    echo "[Unit]" >>${SYSTEMD_LIB}
    echo "Description=Snell Proxy Service" >>${SYSTEMD_LIB}
    echo "After=network.target" >>${SYSTEMD_LIB}
    echo "" >>${SYSTEMD_LIB}
    echo "[Service]" >>${SYSTEMD_LIB}
    echo "Restart=always" >>${SYSTEMD_LIB}
    echo "Type=simple" >>${SYSTEMD_LIB}
    echo "LimitNOFILE=32768" >>${SYSTEMD_LIB}
    echo "ExecStart=/usr/local/bin/snell-server -c /etc/snell/snell-server.conf" >>${SYSTEMD_LIB}
    echo "" >>${SYSTEMD_LIB}
    echo "[Install]" >>${SYSTEMD_LIB}
    echo "WantedBy=multi-user.target" >>${SYSTEMD_LIB}
    echo "" >>${SYSTEMD_LIB}
    systemctl daemon-reload
    systemctl enable snell.service
    systemctl start snell.service
    systemctl status snell.service
fi
