#!/usr/bin/env python 

import sys


def to_decimal(value, decimals=18):
    prefix =''
    if value < 0:
        prefix = '-'
        value  = -value

    output = str(value)
    if len(output) <= decimals:
        pad = decimals + 1 - len(output)
        output = '0'*pad + output

    right = output[-decimals:].rstrip('0')

    return prefix + output[:-decimals] + ('' if len(right) == 0 else '.' + right)

if __name__ == "__main__":
    try:
        if len(sys.argv) != 3:
            raise 
        canonical_value = int(sys.argv[1])
        decimals = int(sys.argv[2])
        print(to_decimal(canonical_value, decimals))
    except:
        print('Usage: input must be an integer token number and an (integer) number of decimals.')
