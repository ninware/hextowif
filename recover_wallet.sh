#!/bin/bash

# param1 must be the prefix byte
# for example C7 for wagerr main net
PREFIX_BYTE=$1

# param2 must be a 64 digits hex key
# for example 2b74257012b64a1ddeaeda2413b2cf1e8916f9798598a515078f76c3f67d0678
# result for this example should be 7gAH5C7oNDBgrD6jSS6L31Bew66hDt86pBA3vTHHp1s8pbY8b7w
# this example is also based on wagerr main net
HEX_KEY=$2

# defining and calling the mit-scheme function.
# param will be replaced by hex key (YYY)
MIT_SCHEME='(define (base58check input)
                (define (base58digit k) (string-ref "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" k))
                (define (extractdigits n digits)
                    (if (> 58 n)
                    	   (list->string (cons (base58digit n) digits))
             	   (extractdigits (quotient n 58) (cons (base58digit (modulo n 58)) digits))))
                (extractdigits input '"'"'()))

             (base58check #xYYY)'

# double sha the hex key with prefix byte
CHECKSUM=$( echo ${PREFIX_BYTE}${HEX_KEY} | xxd -r -p | openssl dgst -sha256 | xxd -r -p | openssl dgst -sha256 )

# get the first 4 checksum bytes
FIRST_8_CHECKSUM=$( echo ${CHECKSUM} | cut -c 1-8 )

# the input for calculating wif key
MIT_INPUT=${PREFIX_BYTE}${HEX_KEY}${FIRST_8_CHECKSUM}

# running mit scheme
MIT_OUTPUT=$( echo "$MIT_SCHEME" | sed "s/YYY/$MIT_INPUT/")

# parsing wif hex key and append it to result file
echo "$MIT_OUTPUT" | mit-scheme | awk -F'"' '/^;Value 2: /{print $2;}' >> recover_wallet.result

# cat result file
cat recover_wallet.result
exit