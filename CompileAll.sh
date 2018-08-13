#!/bin/sh

cd $(dirname $(readlink -e $0))

for f in *.nim; do
    nim c -d=release -o=bin/$(basename ${f%.nim}) $f
done

