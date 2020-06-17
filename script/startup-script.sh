#!/bin/bash

# Create a "yugabytedb" user for YugabyteDB
USER="yugabyte"
useradd -m -s /bin/bash $USER

# Add yugabyte user to sudoers
echo "# yugabyte user for YugabyteDB" >> /etc/sudoers 
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

curl https://raw.githubusercontent.com/YugaByte/utilities/master/common_scripts/install_software.sh > /home/$USER/install_software.sh
curl https://raw.githubusercontent.com/YugaByte/utilities/master/scripts/start_master.sh > /home/$USER/start_master.sh
curl https://raw.githubusercontent.com/YugaByte/utilities/master/scripts/start_tserver.sh >/home/$USER/start_tserver.sh
curl https://raw.githubusercontent.com/YugaByte/utilities/master/common_scripts/create_universe.sh >/home/$USER/create-universe.sh

chmod 755 /home/$USER/*.sh
chown $USER:$USER /home/$USER/*.sh

YB_VERSION=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/yb-version" -H "Metadata-Flavor: Google")
YB_REGION=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/yb-region" -H "Metadata-Flavor: Google")
YB_RF=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/replication-factor" -H "Metadata-Flavor: Google")
YB_ZONE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | cut -d"/" -f4)

NODE_1_IP=$(curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/in-address-0' -H 'Metadata-Flavor: Google')
NODE_2_IP=$(curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/in-address-1' -H 'Metadata-Flavor: Google')
NODE_3_IP=$(curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/in-address-2' -H 'Metadata-Flavor: Google')

bash -c "sudo -u $USER mkdir -p /home/$USER/yugabyte-db/data"
sudo mkfs -t ext4 -F /dev/sdb
sudo mount  /dev/sdb /home/$USER/yugabyte-db/data

chown -R $USER:$USER /home/$USER/yugabyte-db/data

if yum install wget -y; then
  echo -e "Wget installed"
else
  echo -e "Wget failed to install"
  exit 1
fi

if bash -c "sudo -u $USER /home/$USER/install_software.sh $YB_VERSION"; then
  echo -e "YugabyteDB installed"
else
  echo -e "YugabyteDB failed to install"
  exit 1
fi

if bash -c "sudo -u $USER /home/$USER/create-universe.sh GCP $YB_REGION $YB_RF \"$NODE_1_IP $NODE_2_IP $NODE_3_IP\" $YB_ZONE $USER"; then
  echo -e "YugabyteDB Universe created"
else
  echo -e "YugabyteDB Universe failed to create"
  exit 1
fi
