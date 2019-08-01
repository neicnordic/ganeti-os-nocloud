## Synopsis

This is a [cloud-init][] OS definition for [Ganeti][].  It injects the
meta-data and user-data directly into file system of the target host, to be
picked up by the [NoCloud][] data source.

## Usage

Download the needed cloud-init images to `/var/cache/ganeti-cloudimg` and
distribute them to all nodes.  The expected file name of an image is
specified in the corresponding configuration file found under
`/etc/ganeti/nocloud/variants/`.  To add a missing OS variant, create the
configuration file and add the name to `/etc/ganeti/nocloud/variants.list`.

Next, put your [cloud config data][cloud-config] under
`/etc/ganeti/nocloud/user-data/`.  The OS creation script will look for
`${OS_VARIANT}.yml` then `default.yml` by default, but you can provide an
alternative file name with the `cloud_userdata_file` OS parameter.

Finally, then VM can be created by specifying `nocloud+variant` as the OS,
where `variant` is one of `/etc/ganeti/nocloud/variants.list`:

    gnt-instance add -s 7G nocloud+ubuntu-18.04 vm1.example.org

For static IP configuration add an network and an IP number to the interface
with e.g. `--net 0:network=local,ip=172.16.0.20`.  If you pass `-O
static_host_interface=0` then all IPs from the DNS A and AAAA records for
the host will be added to the first interface, in which case the `ip`
network parameter may be omitted.  This allows creating IPv6-only VMs or VMs
with multiple IP numbers.


[Ganeti]: http://www.ganeti.org/
[cloud-init]: https://cloudinit.readthedocs.io/en/latest/
[NoCloud]: https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html
[cloud-config]: https://cloudinit.readthedocs.io/en/latest/topics/format.html#cloud-config-data
