$RootPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$RootPath = Split-Path $RootPath -Parent
. "$RootPath\Helpers\AuditGroupFunctions.ps1"
$listOfWeakCipherSuites = getListOfWeakCipherSuites
$listOfInsecureCipherSuites = getListOfInsecureCipherSuites
[AuditTest] @{
	Id = "SBD-401"
	Task = "Ensure system is configured to deny remote access via Terminal Services."
	Test = {
		$value = (Get-ItemProperty -path "HKLM:\System\CurrentControlSet\Control\Terminal Server").fDenyTSConnections
        if($value -eq 1){
            return @{
                Message = "Compliant"
                Status = "True"
            }
        }
        return @{
            Message = "System is not configured to deny remote access via Terminal Services."
            Status = "False"
        }
	}
}
[AuditTest] @{
	Id = "SBD-402"
	Task = "Ensure system is configured to prevent RDP service."
	Test = {
		$value = (Get-ItemProperty -path "HKLM:\System\CurrentControlSet\Control\Terminal Server").AllowRemoteRPC
        if($value -eq 0){
            return @{
                Message = "Compliant"
                Status = "True"
            }
        }
        return @{
            Message = "System is not configured to prevent RDP service."
            Status = "False"
        }
	}
}
[AuditTest] @{
	Id = "SBD-403"
	Task = "Ensure NTLM Session Server Security settings are configured."
	Test = {
		$value = (Get-ItemProperty -path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0').NtlmMinServerSec
        if($value -eq 537395200){
            return @{
                Message = "Compliant"
                Status = "True"
            }
        }
        return @{
            Message = "NTLM Session Server Security settings are configured. Currently: $($value)"
            Status = "False"
        }
	}
}
[AuditTest] @{
	Id = "SBD-404"
	Task = "Ensure WinFW Service is running."
	Test = {
        try{
            $value = (Get-Service WinRM -ErrorAction Stop).status
            if($value -eq "Running"){
                return @{
                    Message = "Compliant"
                    Status = "True"
                }
            }
        }
        catch [System.SystemException]{
            return @{
                Message = "Service not found!"
                Status = "False"
            }
        }
        return @{
            Message = "WinFW Service is not running. Currently: $($value)"
            Status = "False"
        }
	}
}
[AuditTest] @{
    Id = "SBD-405"
    Task = "Ensure NetBIOS is set to 'Disabled' for all active Network cards."
    Test = {
        try{
            $networkCards = Get-WmiObject win32_networkadapterconfiguration -filter 'IPEnabled=true' | select Description, TcpipNetBIOSOptions
            $nonCompliantCards = @()
            
            for($i = 0; $i -lt $networkCards.Count; $i++){
                 if($networkCards[$i].TcpipNetBIOSOptions -ne 0){
                        $nonCompliantCards += $networkCards[$i]
                 }
            }
            
            if($nonCompliantCards.Count -eq 0){
                return @{
                    Message = "Compliant"
                    Status = "True"
                }
            }
            if($nonCompliantCards.Count -eq $networkCards.Count){
                return @{
                    Message = "All network cards have NETBIOS enabled."
                    Status = "False"
                }
            }
            $message = "Following network cards have NETBIOS enabled: " + $nonCompliantCards.Description
            return @{
                Message = $message
                Status = "Warning"
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Value not found."
                Status = "Error"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Value not found."
                Status = "Error"
            }
        }
    }
}
[AuditTest] @{
	Id = "SBD-406"
	Task = "Ensure SMBv1 is set to 'Disabled'."
	Test = {
		$value = (Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol).State
        if($value -eq "Disabled"){
            return @{
                Message = "Compliant"
                Status = "True"
            }
        }
        return @{
            Message = "SMBv1 is Enabled."
            Status = "False"
        }
	}
}

[AuditTest] @{
    Id = "SBD-407"
    Task = "Disable SSLv2 Protocol (Server)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-408"
    Task = "Disable SSLv2 Protocol (Server DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-409"
    Task = "Disable SSLv2 Protocol (Client)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-410"
    Task = "Disable SSLv2 Protocol (Client DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-411"
    Task = "Disable SSLv3 Protocol (Server)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-412"
    Task = "Disable SSLv3 Protocol (Server DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-413"
    Task = "Disable SSLv3 Protocol (Client)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-414"
    Task = "Disable SSLv3 Protocol (Client DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-415"
    Task = "Disable TLS1.0 Protocol (Server)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-416"
    Task = "Disable TLS1.0 Protocol (Server DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-417"
    Task = "Disable TLS1.0 Protocol (Client)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-418"
    Task = "Disable TLS1.0 Protocol (Client DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-419"
    Task = "Disable TLS1.1 Protocol (Server)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-420"
    Task = "Disable TLS1.1 Protocol (Server DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-421"
    Task = "Disable TLS1.1 Protocol (Client)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-422"
    Task = "Disable TLS1.1 Protocol (Client DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-423"
    Task = "Enable TLS1.2 Protocol (Server)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -eq 4294967295) {
                return @{
                    Message = "The current registry value is '$regValue', which is no longer supported by Microsoft. For more information, please refer to this link:<br/>"`
                    +'<a href="https://learn.microsoft.com/en-us/windows-server/security/tls/tls-registry-settings?tabs=diffie-hellman#tls-dtls-and-ssl-protocol-version-settings">'`
                    +'Learn.microsoft.com - TLS, DTLS, and SSL protocol version settings<a/>'
                    Status = "False"
                }
            }
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-424"
    Task = "Enable TLS1.2 Protocol (Server Default)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-425"
    Task = "Enable TLS1.2 Protocol (Client)"
    Test = {
        $OS = Get-CimInstance Win32_OperatingSystem | Select-Object Caption
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"

            if ($regValue -eq 4294967295) {
                return @{
                    Message = "The current registry value is '$regValue', which is no longer supported by Microsoft. For more information, please refer to this link:<br/>"`
                    +'<a href="https://learn.microsoft.com/en-us/windows-server/security/tls/tls-registry-settings?tabs=diffie-hellman#tls-dtls-and-ssl-protocol-version-settings">'`
                    +'Learn.microsoft.com - TLS, DTLS, and SSL protocol version settings<a/>'
                    Status = "False"
                }
            }
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            if($OS -match "Server 2022" -or $OS -match "Windows 11"){
                return @{
                    Message = "Compliant"
                    Status = "True"
                }
            }
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            if($OS -match "Server 2022" -or $OS -match "Windows 11"){
                return @{
                    Message = "Compliant"
                    Status = "True"
                }
            }
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-426"
    Task = "Enable TLS1.2 Protocol (Client DisabledByDefault)"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" `
                -Name "DisabledByDefault" `
                | Select-Object -ExpandProperty "DisabledByDefault"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-427"
    Task = "Disable NULL Cipher"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-428"
    Task = "Disable DES Cipher Suite"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-429"
    Task = "Disable RC4 Cipher Suite - 40/128"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-430"
    Task = "Disable RC4 Cipher Suite - 56/128"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-431"
    Task = "Disable RC4 Cipher Suite - 64/128"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-432"
    Task = "Disable RC4 Cipher Suite - 128/128"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-433"
    Task = "Disable AES 128/128 Cipher Suite"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128/128" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-434"
    Task = "Enable AES 256/256 Cipher Suite"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256/256" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -eq 4294967295) {
                return @{
                    Message = "The current registry value is '$regValue', which is no longer supported by Microsoft. For more information, please refer to this link:<br/>"`
                    +'<a href="https://learn.microsoft.com/en-us/windows-server/security/tls/tls-registry-settings?tabs=diffie-hellman#tls-dtls-and-ssl-protocol-version-settings">'`
                    +'Learn.microsoft.com - TLS, DTLS, and SSL protocol version settings<a/>'
                    Status = "False"
                }
            }
            if ($regValue -ne 1) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 1"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-435"
    Task = "Disable Triple DES Cipher Suite"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-436"
    Task = "Disable SHA-1 hash"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-437"
    Task = "Disable MD5 hash"
    Test = {
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
                -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5" `
                -Name "Enabled" `
                | Select-Object -ExpandProperty "Enabled"
        
            if ($regValue -ne 0) {
                return @{
                    Message = "Registry value is '$regValue'. Expected: 0"
                    Status = "False"
                }
            }
        }
        catch [System.Management.Automation.PSArgumentException] {
            return @{
                Message = "Registry value not found."
                Status = "False"
            }
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            return @{
                Message = "Registry key not found."
                Status = "False"
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
[AuditTest] @{
    Id = "SBD-438"
    Task = "Configure Cipher Suite Ordering"
    Test = {
        #check if correct type 
        $typeTable = @{
            "String" = "String Value"
            "Byte" = "Byte Value"
            "Int32" = "DWORD (32-bit) Value"
            "Int64" = "QWORD (64-bit) Value"
            "String[]" = "Multi-String Value"
        }
        #Default status
        $status = "Error"
    
        #Output
        $verbInsecure = "rules have"
        $verbWeak = "rules have"
    
        try {
            $regValue = Get-ItemProperty -ErrorAction Stop `
            -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" `
            -Name "Functions"
            $reference = "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"
            $res = $regValue.Functions.GetType().Name
    
    
            $currentType = $typeTable[$res]
            if ($res -ne [String]) {
                return @{  
                    Message = "Wrong Registry type! Registry type is '$currentType'. Expected: 'String Value'"
                    Status = "False"
                }
            }
    
            #check if insecure or weak cipher is inside value
            $regValues = $regValue.Split(',')
            $regValues = $regValues -replace ' ', ''
            $weakRulesFound = @()
            $insecureRulesFound = @()
            foreach($element in $regValues){
                if($listOfWeakCipherSuites.Contains($element)){
                    $weakRulesFound += $element
                }
                if($listOfInsecureCipherSuites.Contains($element)){
                    $insecureRulesFound += $element
                }
            }
            if($insecureRulesFound.Count -eq 1){$verbInsecure = "rule has"}
            if($weakRulesFound.Count -eq 1){$verbWeak = "rule has"}
            $insecureMessage = "$($insecureRulesFound.Count) insecure $($verbInsecure) been found! List of insecure rules: <br/>"
            $weakMessage = "$($weakRulesFound.Count) weak $($verbWeak) been found! List of weak rules: <br/>"
    
            #Preparing message
            foreach($member in $weakRulesFound){
                $status = "Warning"
                $weakMessage += "$($member)<br/>"
            }          
            foreach($member in $insecureRulesFound){
                $status = "False"
                $insecureMessage += "$($member)<br/>"
            }          
            #Combine or shorten message
            if($insecureRulesFound.Count -gt 0 -or $weakRulesFound.Count -gt 0){
                $message = ""
                if($weakRulesFound.Count -eq 0){ $weakMessage = "" }
                if($insecureRulesFound.Count -eq 0){ $insecureMessage = "" }
    
                $message = $insecureMessage + $weakMessage
                return @{
                    Message = $message
                    Status = $status
                }
            }
        }
        catch {
            $regValue = Get-ItemProperty -ErrorAction Stop `
            -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002" `
            -Name "Functions"
            $reference = "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"
            $res = $regValue.Functions.GetType().Name
    
            $currentType = $typeTable[$res]
            if ($res -ne [String[]]) {
                return @{  
                    Message = "Wrong Registry type! Registry type is '$currentType'. Expected: 'Multi-String Value'"
                    Status = "False"
                }
            }
    
            #check if insecure or weak cipher is inside value
            $regValues = $regValue -replace ' ', ''
            $weakRulesFound = @()
            $insecureRulesFound = @()
            foreach($element in $regValues){
                if($listOfWeakCipherSuites.Contains($element)){
                    $weakRulesFound += $element
                }
                if($listOfInsecureCipherSuites.Contains($element)){
                    $insecureRulesFound += $element
                }
            }
            if($insecureRulesFound.Count -eq 1){$verbInsecure = "rule has"}
            if($weakRulesFound.Count -eq 1){$verbWeak = "rule has"}
            $insecureMessage = "$($insecureRulesFound.Count) insecure $($verbInsecure) been found! List of insecure rules: <br/>"
            $weakMessage = "$($weakRulesFound.Count) weak $($verbWeak) been found! List of weak rules: <br/>"
    
            #Preparing message
            foreach($member in $weakRulesFound){
                $status = "Warning"
                $weakMessage += "$($member)<br/>"
            }          
            foreach($member in $insecureRulesFound){
                $status = "False"
                $insecureMessage += "$($member)<br/>"
            }          
            #Combine or shorten message
            if($insecureRulesFound.Count -gt 0 -or $weakRulesFound.Count -gt 0){
                $message = ""
                if($weakRulesFound.Count -eq 0){ $weakMessage = "" }
                if($insecureRulesFound.Count -eq 0){ $insecureMessage = "" }
    
                $message = $insecureMessage + $weakMessage
                return @{
                    Message = $message
                    Status = $status
                }
            }
        }
        
        return @{
            Message = "Compliant"
            Status = "True"
        }
    }
}
