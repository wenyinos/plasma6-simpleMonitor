#!/bin/bash
# 一次性输出所有系统数据，key=value 格式
awk '/^(MemFree|MemTotal|MemAvailable|Buffers|Cached|SwapFree|SwapTotal):/{gsub(/: */,"="); print}' /proc/meminfo
echo "UPTIME=$(awk '{printf "%.0f", $1}' /proc/uptime)"
grep ^'cpu[0-9]' /proc/stat | while read -r line; do
    parts=($line)
    core=${parts[0]}
    idle=${parts[4]}
    total=$((${parts[1]}+${parts[2]}+${parts[3]}+${parts[4]}+${parts[5]}+${parts[6]}+${parts[7]}+${parts[8]}))
    echo "${core}_idle=$idle"
    echo "${core}_total=$total"
done
for z in /sys/class/thermal/thermal_zone*/temp; do
    [ -f "$z" ] || continue
    v=$(cat "$z"); n=$(echo "$z"|grep -oP 'thermal_zone\K\d+')
    echo "TZ${n}=$v"
done
for hw in /sys/class/hwmon/hwmon*; do
    [ -f "$hw/name" ] || continue
    name=$(tr ' ' '_' < "$hw/name")
    for tf in "$hw"/temp*_input; do
        [ -f "$tf" ] || continue
        tn=$(echo "$tf"|grep -oP 'temp\K\d+')
        echo "HW_${name}_${tn}=$(cat "$tf")"
    done
done
# OS / kernel info
if [ -f /etc/os-release ]; then
    grep -E '^(NAME|ID|VERSION)=' /etc/os-release | head -3 | sed -E 's/^([A-Z_]+)="?/\1=/; s/"$//' | sed 's/^/OS_/'
fi
echo "KERNEL_NAME=Linux"
echo "KERNEL_VERSION=$(awk '{print $3}' /proc/version)"
