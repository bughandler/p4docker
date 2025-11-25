#!/bin/sh
if ! p4d -xD; then
    echo $P4NAME>$P4ROOT/server.id
    p4d -Gc
fi
p4d -J journal -L log
