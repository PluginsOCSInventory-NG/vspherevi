<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_vspherevi()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("DROP TABLE IF EXISTS `vspherehost` , `vspherevms`;");

    $commonObject -> sqlQuery("CREATE TABLE `vspherehost` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `HOSTSTATE` VARCHAR(255) DEFAULT NULL,
        `HOSTCONSTATE` VARCHAR(255) DEFAULT NULL,
        `HOSTPOWSTATE` VARCHAR(255) DEFAULT NULL,
        `HOSTSWAPPOLICY` VARCHAR(255) DEFAULT NULL,
        `HOSTSTANDALONE` VARCHAR(255) DEFAULT NULL,
        `HOSTMANUFACTURER` VARCHAR(255) DEFAULT NULL,
        `HOSTMODEL` VARCHAR(255) DEFAULT NULL,
        `HOSTCPU` VARCHAR(255) DEFAULT NULL,
        `HOSTCPUMHZ` VARCHAR(255) DEFAULT NULL,
        `HOSTCPUUSAGE` VARCHAR(255) DEFAULT NULL,
        `HOSTLICENSEKEY` VARCHAR(255) DEFAULT NULL,
        `HOSTMEMORY` VARCHAR(255) DEFAULT NULL,
        `HOSTMEMORYUSAGE` VARCHAR(255) DEFAULT NULL,
        `HOSTCPUTYPE` VARCHAR(255) DEFAULT NULL,
        `HOSTCPUHT` VARCHAR(255) DEFAULT NULL,
        `HOSTTZ` VARCHAR(255) DEFAULT NULL,
        `HOSTVERSION` VARCHAR(255) DEFAULT NULL,
        `HOSTBUILD` VARCHAR(255) DEFAULT NULL,
        `HOSTPARENT` VARCHAR(255) DEFAULT NULL,
        `HOSTSTORAGE` VARCHAR(255) DEFAULT NULL,
        `HOSTNETWORK` VARCHAR(255) DEFAULT NULL,
        `HOSTFIREWALLPOLICY` VARCHAR(255) DEFAULT NULL,
        `HOSTEVCMODE` VARCHAR(255) DEFAULT NULL,
        `HOSTNAME` VARCHAR(255) DEFAULT NULL,
        `HOSTDATASTORELIST` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
    ) ENGINE=INNODB;");

    $commonObject -> sqlQuery("CREATE TABLE `vspherevms` (
        `ID` INT(11) NOT NULL AUTO_INCREMENT,
        `HARDWARE_ID` INT(11) NOT NULL,
        `VMID` VARCHAR(255) DEFAULT NULL,
        `VMNAME` VARCHAR(255) DEFAULT NULL,
        `VMPOWSTATE` VARCHAR(255) DEFAULT NULL,
        `VMGUEST` VARCHAR(255) DEFAULT NULL,
        `VMCPUNUM` VARCHAR(255) DEFAULT NULL,
        `VMCPUCORES` VARCHAR(255) DEFAULT NULL,
        `VMMEMORY` VARCHAR(255) DEFAULT NULL,
        `VMHOST` VARCHAR(255) DEFAULT NULL,
        `VMVAPP` VARCHAR(255) DEFAULT NULL,
        `VMFOLDER` VARCHAR(255) DEFAULT NULL,
        `VMDRSLEVEL` VARCHAR(255) DEFAULT NULL,
        `VMRESPOOL` VARCHAR(255) DEFAULT NULL,
        `VMHARESTARTPRI` VARCHAR(255) DEFAULT NULL,
        `VMHAISOLATIONRESP` VARCHAR(255) DEFAULT NULL,
        `VMSWAPPOLICY` VARCHAR(255) DEFAULT NULL,
        `VMRESCONFIG` VARCHAR(255) DEFAULT NULL,
        `VMVERSION` VARCHAR(255) DEFAULT NULL,
        `VMHWVERSION` VARCHAR(255) DEFAULT NULL,
        `VMUSEDPACE` VARCHAR(255) DEFAULT NULL,
        `VMTOTALSPACE` VARCHAR(255) DEFAULT NULL,
        `VMDATASTORE` VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
    ) ENGINE=INNODB;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_vspherevi()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE IF EXISTS `vspherehost` , `vspherevms`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_vspherevi()
{

}