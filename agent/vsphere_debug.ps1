$Logfile = "C:\ProgramData\OCS Inventory NG\Agent\VsphereScan.log"

# Init empty XML
$xml = "";
$result = @();

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

function Get-OCSVsphereXML {

    param (
        $ServerName,
        $User,
        $Pass
    )


    #Connect to each vCenter and collect data about VM's
    LogWrite("Connecting to the VSphere server : " + $ServerName);

    # Connect to VSphere instances, use Out-Null to prevent connection from disturbing OCS Agent
    if(Connect-VIServer -Server $ServerName -Protocol https -User $User -Password $Pass | Out-Null) {

        #Connect to each vCenter and collect data about VM's
        LogWrite("Connected to the VSphere server : " + $ServerName);


        # Collect Host available
        Get-VMHost | ForEach-Object {
            LogWrite("Scanning Host : " + $_.Name);
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
            LogWrite("Scanning VM : " + $_.Name);

            $vmguest = $_.Guest
            #if($vmguest.Contains(":")){
            #    $guest =  $vmguest
            #    $splittedGuest = $guest.Split(":")
            #    $vmguest = $splittedGuest[1]
            #}

            $Script:xml += "<VSPHEREVMS>"
            $Script:xml += "<VMID>" + $_.Id + "</VMID>"
            $Script:xml += "<VMNAME>" + $_.Name + "</VMNAME>"
            $Script:xml += "<VMNOTES>" + $_.Notes + "</VMNOTES>"
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

        LogWrite("Disconnecting from VSphere server : " + $ServerName);

        # Disconnect from the server
        Disconnect-VIServer -confirm:$false | Out-Null

        LogWrite("Disconnected from VSphere server : " + $ServerName);

    } else {
		LogWrite("Failed to connect to VSphere server : " + $ServerName + ". No data will be returned at the end of the script to avoid re writing current data.");
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

# If any of the connections failed, send email and exit script w/o sending xml
if($result -ne 0) {
<#  $results = $result -join ', '
    # Email config
    $From = "sender@domain.com"
    $To = "support@domain.com"
    $Attachment = $Logfile
    $Subject = "OCS Vsphere plugin - Email alert - Failed connection(s)"
    $Body = "VCenter(s) : " + $results + " could not be reached. Nothing returned to avoid repopulating database with incomplete data."
    $SMTPServer = "smtp.domain.com"
    $SMTPPort = "587"

    # Send email including logfile
	$SMTPMessage = New-Object System.Net.Mail.MailMessage($From,$To,$Subject,$Body)
	$attachment = New-Object System.Net.Mail.Attachment($Attachment)
	$SMTPMessage.Attachments.Add($attachment)
	$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
	$SMTPClient.EnableSsl = $true
	$SMTPClient.Credentials = New-Object System.Net.NetworkCredential('sender@domain.com', 'password');
	$SMTPClient.Send($SMTPMessage) #>

    # Exit now
    Exit
}

# Write Output for windows agent retrival
Write-Output $xml