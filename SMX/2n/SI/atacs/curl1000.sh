#!/bin/bash
for i in {1..1000}
do
   echo "CURL $i"
   curl http://192.168.201.5
done
