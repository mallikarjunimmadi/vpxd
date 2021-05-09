$vCenterServer = Read-Host "Enter vCenter Server FQDN or IP Address"
Connect-VIserver $vCenterServer
$esxHosts= Get-Cluster "Standalone-Cluster" | Get-VMHost
foreach ($esx in $esxHosts) { Get-AdvancedSetting -Entity $esx -Name NFS.MaxQueueDepth | Set-AdvancedSetting -Value '64' -Confirm:$false }