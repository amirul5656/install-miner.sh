#!/bin/bash

echo "📦 Menginstal dependensi..."
apt-get update && apt-get install -y screen wget tar

echo "📁 Membuat skrip mining..."
cat << 'EOF' > /root/start-miner.sh
#!/bin/bash
cd /root || exit

# Buat sesi screen otomatis dan jalankan mining
screen -dmS amirul3 bash -c '
  wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.8.7/SRBMiner-Multi-2-8-7-Linux.tar.gz  
  sleep 10
  tar xf SRBMiner-Multi-2-8-7-Linux.tar.gz
  cd SRBMiner-Multi-2-8-7 || exit
  while true; do
    ./SRBMiner-MULTI --algorithm verushash --pool stratum+tcp://ap.luckpool.net:3956 --wallet RD4NjbgLRVBezibB185G3jhwGCj4eeRZfV
    sleep 2
  done
'
EOF

chmod +x /root/start-miner.sh

echo "⚙️ Membuat service systemd..."
cat << EOF > /etc/systemd/system/verusminer.service
[Unit]
Description=VerusCoin Mining via SRBMiner
After=network.target

[Service]
ExecStart=/root/start-miner.sh
Restart=always
User=root
WorkingDirectory=/root

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Mengaktifkan dan menjalankan service..."
systemctl daemon-reexec
systemctl enable verusminer.service
systemctl start verusminer.service

echo "✅ Instalasi selesai. Mining otomatis aktif bahkan setelah reboot!"
