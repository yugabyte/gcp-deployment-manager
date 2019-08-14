#!/bin/bash

curl https://raw.githubusercontent.com/YugaByte/utilities/master/scripts/install_software.sh > /home/$USER/install_software.sh
curl https://raw.githubusercontent.com/YugaByte/utilities/master/scripts/start_master.sh > /home/$USER/start_master.sh
curl https://raw.githubusercontent.com/YugaByte/utilities/master/scripts/start_tserver.sh >/home/$USER/start_tserver.sh
curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/create-universe -H "Metadata-Flavor: Google" -o /home/$USER/create-universe

YB_VERSION=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/yb-version" -H "Metadata-Flavor: Google")
YB_REGION=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/yb-region" -H "Metadata-Flavor: Google")
YB_RF=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/replication-factor" -H "Metadata-Flavor: Google")
YB_ZONE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | cut -d"/" -f4)

NODE_1_IP=$(curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/in-address-0' -H 'Metadata-Flavor: Google')
NODE_2_IP=$(curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/in-address-1' -H 'Metadata-Flavor: Google')
NODE_3_IP=$(curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/in-address-2' -H 'Metadata-Flavor: Google')

sed -i 's/-ce//g' /home/$USER/install_software.sh  
sed -i 's/1.2.8.0/1.3.0.0/g' /home/$USER/install_software.sh  

yum install wget -y
if [ $? -eq 0 ]; then
        echo -e "Wget installed"
else
        echo -e "Wget failed to install"
        exit 1
fi
bash /home/$USER/install_software.sh 
if [ $? -eq 0 ]; then
        echo -e "YugaByte DB installed"
else
        echo -e "YugaByte failed to install"
        exit 1
fi

bash /home/$USER/create-universe GCP $YB_REGION $YB_RF $NODE_1_IP $NODE_2_IP $NODE_3_IP $YB_ZONE 
if [ $? -eq 0 ]; then
        echo -e "YugaByte Univers created"
else
        echo -e "YugaByte Univers failed to create"
        exit 1
fi
