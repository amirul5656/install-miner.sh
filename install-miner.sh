#!/bin/bash
echo "📦 Menginstal dependensi..."
apt-get update && apt-get install -y screen wget tar cron

echo "📁 Menyimpan skrip mining ke /root/start-miner.sh..."
cat << 'EOF' > /root/start-miner.sh
#!/bin/bash
# Hapus folder lama jika ada
rm -rf SRBMiner-Multi-2-8-7
rm -f SRBMiner-Multi-2-8-7-Linux.tar.gz

# Buat sesi screen dan jalankan mining
screen -dmS amirul3 bash -c '
  wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.8.7/SRBMiner-Multi-2-8-7-Linux.tar.gz  
  sleep 10
  tar xf SRBMiner-Multi-2-8-7-Linux.tar.gz
  cd SRBMiner-Multi-2-8-7
  while true; do
    ./SRBMiner-MULTI --algorithm verushash --pool stratum+tcp://ap.luckpool.net:3956 --wallet RD4NjbgLRVBezibB185G3jhwGCj4eeRZfV
    sleep 2
  done
'
EOF


echo "📝 Menambahkan ke crontab agar auto-jalan setelah reboot..."
(crontab -l 2>/dev/null; echo "@reboot /root/start-miner.sh") | crontab -

echo "🚀 Menjalankan mining sekarang..."
/root/start-miner.sh

echo "✅ Instalasi selesai! Mining akan otomatis jalan setiap reboot."
