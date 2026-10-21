#!/bin/bash
for i in {1..10}
do
   echo "fork $i"
   ./curl1000.sh &
done
