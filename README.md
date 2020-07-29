# Vsphere VI

Retrive Vsphere hosts and VM Instances using VMWare's powershell tools

## Webconsole and communication server setup 

You can install the plugin using the classic way of installing OCS Plugins : 
* https://wiki.ocsinventory-ng.org/10.Plugin-engine/Using-plugins-installer/

## Prerequisites 

PowerCLI Configuration : 
```
Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCEIP $false
Set-PowerCLIConfiguration -Scope AllUsers -WebOperationTimeoutSeconds 300
Set-PowerCLIConfiguration -Scope AllUsers -DisplayDeprecationWarnings $false
Set-PowerCLIConfiguration -Scope AllUsers -DefaultVIServerMode "Multiple"
```

## Install the agent file

To install the agent file, please put the powershell script in the plugins folder of the agent.

For this plugin there is two variants available : 
* vsphere.ps1
* vsphere_debug.ps1

The latter will create log file in "%programdata%/OCS Inventory NG/Agent/" called VsphereScan.log and will debug most of the query, values processed by the plugin.
You will have to ensure that the Windows machine performing the scan have VMWare tools for powershell installed.

Note : The script have only been tested with agent 2.7.0.0

## Configure the agent file

Change the line ```Connect-VIServer``` with your credentials.