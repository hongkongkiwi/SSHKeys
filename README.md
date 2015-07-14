Automated SSH Public Key Pulling for Fun & Profit
=========

# What?
This is a way to make it easy for me to keep my SSH keys in sync.

# Why?
I always loose track of which machines have which access keys setup, 
this makes it easier and (arguably) safer

# Install
First run this command to initially setup on your machine

`bash <(curl -s 
https://raw.githubusercontent.com/hongkongkiwi/SSHKeys/master/install.sh)`

Then after your done, add this line to your crontab to sync the keys 
once nightly

`@daily /home/andy/.ssh/SSHKeys/crontab.sh`

Now your done! Your keys will sync once per day to whatever is in your 
repository.

# Contributing

If you want to improve my scripts please feel free to fork them and 
submit pull requests, or donate me some money for beer :-)

