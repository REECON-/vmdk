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

title=$(basename $0)

tasks()
{
    option=$1
    disk=/dev/sda
    gb=
    if [ -f vmdk-disk.env ] ; then
       . ./vmdk-disk.env
    fi
    name=$(basename $(pwd))

    if [ ! "$(whoami)" = "root" ] ; then
        zenity --error --title="$title" --text="Run $0 as root"
        exit 1
    fi

    if [ "$option" = "restore" ] ; then
        if [ ! "$(df | grep $disk)" = "" ] ; then
            zenity --error --title="$title" --text="$disk is mounted"
            exit 1
        fi
    fi

    if [ ! -f /usr/local/bin/qemu-img -a ! -f /usr/bin/qemu-img ] ; then
        if [ -f /usr/bin/apt-get ] ; then
            sudo apt-get install -y qemu-common qemu-utils
        else
            sudo yum install -y qemu-common qemu-img
        fi
    fi

    if [ ! -f /usr/local/bin/qemu-img -a ! -f /usr/bin/qemu-img ] ; then
        zenity --error --title="$title" --text="qemu-img not found"
        exit 1
    fi

    if [ "$option" = "backup" ] ; then
        if [ ! "$gb" = "" ] ; then
            image=$name.img
            dd bs=1024 count=${gb}G if=$disk of=$image
            /usr/bin/qemu-img convert $image -O vmdk $name.vmdk
            chmod 644 $name.vmdk
            rm $image
        else
            /usr/bin/qemu-img convert $disk -O vmdk $name.vmdk
            chmod 644 $name.vmdk
        fi
    else
        if [ ! -f $name.vmdk ] ; then
            zenity --error --title="$title" --text="$name.vmdk not found"
            exit 1
        fi
        /usr/bin/qemu-img convert $name.vmdk -O raw $disk
    fi
}

case "$1" in
-t ) shift; tasks $* ;;
* ) sudo $0 -t $* ;;
esac

#
