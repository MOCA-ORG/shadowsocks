#!/bin/bash

mkdir /tmp/shadowsocks
cd /tmp/shadowsocks || exit

curl -OL "https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${VERSION}/shadowsocks-v${VERSION}.aarch64-unknown-linux-gnu.tar.xz"
tar -xf "shadowsocks-v${VERSION}.aarch64-unknown-linux-gnu.tar.xz"
mv ssserver /usr/local/bin/
rm -rf /tmp/shadowsocks

nohup ssserver -s "0.0.0.0:${PORT}" -m "aes-256-gcm" -k "${PASSWORD}" &> /dev/null &
