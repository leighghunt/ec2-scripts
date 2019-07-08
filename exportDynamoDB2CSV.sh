#!/bin/bash

aws  dynamodb scan --table-name 'ServiceLocation2' --output text --query "Items[*].[ServiceId.S,VehicleRef.S,RecordedAtTime.S,Lat.S,Long.S,DelaySeconds.N]" |  sed $'s/\t/,/g' > ~/Downloads/ServiceLocation.csv
printf '%s\n%s\n' "ServiceId,VehicleRef,RecordedAtTime,Lat,Long,DelaySeconds" "$(cat ~/Downloads/ServiceLocation.csv)" >~/Downloads/ServiceLocation.csv


