#!/bin/bash
# Author: Jesper Dangaard Brouer <netoptimizer@brouer.com>

if [ -z "$1" ]; then
    echo -e "ERROR: Usage: $0 device"
    exit
fi
DEV=$1

set -x
# TCP_RR:
#ethtool -K $DEV gso off gro off
killall irqbalance
./set_irq_affinity $DEV
ethtool -A $DEV rx off tx off autoneg off
for CPU in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
	echo performance > $CPU
done
tuned-adm profile network-latency
