#!/bin/bash

# Found: http://www.edwiget.name/2013/11/automatically-changing-dynamic-ips-in-aws-security-group/

# By Ed Wiget
# This is run via cron whenever my ip address changes in order to update aws security group

# 20131120 - original script

############################################################################################################################################

# example add:  aws ec2 authorize-security-group-ingress --group-name MySecurityGroup --protocol tcp --port 22 --cidr 203.0.113.0/24
# example revoke: aws ec2 revoke-security-group-ingress --group-name MySecurityGroup --protocol tcp --port 22 --cidr 203.0.113.0/24

#############################################################################################################################################

##### VARIABLES TO SET ##########################

# set our home directory which holds our ip file
HOMEDIR=~

# set the name of the security group as show in aws console
SEC_GROUP='knock-knock'

##### END VARIABLES TO SET ######################

# here we check for the aws binary and if it dont exist we bail cause sysadmin silly to try to run this script

which aws
if [ $? = 0 ]; then
	echo "wooohooooo"
else
	echo "silly rabbit, sysadmin ain't for kids"
	exit 1
fi

# first we check for existing file
if [ -f ${HOMEDIR}/.amazonip ]; then
	# if it exists, we create a backup for comparison
	cp ${HOMEDIR}/.amazonip ${HOMEDIR}/.amazonip.old
	# then grab the current ip
	WAN=`curl -s http://icanhazip.com`
	# and populate the new file
	echo ${WAN} > ${HOMEDIR}/.amazonip

	# here we need to check if the files differ
	diff ${HOMEDIR}/.amazonip ${HOMEDIR}/.amazonip.old
		if [ $? = 0 ]; then
			echo "no update required"
			exit 1
		else
			echo "update required....stand by"
			# here we get the value to revoke
			REVOKE=`cat ${HOMEDIR}/.amazonip.old`
			# then revoke the old ip
			aws ec2 revoke-security-group-ingress --group-name ${SEC_GROUP} --protocol tcp --port 22 --cidr ${REVOKE}/32
			aws ec2 revoke-security-group-ingress --group-name ${SEC_GROUP} --protocol tcp --port 3389 --cidr ${REVOKE}/32
			# next we set the new ip to allow ssh access
			NEWIP=`cat ${HOMEDIR}/.amazonip`
			# and set the new ip address for ssh access
			aws ec2 authorize-security-group-ingress --group-name ${SEC_GROUP} --protocol tcp --port 22 --cidr ${NEWIP}/32
			aws ec2 authorize-security-group-ingress --group-name ${SEC_GROUP} --protocol tcp --port 3389 --cidr ${NEWIP}/32
		fi
else

	# our file didnt exist, so it must be a new system, so lets set it up
	# get the ip
	#WAN=`curl -s http://www.edwiget.name/ip.php`
	WAN=`curl -s http://icanhazip.com`
	# create the file
	echo ${WAN} > ${HOMEDIR}/.amazonip
	# set the variable so we can add the ip to the systems security group
	NEWIP=`cat ${HOMEDIR}/.amazonip`
	# and set the new ip address for ssh access
	aws ec2 authorize-security-group-ingress --group-name ${SEC_GROUP} --protocol tcp --port 22 --cidr ${NEWIP}/32
	aws ec2 authorize-security-group-ingress --group-name ${SEC_GROUP} --protocol tcp --port 3389 --cidr ${NEWIP}/32
fi
