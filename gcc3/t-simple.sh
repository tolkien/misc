#!/bin/sh
if [ ! -e config ]; then
   ln -s . config
fi
runtest --target_board=i519 simple.exp 
