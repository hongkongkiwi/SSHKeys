Automated SSH Public Key Pulling for Fun & Profit
=========

## What?
I wrote this script was a way to easily setup more machines and keep all my SSH public keys in sync

## Why?
I always loose track of which machines have which access keys setup, 
this makes it easier and (arguably) safer

## Install
First run this command to initially setup on your machine

`bash <(curl -s https://raw.githubusercontent.com/hongkongkiwi/SSHKeys/master/install.sh)`

And it's that simple. The setup script will guide you through everything you need. It will even setup automatic cron updating (if you want)

If you want to uinstall later simply do

`rm -Rf "$HOME/.ssh/SSHKeys"`

`rm "$HOME/.ssh/authorized_keys"`

## Is this secure?
Seems fine to me as long as you keep your Github password safe (I recommend turning on two factor authentication). See below for some features that I think will make 
it more safe if implemented.

## Contributing

If you want to improve my scripts please feel free to fork them and 
submit pull requests, or donate me some money for beer :-)

### TODO

1) I would like to add encryption so your not storing your ssh keys publically in the repo
2) Add the option during setup to copy and paste your own repo address (mine is currently hard coded)
3) Be able to use different tools rather than git (for example mercurial)
4) Email user the repo changes from the local version & also when the local repo is changed from remote (should be a red flag, tampering perhaps?)
