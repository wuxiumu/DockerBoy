#!/bin/bash

# 
function foo()
{
    local i=0
    local total=$#

    echo "total param =$total"

    for val in $@
    do
        ((i++))
        echo "$i-- val=$val"
    done

    return $total
} 

foo
foo param param2 param3

echo "return value=$?"

exit 0