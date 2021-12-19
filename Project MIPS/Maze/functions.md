## Functions

**create**
> Return Values:
    4($fp): player position row
    8($fp): player position column

> Arguments:
    12($fp): file name adress
    16($fp): buffer adress
    20($fp): buffer size

> uses $s0 - $s4

> 5 bytes above $fp, 7 bytes below $fp

**toMemAdress**
> Return Values:
    $v1: memory adress

> Arguments:
    $a0: row coördinate
    $a1: column coördinate

**player_position**
> Return Values:
    $v0: (new) player row location
    $v1: (new) player column location

> Arguments:
    4($fp): current player row
    8($fp): current player column
    12($fp): new player row
    16($fp): new player column