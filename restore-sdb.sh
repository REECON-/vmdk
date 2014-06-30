#!/bin/bash
#
# Copyright 2014 Dean Okamura
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

. ./init.shl
part=sdb

tasks()
{
    if [ ! "$(df | grep /dev/$part)" = "" ] ; then
        echo "/dev/$part is mounted"
        exit 1
    fi
    bzip2 -dc $name.$part.bz2 | dd of=/dev/$part bs=100M
}

case "$1" in
-t ) shift; tasks $* ;;
* ) sudo $0 -t $* ;;
esac
