```
     ::::::::::: ::::::::  :::     ::: ::::::::: 
        :+:    :+:    :+: :+:     :+: :+:    :+: 
       +:+    +:+        +:+     +:+ +:+    +:+  
      +#+    +#+        +#+     +:+ +#+    +:+   
     +#+    +#+         +#+   +#+  +#+    +#+    
#+# #+#    #+#    #+#   #+#+#+#   #+#    #+#     
#####      ########      ###     #########
```
![JCVD](https://github.com/samfoo/jcvd/raw/master/jcvd.jpg)

```
Purpose:
Get names of people with late timesheets
Contact people who have late timesheets

To use:
tec --region=desired_region | jcvd --call

or

tec > file
jcvd --email file

default region is australia (au) and this influences the phone parser

To see options:
jcvd --help

See setup_template.sh for environment variables that must be set in order to run the app. 

You will need a Twilio account to make phone calls.

Data to be fed into jcvd is in format
{"name":"a","email":"a@b.com","mobile":"c"}

```
