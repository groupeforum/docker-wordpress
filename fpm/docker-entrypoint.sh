#!/bin/bash

# Set exim installation variables
sed -i "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
sed -i "s/dc_local_interfaces=.*/dc_local_interfaces='127.0.0.1; ::1'/" /etc/exim4/update-exim4.conf.conf
sed -i "s/dc_minimaldns=.*/dc_minimaldns='false'/" /etc/exim4/update-exim4.conf.conf
sed -i "s/dc_use_split_config=.*/dc_use_split_config='false'/" /etc/exim4/update-exim4.conf.conf
sed -i "s/dc_localdelivery=.*/dc_localdelivery='maildir_home'/" /etc/exim4/update-exim4.conf.conf

# Set generic mail address
cat > /etc/email-addresses << EOF
root: root@$SMTP_DOMAIN
postmaster: postmaster@$SMTP_DOMAIN
www-data: root@$SMTP_DOMAIN
EOF

touch /etc/exim4/hubbed_hosts && cat > /etc/exim4/hubbed_hosts << EOF
$SMTP_DOMAIN: $SMTP_HOSTNAME
EOF

# Reconfigure exim
dpkg-reconfigure exim4-config -fnoninteractive

exec "$@"