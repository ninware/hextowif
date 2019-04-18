# ########################################################
# --------------------------------------------------------
# script will convert 64 digits hex key to wif format
# --------------------------------------------------------
# ########################################################

# PREREQUISITE
you will need to have openssl and mit-scheme installed

# !! CARE !!
this script need input of your private key in hex format
it will deliver your key in wif format and append in into
a file called recover_wallet.result in same directory.
dont run on a dirty setup / infected system

# PARAMETERS
1 : prefix byte - for example C7 for wagerr main net
2 : 64 digits hex key

# USAGE
example for wagerr main net
Dont use this keys for transfering value. 
sh recover_wallet.sh C7 2b74257012b64a1ddeaeda2413b2cf1e8916f9798598a515078f76c3f67d0678
will deliver wif key: 7gAH5C7oNDBgrD6jSS6L31Bew66hDt86pBA3vTHHp1s8pbY8b7w

# DISCLAIMER
this script is based on wagerr wiki site
https://github.com/wagerr/wagerr/wiki/How-to-create-a-key-from-openssl
