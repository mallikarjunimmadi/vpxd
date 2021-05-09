#Author: Mallikarjun Immadi
#https://www.vpxd.in
$vCenterServer = Read-Host "Enter vCenter Server FQDN or IP Address"
Connect-VIServer $vCenterServer
$datetime=Get-Date -format "MMddyyyy-HHmmss"
$outFilePath="C:\Users\mallikarjun\Documents\qfle3fDriverInfo-$datetime.csv"
$ehosts = (Get-VMHost).Name | where {($_.ConnectionState -notlike "notresponding")}
Write-Output "HostName,AcceptanceLevel,CreationDate,ID,InstallDate,Name,Status,Vendor,Version" | Out-File $outFilePath
foreach($ehost in $ehosts) {
$esxcli = Get-ESXCli -VMHost $ehost
$vibInfo = $esxcli.software.vib.list()
	foreach ($info in $vibInfo) {
		if($info.name -contains "qfle3f") {
			$ehost + "," + $info.AcceptanceLevel + "," + $info.CreationDate+ "," + $info.ID+ "," + $info.InstallDate +"," + $info.Name+"," + $info.Status +"," + $info.Vendor+"," + $info.Version|Out-File $outFilePath -Append
		}
	}

}
