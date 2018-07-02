#!/usr/bin/env python

import argparse

import openstack


def get_connection():
    #openstack.enable_logging(debug=True)
    conn = openstack.connect()
    return conn


def get_server_floatingips(conn, server_uuid):
    floating = []
    all_addresses = conn.compute.get_server(server_uuid).addresses
    for network, addresses in all_addresses.items():
        for address in addresses:
            if address['OS-EXT-IPS:type'] == 'floating':
                floating.append(address)
    return floating


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('server_uuid', type=str,
                        help='Nova server uuid')
    args = parser.parse_args()

    server_uuid = args.server_uuid

    conn = get_connection()

    floatingips = get_server_floatingips(conn, server_uuid)
    if len(floatingips) == 1:
        server_address = str(floatingips[0]['addr'])
    else:
        raise Exception("Not found just one floating ip, panic!")

    print "[all]"
    print "%s ansible_user=centos" % server_address


if __name__ == '__main__':
    main()
