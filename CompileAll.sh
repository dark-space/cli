#!/bin/sh

cd $(dirname $(readlink -e $0))

rm -fr bin
mkdir -p bin
for f in *.nim; do
    nim c -d=release -o=bin/$(basename ${f%.nim}) $f
done

if [ $# -gt 0 ] && [ "$1" = "--commit" ]; then
    if git status -s | grep '^[A-Z]. ' 2>/dev/null; then
        echo "[ERROR] Some files are added"
        return
    fi
    oldfile=$(tail -n 1 download-bin.sh | awk '{print $3}')
    git rm $oldfile 2>/dev/null || rm -f $oldfile
    tarfile=bin.$(date +%Y%m%d).tar.gz
    sed -i "s/$oldfile/$tarfile/g" download-bin.sh
    tar cvf $tarfile bin
    git add $tarfile download-bin.sh
    git commit -m "$tarfile"
fi

