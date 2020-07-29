###############################################################################
## OCSINVENTORY-NG
## Copyright OCS Inventory team
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################
 
package Apache::Ocsinventory::Plugins::Vspherevi::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

$DATA_MAP{vspherehost} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'HOSTNAME',
	writeDiff => 0,
	cache => 0,
	fields => {
        HOSTSTATE => {},
        HOSTCONSTATE => {},
        HOSTPOWSTATE => {},
		HOSTSWAPPOLICY => {},
		HOSTSTANDALONE => {},
		HOSTMANUFACTURER => {},
		HOSTMODEL => {},
		HOSTCPU => {},
		HOSTCPUMHZ => {},
		HOSTCPUUSAGE => {},
		HOSTLICENSEKEY => {},
		HOSTMEMORY => {},
		HOSTMEMORYUSAGE => {},
		HOSTCPUTYPE => {},
		HOSTCPUHT => {},
		HOSTTZ => {},
		HOSTVERSION => {},
		HOSTBUILD => {},
		HOSTPARENT => {},
		HOSTSTORAGE => {},
		HOSTNETWORK => {},
		HOSTFIREWALLPOLICY => {},
		HOSTEVCMODE => {},
		HOSTNAME => {},
		HOSTDATASTORELIST => {}
	}
};

$DATA_MAP{vspherevms} = {
	mask => 0,
	multi => 1,
	auto => 1,
	delOnReplace => 1,
	sortBy => 'VMID',
	writeDiff => 0,
	cache => 0,
	fields => {
        VMID => {},
		VMNAME => {},
        VMPOWSTATE => {},
        VMGUEST => {},
        VMCPUNUM => {},
        VMCPUCORES => {},
        VMMEMORY => {},
        VMHOST => {},
        VMVAPP => {},
        VMFOLDER => {},
		VMRESPOOL => {},
		VMHARESTARTPRI => {},
		VMHAISOLATIONRESP => {},
		VMDRSLEVEL => {},
		VMSWAPPOLICY => {},
		VMRESCONFIG => {},
		VMVERSION => {},
		VMHWVERSION => {},
		VMUSEDPACE => {},
		VMTOTALSPACE => {},
		VMDATASTORE => {}
	}
};

1;