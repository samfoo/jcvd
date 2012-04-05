# cp setup_template.sh setup.sh
# edit values
# source setup.sh

# TW Active Directory
export TWUSER=
export TWPASS=

# Twilio 
export TWILIO_SID=
export TWILIO_AUTH=
# default au 
export TWILIO_AUTHORIZED_CALL_FROM=+61467970000 
export TWILIO_AUTHORIZED_SMS_FROM=+14155992671 
# export TWILIO_AUTHORIZED_CALL_FROM=7736349969 # chicago
# export TWILIO_AUTHORIZED_SMS_FROM=7736349969 # chicago

# SMS by default uses http://smsmaster.m4u.com.au
export SMSUSER=
export SMSPASS=
# To use twilio sms, enable the below settings
# export TWILIO_SMS=true
# export SMSUSER=$TWILIO_SID
# export SMSPASS=$TWILIO_AUTH

# Peoplesoft - might be the same as Active Directory
# export PUSER=$TWUSER
# export PPASS=$TWPASS

# enable to use local mail client rather than TW mail
# export USE_LOCAL_MAIL=true

# smtp.gmail port
export SMTP_PORT=587 # au
# export SMTP_PORT=25 # Chicago
