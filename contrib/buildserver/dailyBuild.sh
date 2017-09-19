#!/bin/bash

##
# This script is called by Jenkins to perform the dailyBuild.
#
# The script operates in 3 stages:
# 1 executes dailyCMake.sh to perform the build and test on the build nodes
# 2 executes dailyTest.sh to test that the build bundles are good
# 3 rebuilds all links in userContent/builds/{Latest Date Platform SVN}

ssh rmills@rmillsmm         'cd ~/gnu/exiv2/buildserver ; rm -rf exiv2 ; git clone http://github.com/Exiv2/exiv2.git ; cd exiv2/ ;                               contrib/buildserver/dailyCMake.sh'
ssh rmills@rmillsmm-kubuntu 'cd ~/gnu/exiv2/buildserver ; rm -rf exiv2 ; git clone http://github.com/Exiv2/exiv2.git ; cd exiv2/ ;                               contrib/buildserver/dailyCMake.sh'
ssh rmills@rmillsmm-w7      'cd ~/gnu/exiv2/buildserver ; rm -rf exiv2 ; git clone http://github.com/Exiv2/exiv2.git ; cd exiv2/ ;                               contrib/buildserver/dailyCMake.sh'
ssh rmills@rmillsmm-w7      'cd ~/gnu/exiv2/buildserver ; rm -rf exiv2 ; git clone http://github.com/Exiv2/exiv2.git ; cd exiv2/ ; env PLATFORM=msvc             contrib/buildserver/dailyCMake.sh'
# ssh rmills@rmillsmm-w7      'cd ~/gnu/exiv2/buildserver ; rm -rf exiv2 ; git clone http://github.com/Exiv2/exiv2.git ; cd exiv2/ ; env PLATFORM=mingw win32=true contrib/buildserver/dailyCMake.sh'

##
# test the delivery
date=$(date '+%Y-%m-%d+%H-%M-%S')
svn=0000 # $(ssh rmills@rmillsmm   'cd ~/gnu/exiv2/buildserver ; /usr/local/bin/svn info . | grep "^Last Changed Rev" | cut -f 2 "-d:" | tr -d " "')
builds="/mmHD/Users/Shared/Jenkins/Home/userContent/builds"
output="$builds/Daily/test-svn-${svn}-date-${date}.txt"
echo --------------------------------------
echo test log = $output
echo --------------------------------------

ssh rmills@rmillsmm          'cd ~/gnu/exiv2/buildserver/exiv2 ;                                 contrib/buildserver/dailyTest.sh' | tr -d $'\r' | tee -a $output
ssh rmills@rmillsmm-kubuntu  'cd ~/gnu/exiv2/buildserver/exiv2 ;                                 contrib/buildserver/dailyTest.sh' | tr -d $'\r' | tee -a $output
ssh rmills@rmillsmm-w7       'cd ~/gnu/exiv2/buildserver/exiv2 ;                                 contrib/buildserver/dailyTest.sh' | tr -d $'\r' | tee -a $output
ssh rmills@rmillsmm-w7       'cd ~/gnu/exiv2/buildserver/exiv2 ; env PLATFORM=msvc               contrib/buildserver/dailyTest.sh' | tr -d $'\r' | tee -a $output
# ssh rmills@rmillsmm-w7       'cd ~/gnu/exiv2/buildserver/exiv2 ; env PLATFORM=mingw win32=true contrib/buildserver/dailyTest.sh' | tr -d $'\r' | tee -a $output

##
# categorize the builds
ssh rmills@rmillsmm         "cd ~/gnu/exiv2/buildserver/exiv2 ; PATH="$PATH:/usr/local/bin";      contrib/buildserver/categorize.py $builds"

# That's all Folks!
##
