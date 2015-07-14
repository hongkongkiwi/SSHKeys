Automated SSH Public Key Pulling for Fun & Profit
=========

# What?
This is a way to make it easy for me to keep my SSH keys in sync.

# Why?
I always loose track of which machines have which access keys setup, 
this makes it easier and (arguably) safer

# Install
First run this command to initially setup on your machine

`bash <(curl -s https://raw.githubusercontent.com/hongkongkiwi/SSHKeys/master/install.sh)`

And it's that simple. The setup script will guide you through everything you need. It will even setup automatic cron updating (if you want)

# Is this secure?
Seems fine to me as long as you keep your Github password safe (I recommend turning on two factor authentication)

I have considered in future getting the crontab script to email you if there are remote changes, seems like a reasonable precaution, but for now this feature is not 
implemented.

# Contributing

If you want to improve my scripts please feel free to fork them and 
submit pull requests, or donate me some money for beer :-)

