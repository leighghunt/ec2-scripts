#!/bin/bash

##### VARIABLES TO SET ##########################

INSTANCE_IDS='i-7225b64d'

##### END VARIABLES TO SET ######################

which aws
if [ $? = 0 ]; then
	echo "wooohooooo"
else
	echo "silly rabbit, sysadmin ain't for kids"
	exit 1
fi

aws ec2 start-instances --instance-ids ${INSTANCE_IDS}
