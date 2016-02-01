#!/usr/bin/env bash

# Create cut-&-paste jumpfile from AWS Enviroment

INVfile=aws.PUB-jumpfile
SSHkey='/home/ubuntu/.aws/m3DEVaws.pem'
SSHuid='ubuntu'

MASTER=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress]' \
   --filter "Name=tag:Name,Values=AWSCLI v1.2 master" --output text | tr '\t' ' ')

WORKERS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress]' \ 
   --filter "Name=tag:Project,Values=HP-DEMO" "Name=instance-state-name,Values=running" --output text | tr '\t' ' ')

echo '[Master]' > $INVfile
 while IFS=' ' read instanceID PublicIpAddress; do
     echo "ssh -i ${SSHkey} ${SSHuid}@${PublicIpAddress}"
 done <<< "$MASTER" >> $INVfile ; echo >> $INVfile

echo '[Workers]' >> $INVfile
 while IFS=' ' read instanceID PublicIpAddress; do
     echo "ssh -i ${SSHkey} ${SSHuid}@${PublicIpAddress}"
 done <<< "$WORKERS" >> $INVfile

cat $INVfile | ccze -A

exit 0;
