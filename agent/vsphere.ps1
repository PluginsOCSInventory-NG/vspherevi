# Init empty XML
$xml = "";
$result = @();

function Get-OCSVsphereXML {

    param (
        $ServerName,
        $User,
        $Pass
    )

    # Connect to VSphere instances, use Out-Null to prevent connection from disturbing OCS Agent
    if(Connect-VIServer -Server $ServerName -Protocol https -User $User -Password $Pass | Out-Null) {

        # Collect Host available
        Get-VMHost | ForEach-Object {
            $Script:xml += "<VSPHEREHOST>"
            $Script:xml += "<HOSTSTATE>" + $_.ConnectionState + "</HOSTSTATE>"
            $Script:xml += "<HOSTCONSTATE>" + $_.ConnectionState + "</HOSTCONSTATE>"
            $Script:xml += "<HOSTPOWSTATE>" + $_.PowerState + "</HOSTPOWSTATE>"
            $Script:xml += "<HOSTSWAPPOLICY>" + $_.VMSwapfilePolicy + "</HOSTSWAPPOLICY>"
            $Script:xml += "<HOSTSTANDALONE>" + $_.IsStandalone + "</HOSTSTANDALONE>"
            $Script:xml += "<HOSTMANUFACTURER>" + $_.Manufacturer + "</HOSTMANUFACTURER>"
            $Script:xml += "<HOSTMODEL>" + $_.Model + "</HOSTMODEL>"
            $Script:xml += "<HOSTCPU>" + $_.NumCpu + "</HOSTCPU>"
            $Script:xml += "<HOSTCPUMHZ>" + $_.CpuTotalMhz + "</HOSTCPUMHZ>"
            $Script:xml += "<HOSTCPUUSAGE>" + $_.CpuUsageMhz + "</HOSTCPUUSAGE>"
            $Script:xml += "<HOSTLICENSEKEY>" + $_.LicenseKey + "</HOSTLICENSEKEY>"
            $Script:xml += "<HOSTMEMORY>" + $_.MemoryTotalGB + "</HOSTMEMORY>"
            $Script:xml += "<HOSTMEMORYUSAGE>" + $_.MemoryUsageGB + "</HOSTMEMORYUSAGE>"
            $Script:xml += "<HOSTCPUTYPE>" + $_.ProcessorType + "</HOSTCPUTYPE>"
            $Script:xml += "<HOSTCPUHT>" + $_.HyperthreadingActive + "</HOSTCPUHT>"
            $Script:xml += "<HOSTTZ>" + $_.TimeZone + "</HOSTTZ>"
            $Script:xml += "<HOSTVERSION>" + $_.Version + "</HOSTVERSION>"
            $Script:xml += "<HOSTBUILD>" + $_.Build + "</HOSTBUILD>"
            $Script:xml += "<HOSTPARENT>" + $ServerName + " - "+ $_.Parent + "</HOSTPARENT>"
            $Script:xml += "<HOSTSTORAGE>" + $_.StorageInfo + "</HOSTSTORAGE>"
            $Script:xml += "<HOSTNETWORK>" + $_.NetworkInfo + "</HOSTNETWORK>"
            $Script:xml += "<HOSTFIREWALLPOLICY>" + $_.FirewallDefaultPolicy + "</HOSTFIREWALLPOLICY>"
            $Script:xml += "<HOSTEVCMODE>" + $_.MaxEVCMode + "</HOSTEVCMODE>"
            $Script:xml += "<HOSTNAME>" + $_.Name + "</HOSTNAME>"
            $Script:xml += "<HOSTDATASTORELIST></HOSTDATASTORELIST>"
            $Script:xml += "</VSPHEREHOST>";
        }

        #Collect VM available
        Get-VM | ForEach-Object {

            $vmguest = $_.Guest
            #if($vmguest.Contains(":")){
            #    $guest =  $vmguest
            #    $splittedGuest = $guest.Split(":")
            #    $vmguest = $splittedGuest[1]
            #}

            $Script:xml += "<VSPHEREVMS>"
            $Script:xml += "<VMID>" + $_.Id + "</VMID>"
            $Script:xml += "<VMNAME>" + $_.Name + "</VMNAME>"
            $Script:xml += "<VMPOWSTATE>" + $_.PowerState + "</VMPOWSTATE>"
            $Script:xml += "<VMGUEST>" + $vmguest + "</VMGUEST>"
            $Script:xml += "<VMCPUNUM>" + $_.NumCpu + "</VMCPUNUM>"
            $Script:xml += "<VMCPUCORES>" + $_.CoresPerSocket + "</VMCPUCORES>"
            $Script:xml += "<VMMEMORY>" + $_.MemoryMB + "</VMMEMORY>"
            $Script:xml += "<VMHOST>" + $_.VMHost + "</VMHOST>"
            $Script:xml += "<VMVAPP>" + $_.VApp + "</VMVAPP>"
            $Script:xml += "<VMFOLDER>" + $_.Folder + "</VMFOLDER>"
            $Script:xml += "<VMRESPOOL>" + $_.ResourcePool + "</VMRESPOOL>"
            $Script:xml += "<VMHARESTARTPRI>" + $_.HARestartPriority + "</VMHARESTARTPRI>"
            $Script:xml += "<VMHAISOLATIONRESP>" + $_.HAIsolationResponse + "</VMHAISOLATIONRESP>"
            $Script:xml += "<VMDRSLEVEL>" + $_.DrsAutomationLevel + "</VMDRSLEVEL>"
            $Script:xml += "<VMSWAPPOLICY>" + $_.VMSwapfilePolicy + "</VMSWAPPOLICY>"
            $Script:xml += "<VMRESCONFIG>" + $_.VMResourceConfiguration + "</VMRESCONFIG>"
            $Script:xml += "<VMVERSION>" + $_.HardwareVersion + "</VMVERSION>"
            $Script:xml += "<VMHWVERSION>" + $_.HardwareVersion + "</VMHWVERSION>"
            $Script:xml += "<VMUSEDPACE>" + $_.UsedSpaceGB + "</VMUSEDPACE>"
            $Script:xml += "<VMTOTALSPACE>" + $_.ProvisionedSpaceGB + "</VMTOTALSPACE>"
            $Script:xml += "<VMDATASTORE></VMDATASTORE>"
            $Script:xml += "</VSPHEREVMS>";
        }



        # Disconnect from the server
        Disconnect-VIServer -confirm:$false | Out-Null
        
    } else {
        return $ServerName
    }

}

# Connection list Array
$connArray = @()
$connArray += [PSCustomObject]@{ServerName = "myfirst.awesome.server"; User = 'ocs_user_one@my_vsphere_server'; Pass = 'asecurepassword' }
$connArray += [PSCustomObject]@{ServerName = "mysnd.awesome.server"; User = 'ocs_user_snd@my_vsphere_server'; Pass = 'asecurepassword' }

foreach ($connection in $connArray) {
    # $result stores unreachable server's names
    $result += Get-OCSVsphereXML -ServerName $connection.ServerName -User $connection.User -Pass $connection.Pass
}

# If any of the connections failed, exit script w/o sending xml
if($result -ne 0) {
    Exit
}

# Write Output for windows agent retrival
Write-Output $xml