# Copyright (C) 2019  Petter A. Urkedal <urkedal@ndgf.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

IMAGE_DIR="/var/cache/ganeti-cloudimg"
CLOUD_SEED_DIR="/var/lib/cloud/seed/nocloud"

if [ -r "/etc/ganeti/nocloud/variants/${OS_VARIANT}.conf" ]; then
    . "/etc/ganeti/nocloud/variants/${OS_VARIANT}.conf"
fi

die()
{
    echo 1>&2 "$*"
    exit 1
}

_atexit_jobs=( )

_atexit_run()
{
    if [ ${#_atexit_jobs[*]} -gt 0 ]; then
	for i in $(seq $((${#_atexit_jobs[*]} - 1)) -1 0); do
	    ${_atexit_jobs[$i]}
	done
    fi
}

trap _atexit_run EXIT

atexit()
{
    [ $# = 1 ] || die "Usage: atexit COMMAND"
    _atexit_jobs+=("$1")
}

parse_list_parameter()
{
    local IFS=,
    local local__q local__qs local__x
    local__qs="${2//%/%45}"
    local__qs="${local__qs//\\\\/%5c}"
    local__qs="${local__qs//\\,/%54}"
    eval "$1=( )"
    for local__q in $local__qs; do
	local__x="${local__q//%54/,}"
	local__x="${local__x//%5c/\\}"
	local__x="${local__x//%45/%}"
	eval $1+='("$local__x")'
    done
}

# Adapted from ganeti-instance-debootstrap.
map_disk0() {
  blockdev="$1"
  filesystem_dev_base=`kpartx -l $blockdev | \
		       grep -m 1 -- "p1 :[0-9 ]* $blockdev " | \
		       awk '{print $1}'`
  if [ -z "$filesystem_dev_base" ]; then
    die "Cannot interpret kpartx output and get partition mapping"
  fi
  kpartx -a -s $blockdev > /dev/null
  filesystem_dev="/dev/mapper/$filesystem_dev_base"
  if [ ! -b "$filesystem_dev" ]; then
    die "Can't find kpartx mapped partition: $filesystem_dev"
  fi
  echo "$filesystem_dev"
}
unmap_disk0() {
  kpartx -d "$1"
}
