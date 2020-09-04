$Logfile = "C:\ProgramData\OCS Inventory NG\Agent\VsphereScan.log"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

#Connect to each vCenter and collect data about VM's
LogWrite("Connecting to the VI instances...");

# Connect to VSphere instances, use Out-Null to prevent connection from disturbing OCS Agent
Connect-VIServer -Server my.awesome.server -Protocol https -User 'ocs_user@my_vsphere_server' -Password 'asecurepassword' | Out-Null

LogWrite("Connected to the VI instances");

# Init empty XML
$xml = "";

LogWrite("Scanning Hosts");

# Collect Host available
Get-VMHost | ForEach-Object {
    LogWrite("Scanning Host : " + $_.Name);
    $xml += "<VSPHEREHOST>"
    $xml += "<HOSTSTATE>" + $_.ConnectionState + "</HOSTSTATE>"
    $xml += "<HOSTCONSTATE>" + $_.ConnectionState + "</HOSTCONSTATE>"
    $xml += "<HOSTPOWSTATE>" + $_.PowerState + "</HOSTPOWSTATE>"
    $xml += "<HOSTSWAPPOLICY>" + $_.VMSwapfilePolicy + "</HOSTSWAPPOLICY>"
    $xml += "<HOSTSTANDALONE>" + $_.IsStandalone + "</HOSTSTANDALONE>"
    $xml += "<HOSTMANUFACTURER>" + $_.Manufacturer + "</HOSTMANUFACTURER>"
    $xml += "<HOSTMODEL>" + $_.Model + "</HOSTMODEL>"
    $xml += "<HOSTCPU>" + $_.NumCpu + "</HOSTCPU>"
    $xml += "<HOSTCPUMHZ>" + $_.CpuTotalMhz + "</HOSTCPUMHZ>"
    $xml += "<HOSTCPUUSAGE>" + $_.CpuUsageMhz + "</HOSTCPUUSAGE>"
    $xml += "<HOSTLICENSEKEY>" + $_.LicenseKey + "</HOSTLICENSEKEY>"
    $xml += "<HOSTMEMORY>" + $_.MemoryTotalGB + "</HOSTMEMORY>"
    $xml += "<HOSTMEMORYUSAGE>" + $_.MemoryUsageGB + "</HOSTMEMORYUSAGE>"
    $xml += "<HOSTCPUTYPE>" + $_.ProcessorType + "</HOSTCPUTYPE>"
    $xml += "<HOSTCPUHT>" + $_.HyperthreadingActive + "</HOSTCPUHT>"
    $xml += "<HOSTTZ>" + $_.TimeZone + "</HOSTTZ>"
    $xml += "<HOSTVERSION>" + $_.Version + "</HOSTVERSION>"
    $xml += "<HOSTBUILD>" + $_.Build + "</HOSTBUILD>"
    $xml += "<HOSTPARENT>" + $_.Parent + "</HOSTPARENT>"
    $xml += "<HOSTSTORAGE>" + $_.StorageInfo + "</HOSTSTORAGE>"
    $xml += "<HOSTNETWORK>" + $_.NetworkInfo + "</HOSTNETWORK>"
    $xml += "<HOSTFIREWALLPOLICY>" + $_.FirewallDefaultPolicy + "</HOSTFIREWALLPOLICY>"
    $xml += "<HOSTEVCMODE>" + $_.MaxEVCMode + "</HOSTEVCMODE>"
    $xml += "<HOSTNAME>" + $_.Name + "</HOSTNAME>"
    $xml += "<HOSTDATASTORELIST></HOSTDATASTORELIST>"
    $xml += "</VSPHEREHOST>";
}

LogWrite("Scanning VMs");

#Collect VM available
Get-VM | ForEach-Object {
    LogWrite("Scanning VM : " + $_.Name);

    $vmguest = $_.Guest
    if($vmguest.Contains(":")){
        $guest =  $vmguest
        $splittedGuest = $guest.Split(":")
        $vmguest = $splittedGuest[1]
    }

    $xml += "<VSPHEREVMS>"
    $xml += "<VMID>" + $_.Id + "</VMID>"
    $xml += "<VMNAME>" + $_.Name + "</VMNAME>"
    $xml += "<VMPOWSTATE>" + $_.PowerState + "</VMPOWSTATE>"
    $xml += "<VMGUEST>" + $vmguest + "</VMGUEST>"
    $xml += "<VMCPUNUM>" + $_.NumCpu + "</VMCPUNUM>"
    $xml += "<VMCPUCORES>" + $_.CoresPerSocket + "</VMCPUCORES>"
    $xml += "<VMMEMORY>" + $_.MemoryMB + "</VMMEMORY>"
    $xml += "<VMHOST>" + $_.VMHost + "</VMHOST>"
    $xml += "<VMVAPP>" + $_.VApp + "</VMVAPP>"
    $xml += "<VMFOLDER>" + $_.Folder + "</VMFOLDER>"
    $xml += "<VMRESPOOL>" + $_.ResourcePool + "</VMRESPOOL>"
    $xml += "<VMHARESTARTPRI>" + $_.HARestartPriority + "</VMHARESTARTPRI>"
    $xml += "<VMHAISOLATIONRESP>" + $_.HAIsolationResponse + "</VMHAISOLATIONRESP>"
    $xml += "<VMDRSLEVEL>" + $_.DrsAutomationLevel + "</VMDRSLEVEL>"
    $xml += "<VMSWAPPOLICY>" + $_.VMSwapfilePolicy + "</VMSWAPPOLICY>"
    $xml += "<VMRESCONFIG>" + $_.VMResourceConfiguration + "</VMRESCONFIG>"
    $xml += "<VMVERSION>" + $_.HardwareVersion + "</VMVERSION>"
    $xml += "<VMHWVERSION>" + $_.HardwareVersion + "</VMHWVERSION>"
    $xml += "<VMUSEDPACE>" + $_.UsedSpaceGB + "</VMUSEDPACE>"
    $xml += "<VMTOTALSPACE>" + $_.ProvisionedSpaceGB + "</VMTOTALSPACE>"
    $xml += "<VMDATASTORE></VMDATASTORE>"
    $xml += "</VSPHEREVMS>";
}

LogWrite("Disconnecting VIServer...");

# Write Output for windows agent retrival
Write-Output $xml