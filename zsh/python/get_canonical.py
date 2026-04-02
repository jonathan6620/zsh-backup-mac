#!/usr/bin/env python3

import sys

def fractional_to_canonical(decimal_str: str, decimals: int) -> int:
    vals = decimal_str.split('.')

    whole: int = 0 if vals[0] == '0' or vals[0] == '' else int(vals[0]) * 10 ** decimals
    fractional: int = 0
    
    if len(vals) == 2 and vals[1] != '':
        frac_str = vals[1].rstrip('0')
        
        if len(frac_str) > decimals:
            raise ArithmeticError
        fractional = 0 if frac_str == '' else int(frac_str) * 10 ** (decimals-len(frac_str))

    return whole+fractional


if __name__ == "__main__":

    try:
        if len(sys.argv) != 3:
            raise ValueError

        float_number = sys.argv[1]

        # will raise ValueErrors if input is wrong 
        prefix = float(float_number)
        zeros = int(sys.argv[2])
        
        print(fractional_to_canonical(float_number, zeros))
    except ValueError as e:
        print('Usage: must input a floating point number and an integer')
    except ArithmeticError as e:
        print('Fractional part exceeds decimals') 
