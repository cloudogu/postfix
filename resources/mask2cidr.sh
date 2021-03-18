#!/bin/bash

# Function calculates number of bit in a netmask
#
mask2cidr() {
    nbits=0
    for dec in $1 ; do
        case $dec in
            255) (( nbits+=8 ));;
            254) (( nbits+=7 )) ; break ;;
            252) (( nbits+=6 )) ; break ;;
            248) (( nbits+=5 )) ; break ;;
            240) (( nbits+=4 )) ; break ;;
            224) (( nbits+=3 )) ; break ;;
            192) (( nbits+=2 )) ; break ;;
            128) (( nbits+=1 )) ; break ;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}

## main ##
# MASK=255.255.254.0
MASK=$1
numbits=$(IFS=. ; mask2cidr "$MASK")
echo "$numbits"
exit 0
