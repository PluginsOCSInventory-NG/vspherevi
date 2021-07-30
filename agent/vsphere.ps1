function Get-OCSVsphereXML {

    param (
        $ServerName,
        $User,
        $Pass
    )

    # Connect to VSphere instances, use Out-Null to prevent connection from disturbing OCS Agent
    Connect-VIServer -Server $ServerName -Protocol https -User $User -Password $Pass | Out-Null

    # Init empty XML
    $xml = "";

    # Collect Host available
    Get-VMHost | ForEach-Object {
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
        $xml += "<HOSTPARENT>" + $ServerName + " - "+ $_.Parent + "</HOSTPARENT>"
        $xml += "<HOSTSTORAGE>" + $_.StorageInfo + "</HOSTSTORAGE>"
        $xml += "<HOSTNETWORK>" + $_.NetworkInfo + "</HOSTNETWORK>"
        $xml += "<HOSTFIREWALLPOLICY>" + $_.FirewallDefaultPolicy + "</HOSTFIREWALLPOLICY>"
        $xml += "<HOSTEVCMODE>" + $_.MaxEVCMode + "</HOSTEVCMODE>"
        $xml += "<HOSTNAME>" + $_.Name + "</HOSTNAME>"
        $xml += "<HOSTDATASTORELIST></HOSTDATASTORELIST>"
        $xml += "</VSPHEREHOST>";
    }

    #Collect VM available
    Get-VM | ForEach-Object {

        $vmguest = $_.Guest
        #if($vmguest.Contains(":")){
        #    $guest =  $vmguest
        #    $splittedGuest = $guest.Split(":")
        #    $vmguest = $splittedGuest[1]
        #}

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

    # Write Output for windows agent retrival
    Write-Output $xml

    # Disconnect from the server
    Disconnect-VIServer -confirm:$false | Out-Null

}

# Connection list Array
$connArray = @()
$connArray += [PSCustomObject]@{ServerName = "myfirst.awesome.server"; User = 'ocs_user_one@my_vsphere_server'; Pass = 'asecurepassword' }
$connArray += [PSCustomObject]@{ServerName = "mysnd.awesome.server"; User = 'ocs_user_snd@my_vsphere_server'; Pass = 'asecurepassword' }

foreach ($connection in $connArray) {
    Get-OCSVsphereXML -ServerName $connection.ServerName -User $connection.User -Pass $connection.Pass
}