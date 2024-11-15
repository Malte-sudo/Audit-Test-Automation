$RootPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$RootPath = Split-Path $RootPath -Parent
. "$RootPath\Helpers\AuditGroupFunctions.ps1"
[AuditTest] @{
    Id = "SBD-501"
	Task = "Ensure Windows Defender Application Control (WDAC) is available."
	Test = {
        # check newer than win10
        $osVersion = (Get-CimInstance Win32_OperatingSystem).Version
        # check whether system is server version 16 or newer
        $windowsServerVersions = @(
            "Windows Server 2016",
            "Windows Server 2019",
            "Windows Server 2022"
        )
        $isServer2016newer = $windowsServerVersions -contains $os
        if( $osVersion -ge '10.0.0.0' -or $isServer2016newer -eq $true){
            return @{
                Message = "Your device supports WDAC."
                Status = "True"
            }
        }
        return @{
            Message = "Only supported on Windows 10 and newer, as well as Windows Server 2016 and newer."
            Status = "None"
        }
	}
}
[AuditTest] @{
	Id = "SBD-502"
	Task = "Ensure Windows Defender Application ID Service is running."
	Test = {
        try{
            if((Get-Service -Name APPIDSvc -ErrorAction Stop).Status -eq "Running"){
                return @{
                    Message = "Compliant"
                    Status = "True"
                }
            }
            return @{
                Message = "AppLocker is not running. Currently: $((Get-Service -Name APPIDSvc -ErrorAction Stop).Status)"
                Status = "False"
            }
        }
        catch [System.SystemException]{
            return @{
                Message = "Service not found!"
                Status = "False"
            }
        }
	}
}
# [AuditTest] @{ Check for executable rules - windows installer rules - script rules - packaged app rules
# 	Id = "SBD-042"
# 	Task = "Ensure Windows Defender Application ID Service is running."
# 	Test = {
#         if((Get-Service -Name APPIDSvc).Status -eq "Running"){
#             return @{
#                 Message = "Compliant"
#                 Status = "True"
#             }
#         }
#         return @{
#             Message = "AppLocker is not running. Currently: $((Get-Service -Name APPIDSvc).Status)"
#             Status = "False"
#         }
# 	}
# }
