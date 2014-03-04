#!/bin/bash
#
# This is a convenience script for me to clean and re-create my dropbox
# directories. Use it at your peril, it may not work for you!
#
config=monitor.conf

inbox=`  cat $config | sed -e 's%#.*$%%' | grep inbox | grep -v inbox_ | awk '{ print $NF }'`
workdir=`cat $config | sed -e 's%#.*$%%' | grep workdir | awk '{ print $NF }'`
outbox=` cat $config | sed -e 's%#.*$%%' | grep outbox | awk '{ print $NF }'`

for dir in $inbox $workdir $outbox /tmp/wildish
do
  echo Clean $dir
  rm -rf $dir
  mkdir -p $dir
done

rm *.log *.pid
