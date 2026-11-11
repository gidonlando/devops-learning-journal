# Linux System Health Monitor

A Bash-based Linux system monitoring tool developed as part of my DevOps learning project.

## Overview

This project provides a lightweight system health check for Linux environments.

It monitors:

- CPU load average normalized by logical CPU count
- Memory utilization
- Root filesystem disk usage
- Presence of a specified process

The script prints a status report and returns a nonzero exit code when a warning is detected.

## Requirements

- Linux
- Bash
- GNU coreutils
- awk
- procps utilities (`free`, `pgrep`, `nproc`)

## Usage

From the repository root:

```bash
./week02/scripts/health-check.sh
```

To check a particular process:

```bash
./week02/scripts/health-check.sh sshd
```

## Configuration

The script currently uses these thresholds:

| Metric | Warning threshold |
|---|---|
| Normalized CPU load | Greater than 1.0 |
| Memory usage | Greater than 80% |
| Disk usage | Greater than 85% |

Thresholds are configured in the script.

## Exit Codes

- `0`: All checks passed
- `1`: One or more checks reported a warning

## Testing

Run:

```bash
bash -n week02/scripts/health-check.sh
shellcheck week02/scripts/health-check.sh
./week02/scripts/test-health-check.sh
```

## Limitations

- CPU load average is not the same as instantaneous CPU utilization.
- The script checks only the root filesystem.
- Process detection is based on process names.
- The monitor is intended as a learning project, not a replacement for a production observability platform.

## Future Improvements

- Configurable thresholds via command-line arguments
- More comprehensive automated tests
- Monitoring multiple filesystems
- JSON output for integration with other tools
- CI/CD integration using GitHub Actions

