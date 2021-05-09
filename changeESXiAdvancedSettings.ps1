#Author: Mallikarjun Immadi
#Website: https://www.vpxd.in

##########################################
#Defining Functions
##########################################

function Get-AdvancedSystemSetting{ param( [Parameter(Mandatory=$true,ValueFromPipeline=$true)] [VMware.VimAutomation.ViCore.Impl.V1.VIObjectImpl]$cluster, [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [String[]]$advSetting ) Get-Cluster $cluster | Get-VMHost | Where {$_.ConnectionState -notlike "notresponding"}| Get-AdvancedSetting -Name $advSetting| select entity,name,value | ft -AutoSize }

function Set-AdvancedSystemSetting{ param( [Parameter(Mandatory=$true,ValueFromPipeline=$true)] [VMware.VimAutomation.ViCore.Impl.V1.VIObjectImpl]$cluster, [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [String[]]$advSetting, [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()]$advValue )

$esxHosts= Get-Cluster $cluster | Get-VMHost | Where {$_.ConnectionState -notlike "notresponding"}
Write-Host "Applying Configuration Changes" -ForegroundColor Yellow
foreach ($esx in $esxHosts) { Get-AdvancedSetting -Entity $esx -Name $advSetting | where {$_.Value -notlike $advValue} |Set-AdvancedSetting -Value $advValue -Confirm:$false } Write-Host Write-Host "Values after configuration changes" -ForegroundColor Green Get-Cluster $cluster | Get-AdvancedSystemSetting -advSetting $advSetting
}

###############################################
#Working with the defined functions
###############################################

#Defining Variables
$cluster = 'Standalone-Cluster'
$advSetting = 'Vpx.Vpxa.config.workingDir'
$advValue = '/var/log/vmware/vpx'

#Get the current configured values
Get-Cluster $cluster | Get-AdvancedSystemSetting -advSetting $advSetting

#Change the values to desired ones if configured values doesn't match with desired ones (Set-AdvancedSystemSetting function will compare the configured value with the desired one).
Get-Cluster $cluster | Set-AdvancedSystemSetting -advSetting $advSetting -advValue $advValue