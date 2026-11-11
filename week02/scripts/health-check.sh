#!/usr/bin/env bash

set -o pipefail

# Configurable thresholds
CPU_THRESHOLD=1.0
MEMORY_THRESHOLD=80
SWAP_SPACE_TJRESHHOLD=80
DISK_THRESHOLD="${2:-1}"
PROCESS_NAME="${1:-bash}"

# Overall status: 0 = healthy, 1 = warning
overall_status=0

report_status() {
    local component="$1"
    local status="$2"
    local details="$3"

    printf "%-12s %-8s %s\n" \
        "$component" "$status" "$details"

    if [[ "$status" == "WARN" ]]; then
        overall_status=1
    fi
}

check_cpu() {
    local load2 cpus normalized

    load2=$(awk '{print $1}' /proc/loadavg)
    cpus=$(nproc)

    normalized=$(awk -v load2="$load2" -v cpus="$cpus" \
        'BEGIN {printf "%.2f", load2/cpus}')

    if awk -v n="$normalized" -v t="$CPU_THRESHOLD" \
        'BEGIN {exit !(n > t)}'; then

        report_status "CPU" "WARN" \
            "Load per CPU: $normalized"
    else
        report_status "CPU" "OK" \
            "Load per CPU: $normalized"
    fi
}

check_memory() {
    local used

    used=$(free | awk '/^Mem:/ {
        printf "%.0f", ($2-$7)/$2*100
    }')

    if (( used > MEMORY_THRESHOLD )); then
        report_status "Memory" "WARN" \
            "Usage: ${used}%"
    else
        report_status "Memory" "OK" \
            "Usage: ${used}%"
    fi
}

check_disk() {
    local used

    used=$(df -P / | awk 'NR==2 {
        gsub(/%/, "", $5)
        print $5
    }')

    if (( used > DISK_THRESHOLD )); then
        report_status "Disk" "WARN" \
            "Usage: ${used}%"
    else
        report_status "Disk" "OK" \
            "Usage: ${used}%"
    fi
}

check_process() {
    if pgrep -x -- "$PROCESS_NAME" > /dev/null; then
        report_status "Process" "OK" \
            "$PROCESS_NAME is running"
    else
        report_status "Process" "WARN" \
            "$PROCESS_NAME not found"
    fi
}

print_uptime() {
    echo "Uptime is: $(uptime)"
}

echo "================================"
echo "Linux System Health Report"
echo "================================"
echo "Hostname: $(hostname)"
echo "Number of logical CPs: $(nrpoc)"
echo "Date: $(date)"
echo

check_cpu
check_memory
check_disk
check_process

echo
if (( overall_status == 0 )); then
    echo "Overall status: HEALTHY"
else
    echo "Overall status: WARNING"
fi

exit "$overall_status"
