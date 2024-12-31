#!/bin/bash

instance_id="i-0491278ad07ffa023"

region="us-east-1"

instance_name="automation_testing"

start_time="16:03"

end_time="16:04"

current_time=$(TZ="Asia/Kolkata" date +"%H:%M")

recipient_email="vijaysaw50@gmail.com"

echo "Current Time (Asia/Kolkata): $current_time"

#send_email() {

 #   	SUBJECT=$1
    
#	MESSAGE=$2
    
#	echo "$MESSAGE" | mail -s "$SUBJECT" "$recipient_email"
#}

if [ "$current_time" == "$start_time" ]; then
    
	echo "Starting EC2 instance with name: $instance_name"
   
       	aws ec2 start-instances --instance-ids "$instance_id" --region "$region"
   
       
        echo -e "Subject: $instance_name EC2 got started at $current_time successfully" | msmtp "$recipient_email"

	
#	send_email "EC2 Instance Started" "The EC2 instance $instance_name has been started at $current_time."


elif [ "$current_time" == "$end_time" ]; then

    	echo "Stopping EC2 instance with name: $instance_name"
   
       	aws ec2 stop-instances --instance-ids "$instance_id" --region "$region"
    

         echo -e "Subject: $instance_name EC2 got stopped at $current_time successfully" | msmtp "$recipient_email"

    
#	send_email "EC2 Instance Stopped" "The EC2 instance $instance_name has been stopped at $current_time."




else
    echo "waiting for the current time $current_time"
fi


