#!/bin/bash

# param1 must be the prefix byte
# for example C7 for wagerr main net
PREFIX_BYTE=$1

# param2 must be absolute or relativ path to wallet.dat or folder
WALLET_PATH=$2

# param3 is the path to wallet-cli
CLI_PATH=$3

# search string. private key may after this
HEX_SEARCH_STRING="0420"

# count the number of found keys/file
FOUND_COUNT=0


#
# convert 64 digits hex key (32 bytes) to wif key.
#
function hexToWIF() {

    local prefixByte=$1
    local hexKey=$2

    # defining and calling the mit-scheme function.
    # param will be replaced by hex key (YYY)
    local base58Function='(define (base58check input)
                    (define (base58digit k) (string-ref "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" k))
                    (define (extractdigits n digits)
                        (if (> 58 n)
                               (list->string (cons (base58digit n) digits))
                       (extractdigits (quotient n 58) (cons (base58digit (modulo n 58)) digits))))
                    (extractdigits input '"'"'()))

                 (base58check #xYYY)'

    # double sha the hex key with prefix byte
    local checksum=$( echo ${prefixByte}${hexKey} | xxd -r -p | openssl dgst -sha256 | xxd -r -p | openssl dgst -sha256 )

    # get the first 4 checksum bytes
    local firstBytes=$( echo ${checksum} | cut -c 1-8 )

    # the input for calculating wif key
    local base58Input=${prefixByte}${hexKey}${firstBytes}

    # running mit scheme
    local base58Output=$( echo "$base58Function" | sed "s/YYY/$base58Input/")

    # parsing wif hex key and append it to result file
    local wifKey=$(echo "$base58Output" | mit-scheme | awk -F'"' '/^;Value 2: /{print $2;}')

    # return the wif key
    echo ${wifKey}
}

# runs over the wallet file until end
# finding hex keys, convert to wif keys and import / check the balance
function runOverWalletFile() {

    local actualHexValue=$1
    local stopLoop=0

    # loop the first 50k digits
    # throw away first 50k digits if no search string is found
    while [[ ${stopLoop} -ne 1 ]]
    do
        local firstDigits=$(echo ${actualHexValue} | cut -c1-49999)
        local countFirstDigits=$(echo ${firstDigits} | wc -c)
        local countAllDigits=$(echo ${actualHexValue} | wc -c)
        if [[ ${firstDigits} == *"$2"* ]] || [[ ${countFirstDigits} -lt 50000 ]];
            then
                echo "found a search string in next 50000 digits or end reached. digits left: "${countAllDigits}
                stopLoop=1
            else
                echo "no search string in next 50000 digits found. next. digits left: "${countAllDigits}
                actualHexValue=$(echo ${actualHexValue} | cut -c49990-)
        fi
    done

    # cut search string and everything before
    # then take the key, check it and run again with rest digits
    local rest=$(echo ${actualHexValue#*$2})
    if [[ -z "${rest}" ]] || [[ ${rest} == ${actualHexValue} ]]
        then
            echo "No more 0420 left. Found: "${FOUND_COUNT};
            ((FOUND_COUNT=0))
        else
            # key found
            hexKey=$(echo ${rest} | cut -c 1-64)
            ((FOUND_COUNT+=1))

            if grep -q ${hexKey} "recover_wallet.result";
                then
                    echo "key not imported cause already known"
                else
                    if [[ ${CLI_PATH} != "" ]];
                        then

                            wifKey=$(hexToWIF $3 ${hexKey})

                            # generate random number for alias
                            alias=$(shuf -i 2000-65000 -n 1)$(shuf -i 2000-65000 -n 1)

                            # import the key into the wallet
                            /Users/nils/Downloads/wagerr-2.0.2_osx/bin/wagerr-cli importprivkey ${wifKey} ${alias} false

                            # get address and balance
                            address=$(${CLI_PATH} getaddressesbyaccount ${alias} | cut -c4-37 | tr -d '\n')
                            balance=$(${CLI_PATH} getbalance ${alias})
                            key=$(${CLI_PATH} dumpprivkey ${address})

                            # check balance at wagerr explorer
                            # experimental for wagerr. dont spam explorer site
                            #balanceAPI=$(curl -s https://explorer.wagerr.com/api/address/${address} | tr -dc '0-9')
                            balanceAPI="0000"

                            if [[ ${balanceAPI} != "0000" ]];
                                then
                                    # wif key to lucky file
                                    echo "${key}|${hexKey}|${wifKey}|${address}|${balance}|${alias}" >> recover_wallet.luckyapi
                            fi

                            if [[ ${balance} != "0.00000000" ]];
                                then
                                    # wif key to lucky file
                                    echo "${key}|${hexKey}|${wifKey}|${address}|${balance}|${alias}" >> recover_wallet.lucky
                            fi
                    fi

                    # wif key to result file
                    echo "${key}|${hexKey}|${wifKey}|${address}|${balance}|${alias}" >> recover_wallet.result
            fi

            # next round ;)
            runOverWalletFile "${rest}" "${HEX_SEARCH_STRING}" "$3"
    fi
}

# create empty result file
touch recover_wallet.result

# start the process - loop folder
for file in $(find ${WALLET_PATH} -name 'wallet*');
    do
        walletHex=$(xxd -p ${file} | tr -d '\n')

        # check if we have at least one search string
        if [[ ${walletHex} == *${HEX_SEARCH_STRING}* ]];
            then
                echo ${file}" - Found at least one search string"
                runOverWalletFile ${walletHex} ${HEX_SEARCH_STRING} ${PREFIX_BYTE}
            else
                echo ${file}" - No search string was found"
        fi
    done
exit
