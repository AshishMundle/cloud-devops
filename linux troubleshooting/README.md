# Linux Troubleshooting

## Overview

Focused on production-style troubleshooting fundamentals — log inspection, system performance monitoring, disk health checks, file permission management, and service control. Also did a quick exploratory pass at installing Jenkins to understand the setup process, without going deep into a full working install.

## Topics Covered

**Log inspection & system performance**
Reading and filtering system logs (`auth.log`, `syslog`), monitoring live performance with `top`/`htop`/`vmstat`, and checking boot/hardware messages via `dmesg`.

**Disk health & hardware checks**
Disk usage and health verification using `df -h`, `smartctl`, `lsblk`, `lshw`, and memory checks with `free -m`.

**File permissions**
Practiced permission levels using `chmod` — symbolic (`+x`) and numeric (`777`, `555`) modes, verified with `ls -l`.

**Service management**
Installed and controlled nginx via `systemctl` (status/stop/start), and did a trial run at setting up Jenkins (adding its repo/keyring) to understand the install flow — didn't take it to a fully working state, just explored the process.

## Hands-on — Log Inspection

    cd /var/log/
    ls
    cat auth.log
    more auth.log
    head -10 auth.log
    tail -10 auth.log
    cat auth.log | grep failed
    cat auth.log | grep error
    cat auth.log | grep warning
    cat auth.log | grep invalid
    cat /var/log/syslog

## Hands-on — System Performance & Disk Health

    top
    htop
    vmstat 1
    df -h
    sudo apt install smartmontools
    sudo smartctl -a /dev/sda13
    lshw
    lsblk
    free -m
    dmesg
    dmesg | tail

## Hands-on — File Permissions

    cd /tmp/
    touch 123
    ls -l
    chmod +x 123
    ls -l
    chmod 777 123
    ls -l
    chmod 555 123
    ls -l

## Hands-on — Service Management

    apt-get update
    apt install nginx
    systemctl status nginx
    systemctl stop nginx
    systemctl status nginx
    systemctl start nginx
    systemctl status nginx
    ps -aef | grep nginx

**Jenkins install — quick trial**

    apt install jenkins
    sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt install jenkins

Just an exploratory pass at the Jenkins install flow (adding the keyring and repo source) — didn't take this further into a running setup this session.

## KEY Notes

- **chmod numeric modes:** `777` = full read/write/execute for everyone (avoid in production), `555` = read/execute only, no write — useful for locking down scripts you don't want accidentally modified.
- **systemctl basics:** `status` to check state, `stop`/`start` to control a service, always verify with `status` after any change.
- **Disk health tools:** `df -h` for usage, `smartctl` for physical disk health, `lsblk` for block device layout.
- **Where to look first when troubleshooting:** logs (`/var/log/auth.log`, `/var/log/syslog`), then process state (`ps -aef | grep <service>`), then resource checks (`top`, `free -m`, `df -h`).
