# obviously this is limited
if [[ "`cat /proc/cpuinfo`" == *"hypervisor"* ]]; then
    echo "hypervisor tag found in /proc/cpuinfo"
fi
dmesg | grep -i hypervisor
