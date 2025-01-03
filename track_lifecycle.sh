#!/bin/bash


INSTANCE_LIFECYCLE_FILE="instance_lifecycle_log.csv"


REGIONS="us-east-1,us-east-2,ap-south-1"


if [ ! -f "$INSTANCE_LIFECYCLE_FILE" ]; then
  echo "InstanceId,State,Timestamp" > "$INSTANCE_LIFECYCLE_FILE"
fi


for REGION in $(echo $REGIONS | tr ',' ' '); do
  echo "Processing region: $REGION"


  INSTANCE_DETAILS=$(aws ec2 describe-instances --region "$REGION" \
    --query "Reservations[*].Instances[*].[InstanceId,State.Name,LaunchTime]" \
    --output text)


  if [ $? -ne 0 ]; then
    echo "Failed to retrieve EC2 instance details for region $REGION"
    continue
  fi


  echo "$INSTANCE_DETAILS" | while read -r instance; do
    instance_id=$(echo $instance | awk '{print $1}')
    state=$(echo $instance | awk '{print $2}')
    launch_time=$(echo $instance | awk '{print $3}')

   
    if [ -z "$instance_id" ] || [ -z "$launch_time" ]; then
      continue
    fi


    launch_time_ist=$(TZ="Asia/Kolkata" date -d "$launch_time" "+%Y-%m-%d %H:%M:%S")

  
    last_state=$(grep "$instance_id" "$INSTANCE_LIFECYCLE_FILE" | tail -n 1 | cut -d ',' -f2)


    if [ "$state" != "$last_state" ]; then
      
      echo "$instance_id,$state,$launch_time_ist" >> "$INSTANCE_LIFECYCLE_FILE"
      echo "Logged Instance $instance_id as $state at $launch_time_ist"
    else
      echo "No state change for Instance $instance_id (Current State: $state)"
    fi
  done
done

