# ########################################################
# --------------------------------------------------------
# script will scan folder for wallet files (*.dat)
# it will find 64 digits hex keys and converts them to wif format
# possibility of automatically wallet import
# this script is only tested for wagerr coin 2.0.2
# --------------------------------------------------------
# ########################################################


# PREREQUISITE
you will need to have openssl and mit-scheme installed

for automatically import function you need your wallet/daemon started
and the cli installed


# !! CARE !!
determined wif keys will be logged in recover_wallet.result file.

do not run on a dirty setup / infected system


# PARAMETERS
1 : prefix byte - for example C7 for wagerr main net

2 : 64 digits hex key

3 : path to cli (optional)


# USAGE
example for wagerr main net

sh recover_wallet.sh C7 /path/to/check

sh recover_wallet.sh C7 /path/to/check /path/to/wagerr-cli


# AUTOMATICALLY VALUE CHECK
you have the possibility to check wagerr keys for value on wagerr explorer.
to do this, change variable "CHECK_EXPLORER" to 1 in batch file.
care: may you spam the explorer website if you set this to 1.

better way: set this value to 0 and start a rescan in your GUI client.


# DISCLAIMER
this script is based on wagerr wiki site

https://github.com/wagerr/wagerr/wiki/How-to-create-a-key-from-openssl