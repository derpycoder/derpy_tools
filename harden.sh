#!/bin/sh
set -eux

SSH_PORT=22

### ---> FIREWALL
ufw default deny outgoing comment 'deny all outgoing traffic'
ufw default deny incoming comment 'deny all incoming traffic'

# ufw limit in ssh comment 'allow SSH connections in'
ufw allow in ${SSH_PORT} comment 'allow incoming SSH connections'

ufw allow out 53 comment 'allow DNS calls out'

ufw allow out 123 comment 'allow NTP calls out'

ufw allow in http comment 'allow HTTP traffic in'
ufw allow in https comment 'allow HTTPS traffic in'
ufw allow out http comment 'allow HTTP traffic out'
ufw allow out https comment 'allow HTTPS traffic out'

ufw enable
### <--- FIREWALL

# ---> Thwart SSH crackers/brute force attacks
systemctl enable --now fail2ban

# Unless we really need it its best to have it disabled.
sed -i -E "/^#?X11Forwarding/s/^.*$/X11Forwarding no # $(date -R)/" /etc/ssh/sshd_config

# Can be used by hackers and malware to open backdoors in the server.
sed -i -E "/^#?AllowTcpForwarding/s/^.*$/AllowTcpForwarding no # $(date -R)/" /etc/ssh/sshd_config

# ---> Configure idle log out timeout interval
# set for two minutes
sed -i -E "/^#?ClientAliveInterval/s/^.*$/ClientAliveInterval 120 # $(date -R)/" /etc/ssh/sshd_config

# LogLevel VERBOSE logs user's key fingerprint on login. Needed to have a clear audit track of which key was using to log in.
echo "LogLevel VERBOSE # $(date -R)" >> /etc/ssh/sshd_config

# Log sftp level file access (read/write/etc.) that would not be easily logged otherwise.
sed -i -E "/^#?Subsystem sftp/s/^.*$/Subsystem sftp \/usr\/lib\/openssh\/sftp-server -f AUTHPRIV -l INFO # $(date -R)/" /etc/ssh/sshd_config

sshd -t

systemctl restart ssh.service

systemctl status ssh.service
