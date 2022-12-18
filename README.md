# qt wallet recovery

## Introduction
This Script will scan a specific folder for wallet files (*.dat).
It will find 64 digits hex keys and converts them to wif format.
You have the possibility to do an automatic value check and an automatic wallet import.


This script is only tested for **wagerr** coin 2.0.2.


## Prerequisite for automatic wallet import
You will need to have openssl and mit-scheme installed.
For automatically import function you need your wallet/daemon started
and the cli installed


##  !! CARE !!
Determined wif keys will be logged in recover_wallet.result file.
Do not run on a dirty setup / infected system.
If you just want to extract the keys, use a fresh offline VM.


## Parameters
1 : prefix byte - for example C7 for wagerr main net (required)

2 : path to scan (required)

3 : path to cli (optional)


## Usage

Recover the private Keys

sh recover_wallet.sh C7 /path/to/check


Recover the private Keys and import them into the current wallet.

sh recover_wallet.sh C7 /path/to/check /path/to/wagerr-cli


## Automatic Value Check on Explorer Site
Yyou have the possibility to check wagerr keys for value on wagerr explorer.
To do this, change variable "CHECK_EXPLORER" to 1 in batch file.

Care:

May you spam the explorer website if you set this to 1.
Better way: set this value to 0 and start a rescan in your GUI client.

To try another Coin than wagerr, please change Explorer URL manualy in sh-File.


## Disclaimer
this script is based on wagerr wiki site

https://github.com/wagerr/wagerr/wiki/How-to-create-a-key-from-openssl