#! /bin/bash

echo 'Creating systemd config'

cat <<EOF > /etc/systemd/system/puma.service
[Unit]
Description=Puma service
After=network.target mongod.service
[Service]
User=appuser
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma -d
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

echo 'Enabling puma service'

systemctl daemon-reload
systemctl enable puma.service
