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

BIN_DIR=$(dirname $0)
SCRIPT=$BIN_DIR/vmdk-disk.sh
. $BIN_DIR/init.shl

command="$SCRIPT backup"
zenity --question --title="$SCRIPT" --text="Continue with $command?"
if [ $? -eq 0 ] ; then
    sudo $command
fi
