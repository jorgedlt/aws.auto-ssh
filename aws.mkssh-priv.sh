#!/usr/bin/env bash

# Create cut-&-paste jumpfile from AWS Enviroment

INVfile=aws.PRV-jumpfile
SSHkey='/home/ubuntu/.aws/m3DEVaws.pem'
SSHuid='ubuntu'

MASTER=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]' \
   --filter "Name=tag:Name,Values=AWSCLI v1.2 master" --output text | tr '\t' ' ')

WORKERS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]' --filter "Name=tag:Project,Value
s=HP-DEMO" "Name=instance-state-name,Values=running" --output text | tr '\t' ' ')

echo '[Master]' > $INVfile
 while IFS=' ' read instanceID PrivateIpAddr; do
     echo "ssh -i ${SSHkey} ${SSHuid}@${PrivateIpAddr}"
 done <<< "$MASTER" >> $INVfile ; echo >> $INVfile

echo '[Workers]' >> $INVfile
 while IFS=' ' read instanceID PrivateIpAddr; do
     echo "ssh -i ${SSHkey} ${SSHuid}@${PrivateIpAddr}"
 done <<< "$WORKERS" >> $INVfile

cat $INVfile | ccze -A

exit 0;
