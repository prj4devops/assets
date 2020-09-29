#!/bin/bash
ip link delete vhost
ip link delete nginx
ip netns delete ns-nginx
runc delete nginx-container
