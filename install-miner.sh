#!/bin/bash
echo "📦 Menginstal dependensi..."
apt-get update && apt-get install -y screen wget tar

echo "📁 Menyimpan skrip mining ke /root/start-miner.sh..."
cat << 'EOF' > /root/start-miner.sh
#!/bin/bash

cd /root || exit

# Download miner jika belum ada
if [ ! -f SRBMiner-Multi-2-8-7-Linux.tar.gz ]; then
  wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.8.7/SRBMiner-Multi-2-8-7-Linux.tar.gz
fi

# Ekstrak jika folder belum ada
if [ ! -d SRBMiner-Multi-2-8-7 ]; then
  tar xf SRBMiner-Multi-2-8-7-Linux.tar.gz
fi

cd SRBMiner-Multi-2-8-7 || exit

# Cek apakah screen sudah berjalan
if screen -list | grep -q amirul3; then
  echo "⚠️  Screen 'amirul3' sudah jalan, skip."
else
  echo "▶ Menjalankan mining di screen 'amirul3'..."
  screen -dmS amirul3 bash -c '
    while true; do
      ./SRBMiner-MULTI --algorithm xelishashv2_pepew --pool stratum+tcp://xelisv2-pepew.sea.mine.zpool.ca:4833 --wallet ltc1q682mxnytl67x3gdw8eezxpuq4pehz5qhax4ls5 --password c=DOGE
      sleep 2
    done
  '
fi
EOF

chmod +x /root/start-miner.sh
echo "🚀 Menjalankan miner sekarang..."
bash /root/start-miner.sh

echo "✅ Siap! Mining aktif sekarang & otomatis jalan setelah reboot lewat /etc/rc.local."
