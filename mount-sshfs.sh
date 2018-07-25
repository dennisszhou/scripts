#!/bin/bash

dpipe /usr/libexec/openssh/sftp-server = ssh test sshfs :/data/users/dennisz /root/mount -o slave &
