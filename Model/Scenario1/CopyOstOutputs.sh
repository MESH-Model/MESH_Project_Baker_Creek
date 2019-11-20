#!/bin/bash

scenario=$(printf '%s\n' "${PWD##*/}")
echo $scenario
for f in ${scenario}_*
do
  cp -r ../$f/Output/* ./Output/.
done
