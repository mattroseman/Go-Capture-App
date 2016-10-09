#!/bin/sh -x

rm -f *~
pwd=`pwd`
pkg=`basename $pwd`

cd ..
tar -czvf $pkg.tar.gz $pkg
