# Copyright (C) 2016  Codethink Limited
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# =*= License: GPL-2 =*=

#
# This is a bash script which attempts to install ybd's dependencies.
# It's mainly intended for ci and automated test setups...
#

# echo what we're doing
set -x

installed=false
# install dependencies for debian, ubuntu
which apt-get 2>&1 > /dev/null
if [ $? -eq 0 ]; then
    sudo apt-get -qq update
    sudo apt-get -qq install build-essential gawk git m4 wget
    if [ $? -ne 0 ]; then
        echo "Install failed"
        exit 1
    fi
    installed=true
fi

# install for fedora
which dnf 2>&1 > /dev/null
if [ $? -eq 0 ] && [ $installed = false ]; then
    sudo dnf install -y which make automake gcc gcc-c++ gawk git m4 wget python
    if [ $? -ne 0 ]; then
        echo "Install failed"
        exit 1
    fi
    installed=true
fi

# install for aws
which yum 2>&1 > /dev/null
if [ $? -eq 0 ] && [ $installed = false ]; then
    sudo yum install -y which make automake gcc gcc-c++ gawk git m4 wget python
    if [ $? -ne 0 ]; then
        echo "Install failed"
        exit 1
    fi
    installed=true
fi

# install for Arch
which pacman 2>&1 > /dev/null
if [ $? -eq 0 ] && [ $installed = false ]; then
    sudo pacman -S --noconfirm which make automake gcc gawk git m4 wget python2
    if [ $? -ne 0 ]; then
        echo "Install failed"
        exit 1
    fi
    installed=true
fi

if [ $installed = false ]; then
    echo "No way to install dependencies: [apt|dnf|yum|pacman] not found"
    exit 1
fi

pip --version 2>&1 > /dev/null
if [ $? -ne 0 ]; then
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py
    sudo rm get-pip.py
fi

sudo pip install fs pyyaml sandboxlib requests
sudo pip install jsonschema bottle cherrypy riemann-client
sudo pip install pep8
