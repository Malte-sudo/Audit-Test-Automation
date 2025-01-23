$rcTrue = "True"
$rcCompliant = "Compliant"
$rcFalse = "False"
$rcNone = "None"
$rcNonCompliant = "Non-Compliant"
$rcNonCompliantManualReviewRequired = "Manual review required"
$rcCompliantIPv6isDisabled = "IPv6 is disabled"

$retCompliant = @{
    Message = $rcCompliant
    Status = $rcTrue
}
$retNonCompliant = @{
    Message = $rcNonCompliant
    Status = $rcFalse
}
$retCompliantIPv6Disabled = @{
    Message = $rcCompliantIPv6isDisabled
    Status = $rcTrue
}
$retNonCompliantManualReviewRequired = @{
    Message = $rcNonCompliantManualReviewRequired
    Status = $rcNone
}

$IPv6Status_script = grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo "IPv6 is enabled" || echo "IPv6 is not enabled"
$IPv6Status = bash -c $IPv6Status_script
if ($IPv6Status -match "is enabled") {
    $IPv6Status = "enabled"
} else {
    $IPv6Status = "disabled"
}

$parentPath = Split-Path -Parent -Path $PSScriptRoot
$scriptPath = $parentPath + "/Helpers/ShellScripts/RHEL9/"


### Chapter 1 - Initial Setup


[AuditTest] @{
    Id = "1.1.1.1"
    Task = "Ensure mounting of squashfs filesystems is disabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_1111.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.1.2"
    Task = "Ensure mounting of udf filesystems is disabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_1112.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.2.1"
    Task = "Ensure /tmp is a separate partition"
    Test = {
        $result = findmnt --kernel /tmp | grep -E '\s/tmp\s'
        if ($result -match "/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.2.2"
    Task = "Ensure nodev option set on /tmp partition"
    Test = {
        $result = findmnt --kernel /tmp | grep nodev
        if ($result -match "/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.2.3"
    Task = "Ensure noexec option set on /tmp partition"
    Test = {
        $result = findmnt --kernel /tmp | grep noexec
        if ($result -match "/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.2.4"
    Task = "Ensure nosuid option set on /tmp partition"
    Test = {
        $result = findmnt --kernel /tmp | grep nosuid
        if ($result -match "/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.3.1"
    Task = "Ensure separate partition exists for /var"
    Test = {
        $result = findmnt --kernel /var
        if ($result -match "/var") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}


[AuditTest] @{
    Id = "1.1.3.2"
    Task = "Ensure nodev option set on /var partition"
    Test = {
        $result = findmnt --kernel /var | grep nodev
        if ($result -match "/var") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.3.3"
    Task = "Ensure nosuid option set on /var partition"
    Test = {
        $result = findmnt --kernel /var | grep nosuid
        if ($result -match "/var") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.4.1"
    Task = "Ensure separate partition exists for /var/tmp"
    Test = {
        $result = findmnt --kernel /var/tmp
        if ($result -match "/var/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.4.2"
    Task = "Ensure noexec option set on /var/tmp partition"
    Test = {
        $result = findmnt --kernel /var/tmp | grep noexec
        if ($result -match "/var/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.4.3"
    Task = "Ensure nosuid option set on /var/tmp partition"
    Test = {
        $result = findmnt --kernel /var/tmp | grep nosuid
        if ($result -match "/var/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.4.4"
    Task = "Ensure nodev option set on /var/tmp partition"
    Test = {
        $result = findmnt --kernel /var/tmp | grep nodev
        if ($result -match "/tmp") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.5.1"
    Task = "Ensure separate partition exists for /var/log"
    Test = {
        $result = findmnt --kernel /var/log
        if ($result -match "/var/log") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.5.2"
    Task = "Ensure nodev option set on /var/log"
    Test = {
        $result = findmnt --kernel /var/log | grep nodev
        if ($result -match "/var/log") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.5.3"
    Task = "Ensure noexec option set on /var/log"
    Test = {
        $result = findmnt --kernel /var/log | grep noexec
        if ($result -match "/var/log") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.5.4"
    Task = "Ensure nosuid option set on /var/log"
    Test = {
        $result = findmnt --kernel /var/log | grep nosuid
        if ($result -match "/var/log") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.6.1"
    Task = "Ensure separate partition exists for /var/log/audit"
    Test = {
        $result = findmnt --kernel /var/log/audit
        if ($result -match "/var/log/audit") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.6.2"
    Task = "Ensure noexec option set on /var/log/audit"
    Test = {
        $result = findmnt --kernel /var/log/audit | grep noexec
        if ($result -match "/var/log/audit") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.6.3"
    Task = "Ensure nodev option set on /var/log/audit"
    Test = {
        $result = findmnt --kernel /var/log/audit | grep nodev
        if ($result -match "/var/log/audit") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.6.4"
    Task = "Ensure nosuid option set on /var/log/audit"
    Test = {
        $result = findmnt --kernel /var/log/audit | grep nosuid
        if ($result -match "/var/log/audit") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.7.1"
    Task = "Ensure separate partition exists for /home"
    Test = {
        $result = findmnt --kernel /home
        if ($result -match "/home") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.7.2"
    Task = "Ensure nodev option set on /home"
    Test = {
        $result = findmnt --kernel /home | grep nodev
        if ($result -match "/home") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.7.3"
    Task = "Ensure nosuid option set on /home"
    Test = {
        $result = findmnt --kernel /home | grep nosuid
        if ($result -match "/home") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.8.1"
    Task = "Ensure /dev/shm is a separate partition"
    Test = {
        $result = findmnt --kernel /dev/shm
        if ($result -match "/dev/shm") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.8.2"
    Task = "Ensure nodev option set on /dev/shm partition"
    Test = {
        $result = mount | grep -E '\s/dev/shm\s' | grep nodev
        if ($result -match "/dev/shm") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.8.3"
    Task = "Ensure noexec option set on /dev/shm partition"
    Test = {
        $result = findmnt --kernel /dev/shm | grep noexec
        if ($result -match "/dev/shm") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.8.4"
    Task = "Ensure nosuid option set on /dev/shm partition"
    Test = {
        $result = findmnt --kernel /dev/shm | grep nosuid
        if ($result -match "/dev/shm") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.1.9"
    Task = "Disable USB Storage"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_119.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.2.1"
    Task = "Ensure GPG keys are configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "1.2.2"
    Task = "Ensure gpgcheck is globally activated"
    Test = {
        $result = grep ^gpgcheck /etc/dnf/dnf.conf
        if ($result -match "gpgcheck=1") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.2.3"
    Task = "Ensure package manager repositories are configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "1.2.4"
    Task = "Ensure repo_gpgcheck is globally activated"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "1.3.1"
    Task = "Ensure aide is installed"
    Test = {
        $result = rpm -q aide
        if ($result -match "aide-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.3.2"
    Task = "Ensure filesystem integrity is regularly checked"
    Test = {
        $result1 = systemctl is-enabled aidecheck.service
        $result2 = systemctl is-enabled aidecheck.timer
        $result3 = systemctl status aidecheck.service
        if ($result1 -match "enabled" -and $result2 -match "enabled" -and $result3 -match "Active:") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.3.3"
    Task = "Ensure filesystem integrity is regularly checked"
    Test = {
        $result = grep -Ps -- '(\/sbin\/(audit|au)\H*\b)' /etc/aide.conf.d/*.conf /etc/aide.conf
        if ($result -match "/sbin/auditctl p+i+n+u+g+s+b+acl+xattrs+sha512" -and
        $result -match "/sbin/auditd p+i+n+u+g+s+b+acl+xattrs+sha512" -and
        $result -match "/sbin/ausearch p+i+n+u+g+s+b+acl+xattrs+sha512" -and
        $result -match "/sbin/aureport p+i+n+u+g+s+b+acl+xattrs+sha512" -and
        $result -match "/sbin/autrace p+i+n+u+g+s+b+acl+xattrs+sha512" -and
        $result -match "/sbin/augenrules p+i+n+u+g+s+b+acl+xattrs+sha512"){
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.4.1"
    Task = "Ensure bootloader password is set"
    Test = {
        $result = awk -F. '/^\s*GRUB2_PASSWORD/ {print $1"."$2"."$3}' /boot/grub2/user.cfg
        if ($result -match "GRUB2_PASSWORD=grub.pbkdf2.sha512") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.4.2"
    Task = "Ensure permissions on bootloader config are configured"
    Test = {
        $result1 = stat -Lc "%n %#a %u/%U %g/%G" /boot/grub2/grub.cfg | grep '/boot/grub2/grub.cfg\s*0700\s*0/root\s*0/root'
        $result2 = stat -Lc "%n %#a %u/%U %g/%G" /boot/grub2/grubenv | grep '/boot/grub2/grubenv\s*0600\s*0/root\s*0/root'
        $result3 = stat -Lc "%n %#a %u/%U %g/%G" /boot/grub2/user.cfg | grep '/boot/grub2/user.cfg\s*0600\s*0/root\s*0/root'
        if ($result1 -ne $null -and $result2 -ne $null -and $result3 -ne $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.5.1"
    Task = "Ensure core dump storage is disabled"
    Test = {
        $result = grep -i '^\s*storage\s*=\s*none' /etc/systemd/coredump.conf
        if ($result -match "Storage=none") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.5.2"
    Task = "Ensure core dump backtraces are disabled"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    grep -Pi '^\h*ProcessSizeMax\h*=\h*0\b' /etc/systemd/coredump.conf || echo -e "\n- Audit results:\n FAIL\n - \"ProcessSizeMax\" is: \"$(grep -i 'ProcessSizeMax' /etc/systemd/coredump.conf)\""
}
'@
        $result = bash -c $script_string
        if ($result -match "FAIL") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.5.3"
    Task = "Ensure address space layout randomization (ASLR) is enabled"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    l_output="" l_output2=""
    l_parlist="kernel.randomize_va_space=2"
    l_searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf $([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
    KPC()
    {
        l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)"
        l_pafile="$(grep -Psl -- "^\h*$l_kpname\h*=\h*$l_kpvalue\b\h*(#.*)?$" $l_searchloc)"
        l_fafile="$(grep -s -- "^\s*$l_kpname" $l_searchloc | grep -Pv -- "\h*=\h*$l_kpvalue\b\h*" | awk -F: '{print $1}')"
        if [ "$l_krp" = "$l_kpvalue" ]; then
            l_output="$l_output\n - \"$l_kpname\" is set to \"$l_kpvalue\" in the running configuration"
        else
            l_output2="$l_output2\n - \"$l_kpname\" is set to \"$l_krp\" in the running configuration"
        fi
        if [ -n "$l_pafile" ]; then
            l_output="$l_output\n - \"$l_kpname\" is set to \"$l_kpvalue\" in \"$l_pafile\""
        else
            l_output2="$l_output2\n - \"$l_kpname = $l_kpvalue\" is not set in a kernel parameter configuration file"
        fi
        [ -n "$l_fafile" ] && l_output2="$l_output2\n - \"$l_kpname\" is set incorrectly in \"$l_fafile\""
    }
    for l_kpe in $l_parlist; do
        l_kpname="$(awk -F= '{print $1}' <<< "$l_kpe")"
        l_kpvalue="$(awk -F= '{print $2}' <<< "$l_kpe")"
        KPC
    done
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n PASS\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n FAIL\n - Reason(s) for audit failure:\n$l_output2\n" [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
}
'@
        $script = bash -c $script_string
        if ($script -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.1"
    Task = "Ensure SELinux is installed"
    Test = {
        $result = rpm -q libselinux
        if ($result -match "libselinux-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.2"
    Task = "Ensure SELinux is not disabled in bootloader configuration"
    Test = {
        $result = grubby --info=ALL | grep -Po '(selinux|enforcing)=0\b'
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.3"
    Task = "Ensure SELinux policy is configured"
    Test = {
        $result1 = grep -E '^\s*SELINUXTYPE=(targeted|mls)\b' /etc/selinux/config
        $result2 = sestatus | grep Loaded
        if (($result1 -match "targeted" -or $result1 -match "mls") -and ($result2 -match "targeted" -or $result2 -match "mls")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.4"
    Task = "Ensure the SELinux mode is not disabled"
    Test = {
        $result1 = getenforce
        $result2 = grep -Ei '^\s*SELINUX=(enforcing|permissive)' /etc/selinux/config
        if (($result1 -match "Enforcing" -or $result1 -match "Permissive") -and ($result2 -match "SELINUX=enforcing" -or $result2 -match "SELINUX=permissive")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.5"
    Task = "Ensure the SELinux mode is enforcing"
    Test = {
        $result1 = getenforce
        $result2 = grep -i SELINUX=enforcing /etc/selinux/config
        if ($result1 -match "Enforcing" -and $result2 -match "SELINUX=enforcing") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.6"
    Task = "Ensure no uncofined services exist"
    Test = {
        $result = ps -eZ | grep unconfined_service_t
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.7"
    Task = "Ensure SETroubleshoot is not installed"
    Test = {
        $result = rpm -q setroubleshoot
        if ($result -match "is not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.6.1.8"
    Task = "Ensure the MCS Translation Service (mcstrans) is not installed"
    Test = {
        $result = rpm -q mcstrans
        if ($result -match "is not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.7.1"
    Task = "Ensure the MCS Translation Service (mcstrans) is not installed"
    Test = {
        $result = grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/motd
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.7.2"
    Task = "Ensure local login warning banner is configured properly"
    Test = {
        $result = grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.7.3"
    Task = "Ensure remote login warning banner is configured properly"
    Test = {
        $result = grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" /etc/issue.net
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.7.4"
    Task = "Ensure permissions on /etc/motd are configured"
    Test = {
        $result = stat  -c "%a" /etc/motd
        if ($result -eq 644) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.7.5"
    Task = "Ensure permissions on /etc/issue are configured"
    Test = {
        $result = stat -c "%a" /etc/issue
        if ($result -eq 644) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.7.6"
    Task = "Ensure permissions on /etc/issue.net are configured"
    Test = {
        $result = stat -c "%a" /etc/issue.net
        if ($result -eq 644) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.1"
    Task = "Ensure GNOME Display Manager is removed"
    Test = {
        $result = rpm -q gdm
        if ($result -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.2"
    Task = "Ensure GDM login banner is configured"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_182.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.3"
    Task = "Ensure GDM disable-user-list option is enabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_183.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.4"
    Task = "Ensure GDM screen locks then the user is idle"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_184.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.5"
    Task = "Ensure GDM screen locks cannot be overridden"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_185.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.6"
    Task = "Ensure GDM automatic mounting of removable media is disabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_186.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.7"
    Task = "Ensure GDM disabling automatic mounting of removable media is not overridden"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_187.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.8"
    Task = "Ensure GDM autorun-never is enabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_188.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.9"
    Task = "Ensure GDM autorun-never is not overridden"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_189.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.8.10"
    Task = "Ensure XDCMP is not enabled"
    Test = {
        $test = grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm/custom.conf
        if ($test -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "1.9"
    Task = "Ensure updates, patches, and additional security software are installed"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "1.10"
    Task = "Ensure system-wide crypto policy is not legacy"
    Test = {
        $test = grep -E -i '^\s*LEGACY\s*(\s+#.*)?$' /etc/crypto-policies/config
        if ($test -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}


### Chapter 2 - Services


[AuditTest] @{
    Id = "2.1.1"
    Task = "Ensure time synchronization is in use"
    Test = {
        $test = rpm -q chrony
        if ($test -match "chrony-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.1.2"
    Task = "Ensure chrony is configured"
    Test = {
        $test = grep -E "^(server|pool)" /etc/chrony.conf | grep OPTIONS\s*-u\s*chrony
        if ($test -match "OPTIONS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.1"
    Task = "Ensure xorg-x11-server-common is not installed"
    Test = {
        $test = rpm -q xorg-x11-server-common
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.2"
    Task = "Ensure Avahi Server is not installed"
    Test = {
        $test = rpm -q avahi
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.3"
    Task = "Ensure CUPS is not installed"
    Test = {
        $test = rpm -q cups
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.4"
    Task = "Ensure DHCP Server is not installed"
    Test = {
        $test = rpm -q dhcp-server
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.5"
    Task = "Ensure DNS Server is not installed"
    Test = {
        $test = rpm -q bind
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.6"
    Task = "Ensure VSFTP Server is not installed"
    Test = {
        $test = rpm -q vsftpd
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.7"
    Task = "Ensure VSFTP Server is not installed"
    Test = {
        $test = rpm -q vsftpd
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.8"
    Task = "Ensure a web server is not installed"
    Test = {
        $test = rpm -q httpd nginx
        if ($test -match "httpd is not installed" -and $test -match "nginx is not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.9"
    Task = "Ensure IMAP and POP3 server is not installed"
    Test = {
        $test = rpm -q dovecot cyrus-imapd
        if ($test -match "dovecot is not installed" -and $test -match "cyrus-imapd is not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.10"
    Task = "Ensure Samba is not installed"
    Test = {
        $test = rpm -q samba
        if ($test -match "samba is not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.11"
    Task = "Ensure HTTP Proxy Server is not installed"
    Test = {
        $test = rpm -q squid
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.12"
    Task = "Ensure net-snmp is not installed"
    Test = {
        $test = rpm -q net-snmp
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.13"
    Task = "Ensure telnet-server is not installed"
    Test = {
        $test = rpm -q telnet-server
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.14"
    Task = "Ensure dnsmasq is not installed"
    Test = {
        $test = rpm -q dnsmasq
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.15"
    Task = "Ensure mail transfer agent is configured for local-only mode"
    Test = {
        $test = ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|\[?::1\]?):25\s'
        if ($test -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.16"
    Task = "Ensure nfs-utils is not installed or the nfs-server service is masked"
    Test = {
        rpm -q nfs-utils
        if ($?) {
          return $retCompliant
        } else {
          return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.17"
    Task = "Ensure rpcbind is not installed or the rpcbind services are masked"
    Test = {
        $test1 = rpm -q rpcbind
        $test21 = systemctl is-enabled rpcbind
        $test22 = systemctl is-enabled rpcbind.socket
        if ($test1 -match "not installed" -or ($test21 -match "masked" -and $test22 -match "masked")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.2.18"
    Task = "Ensure rsync-daemon is not installed or the rsyncd service is masked"
    Test = {
        $test1 = rpm -q rsync-daemon
        $test2 = systemctl is-enabled rsync-daemon
        if ($test1 -match "not installed" -or $test2 -match "masked") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.3.1"
    Task = "Ensure telnet client is not installed"
    Test = {
        $test = rpm -q telnet
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.3.2"
    Task = "Ensure LDAP client is not installed"
    Test = {
        $test = rpm -q openldap-clients
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.3.3"
    Task = "Ensure TFTP client is not installed"
    Test = {
        $test = rpm -q tftp
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.3.4"
    Task = "Ensure FTP client is not installed"
    Test = {
        $test = rpm -q ftp
        if ($test -match "not installed") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "2.4"
    Task = "Ensure nonessential services listening on the system are removed or masked"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}


### Chapter 3 - Network Configuration


[AuditTest] @{
    Id = "3.1.1"
    Task = "Ensure IPv6 status is identified"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "3.1.2"
    Task = "Ensure wireless interfaces are disabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_312.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.1.3"
    Task = "Ensure TIPC is disabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_313.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.2.1"
    Task = "Ensure IP forwarding is disabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_321.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.2.2"
    Task = "Ensure packet redirect sending is disabled"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_322_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_322_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "PASS" -and $result2 -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.3.1"
    Task = "Ensure packet redirect sending is disabled"
    Test = {
        $resultScript11 = $scriptPath + "CIS100_RHEL9_331_11.sh"
        $result11 = bash $resultScript11
        $resultScript12 = $scriptPath + "CIS100_RHEL9_331_12.sh"
        $result12 = bash $resultScript12
        $resultScript21 = $scriptPath + "CIS100_RHEL9_331_21.sh"
        $result21 = bash $resultScript21
        $resultScript22 = $scriptPath + "CIS100_RHEL9_331_22.sh"
        $result22 = bash $resultScript22
        if ($IPv6Status -eq "enabled") {
            if ($result21 -match "PASS" -and $result22 -match "PASS") {
                return $retCompliant
            } else {
                return $retNonCompliant
            }
        } else {
            if ($result11 -match "PASS" -and $result12 -match "PASS") {
                return $retCompliant
            } else {
                return $retNonCompliant
            }
        }
    }
}

[AuditTest] @{
    Id = "3.3.2"
    Task = "Ensure ICMP redirects are not accepted"
    Test = {
        $resultScript11 = $scriptPath + "CIS100_RHEL9_332_11.sh"
        $result11 = bash $resultScript11
        $resultScript12 = $scriptPath + "CIS100_RHEL9_332_12.sh"
        $result12 = bash $resultScript12
        $resultScript21 = $scriptPath + "CIS100_RHEL9_332_21.sh"
        $result21 = bash $resultScript21
        $resultScript22 = $scriptPath + "CIS100_RHEL9_332_22.sh"
        $result22 = bash $resultScript22
        if ($IPv6Status -eq "enabled") {
            if ($result21 -match "PASS" -and $result22 -match "PASS") {
                return $retCompliant
            } else {
                return $retNonCompliant
            }
        } else {
            if ($result11 -match "PASS" -and $result12 -match "PASS") {
                return $retCompliant
            } else {
                return $retNonCompliant
            }
        }
    }
}

# 3.3.3 ist identisch mit 3.3.2 ... warum auch immer - wird hier weg gelassen

[AuditTest] @{
    Id = "3.3.4"
    Task = "Ensure suspicious packets are logged"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_334_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_334_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "PASS" -and $result2 -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.3.5"
    Task = "Ensure broadcast ICMP requests are ignored"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_335.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.3.6"
    Task = "Ensure bogus ICMP responses are ignored"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_336.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.3.7"
    Task = "Ensure Reverse Path Filtering is enabled"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_337_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_337_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "PASS" -and $result2 -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.3.8"
    Task = "Ensure TCP SYN Cookies is enabled"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_338.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.3.9"
    Task = "Ensure IPv6 router advertisements are not accepted"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_339_1.sh"
        $resultScript1 = $scriptPath + "CIS100_RHEL9_339_2.sh"
        if ($IPv6Status -match "disabled") {
            return $retCompliantIPv6Disabled
        } else {
            $script1 = bash $resultScript1
            $script2 = bash $resultScript2
            if ($script1 -match "PASS" -and $script2 -match "PASS") {
                return $retCompliant
            } else {
                return $retNonCompliant
            }
        }
    }
}

[AuditTest] @{
    Id = "3.4.1.1"
    Task = "Ensure nftables is installed"
    Test = {
        $result = rpm -q nftables
        if ($result -match "nftables-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.4.1.2"
    Task = "Ensure a single firewall configuration utility is in use"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_3412.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.4.2.1"
    Task = "Ensure firewalld default zone is set"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_3421.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.4.2.2"
    Task = "Ensure at least one nftables table exists"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "3.4.2.3"
    Task = "Ensure nftables base chains exist"
    Test = {
        try{
            $test1 = nft list ruleset | grep 'hook input'
            $test2 = nft list ruleset | grep 'hook forward'
            $test3 = nft list ruleset | grep 'hook output'
            if($test1 -match "type filter hook input" -and $test2 -match "type filter hook forward" -and $test3 -match "type filter hook output"){
                return @{
                    Message = "Compliant"
                    Status = "True"
                }
            }
            return @{
                Message = "Not-Compliant"
                Status = "False"
            }
        }
        catch{
            return @{
                Message = "Command not found!"
                Status = "False"
            }
        }
    }
}

[AuditTest] @{
    Id = "3.4.2.4"
    Task = "Ensure host based firewall loopback traffic is configured"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    l_output="" l_output2=""
    if nft list ruleset | awk '/hook\s+input\s+/,/\}\s*(#.*)?$/' | grep -Pq -- '\H+\h+"lo"\h+accept'; then
        l_output="$l_output\n - Network traffic to the loopback address is correctly set to accept"
    else
        l_output2="$l_output2\n - Network traffic to the loopback address is not set to accept"
    fi
    l_ipsaddr="$(nft list ruleset | awk '/filter_IN_public_deny|hook\s+input\s+/,/\}\s*(#.*)?$/' | grep -P -- 'ip\h+saddr')"
    if grep -Pq -- 'ip\h+saddr\h+127\.0\.0\.0\/8\h+(counter\h+packets\h+\d+\h+bytes\h+\d+\h+)?drop' <<< "$l_ipsaddr" || grep -Pq -- 'ip\h+daddr\h+\!\=\h+127\.0\.0\.1\h+ip\h+saddr\h+127\.0\.0\.1\h+drop' <<< "$l_ipsaddr"; then
        l_output="$l_output\n - IPv4 network traffic from loopback address correctly set to drop"
    else
        l_output2="$l_output2\n - IPv4 network traffic from loopback address not set to drop"
    fi
    if grep -Pq -- '^\h*0\h*$' /sys/module/ipv6/parameters/disable; then
        l_ip6saddr="$(nft list ruleset | awk '/filter_IN_public_deny|hook input/,/}/' | grep 'ip6 saddr')"
        if grep -Pq 'ip6\h+saddr\h+::1\h+(counter\h+packets\h+\d+\h+bytes\h+\d+\h+)?drop' <<< "$l_ip6saddr" || grep -Pq -- 'ip6\h+daddr\h+\!=\h+::1\h+ip6\h+saddr\h+::1\h+drop' <<< "$l_ip6saddr"; then
            l_output="$l_output\n - IPv6 network traffic from loopback address correctly set to drop"
        else
            l_output2="$l_output2\n - IPv6 network traffic from loopback address not set to drop"
        fi
    fi
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n PASS\n$l_output"
    else
        echo -e "\n- Audit Result:\n FAIL\n$l_output2\n\n - Correctly set:\n$l_output"
    fi
}
'@
        $script = bash -c $script_string
        if ($script -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "3.4.2.5"
    Task = "Ensure firewalld drops unnecessary services and ports"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "3.4.2.6"
    Task = "Ensure nftables established connections are configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "3.4.2.7"
    Task = "Ensure nftables default deny firewall policy"
    Test = {
        $result1 = systemctl --quiet is-enabled nftables.service && nft list ruleset | grep 'hook input' | grep -v 'policy drop'
        $result2 = systemctl --quiet is-enabled nftables.service && nft list ruleset | grep 'hook forward' | grep -v 'policy drop'
        if ($result1 -eq $null -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}


### Chapter 4 - Logging and Auditing


[AuditTest] @{
    Id = "4.1.1.1"
    Task = "Ensure auditd is installed"
    Test = {
        $result1 = rpm -q audit
        if ($result1 -match "audit-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.1.2"
    Task = "Ensure auditing for processes that start prior to auditd is enabled"
    Test = {
        $result1 = grubby --info=ALL | grep -Po '\baudit=1\b'
        if ($result1 -match "audit=1") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.1.3"
    Task = "Ensure audit_backlog_limit is sufficient"
    Test = {
        $result1 = grubby --info=ALL | grep -Po "\baudit_backlog_limit=\d+\b"
        if ($result1 -match "audit_backlog_limit=") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.1.4"
    Task = "Ensure auditd service is enabled"
    Test = {
        $result1 = systemctl is-enabled auditd
        if ($result1 -match "enabled") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.2.1"
    Task = "Ensure audit log storage size is configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.1.2.2"
    Task = "Ensure audit logs are not automatically deleted"
    Test = {
        $result1 = grep max_log_file_action /etc/audit/auditd.conf | grep max_log_file_action
        if ($result1 -match "max_log_file_action = keep_logs") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.2.3"
    Task = "Ensure system is disabled when audit logs are full"
    Test = {
        $result1 = grep space_left_action /etc/audit/auditd.conf
        $result2 = grep action_mail_acct /etc/audit/auditd.conf
        $result3 = grep -E 'admin_space_left_action\s*=\s*(halt|single)' /etc/audit/auditd.conf
        if ($result1 -match "space_left_action = email" -and $result2 -match "action_mail_acct = root" -and ($result3 -match "admin_space_left_action = halt" -or $result3 -match "admin_space_left_action = single")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.1"
    Task = "Ensure changes to system administration scope (sudoers) is collected"
    Test = {
        $result1 = awk '/^ *-w/ &&/\/etc\/sudoers/ &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
        $result2 = auditctl -l | awk '/^ *-w/ &&/\/etc\/sudoers/ &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
        if ($result1 -match "-w /etc/sudoers -p wa -k scope" -and $result1 -match "-w /etc/sudoers.d -p wa -k scope" -and $result2 -match "-w /etc/sudoers -p wa -k scope" -and $result2 -match "-w /etc/sudoers.d -p wa -k scope") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.2"
    Task = "Ensure actions as another user are always logged"
    Test = {
        $result1 = awk '/^ *-a *always,exit/ &&/ -F *arch=b[2346]{2}/ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&(/ -C *euid!=uid/||/ -C *uid!=euid/) &&/ -S *execve/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
        $result2 = auditctl -l | awk '/^ *-a *always,exit/ &&/ -F *arch=b[2346]{2}/ &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) &&(/ -C *euid!=uid/||/ -C *uid!=euid/) &&/ -S *execve/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
        if ($result1 -match "-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation" -and $result1 -match "-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation" -and $result2 -match "-a always,exit -F arch=b64 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation" -and $result2 -match "-a always,exit -F arch=b32 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.3"
    Task = "Ensure events that modify the sudo log file are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_4133_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_4133_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-w /var/log/sudo.log -p wa -k sudo_log_file" -and $result2 -match "-w /var/log/sudo.log -p wa -k sudo_log_file") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.4"
    Task = "Ensure events that modify date and time information are collected"
    Test = {
        $script_string1 = @'
    #!/usr/bin/env bash
    {
        awk '/^ *-a *always,exit/ &&/ -F *arch=b[2346]{2}/ &&/ -S/ &&(/adjtimex/ ||/settimeofday/ ||/clock_settime/ ) &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
        awk '/^ *-w/ &&/\/etc\/localtime/ &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
    }
'@
        $script_string2 = @'
#!/usr/bin/env bash
{
    auditctl -l | awk '/^ *-a *always,exit/ &&/ -F *arch=b[2346]{2}/ &&/ -S/ &&(/adjtimex/ ||/settimeofday/ ||/clock_settime/ ) &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
    auditctl -l | awk '/^ *-w/ &&/\/etc\/localtime/ &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}
'@
        $result1 = bash -c $script_string1
        $result2 = bash -c $script_string2
        if ($result1 -match "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -F key=time-change" -and $result1 -match "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change" -and $result1 -match "-w /etc/localtime -p wa -k time-change" -and
            $result2 -match "-w /var/log/sudo.log -p wa -k sudo_log_file" -and $result2 -match "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -F key=time-change" -and $result2 -match "-w /etc/localtime -p wa -k time-change") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.5"
    Task = "Ensure events that modify the system's network environment are collected"
    Test = {
        $script_string1 = @'
    #!/usr/bin/env bash
    {
        awk '/^ *-a *always,exit/ &&/ -F *arch=b(32|64)/ &&/ -S/ &&(/sethostname/ ||/setdomainname/) &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
        awk '/^ *-w/ &&(/\/etc\/issue/ ||/\/etc\/issue.net/ ||/\/etc\/hosts/ ||/\/etc\/sysconfig\/network/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
    }
'@
        $script_string2 = @'
#!/usr/bin/env bash
{
    auditctl -l | awk '/^ *-a *always,exit/ &&/ -F *arch=b(32|64)/ &&/ -S/ &&(/sethostname/ ||/setdomainname/) &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
    auditctl -l | awk '/^ *-w/ &&(/\/etc\/issue/ ||/\/etc\/issue.net/ ||/\/etc\/hosts/ ||/\/etc\/sysconfig\/network/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}
'@
        $result1 = bash -c $script_string1
        $result2 = bash -c $script_string2
        if ($result1 -match "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale" -and $result1 -match "-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale" -and $result1 -match "-w /etc/issue -p wa -k system-locale" -and $result1 -match "-w /etc/issue.net -p wa -k system-locale" -and $result1 -match "-w /etc/hosts -p wa -k system-locale" -and $result1 -match "-w /etc/sysconfig/network -p wa -k system-locale" -and $result1 -match "-w /etc/sysconfig/network-scripts/ -p wa -k system-locale" -and 
            $result2 -match "-a always,exit -F arch=b64 -S sethostname,setdomainname -F key=system-locale" -and $result2 -match "-a always,exit -F arch=b32 -S sethostname,setdomainname -F key=system-locale" -and $result2 -match "-w /etc/issue -p wa -k system-locale" -and $result2 -match "-w /etc/issue.net -p wa -k system-locale" -and $result2 -match "-w /etc/hosts -p wa -k system-locale" -and $result2 -match "-w /etc/sysconfig/network -p wa -k system-locale" -and $result2 -match "-w /etc/sysconfig/network-scripts -p wa -k system-locale") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.6"
    Task = "Ensure use of privileged commands are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_4136_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_4136_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "Warning" -or $result2 -match "Warning") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.7"
    Task = "Ensure unsuccessful file access attempts are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_4137_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_4137_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=unset -k access" -and $result1 -match "-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=unset -k access" -and $result1 -match "-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=unset -k access" -and $result1 -match "-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=unset -k access" -and
            $result2 -match "-a always,exit -F arch=b64 -S open,truncate,ftruncate,creat,openat -F exit=-EACCES -F auid>=1000 -F auid!=-1 -F key=access" -and $result2 -match "-a always,exit -F arch=b64 -S open,truncate,ftruncate,creat,openat -F exit=-EPERM -F auid>=1000 -F auid!=-1 -F key=access" -and $result2 -match "-a always,exit -F arch=b32 -S open,truncate,ftruncate,creat,openat -F exit=-EACCES -F auid>=1000 -F auid!=-1 -F key=access" -and $result2 -match "-a always,exit -F arch=b32 -S open,truncate,ftruncate,creat,openat -F exit=-EPERM -F auid>=1000 -F auid!=-1 -F key=access") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.8"
    Task = "Ensure events that modify user/group information are collected"
    Test = {
        $script_string1 = @'
#!/usr/bin/env bash
{
    awk '/^ *-w/ &&(/\/etc\/group/ ||/\/etc\/passwd/ ||/\/etc\/gshadow/ ||/\/etc\/shadow/ ||/\/etc\/security\/opasswd/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}
'@
        $script_string2 = @'
#!/usr/bin/env bash
{
    auditctl -l | awk '/^ *-w/ &&(/\/etc\/group/ ||/\/etc\/passwd/ ||/\/etc\/gshadow/ ||/\/etc\/shadow/ ||/\/etc\/security\/opasswd/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}
'@
        $result1 = bash -c $script_string1
        $result2 = bash -c $script_string2
        if ($result1 -match "-w /etc/group -p wa -k identity" -and $result1 -match "-w /etc/passwd -p wa -k identity" -and $result1 -match "-w /etc/gshadow -p wa -k identity" -and $result1 -match "-w /etc/shadow -p wa -k identity" -and $result1 -match "-w /etc/security/opasswd -p wa -k identity" -and
            $result2 -match "-w /etc/group -p wa -k identity" -and $result2 -match "-w /etc/passwd -p wa -k identity" -and $result2 -match "-w /etc/gshadow -p wa -k identity" -and $result2 -match "-w /etc/shadow -p wa -k identity" -and $restul2 -match "-w /etc/security/opasswd -p wa -k identity") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.9"
    Task = "Ensure discretionary access control permission modification events are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_4139_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_4139_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod" -and $result1 -match "-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=unset -F key=perm_mod" -and $result1 -match "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod" -and
            $result1 -match "-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=1000 -F auid!=unset -F key=perm_mod" -and $result1 -match "-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod" -and $result1 -match "-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod" -and
            $result2 -match "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -F key=perm_mod" -and $result2 -match "-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=-1 -F key=perm_mod" -and $result2 -match "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -F key=perm_mod" -and
            $result2 -match "-a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=1000 -F auid!=-1 -F key=perm_mod" -and $result2 -match "-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=-1 -F key=perm_mod" -and $result2 -match "-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=-1 -F key=perm_mod") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.10"
    Task = "Ensure successful file system mounts are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41310_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41310_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts" -and $result1 -match "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=unset -k mounts" -and
            $result2 -match "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=-1 -F key=mounts" -and $result2 -match "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=-1 -F key=mounts") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.11"
    Task = "Ensure session initiation information is collected"
    Test = {
        $script_string1 = @'
#!/usr/bin/env bash
{
    awk '/^ *-w/ &&(/\/var\/run\/utmp/ ||/\/var\/log\/wtmp/ ||/\/var\/log\/btmp/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}
'@
        $script_string2 = @'
#!/usr/bin/env bash
{
    auditctl -l | awk '/^ *-w/ &&(/\/var\/run\/utmp/ ||/\/var\/log\/wtmp/ ||/\/var\/log\/btmp/) &&/ +-p *wa/ &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}
'@
        $result1 = bash -c $script_string1
        $result2 = bash -c $script_string2
        if ($result1 -match "-w /var/run/utmp -p wa -k session" -and $result1 -match "-w /var/log/wtmp -p wa -k session" -and $result1 -match "-w /var/log/btmp -p wa -k session" -and
            $result2 -match "-w /var/run/utmp -p wa -k session" -and $result2 -match "-w /var/log/wtmp -p wa -k session" -and $result2 -match "-w /var/log/btmp -p wa -k session") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}


[AuditTest] @{
    Id = "4.1.3.12"
    Task = "Ensure login and logout events are collected"
    Test = {
        $script_string1 = @'
#!/usr/bin/env bash
{
    awk '/^ *-w/ \
    &&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules
}
'@
        $script_string2 = @'
#!/usr/bin/env bash
{
    auditctl -l | awk '/^ *-w/ \
    &&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)'
}
'@
        $result1 = bash -c $script_string1
        $result2 = bash -c $script_string2
        if ($result1 -match "-w /var/log/lastlog -p wa -k logins" -and $result1 -match "-w /var/run/faillock -p wa -k logins" -and
            $result2 -match "-w /var/log/lastlog -p wa -k logins" -and $result2 -match "-w /var/run/faillock -p wa -k logins") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.13"
    Task = "Ensure file deletion events by users are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41313_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41313_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete" -and $result1 -match "-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete" -and
            $result2 -match "-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=1000 -F auid!=-1 -F key=delete" -and $result2 -match "-a always,exit -F arch=b32 -S unlink,rename,unlinkat,renameat -F auid>=1000 -F auid!=-1 -F key=delete") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.14"
    Task = "Ensure events that modify the system's Mandatory Access Controls are collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41314_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41314_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-w /etc/selinux -p wa -k MAC-policy" -and $result1 -match "-w /usr/share/selinux -p wa -k MAC-policy" -and
            $result2 -match "-w /etc/selinux -p wa -k MAC-policy" -and $result2 -match "-w /usr/share/selinux -p wa -k MAC-policy") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.15"
    Task = "Ensure successful and unsuccessful attempts to use the chcon command are recorded"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41315_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41315_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng" -and
            $result2 -match "-a always,exit -S all -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=-1 -F key=perm_chng") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.16"
    Task = "Ensure successful and unsuccessful attempts to use the setfacl command are recorded"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41316_1.sh"
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41316_2.sh"
        $result1 = bash $resultScript1
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng" -and
            $result2 -match "-a always,exit -S all -F path=/usr/bin/setfacl -F perm=x -F auid>=1000 -F auid!=-1 -F key=perm_chng") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.17"
    Task = "Ensure successful and unsuccessful attempts to use the chacl command are recorded"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41317_1.sh"
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41317_2.sh"
        $result1 = bash $resultScript1
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng" -and
            $result2 -match "-a always,exit -S all -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=-1 -F key=perm_chng") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.18"
    Task = "Ensure successful and unsuccessful attempts to use the usermod command are recorded"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41318_1.sh"
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41318_2.sh"
        $result1 = bash $resultScript1
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k usermod" -and
            $result2 -match "-a always,exit -S all -F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=-1 -F key=usermod") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.19"
    Task = "Ensure kernel module loading unloading and modification is collected"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_41319_1.sh"
        $resultScript2 = $scriptPath + "CIS100_RHEL9_41319_2.sh"
        $result1 = bash $resultScript1
        $result2 = bash $resultScript2
        if ($result1 -match "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=1000 -F auid!=unset -k kernel_modules" -and $result1 -match "-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=unset -k kernel_modules" -and
            $result2 -match "-a always,exit -F arch=b64 -S create_module,init_module,delete_module,query_module,finit_module -F auid>=1000 -F auid!=-1 -F key=kernel_modules" -and $result2 -match "-a always,exit -S all -F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=-1 -F key=kernel_modules" -and $result3 -match "OK") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.20"
    Task = "Ensure the audit configuration is immutable"
    Test = {
        $result1 = grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -1
        if ($result1 -match "-e 2") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.3.21"
    Task = "Ensure the running and on disk configuration is the same"
    Test = {
        $result1 = augenrules --check
        if ($result1 -match "/usr/sbin/augenrules: No change") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.1"
    Task = "Ensure audit log files are mode 0640 or less permissive"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_4141.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.2"
    Task = "Ensure only authorized users own audit log files"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_3412.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.3"
    Task = "Ensure only authorized groups are assigned ownership of audit log files"
    Test = {
        $script_string1 = @'
#!/usr/bin/env bash
{
    stat -c "%n %G" "$(dirname $(awk -F"=" '/^\s*log_file\s*=\s*/ {print $2}' /etc/audit/auditd.conf | xargs))"/* | grep -Pv '^\h*\H+\h+(adm|root)\b'
}
'@
        $result1 = bash -c $script_string1
        $result2 = grep -Piw -- '^\h*log_group\h*=\h*(adm|root)\b' /etc/audit/auditd.conf
        if (($result1 -match "log_group = adm" -or $result1 -match "log_group = root") -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.4"
    Task = "Ensure the audit log directory is 0750 or more restrictive"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_4144.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.5"
    Task = "Ensure audit configuration files are 640 or more restrictive"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_4145.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.6"
    Task = "Ensure audit configuration files are owned by root"
    Test = {
        $result1_string = @'
#!/usr/bin/env bash
{
    find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root
}
'@
        $result1 = bash -c $result1_string
        if ($result1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.7"
    Task = "Ensure audit configuration files belong to group root"
    Test = {
        $result1_string = @'
#!/usr/bin/env bash
{
    find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root
}
'@
        $result1 = bash -c $result1_string
        if ($result1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.8"
    Task = "Ensure audit tools are 755 or more restrictive"
    Test = {
        $result1 = stat -c "%n %a" /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules | grep -Pv -- '^\h*\H+\h+([0-7][0,1,4,5][0,1,4,5])\h*$'
        if ($result1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.9"
    Task = "Ensure audit tools are owned by root"
    Test = {
        $result1 = stat -c "%n %U" /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules | grep -Pv -- '^\h*\H+\h+root\h*$'
        if ($result1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.1.4.10"
    Task = "Ensure audit tools belong to group root"
    Test = {
        $result1 = stat -c "%n %a %U %G" /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules | grep -Pv -- '^\h*\H+\h+([0-7][0,1,4,5][0,1,4,5])\h+root\h+root\h*$'
        if ($result1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.1.1"
    Task = "Ensure rsyslog is installed"
    Test = {
        $result1 = rpm -q rsyslog
        if ($result1 -match "rsyslog-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.1.2"
    Task = "Ensure rsyslog service is enabled"
    Test = {
        $result1 = systemctl is-enabled rsyslog
        if ($result1 -match "enabled") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.1.3"
    Task = "Ensure journald is configured to send logs to rsyslog"
    Test = {
        $result1 = grep ^\s*ForwardToSyslog /etc/systemd/journald.conf
        if ($result1 -match "ForwardToSyslog=yes") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.1.4"
    Task = "Ensure journald is configured to send logs to rsyslog"
    Test = {
        $result1 = grep -Ps '^\h*\$FileCreateMode\h+0[0,2,4,6][0,2,4]0\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf
        if ($result1 -match "FileCreateMode 0640") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.1.5"
    Task = "Ensure logging is configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.2.1.6"
    Task = "Ensure rsyslog is configured to send logs to a remote log host"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.2.1.7"
    Task = "Ensure journald is configured to send logs to rsyslog"
    Test = {
        $result1 = grep -Ps -- '^\h*module\(load="imtcp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf
        $result2 = grep -Ps -- '^\h*input\(type="imtcp" port="514"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf
        if ($result1 -eq $null -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.1.1"
    Task = "Ensure journald is configured to send logs to rsyslog"
    Test = {
        $result1 = rpm -q systemd-journal-remote
        if ($result1 -eq "systemd-journal-remote-") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.1.2"
    Task = "Ensure systemd-journal-remote is configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.2.2.1.3"
    Task = "Ensure systemd-journal-remote is enabled"
    Test = {
        $result1 = systemctl is-enabled systemd-journal-upload.service
        if ($result1 -match "enabled") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.1.4"
    Task = "Ensure journald is not configured to receive logs from a remote client"
    Test = {
        $result1 = systemctl is-enabled systemd-journal-remote.socket
        if ($result1 -match "masked") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.2"
    Task = "Ensure journald service is enabled"
    Test = {
        $result1 = systemctl is-enabled systemd-journald.service
        if ($result1 -match "static") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.3"
    Task = "Ensure journald is configured to compress large log files"
    Test = {
        $result1 = grep ^\s*Compress /etc/systemd/journald.conf
        if ($result1 -match "Compress=yes") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.4"
    Task = "Ensure journald is configured to write logfiles to persistent disk"
    Test = {
        $result1 = grep ^\s*Storage /etc/systemd/journald.conf
        if ($result1 -match "Storage=persistent") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.2.2.5"
    Task = "Ensure journald is not configured to send logs to rsyslog"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.2.2.6"
    Task = "Ensure journald log rotation is configured per site policy"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.2.2.7"
    Task = "Ensure journald default file permissions configured"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "4.2.3"
    Task = "Ensure all logfiles have appropriate permissions and ownership"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    echo -e "\n- Start check - logfiles have appropriate permissions and ownership"
    output=""
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    find /var/log -type f | (while read -r fname; do
        bname="$(basename "$fname")"
        fugname="$(stat -Lc "%U %G" "$fname")"
        funame="$(awk '{print $1}' <<< "$fugname")"
        fugroup="$(awk '{print $2}' <<< "$fugname")"
        fuid="$(stat -Lc "%u" "$fname")"
        fmode="$(stat -Lc "%a" "$fname")"
        case "$bname" in lastlog | lastlog.* | wtmp | wtmp.* | wtmp-* | btmp | btmp.* | btmp-*)
            if ! grep -Pq -- '^\h*[0,2,4,6][0,2,4,6][0,4]\h*$' <<< "$fmode"; then
                output="$output\n- File: \"$fname\" mode: \"$fmode\"\n"
            fi
            if ! grep -Pq -- '^\h*root\h+(utmp|root)\h*$' <<< "$fugname"; then
                output="$output\n- File: \"$fname\" ownership: \"$fugname\"\n"
            fi
            ;;
        secure | auth.log | syslog | messages)
            if ! grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$' <<< "$fmode"; then
                output="$output\n- File: \"$fname\" mode: \"$fmode\"\n"
            fi
            if ! grep -Pq -- '^\h*(syslog|root)\h+(adm|root)\h*$' <<< "$fugname"; then
                output="$output\n- File: \"$fname\" ownership: \"$fugname\"\n"
            fi
            ;;
        SSSD | sssd)
            if ! grep -Pq -- '^\h*[0,2,4,6][0,2,4,6]0\h*$' <<< "$fmode"; then
                output="$output\n- File: \"$fname\" mode: \"$fmode\"\n"
            fi
            if ! grep -Piq -- '^\h*(SSSD|root)\h+(SSSD|root)\h*$' <<< "$fugname"; then
                output="$output\n- File: \"$fname\" ownership: \"$fugname\"\n"
            fi
            ;;
        gdm | gdm3)
            if ! grep -Pq -- '^\h*[0,2,4,6][0,2,4,6]0\h*$' <<< "$fmode"; then
                output="$output\n- File: \"$fname\" mode: \"$fmode\"\n"
            fi
            if ! grep -Pq -- '^\h*(root)\h+(gdm3?|root)\h*$' <<< "$fugname"; then
                output="$output\n- File: \"$fname\" ownership: \"$fugname\"\n"
            fi
            ;;
        *.journal | *.journal~)
            if ! grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$' <<< "$fmode"; then
                output="$output\n- File: \"$fname\" mode: \"$fmode\"\n"
            fi
            if ! grep -Pq -- '^\h*(root)\h+(systemd-journal|root)\h*$' <<< "$fugname"; then
                output="$output\n- File: \"$fname\" ownership: \"$fugname\"\n"
            fi
            ;;
        *)  if ! grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$' <<< "$fmode"; then
                output="$output\n- File: \"$fname\" mode: \"$fmode\"\n"
            fi
            if [ "$fuid" -ge "$UID_MIN" ] || ! grep -Pq -- '(adm|root|'"$(id -gn "$funame")"')' <<< "$fugroup"; then
                if [ -n "$(awk -v grp="$fugroup" -F: '$1==grp {print $4}' /etc/group)" ] || ! grep -Pq '(syslog|root)' <<< "$funame"; then
                    output="$output\n- File: \"$fname\" ownership: \"$fugname\"\n"
                fi
            fi
            ;;
        esac
    done # If all files passed, then we pass
    if [ -z "$output" ]; then
        echo -e "\n- Audit Results:\n PASS\n- All files in \"/var/log/\" have appropriate permissions and ownership\n"
    else # print the reason why we are failing
        echo -e "\n- Audit Results:\n FAIL\n$output"
    fi
    echo -e "- End check - logfiles have appropriate permissions and ownership\n"
    )
}
'@
        $script = bash -c $script_string
        if ($script -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "4.3"
    Task = "Ensure logrotate is configured"
    Test = {
        return $retNonCompliantManualReviewRequired
 
    }
}


### Chapter 5 - Access, Authentication and Authorization


[AuditTest] @{
    Id = "5.1.1"
    Task = "Ensure cron daemon is enabled"
    Test = {
        $result1 = systemctl is-enabled crond
        if ($result1 -match "enabled") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.2"
    Task = "Ensure permissions on /etc/crontab are configured"
    Test = {
        $result1 = stat -c "%a" /etc/crontab
        if ($result1 -eq 600 ) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.3"
    Task = "Ensure permissions on /etc/cron.hourly are configured"
    Test = {
        $result1 = stat -c "%a" /etc/cron.hourly
        if ($result1 -eq 700 ) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.4"
    Task = "Ensure permissions on /etc/cron.daily are configured"
    Test = {
        $result1 = stat -c "%a" /etc/cron.daily
        if ($result1 -eq 700 ) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.5"
    Task = "Ensure permissions on /etc/cron.weekly are configured"
    Test = {
        $result1 = stat -c "%a" /etc/cron.weekly
        if ($result1 -eq 700 ) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.6"
    Task = "Ensure permissions on /etc/cron.monthly are configured"
    Test = {
        $result1 = stat -c "%a" /etc/cron.monthly
        if ($result1 -eq 700 ) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.7"
    Task = "Ensure permissions on /etc/cron.d are configured"
    Test = {
        $result1 = stat -c "%a" /etc/cron.d
        if ($result1 -eq 700 ) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.8"
    Task = "Ensure cron is restricted to authorized users"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    if rpm -q cronie >/dev/null; then
        [ -e /etc/cron.deny ] && echo "Fail: cron.deny exists"
        if [ ! -e /etc/cron.allow ]; then
            echo "Fail: cron.allow doesn't exist"
        else
            ! stat -Lc "%a" /etc/cron.allow | grep -Eq "[0,2,4,6]00" && echo "Fail: cron.allow mode too permissive"
            ! stat -Lc "%u:%g" /etc/cron.allow | grep -Eq "^0:0$" && echo "Fail: cron.allow owner and/or group not root"
        fi
        if [ ! -e /etc/cron.deny ] && [ -e /etc/cron.allow ] && stat -Lc "%a" /etc/cron.allow | grep -Eq "[0,2,4,6]00" \ && stat -Lc "%u:%g" /etc/cron.allow | grep -Eq "^0:0$"; then
            echo "Pass"
        fi
    else
        echo "PASS: cron is not installed on the system"
    fi
}
'@
        $script = bash -c $script_string
        if ($script -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.1.9"
    Task = "Ensure at is restricted to authorized users"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    if rpm -q at >/dev/null; then
        [ -e /etc/at.deny ] && echo "Fail: at.deny exists"
        if [ ! -e /etc/at.allow ]; then
            echo "Fail: at.allow doesn't exist"
        else
            ! stat -Lc "%a" /etc/at.allow | grep -Eq "[0,2,4,6]00" && echo "Fail: at.allow mode too permissive"
            ! stat -Lc "%u:%g" /etc/at.allow | grep -Eq "^0:0$" && echo "Fail: at.allow owner and/or group not root"
        fi
        if [ ! -e /etc/at.deny ] && [ -e /etc/at.allow ] && stat -Lc "%a" /etc/at.allow | grep -Eq "[0,2,4,6]00" && stat -Lc "%u:%g" /etc/at.allow | grep -Eq "^0:0$"; then
            echo "PASS"
        fi
    else
        echo "PASS: at is not installed on the system"
    fi
}
'@
        $script = bash -c $script_string
        if ($script -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.1"
    Task = "Ensure permissions on /etc/ssh/sshd_config are configured"
    Test = {
        $result1 = stat -Lc "%n %a %u/%U %g/%G" /etc/ssh/sshd_config
        if ($result1 -match "/etc/ssh/sshd_config 600 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.2"
    Task = "Ensure permissions on SSH private host key files are configured"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_522.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.3"
    Task = "Ensure permissions on SSH public host key files are configured"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_523.sh"
        $result = bash $resultScript
        if ($result -match "PASS") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.4"
    Task = "Ensure SSH access is limited"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$'
        $test2 = grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$' /etc/ssh/sshd_config
        if ($test1 -match "allowusers " -or $test1 -match "allowgroups " -or $test1 -match "denyusers " -or $test1 -match "denygroups " -or
            $test2 -match "allowusers " -or $test2 -match "allowgroups " -or $test2 -match "denyusers " -or $test2 -match "denygroups ") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.5"
    Task = "Ensure SSH LogLevel is appropriate"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$'
        $test2 = grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$' /etc/ssh/sshd_config
        if (($test1 -match "allowusers " -or $test1 -match "allowgroups " -or $test1 -match "denyusers " -or $test1 -match "denygroups ") -and
            ($test2 -match "allowusers " -or $test2 -match "allowgroups " -or $test2 -match "denyusers " -or $test2 -match "denygroups ")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.6"
    Task = "Ensure SSH PAM is enabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i usepam
        $test2 = grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$' /etc/ssh/sshd_config
        if ($test1 -match "usepam yes" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.7"
    Task = "Ensure SSH root login is disabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep permitrootlogin
        $test2 = grep -Ei '^\s*PermitRootLogin\s+yes' /etc/ssh/sshd_config
        if ($test1 -match "permitrootlogin no" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.8"
    Task = "Ensure SSH HostbasedAuthentication is disabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep hostbasedauthentication
        $test2 = grep -Ei '^\s*HostbasedAuthentication\s+yes' /etc/ssh/sshd_config
        if ($test1 -match "permitrootlogin no" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.9"
    Task = "Ensure SSH PermitEmptyPasswords is disabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep permitemptypasswords
        $test2 = grep -Ei '^\s*PermitEmptyPasswords\s+yes' /etc/ssh/sshd_config
        if ($test1 -match "permitemptypasswords no" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.10"
    Task = "Ensure SSH PermitUserEnvironment is disabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep permituserenvironment
        $test2 = grep -Ei '^\s*PermitUserEnvironment\s+yes' /etc/ssh/sshd_config
        if ($test1 -match "permituserenvironment no" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.11"
    Task = "Ensure SSH IgnoreRhosts is enabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep ignorerhosts
        $test2 = grep -Ei '^\s*ignorerhosts\s+no\b' /etc/ssh/sshd_config
        if ($test1 -match "ignorerhosts yes" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.12"
    Task = "Ensure SSH X11 forwarding is disabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i x11forwarding
        $test2 = grep -Ei '^\s*x11forwarding\s+yes' /etc/ssh/sshd_config
        if ($test1 -match "x11forwarding no" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.13"
    Task = "Ensure SSH AllowTcpForwarding is disabled"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i allowtcpforwarding
        $test2 = grep -Ei '^\s*AllowTcpForwarding\s+yes' /etc/ssh/sshd_config
        if ($test1 -match "allowtcpforwarding no" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.14"
    Task = "Ensure system-wide crypto policy is not over-ridden"
    Test = {
        $test = grep -i '^\s*CRYPTO_POLICY=' /etc/sysconfig/sshd
        if ($test -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.15"
    Task = "Ensure SSH warning banner is configured"
    Test = {
        $test = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep banner
        if ($test -match "banner /etc/issue.net") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.16"
    Task = "Ensure SSH MaxAuthTries is set to 4 or less"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep maxauthtries
        $test2 = grep -Ei '^\s*maxauthtries\s+([5-9]|[1-9][0-9]+)' /etc/ssh/sshd_config
        if ($test1 -match "maxauthtries 4" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.17"
    Task = "Ensure SSH MaxStartups is configured"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxstartups
        $test2 = grep -Ei '^\s*maxstartups\s+(((1[1-9]|[1-9][0-9][0-9]+):([0-9]+):([0-9]+))|(([0-9]+):(3[1-9]|[4-9][0-9]|[1-9][0-9][0-9]+):([0-9]+))|(([0-9]+):([0-9]+):(6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+)))' /etc/ssh/sshd_config
        if ($test1 -match "maxstartups 10:30:60" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.18"
    Task = "Ensure SSH MaxSessions is set to 10 or less"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxsessions
        $test2 = grep -Ei '^\s*MaxSessions\s+(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)' /etc/ssh/sshd_config
        if ($test1 -match "maxsessions 10" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.19"
    Task = "Ensure SSH LoginGraceTime is set to one minute or less"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep logingracetime
        $test2 = grep -Ei '^\s*LoginGraceTime\s+(0|6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+|[^1]m)' /etc/ssh/sshd_config
        if ($test1 -match "logingracetime 60" -and $test2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.2.20"
    Task = "Ensure SSH Idle Timeout Interval is configured"
    Test = {
        $test1 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientaliveinterval | cut -d ' ' -f 2
        $test2 = sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientalivecountmax | cut -d ' ' -f 2
        if ($test1 -gt 0 -and $test2 -gt 0) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.1"
    Task = "Ensure SUDO is installed"
    Test = {
        $test = dnf list sudo | grep sudo.x86_64
        if ($test -match "sudo") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.2"
    Task = "Ensure sudo commands use pty"
    Test = {
        $test = grep -rPi '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers*
        if ($test -match "/etc/sudoers:Defaults use_pty") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.3"
    Task = "Ensure sudo log file exists"
    Test = {
        $test = grep -Ei '^\s*Defaults\s+logfile=\S+' /etc/sudoers /etc/sudoers.d/*
        if ($test -match "/etc/sudoers:Defaults use_pty") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.4"
    Task = "Ensure users must provide password for escalation"
    Test = {
        $test = grep -r "^[^#].*NOPASSWD" /etc/sudoers*
        if ($test -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.5"
    Task = "Ensure re-authentication for privilege escalation is not disabled globally"
    Test = {
        $test = grep -r "^[^#].*\!authenticate" /etc/sudoers*
        if ($test -match "!authenticate") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.6"
    Task = "Ensure sudo authentication timeout is configured correctly"
    Test = {
        $test = grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers* | cut -d ' ' -f 2
        if ($test -le 15) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.3.7"
    Task = "Ensure access to the su command is restricted"
    Test = {
        $test1 = grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' /etc/pam.d/su
        if ($test1 -match "auth required pam_wheel.so use_uid group=") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.4.1"
    Task = "Ensure custom authselect profile is used"
    Test = {
        $test1 = authselect list | grep '^-\s*custom'
        if ($test1 -eq $null) {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

# 5.4.2 ist leider schlecht beschrieben, die Pruefung ist mit ihren Parametern bestenfalls mangelhaft
[AuditTest] @{
    Id = "5.4.2"
    Task = "Ensure authselect includes with-faillock"
    Test = {
        $test1 = grep pam_faillock.so /etc/pam.d/password-auth /etc/pam.d/system-auth
        if ($test1 -match "/etc/authselect/password-auth:auth") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.5.1"
    Task = "Ensure password creation requirements are configured"
    Test = {
        $test1 = grep ^minlen /etc/security/pwquality.conf | cut -d '=' -f 2
        if ($test1 -ge 14) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.5.2"
    Task = "Ensure lockout for failed password attempts is configured"
    Test = {
        $test1 = grep -E '^\s*deny\s*=\s*[1-5]\b' /etc/security/faillock.conf | cut -d '=' -f 2
        $test2 = grep -E '^\s*unlock_time\s*=\s*(0|9[0-9][0-9]|[1-9][0-9][0-9][0-9]+)\b' /etc/security/faillock.conf | cut -d '=' -f 2
        if ($test1 -le 5 -and ($test2 -eq 0 -or $test2 -ge 900)) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.5.3"
    Task = "Ensure password reuse is limited"
    Test = {
        $test1 = grep -P '^\h*password\h+(requisite|sufficient)\h+(pam_pwhistory\.so|pam_unix\.so)\h+([^#\n\r]+\h+)?remember=([5-9]|[1-9][0-9]+)\h*(\h+.*)?$' /etc/pam.d/system-auth
        if ($test1 -match "remember=5") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.5.4"
    Task = "Ensure password hashing algorithm is SHA-512 or yescrypt"
    Test = {
        $test1 = grep -Ei '^\s*crypt_style\s*=\s*(sha512|yescrypt)\b' /etc/libuser.conf
        $test2 = grep -Ei '^\s*ENCRYPT_METHOD\s+(SHA512|yescrypt)\b' /etc/login.defs
        if (($test2 -match "ENCRYPT_METHOD SHA512" -or $test2 -match "ENCRYPT_METHOD YESCRYPT") -and ($test1 -match "crypt_style = sha512" -or $test1 -match "crypt_style = yescrypt")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.1.1"
    Task = "Ensure password expiration is 365 days or less"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_5611_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_5611_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -le 365 -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.1.2"
    Task = "Ensure minimum days between password changes is configured"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_5612_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_5612_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -ge 1 -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.1.3"
    Task = "Ensure password expiration warning days is 7 or more"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_5613_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_5613_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "PASS_WARN_AGE\s*7" -and !($result2 -match "FAIL")) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.1.4"
    Task = "Ensure inactive password lock is 30 days or less"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_5614_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_5614_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -ge 2 -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.1.5"
    Task = "Ensure all users last password change date is in the past"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_5615.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.2"
    Task = "Ensure system accounts are secured"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_562_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_562_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -eq $null -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.3"
    Task = "Ensure default user shell timeout is 900 seconds or less"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    output1="" output2=""
    [ -f /etc/bashrc ] && BRC="/etc/bashrc"
    for f in "$BRC" /etc/profile /etc/profile.d/*.sh ; do
        grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' "$f" && grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && output1="$f"
    done
    grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC" && output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh $BRC)
    if [ -n "$output1" ] && [ -z "$output2" ]; then
        echo -e "\nPASSED\n\nTMOUT is configured in: \"$output1\"\n"
    else
        [ -z "$output1" ] && echo -e "\nFAILED\n\nTMOUT is not configured\n" [ -n "$output2" ] && echo -e "\nFAILED\n\nTMOUT is incorrectly configured in: \"$output2\"\n"
    fi
}
'@
        $script = bash -c $script_string
        if ($script -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.4"
    Task = "Ensure default group for the root account is GID 0"
    Test = {
        $test1 = grep "^root:" /etc/passwd | cut -f4 -d ':'
        if ($test1 -eq 0) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.5"
    Task = "Ensure default user shell timeout is 900 seconds or less"
    Test = {
        $resultScript1 = $scriptPath + "CIS100_RHEL9_565_1.sh"
        $result1 = bash $resultScript1
        $resultScript2 = $scriptPath + "CIS100_RHEL9_565_2.sh"
        $result2 = bash $resultScript2
        if ($result1 -match "umask is set" -and $result2 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "5.6.6"
    Task = "Ensure root password is set"
    Test = {
        $test1 = passwd -S root
        if ($test1 -match "Password set") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}


### Chapter 6 - System Maintenance


[AuditTest] @{
    Id = "6.1.1"
    Task = "Ensure permissions on /etc/passwd are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/passwd
        if ($test1 -match "644 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.2"
    Task = "Ensure permissions on /etc/passwd are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/passwd-
        if ($test1 -match "644 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.3"
    Task = "Ensure permissions on /etc/group are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/group
        if ($test1 -match "644 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.4"
    Task = "Ensure permissions on /etc/group- are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/group-
        if ($test1 -match "644 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.5"
    Task = "Ensure permissions on /etc/shadow are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/shadow
        if ($test1 -match "0 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.6"
    Task = "Ensure permissions on /etc/shadow- are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/shadow-
        if ($test1 -match "0 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.7"
    Task = "Ensure permissions on /etc/gshadow are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow
        if ($test1 -match "0 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.7"
    Task = "Ensure permissions on /etc/gshadow are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow
        if ($test1 -match "0 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.8"
    Task = "Ensure permissions on /etc/gshadow- are configured"
    Test = {
        $test1 = stat -Lc "%n %a %u/%U %g/%G" /etc/gshadow-
        if ($test1 -match "0 0/root 0/root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.9"
    Task = "Ensure no world writable files exist"
    Test = {
        $test1 = df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002
        if ($test1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.10"
    Task = "Ensure no unowned files or directories exist"
    Test = {
        $test1 = df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nouser
        if ($test1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.11"
    Task = "Ensure no ungrouped files or directories exist"
    Test = {
        $test1 = df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup
        if ($test1 -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.12"
    Task = "Ensure sticky bit is set on all world-writable directories"
    Test = {
        $test_string = "df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null"
        $test = bash -c $test_string
        if ($test -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.1.13"
    Task = "Audit SUID executables"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "6.1.14"
    Task = "Audit SGID executables"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "6.1.15"
    Task = "Audit system file permissions"
    Test = {
        return $retNonCompliantManualReviewRequired
    }
}

[AuditTest] @{
    Id = "6.2.1"
    Task = "Ensure accounts in /etc/passwd use shadowed passwords"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_621.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.2"
    Task = "Ensure /etc/shadow password fields are not empty"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_622.sh"
        $result = bash $resultScript
        if ($result -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.3"
    Task = "Ensure all groups in /etc/passwd exist in /etc/group"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
        grep -q -P "^.*?:[^:]*:$i:" /etc/group
        if [ $? -ne 0 ]; then
            echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
        fi
    done
}
'@
        $script = bash -c $script_string
        if ($script -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.4"
    Task = "Ensure no duplicate UIDs exist"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do
        [ -z "$x" ] && break
        set - $x
        if [ $1 -gt 1 ]; then
            users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
            echo "Duplicate UID ($2): $users"
        fi
    done
}
'@
        $script = bash -c $script_string
        if ($script -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.5"
    Task = "Ensure no duplicate GIDs exist"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
        echo "Duplicate GID ($x) in /etc/group"
    done
}
'@
        $script = bash -c $script_string
        if ($script -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.6"
    Task = "Ensure no duplicate user names exist"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
        echo "Duplicate login name $x in /etc/passwd"
    done
}
'@
        $script = bash -c $script_string
        if ($script -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.7"
    Task = "Ensure no duplicate group names exist"
    Test = {
        $script_string = @'
#!/usr/bin/env bash
{
    cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
        echo "Duplicate group name $x in /etc/group"
    done
}
'@
        $script = bash -c $script_string
        if ($script -eq $null) {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.8"
    Task = "Ensure root PATH Integrity"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_628.sh"
        $result = bash $resultScript
        if ($result -match "is not a directory") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.9"
    Task = "Ensure root is the only UID 0 account"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_629.sh"
        $result = bash $resultScript
        if ($result -eq "root") {
            return $retCompliant
        } else {
            return $retNonCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.10"
    Task = "Ensure local interactive user home directories exist"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6210.sh"
        $result = bash $resultScript
        if ($result -match "FAILED") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.11"
    Task = "Ensure local interactive users own their home directories"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6210.sh"
        $result = bash $resultScript
        if ($result -match "FAILED") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.12"
    Task = "Ensure local interactive user home directories are mode 750 or more restrictive"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6212.sh"
        $result = bash $resultScript
        if ($result -match "FAILED") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.13"
    Task = "Ensure no local interactive user has .netrc files"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6213.sh"
        $result = bash $resultScript
        if ($result -match "FAILED") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.14"
    Task = "Ensure no local interactive user has .forward files"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6214.sh"
        $result = bash $resultScript
        if ($result -match "FAILED") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.15"
    Task = "Ensure no local interactive user has .rhosts files"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6215.sh"
        $result = bash $resultScript
        if ($result -match "FAILED") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}

[AuditTest] @{
    Id = "6.2.16"
    Task = "Ensure local interactive user dot files are not group or world writable"
    Test = {
        $resultScript = $scriptPath + "CIS100_RHEL9_6216.sh"
        $result = bash $resultScript
        if ($result -match "Failed") {
            return $retNonCompliant
        } else {
            return $retCompliant
        }
    }
}
