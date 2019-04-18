# ########################################################
# --------------------------------------------------------
# script will convert 64 digits hex key to wif format
# --------------------------------------------------------
# ########################################################

# PREREQUISITE
# you will need to have openssl and mit-scheme installed

# !! CARE !!
# this script need input of your private key in hex format
# it will deliver your key in wif format and append in into -
# a file called recover_wallet.result in same directory.
# dont run on a dirty setup / infected system

# PARAMETERS
# 1 : prefix byte - for example C7 for wagerr main net
# 2 : 64 digits hex key