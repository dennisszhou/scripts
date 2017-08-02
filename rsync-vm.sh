#!/bin/bash
#ssh -6 root@fe80::5054:ff:fe12:3456%tap0
rsync -avH ~/local/workplace/pcpu-km ssh -6 '[root@fe80::5054:ff:fe12:3456%tap0]':~/workplace
