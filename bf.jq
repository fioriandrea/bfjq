#!/bin/jq -MRsf

# Copyright (C) 2024 Andrea Fiori <fiori-andrea@tiscali.it>

# Licensed under GPLv3, see file LICENSE in this source tree.

def less:
    if .dp - 1 < 0 then error("data pointer cannot be negative")
    else .dp -= 1 end;

def greater:
    if .dp + 1 >= (.data | length) then .data |= . + map(0) | greater
    else .dp += 1 end;

def plus:
    .data[.dp] += 1;

def minus:
    .data[.dp] -= 1;

def lsquare:
    def w:
        if .ip >= (.prog | length) then error("no matching ] for [")
        elif .prog[.ip] == "]" and .br == 0 then (.loops = .loops[:-1])
        elif .prog[.ip] == "[" then .br += 1 | .ip += 1 | w
        elif .prog[.ip] == "]" then .br -= 1 | .ip += 1 | w
        else .ip += 1 | w end;
    if .data[.dp] == 0 then .ip += 1 | w
    else . end;

def rsquare:
    def w:
        if .ip < 0 then error("no matching [ for ]")
        elif .prog[.ip] == "[" and .br == 0 then .
        elif .prog[.ip] == "[" then .br += 1 | .ip -= 1 | w
        elif .prog[.ip] == "]" then .br -= 1 | .ip -= 1 | w
        else .ip -= 1 | w end;
    if .data[.dp] != 0 then .ip -= 1 | w
    else . end;

def dot:
    . as $state | [.data[.dp]] | implode | stderr | $state;

def comma:
    if .input | length == 0 then .data[.dp] = 0
    else .data[.dp] = .input[0] | .input |= .[1:] end;

def exec_step:
    .prog[.ip] as $i |
    if $i == "<" then less
    elif $i == ">" then greater
    elif $i == "+" then plus
    elif $i == "-" then minus
    elif $i == "[" then lsquare
    elif $i == "]" then rsquare
    elif $i == "." then dot
    elif $i == "," then comma
    else . end;

def exec:
    . as $in |
    { ip } |
    #debug |
    $in |
    if .ip >= (.prog | length) then empty
    else exec_step | .ip += 1 | exec end;

{
    ip: 0,
    dp: 0,
    data: ($ARGS.named.data // [0]),
    input: . | explode,
    prog: $program | split(""),
    br: 0,
} | exec
