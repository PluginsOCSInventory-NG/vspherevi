<?php
//====================================================================================
// OCS INVENTORY REPORTS
// Copyleft GILLES DUBOIS 2020 (erwan(at)ocsinventory-ng(pt)org)
// Web: http://www.ocsinventory-ng.org
//
// This code is open source and may be copied and modified as long as the source
// code is always made freely available.
// Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
//====================================================================================
 
if(AJAX){
  parse_str($protectedPost['ocs']['0'], $params);
  $protectedPost+=$params;
  ob_start();
  $ajax = true;
}
else{
  $ajax=false;
}

require "require/function_machine.php";

print_item_header($l->g(73000));

//form name
$form_name = 'vspherevi';

$def_onglets['VM'] = $l->g(73001);
$def_onglets['HOST'] = $l->g(73002); 

//default => first onglet
if (empty($protectedPost['onglet'])) {
  $protectedPost['onglet'] = "VM";
}

//form open
echo open_form($form_name, '', '', 'form-horizontal');

//show first ligne of onglet
show_tabs($def_onglets,$form_name,"onglet",true);

echo "<div class='col-md-10'>";

$table_name=$form_name;
$tab_options=$protectedPost;
$tab_options['form_name']=$form_name;
$tab_options['table_name']=$table_name;

if($protectedPost['onglet'] == "VM"){

  $list_fields = array(
    $l->g(296) => 'VMID',
    $l->g(49) => 'VMNAME',
    $l->g(73003) => 'VMPOWSTATE',
    $l->g(25) => 'VMGUEST',
    $l->g(351) => 'VMCPUNUM',
    $l->g(1317) => 'VMCPUCORES',
    $l->g(568) => 'VMMEMORY',
    $l->g(73007) => 'VMHOST',
    $l->g(73012) => 'VMVAPP',
    $l->g(73008) => 'VMFOLDER',
    $l->g(73009) => 'VMRESPOOL',
    $l->g(73010) => 'VMHARESTARTPRI',
    $l->g(73011) => 'VMHAISOLATIONRESP',
    $l->g(73013) => 'VMDRSLEVEL',
    $l->g(50) => 'VMSWAPPOLICY',
    $l->g(73014) => 'VMRESCONFIG',
    $l->g(7003) => 'VMVERSION',
    $l->g(73015) => 'VMHWVERSION',
    $l->g(73018) => 'VMUSEDPACE',
    $l->g(73017) => 'VMTOTALSPACE',
    $l->g(68706) => 'VMDATASTORE'
  );

  $default_fields = array(
    $l->g(296) => 'VMID',
    $l->g(49) => 'VMNAME',
    $l->g(25) => 'VMGUEST',
    $l->g(351) => 'VMCPUNUM',
    $l->g(568) => 'VMMEMORY',
    $l->g(73007) => 'VMHOST',
    $l->g(73012) => 'VMVAPP',
    $l->g(73008) => 'VMFOLDER',
    $l->g(73009) => 'VMRESPOOL',
    $l->g(73010) => 'VMHARESTARTPRI',
    $l->g(73011) => 'VMHAISOLATIONRESP',
    $l->g(73013) => 'VMDRSLEVEL',
    $l->g(73014) => 'VMRESCONFIG',
    $l->g(7003) => 'VMVERSION',
    $l->g(73015) => 'VMHWVERSION'
  );
  $list_col_cant_del = $default_fields;

  $sql['SQL'] = 'SELECT * FROM vspherevms';

}

/******************************* RESOURCES *******************************/
if($protectedPost['onglet'] == "HOST"){

  $list_fields = array(
    $l->g(81) => 'HOSTSTATE',
    $l->g(73004) => 'HOSTCONSTATE',
    $l->g(73003) => 'HOSTPOWSTATE',
    $l->g(50) => 'HOSTSWAPPOLICY',
    $l->g(73005) => 'HOSTSTANDALONE',
    $l->g(563) => 'HOSTMANUFACTURER',
    $l->g(1446) => 'HOSTMODEL',
    $l->g(1368) => 'HOSTCPU',
    $l->g(569) => 'HOSTCPUMHZ',
    $l->g(73006) => 'HOSTCPUUSAGE',
    $l->g(73019) => 'HOSTLICENSEKEY',
    $l->g(73020) => 'HOSTMEMORY',
    $l->g(73021) => 'HOSTMEMORYUSAGE',
    $l->g(350) => 'HOSTCPUTYPE',
    $l->g(73022) => 'HOSTCPUHT',
    $l->g(73023) => 'HOSTTZ',
    $l->g(7003) => 'HOSTVERSION',
    $l->g(73024) => 'HOSTBUILD',
    $l->g(73025) => 'HOSTPARENT',
    $l->g(63) => 'HOSTSTORAGE',
    $l->g(82) => 'HOSTNETWORK',
    $l->g(73027) => 'HOSTFIREWALLPOLICY',
    $l->g(73026) => 'HOSTEVCMODE',
    $l->g(49) => 'HOSTNAME',
    $l->g(73016) => 'HOSTDATASTORELIST'
  );

  $default_fields = array(
    $l->g(81) => 'HOSTSTATE',
    $l->g(73004) => 'HOSTCONSTATE',
    $l->g(73003) => 'HOSTPOWSTATE',
    $l->g(50) => 'HOSTSWAPPOLICY',
    $l->g(73005) => 'HOSTSTANDALONE',
    $l->g(49) => 'HOSTNAME',
    $l->g(73016) => 'HOSTDATASTORELIST'
  );
  $list_col_cant_del = $default_fields;

  $sql['SQL'] = 'SELECT * FROM vspherehost';

}

ajaxtab_entete_fixe($list_fields, $default_fields, $tab_options, $list_col_cant_del);

echo '</div>';

echo close_form();

if ($ajax){
  ob_end_clean();
  tab_req($list_fields,$default_fields,$list_col_cant_del,$sql['SQL'],$tab_options);
  ob_start();
}
