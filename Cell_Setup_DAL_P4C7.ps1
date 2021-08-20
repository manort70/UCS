###########################################################################################################################
# Cisco UCS Automated Configuration and Provisioning Script by J Bruce Bannerman     jbannerman@kpmg.com                  #
###########################################################################################################################


##########################
# Input variables here   #
##########################


$ucsvip = '10.41.56.10'
$ucsadmin = 'admin'
$ucspsswd = 'P@ssw0rd!'
$dns1 = '10.1.177.22'
$dns2 = '10.14.0.120'
$ntp1 = 'ns01.us.kworld.kpmg.com'
$ntp2 = 'ns02.us.kworld.kpmg.com'
$timezone = 'America/New_York'
$smtpfrom = 'UCS_POD-07_CELL-1@kpmg.com'
$smtprcpt = 'us-nssitsucsmgrlist@kpmg.com'
$uuidfrom = '0501-4700000007D1'
$uuidto = '0501-470000000910'
$macafrom = '00:25:B5:A4:77:D0'
$macato = '00:25:B5:A4:7B:8F'
$macbfrom = '00:25:B5:B4:77:D0'
$macbto = '00:25:B5:B4:7B:8F'
$wwnnfrom = '20:00:00:25:B5:47:07:D0'
$wwnnto = '20:00:00:25:B5:47:09:0F'
$wwpnafrom = '20:00:00:25:B5:A4:77:D0'
$wwpnato   = '20:00:00:25:B5:A4:79:C3'
$wwpnbfrom = '20:00:00:25:B5:B4:77:D0'
$wwpnbto   = '20:00:00:25:B5:B4:79:C3'
$cimcfrom = '10.58.28.143'
$cimcto   = '10.58.28.190'
$defgw = '10.58.28..1'


############################################
# Authenticate to UCSM with the admin user #
############################################
$user = $ucsadmin
$password = $ucspsswd | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object system.Management.Automation.PSCredential($user, $password)
$handle1 = Connect-Ucs $ucsvip -Credential $cred

##########################
# Set UCS Admin Settings #
##########################

# Get-UcsNativeAuth | Set-UcsNativeAuth -ConLogin local -DefLogin local -DefRolePolicy no-login -Force
Add-UcsDnsServer -Name $dns1
Add-UcsDnsServer -Name $dns2
Set-UcsTimezone -Timezone $timezone -Force
Add-UcsNtpServer -Name $ntp1
Add-UcsNtpServer -Name $ntp2

################################
# Set Chassis Discovery Policy #
################################

Get-UcsOrg -Level root | 
Get-UcsChassisDiscoveryPolicy | Set-UcsChassisDiscoveryPolicy -Action '2-link'`
-Descr '' -LinkAggregationPref 'port-channel' -Name '' -PolicyOwner 'local' -Rebalance 'user-acknowledged' -Force

################################
# Set Global Power Policy      #
################################

Get-UcsPowerControlPolicy | Set-UcsPowerControlPolicy -Redundancy grid -Force

#########################################################
# Remove default WWPN and MAC pools                     #
#########################################################

Get-UcsOrg -Level root | Get-UcsIqnPoolPool -Name 'default' -LimitScope | Remove-UcsIqnPoolPool -Force

###########################################################
# Configure a Network Control Policy                      #
###########################################################

Start-UcsTransaction
$mo = Get-UcsOrg -Level root  | Add-UcsNetworkControlPolicy -Cdp 'enabled' -Descr ''`
-MacRegisterMode 'only-native-vlan' -Name 'VMWARE-CDP' -PolicyOwner 'local' -UplinkFailAction 'link-down'
$mo_1 = $mo | Add-UcsPortSecurityConfig -ModifyPresent -Descr '' -Forge 'allow' -Name '' -PolicyOwner 'local'
Complete-UcsTransaction

#####################################################
# Create Southbound links (Server Ports) from FI(6K)#
#####################################################

Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 9 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 10 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 11 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 12 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 13 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 14 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 15 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 16 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 17 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 18 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 19 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 20 -SlotId 1 -UsrLbl ''
#Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 13 -SlotId 1 -UsrLbl ''
#Get-UcsFabricServerCloud -Id 'A' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 14 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 9 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 10 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 11 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 12 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 13 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 14 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 15 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 16 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 17 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 18 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 19 -SlotId 1 -UsrLbl ''
Get-UcsFabricServerCloud -Id 'B' | Add-UcsServerPort -AdminState 'enabled' -Name '' -PortId 20 -SlotId 1 -UsrLbl ''


######################################
# Configure Host Firmware Policy     #
######################################

#Get-UcsOrg -Level root  | Add-UcsFirmwareComputeHostPack -BladeBundleVersion '2.1(2a)B'`
#-Descr '' -IgnoreCompCheck 'yes' -Mode 'staged' -Name 'FW_UPG_2_1_2a'`
#-PolicyOwner 'local' -RackBundleVersion '' -StageSize 0 -UpdateTrigger 'immediate'

######################################
# Change Default Maintenance Policy  #
######################################

Get-UcsOrg -Level root | Get-UcsMaintenancePolicy -Name 'default'`
-LimitScope | Set-UcsMaintenancePolicy -Descr '' -PolicyOwner 'local' -SchedName '' -UptimeDisr 'user-ack' -Force

######################################
# Create Management Pool             #
######################################

Get-UcsIpPool -Name ext-mgmt -LimitScope | Add-UcsIpPoolBlock -DefGw $defgw -From $cimcfrom -To $cimcto

######################################
# Create UUID Pool                   #
######################################

#Remove default UUID pool

Get-UcsUuidSuffixPool -Name default -LimitScope | Remove-UcsUuidSuffixPool -Force

Start-UcsTransaction
$uuid = Get-UcsOrg -Level root  | Add-UcsUuidSuffixPool -Descr `
'UUID Pool for Servers' -Name 'UUID_POD-04_CELL-7' -Prefix derived
$uuid_1 = $uuid | Add-UcsUuidSuffixBlock -From $uuidfrom -To $uuidto
Complete-UcsTransaction

######################################
# Create MAC Pools                   #
######################################

#Remove default MAC pool

Get-UcsMacPool -Name default -LimitScope | Remove-UcsMacPool -Force

Start-UcsTransaction
$maca = Get-UcsOrg -Level root  | Add-UcsMacPool `
-Descr 'MAC Address Pool for vNICs on Fabric A' -Name 'MAC_POD-04_CELL-7_FABRIC-A'
$maca_1 = $maca | Add-UcsMacMemberBlock -From $macafrom -To $macato
Complete-UcsTransaction

Start-UcsTransaction
$macb = Get-UcsOrg -Level root  | Add-UcsMacPool `
-Descr 'MAC Address Pool for vNICs on Fabric B' -Name 'MAC_POD-04_CELL-7_FABRIC-B'
$macb_1 = $macb | Add-UcsMacMemberBlock -From $macbfrom -To $macbto
Complete-UcsTransaction

######################################
# Create WWNN Pool                   #
######################################

#Remove default WWNN pools

Get-UcsWwnPool -Name node-default -LimitScope | Remove-UcsWwnPool -Force
Get-UcsWwnPool -Name default -LimitScope | Remove-UcsWwnPool -Force

Start-UcsTransaction
$wwnn = Get-UcsOrg -Level root  | Add-UcsWwnPool -Descr 'Server WWNN Pool' -Name 'WWNN_POD-04_CELL-7'`
-Purpose 'node-wwn-assignment'
$wwnn_1 = $wwnn | Add-UcsWwnMemberBlock -From $wwnnfrom -To $wwnnto
Complete-UcsTransaction

######################################
# Create Server Pools                #
######################################

#Remove default Server Pool

Get-UcsOrg -Level root | Get-UcsServerPool -Name 'default' -LimitScope | Remove-UcsServerPool -force

Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'B200_M5_768GB' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B200_M2_96G' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B230_M2_128G' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B440_M2_128G' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B440_M2_256G' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B200_M3_32G' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B200_M3_96G' -PolicyOwner 'local'
#Get-UcsOrg -Level root  | Add-UcsServerPool -Descr '' -Name 'Pod7_MPOD3_B200_M3_256G' -PolicyOwner 'local'

###################################################
# Create Server Pool Policy Qualifications        #
###################################################

#Remove default Server Pool Qualification

Get-UcsOrg -Level root | Get-UcsServerPoolQualification -Name 'default'`
-LimitScope | Remove-UcsServerPoolQualification -force

Start-UcsTransaction
$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B200_M5_768GB' -PolicyOwner 'local'
$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
-Latency 'unspecified' -MaxCap '786432' -MinCap '786430' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
$mo_3 = $mo | Add-UcsServerModelQualification -Model 'N20-B6625-1'
Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B200_M5_768GB' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
#-Latency 'unspecified' -MaxCap '99000' -MinCap '90000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'N20-B6625-1'
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B230_M2_128G' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
-Latency 'unspecified' -MaxCap '132000' -MinCap '120000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'B230-BASE-M2'
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B440_M2_128G' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
#-Latency 'unspecified' -MaxCap '132000' -MinCap '120000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'B440-BASE-M2'
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B440_M2_256G' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
#-Latency 'unspecified' -MaxCap '270000' -MinCap '250000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'B440-BASE-M2'
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B200_M3_32G' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
#-Latency 'unspecified' -MaxCap '33000' -MinCap '32000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'UCSB-B200-M3'
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B200_M3_96G' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
#-Latency 'unspecified' -MaxCap '99000' -MinCap '97000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'UCSB-B200-M3'
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsServerPoolQualification -Descr '' -Name 'B200_M3_256G' -PolicyOwner 'local'
#$mo_1 = $mo | Add-UcsChassisQualification -MaxId 20 -MinId 1
#$mo_2 = $mo | Add-UcsMemoryQualification -Clock 'unspecified'`
#-Latency 'unspecified' -MaxCap '263000' -MinCap '260000' -Speed 'unspecified' -Units 'unspecified' -Width 'unspecified'
#$mo_3 = $mo | Add-UcsServerModelQualification -Model 'UCSB-B200-M3'
#Complete-UcsTransaction

######################################
# Create Server Pool Policies        #
######################################

Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B200_M5_768GB'`
-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-B200_M5_768GB' -Qualifier 'B200_M5_768GB'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B200_M2_96G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B200_M2_96G' -Qualifier 'B200_M2_96G'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B230_M2_128G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B230_M2_128G' -Qualifier 'B230_M2_128G'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B440_M2_128G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B440_M2_128G' -Qualifier 'B440_M2_128G'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B440_M2_256G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B440_M2_256G' -Qualifier 'B440_M2_256G'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B200_M3_32G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B200_M3_32G' -Qualifier 'B200_M3_32G'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B200_M3_96G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B200_M3_96G' -Qualifier 'B200_M3_96G'

#Get-UcsOrg -Level root  | Add-UcsServerPoolPolicy -Descr '' -Name 'B200_M3_256G'`
#-PolicyOwner 'local' -PoolDn 'org-root/compute-pool-Pod7_MPOD3_B200_M3_256G' -Qualifier 'B200_M3_256G'


######################################
# Create WWPN Pools                  #
######################################

#Remove default WWPN pool

Get-UcsOrg -Level root | Get-UcsWwnPool -Name 'default' -LimitScope | Remove-UcsWwnPool

Start-UcsTransaction
$wwpna = Get-UcsOrg -Level root  | Add-UcsWwnPool -Descr 'WWPN Pool for vHBAs on Fabric A' `
-Name 'WWPN_POD-04_CELL-7_FABRIC-A' -Purpose 'port-wwn-assignment'
$wwpna_1 = $wwpna | Add-UcsWwnMemberBlock -From $wwpnafrom -To $wwpnato
Complete-UcsTransaction

Start-UcsTransaction
$wwpnb = Get-UcsOrg -Level root  | Add-UcsWwnPool -Descr 'WWPN Pool for vHBAs on Fabric B' `
-Name 'WWPN_POD-04_CELL-7_FABRIC-B' -Purpose 'port-wwn-assignment'
$wwpnb_1 = $wwpnb | Add-UcsWwnMemberBlock -From $wwpnbfrom -To $wwpnbto

###########################################################
# Configure LAN Uplink ports for Northbound Links on FI   #
###########################################################

#Fabric Interconnect A

Start-UcsTransaction
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 33 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 34 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 35 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 36 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 37 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 38 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 39 -SlotId 1 -UsrLbl ''
Complete-UcsTransaction

#Fabric Interconnect B

Start-UcsTransaction
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 33 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 34 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 35 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 36 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 37 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 38 -SlotId 1 -UsrLbl ''
Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPort -AdminSpeed '10gbps' -AdminState 'enabled' -FlowCtrlPolicy 'default'`
-Name '' -PortId 39 -SlotId 1 -UsrLbl ''
Complete-UcsTransaction


###########################################################
# Create Port Channel on fabric A and enable              #
###########################################################

Start-UcsTransaction
$mo = Get-UcsFiLanCloud -Id 'A' | Add-UcsUplinkPortChannel -AdminSpeed '10gbps' -AdminState 'enabled'`
-FlowCtrlPolicy 'default' -Name 'PortChannel_71' -OperSpeed '10gbps' -PortId 71
$mo_1 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 33 -SlotId 1
$mo_2 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 34 -SlotId 1
$mo_3 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 35 -SlotId 1
$mo_4 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 36 -SlotId 1
$mo_5 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 37 -SlotId 1
$mo_6 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 38 -SlotId 1
Complete-UcsTransaction

###########################################################
# Create Port Channel on fabric B and enable              #
###########################################################

Start-UcsTransaction
$mo = Get-UcsFiLanCloud -Id 'B' | Add-UcsUplinkPortChannel -AdminSpeed '10gbps'`
-AdminState 'enabled' -FlowCtrlPolicy 'default' -Name 'PortChannel_72' -OperSpeed '10gbps' -PortId 72
$mo_1 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 33 -SlotId 1
$mo_2 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 34 -SlotId 1
$mo_3 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 35 -SlotId 1
$mo_4 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 36 -SlotId 1
$mo_5 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 37 -SlotId 1
$mo_6 = $mo | Add-UcsUplinkPortChannelMember -ModifyPresent -AdminState 'enabled' -Name '' -PortId 38 -SlotId 1
Complete-UcsTransaction


##################################################################
# Configure SAN uplink FC ports for Northbound Links on FI       #    
##################################################################

Start-UcsTransaction
Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 1 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 2 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 3 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 4 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 5 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 6 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 7 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 8 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 9 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 10 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 11 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 12 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 13 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 14 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 15 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 16 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Complete-UcsTransaction



Start-UcsTransaction
Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 1 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 2 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 3 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
-PortId 4 -SlotId 1 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 5 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 6 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 7 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 8 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 9 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 10 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 11 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 12 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 13 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 14 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 15 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
#Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPort -ModifyPresent  -AdminState 'enabled' -Name ''`
#-PortId 16 -SlotId 3 -UsrLbl '' -XtraProperty @{FillPattern='arbff'; }
Complete-UcsTransaction

###################################
#      Wait for FIs to reboot     #
###################################

Start-Sleep -Seconds 900

############################################################################################
# Configure SAN connectivity (Port Channels) for Northbound Links on FI and enable         #    
############################################################################################

#Start-UcsTransaction
#$mo = Get-UcsFiSanCloud -Id 'A' | Add-UcsFcUplinkPortChannel -AdminSpeed 'auto'`
#-AdminState 'enabled' -Name 'PortChannel_131' -PortId 131
#$mo_1 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 1 -SlotId 1
#$mo_2 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 2 -SlotId 1
#$mo_3 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 3 -SlotId 1
#$mo_3 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 4 -SlotId 1
#Complete-UcsTransaction

#Get-UcsFiSanCloud -Id 'A' | Get-UcsVsan -Name 'VSAN_23' | Add-UcsVsanMemberFcPortChannel -ModifyPresent -AdminState 'enabled'`
#-Name '' -PortId 131 -SwitchId 'A'

#Start-UcsTransaction
#$mo = Get-UcsFiSanCloud -Id 'B' | Add-UcsFcUplinkPortChannel -AdminSpeed 'auto'`
#-AdminState 'enabled' -Name 'PortChannel_132' -PortId 132
#$mo_1 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 1 -SlotId 1
#$mo_2 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 2 -SlotId 1
#$mo_3 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 3 -SlotId 1
#$mo_3 = $mo | Add-UcsFabricFcSanPcEp -ModifyPresent -AdminSpeed 'auto' -AdminState 'enabled' -Name '' -PortId 4 -SlotId 1
#Complete-UcsTransaction

#Get-UcsFiSanCloud -Id 'B' | Get-UcsVsan -Name 'VSAN_24' | Add-UcsVsanMemberFcPortChannel -ModifyPresent  -AdminState 'enabled'`
#-Name '' -PortId 132 -SwitchId 'B'

#Get-UcsFiSanCloud -Id 'A' | Set-UcsFiSanCloud -UplinkTrunking 'false' -Force

#Get-UcsFiSanCloud -Id 'B' | Set-UcsFiSanCloud -UplinkTrunking 'false' -Force

###########################################################
# Create VSANS                                            #
###########################################################

#Get-UcsFiSanCloud -Id A | Add-UcsVsan -Name $fabavsan -Id $fabavsanid -fcoevlan $fabavsanid -zoningstate disabled
#Get-UcsFiSanCloud -Id B | Add-UcsVsan -Name $fabbvsan -Id $fabbvsanid -fcoevlan $fabbvsanid -zoningstate disabled 

###########################################################
# Configure Call Home                                     #
###########################################################

Start-UcsTransaction
$mo = Get-UcsCallhome | Set-UcsCallhome -AdminState 'on' -Force `
-AlertThrottlingAdminState 'on' -Descr '' -Name '' -PolicyOwner 'local'
$mo_1 = Get-UcsCallhomeSmtp | Set-UcsCallhomeSmtp -Host 'smtpout.us.kworld.kpmg.com' -Port 25 -force
Complete-UcsTransaction


###########################################################
# Configure SNMP                                          #
###########################################################

$mo = Get-UcsSvcEp -Descr '' -PolicyOwner 'local'
Start-UcsTransaction
$mo_1 = Get-UcsSnmp | Set-UcsSnmp -AdminState 'enabled'`
-Community 'ucsro123' -Descr 'SNMP Service' -PolicyOwner 'local'`
-SysContact 'us-nssitsucsmgrlist@kpmg.com' -SysLocation '' -XtraProperty @{IsSetSnmpSecure='no'; } -force
Complete-UcsTransaction

###########################################################
# Configure Local Disk Config Policies                    #
###########################################################

Get-UcsOrg -Level root  | Add-UcsLocalDiskConfigPolicy -Descr ''`
-Mode 'Any Configuration' -Name 'ESXi_SD' -PolicyOwner 'local'`
-ProtectConfig 'no' -XtraProperty @{FlexFlashState='enable'; FlexFlashRAIDReportingState='enable'; }

#Get-UcsOrg -Level root  | Add-UcsLocalDiskConfigPolicy -Descr ''`
#-Mode 'raid-mirrored' -Name 'RAID-1' -PolicyOwner 'local'`
#-ProtectConfig 'yes' -XtraProperty @{FlexFlashState='disable'; FlexFlashRAIDReportingState='disable'; }

###########################################################
# 	Configure Boot Policies                               #
###########################################################

			#############
			#LOCAL_BOOT #
			#############

Start-UcsTransaction
$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name FlashNoAuto -RebootOnUpdate no
$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2 | Add-UcsLsbootLocalStorage
$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
Complete-UcsTransaction

			##################
			#VSAN23_SPA0_5390#
			##################

#@Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN23_SPA0_5390 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna5390_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna5390_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb5390_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb5390_2
#Complete-UcsTransaction

			##################
			#VSAN24_SPB0_5390#
			##################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN24_SPB0_5390 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb5390_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb5390_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna5390_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna5390_2
#Complete-UcsTransaction

			##################
			#VSAN23_SPA0_5391#
			##################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN23_SPA0_5391 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna5391_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna5391_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb5391_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb5391_2
#Complete-UcsTransaction

			##################
			#VSAN24_SPB0_5391#
			##################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN24_SPB0_5391 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb5391_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb5391_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna5391_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna5391_2
#Complete-UcsTransaction

			##################
			#VSAN23_SPA0_6327#
			##################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN23_SPA0_6327 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna5391_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna5391_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb5391_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb5391_2
#Complete-UcsTransaction

			##################
			#VSAN24_SPB0_6327#
			##################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN24_SPB0_6327 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb5391_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb5391_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna5391_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna5391_2
#Complete-UcsTransaction

			##################
			#VSAN23_SPA0_3062#
			##################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsBootPolicy -EnforceVnicName no -Name VSAN23_SPA0_3062 -RebootOnUpdate no
#$mo_2 = $mo | Add-UcsLsbootVirtualMedia -Access read-only -Order 1
#$mo_4 = $mo | Add-UcsLsbootLan -Order 3 | Add-UcsLsbootLanImagePath -VnicName vNIC0 -Type primary
#$mo_3 = $mo | Add-UcsLsbootStorage -ModifyPresent -Order 2
#$mo_3_1 = $mo_3 | Add-UcsLsbootSanImage -Type primary -VnicName vHBA0
#$mo_3_1_1 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpna3062_1
#$mo_3_1_2 = $mo_3_1 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpna3062_2
#$mo_3_2 = $mo_3 | Add-UcsLsbootSanImage -Type secondary -VnicName vHBA1
#$mo_3_2_1 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type primary -Wwn $sanwwpnb3062_1
#$mo_3_2_2 = $mo_3_2 | Add-UcsLsbootSanImagePath -Lun 0 -Type secondary -Wwn $sanwwpnb3062_2
#Complete-UcsTransaction


###########################################################
# Configure SAN vHBA Templates                            #
###########################################################

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsVhbaTemplate -Descr "" -IdentPoolName "WWPN_POD-04_CELL-7_FABRIC-A"`
#-MaxDataFieldSize 2048 -Name "vHBA_TMP_SAN_A" -PinToGroupName "" -PolicyOwner "local" -QosPolicyName ""`
#-StatsPolicyName "default" -SwitchId "A" -TemplType "updating-template"
#$mo_1 = $mo | Add-UcsVhbaInterface -ModifyPresent -Name "VSAN_23"
#Complete-UcsTransaction

#Start-UcsTransaction
#$mo = Get-UcsOrg -Level root  | Add-UcsVhbaTemplate -Descr "" -IdentPoolName "WWPN_POD-07_MPOD-3_FABRIC-B"`
#-MaxDataFieldSize 2048 -Name "vHBA_TMP_SAN_B" -PinToGroupName "" -PolicyOwner "local" -QosPolicyName ""`
#-StatsPolicyName "default" -SwitchId "B" -TemplType "updating-template"
#$mo_1 = $mo | Add-UcsVhbaInterface -ModifyPresent -Name "VSAN_24"
#Complete-UcsTransaction

###########################################################
# Create VLANS  (Change file location)                    #
###########################################################

import-csv c:\temp\vlans.csv | % { Get-UcsLanCloud | add-ucsvlan -Name $_.Name -Id $_.Id }

###########################################################
# Modify Native VLAN                                      #
###########################################################

Get-UcsLanCloud | Get-UcsVlan -Name 'VLAN_999' -LimitScope | Set-UcsVlan -CompressionType 'included'`
-DefaultNet 'yes' -Id 999 -McastPolicyName '' -PubNwName '' -Sharing 'none' -XtraProperty @{PolicyOwner='local'; } -Force

###########################################################
# Create vNIC Templates (Change file location)            #
###########################################################

import-csv c:\temp\vNICCTEMPLATE.csv | % { add-ucsVnicTemplate -Name $_.name`
-NwCtrlPolicyName 'default' -Target $_.target -IdentPoolName $_.idpoolname`
-SwitchId $_.switchid -templtype $_.templtype -Org $_.org}

#ESX A VNIC Template

 Get-UcsOrg -Level root  | Add-UcsVnicTemplate -Descr ''`
-IdentPoolName 'MAC_POD-04_CELL-7_FABRIC-A' -Mtu 1500 -Name 'ESX_A_MGMT'`
-NwCtrlPolicyName 'VMWARE-CDP' -PinToGroupName ''`
-PolicyOwner 'local' -QosPolicyName '' -StatsPolicyName 'default' -SwitchId 'A' -TemplType 'updating-template'

#ESX B VNIC Template

Get-UcsOrg -Level root  | Add-UcsVnicTemplate -Descr ''`
-IdentPoolName 'MAC_POD-04_CELL-7_FABRIC-B' -Mtu 1500 -Name 'ESX_B_MGMT'`
-NwCtrlPolicyName 'VMWARE-CDP' -PinToGroupName ''`
-PolicyOwner 'local' -QosPolicyName '' -StatsPolicyName 'default' -SwitchId 'B' -TemplType 'updating-template'


###########################################################
# Populate vNIC Templates with VLANs                      #
###########################################################

import-csv c:\temp\PopulateVNICTEMPL.csv | % { $vnicTemp = Get-UcsVnicTemplate -Name $_.vnictmp `
;Add-UcsVnicInterface -VnicTemplate $vnicTemp -Name $_.id -default yes}

#import-csv c:\temp\step3_ESX_vnictmpvlanlist_montvale.csv | % { $vnicTemp = Get-UcsVnicTemplate -Name $_.vnictmp
#Add-UcsVnicInterface -VnicTemplate $vnicTemp -Name $_.id -default no}

#Mark VLAN 999 as native VLAN in ESX Mgmt

Start-UcsTransaction
Get-UcsVnicTemplate -Name 'ESX_A_Templates' -LimitScope | 
Get-UcsVnicInterface -Name 'VLAN_999' | Set-UcsVnicInterface -DefaultNet 'yes' -Force


Get-UcsVnicTemplate -Name 'ESX_A_Templates' -LimitScope | Get-UcsVnicInterface -Name 'default' |
Set-UcsVnicInterface -DefaultNet 'no' -Force
Complete-UcsTransaction

Start-UcsTransaction
Get-UcsVnicTemplate -Name 'ESX_B_Templates' -LimitScope | 
Get-UcsVnicInterface -Name 'VLAN_999' | Set-UcsVnicInterface -DefaultNet 'yes' -Force


Get-UcsVnicTemplate -Name 'ESX_B_Templates' -LimitScope | Get-UcsVnicInterface -Name 'default' |
Set-UcsVnicInterface -DefaultNet 'no' -Force
Complete-UcsTransaction

##########################
#   Authentication       #
##########################

		###########################
		#     Add LDAP Providers  #
		###########################
		
Start-UcsTransaction
$mo = Add-UcsLdapProvider -Attribute "" -Basedn "DC=us,DC=kworld,DC=kpmg,DC=com" -Descr ""`
-EnableSSL "no" -FilterValue "sAMAccountName=`$userid" -Key "KPMGKloud" -Name "useomgc22.us.kworld.kpmg.com"`
-Order "1" -Port 389 -Retries 1 -Rootdn "CN=us-svcucsbind,OU=US Service Accounts,DC=us,DC=kworld,DC=kpmg,DC=com"`
-Timeout 30 -XtraProperty @{Vendor="MS-AD"; }
$mo_1 = $mo | Add-UcsLdapGroupRule -ModifyPresent -Authorization "enable" -Descr "" -Name ""`
-TargetAttr "memberOf" -Traversal "non-recursive"
Complete-UcsTransaction

Start-UcsTransaction
$mo = Add-UcsLdapProvider -Attribute "" -Basedn "DC=us,DC=kworld,DC=kpmg,DC=com" -Descr ""`
-EnableSSL "no" -FilterValue "sAMAccountName=`$userid" -Key "KPMGKloud" -Name "useomgc24.us.kworld.kpmg.com"`
-Order "2" -Port 389 -Retries 1 -Rootdn "CN=us-svcucsbind,OU=US Service Accounts,DC=us,DC=kworld,DC=kpmg,DC=com"`
-Timeout 30 -XtraProperty @{Vendor="MS-AD"; }
$mo_1 = $mo | Add-UcsLdapGroupRule -ModifyPresent -Authorization "enable" -Descr "" -Name ""`
-TargetAttr "memberOf" -Traversal "non-recursive"
Complete-UcsTransaction

Start-UcsTransaction
$mo = Add-UcsLdapProvider -Attribute "" -Basedn "DC=us,DC=kworld,DC=kpmg,DC=com" -Descr ""`
-EnableSSL "no" -FilterValue "sAMAccountName=`$userid" -Key "KPMGKloud" -Name "useomgc25.us.kworld.kpmg.com"`
-Order "3" -Port 389 -Retries 1 -Rootdn "CN=us-svcucsbind,OU=US Service Accounts,DC=us,DC=kworld,DC=kpmg,DC=com"`
-Timeout 30 -XtraProperty @{Vendor="MS-AD"; }
$mo_1 = $mo | Add-UcsLdapGroupRule -ModifyPresent -Authorization "enable" -Descr "" -Name ""`
-TargetAttr "memberOf" -Traversal "non-recursive"
Complete-UcsTransaction

Start-UcsTransaction
$mo = Add-UcsLdapProvider -Attribute "" -Basedn "DC=us,DC=kworld,DC=kpmg,DC=com" -Descr ""`
-EnableSSL "no" -FilterValue "sAMAccountName=`$userid" -Key "KPMGKloud" -Name "useomgc26.us.kworld.kpmg.com"`
-Order "4" -Port 389 -Retries 1 -Rootdn "CN=us-svcucsbind,OU=US Service Accounts,DC=us,DC=kworld,DC=kpmg,DC=com"`
-Timeout 30 -XtraProperty @{Vendor="MS-AD"; }
$mo_1 = $mo | Add-UcsLdapGroupRule -ModifyPresent -Authorization "enable" -Descr "" -Name ""`
-TargetAttr "memberOf" -Traversal "non-recursive"
Complete-UcsTransaction

		##################################
		#  	Add LDAP Provider Group      #
		##################################

Start-UcsTransaction
$mo = Get-UcsLdapGlobalConfig | Add-UcsProviderGroup -Descr "" -Name "KPMG_LDAP"
$mo_1 = $mo | Add-UcsProviderReference -ModifyPresent -Descr "" -Name "useomgc22.us.kworld.kpmg.com" -Order "1"
$mo_2 = $mo | Add-UcsProviderReference -ModifyPresent -Descr "" -Name "useomgc24.us.kworld.kpmg.com" -Order "2"
$mo_3 = $mo | Add-UcsProviderReference -ModifyPresent -Descr "" -Name "useomgc25.us.kworld.kpmg.com" -Order "3"
$mo_4 = $mo | Add-UcsProviderReference -ModifyPresent -Descr "" -Name "useomgc26.us.kworld.kpmg.com" -Order "4"
Complete-UcsTransaction

		##################################
		#  	Add Authentication Domain    #
		##################################
		
Start-UcsTransaction
$mo = Add-UcsAuthDomain -Descr "" -Name "US" -RefreshPeriod 600 -SessionTimeout 7200
$mo_1 = $mo | Set-UcsAuthDomainDefaultAuth -Descr "" -Name "" -ProviderGroup "KPMG_LDAP" -Realm "ldap" -Force
Complete-UcsTransaction

Start-UcsTransaction
$mo = Add-UcsAuthDomain -Descr "" -Name "Local" -RefreshPeriod 600 -SessionTimeout 7200
$mo_1 = $mo | Set-UcsAuthDomainDefaultAuth -Descr "" -Name "" -ProviderGroup "" -Realm "local" -Force
Complete-UcsTransaction

		##################################
		#  	Add Role                     #
		##################################

Add-UcsRole -Descr "" -Name "kvm-only" -PolicyOwner "local" -Priv "ls-ext-access"

		##################################
		#  	Add LDAP Group Maps          #
		##################################

Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG SAG IBM NT Admin,OU=CPAS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-equipment"
$mo_2 = $mo | Add-UcsUserRole -Descr "" -Name "server-profile"
$mo_3 = $mo | Add-UcsUserRole -Descr "" -Name "server-security"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG SAG CTS NT Admin,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-equipment"
$mo_2 = $mo | Add-UcsUserRole -Descr "" -Name "server-profile"
$mo_3 = $mo | Add-UcsUserRole -Descr "" -Name "server-security"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG SAG IBM Unix Admins,OU=CPAS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-equipment"
$mo_2 = $mo | Add-UcsUserRole -Descr "" -Name "server-profile"
$mo_3 = $mo | Add-UcsUserRole -Descr "" -Name "server-security"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG SAG IBM VMware Admins,OU=CPAS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-equipment"
$mo_2 = $mo | Add-UcsUserRole -Descr "" -Name "server-profile"
$mo_3 = $mo | Add-UcsUserRole -Descr "" -Name "server-security"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG SAG NT Admins,OU=CPAS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-equipment"
$mo_2 = $mo | Add-UcsUserRole -Descr "" -Name "server-profile"
$mo_3 = $mo | Add-UcsUserRole -Descr "" -Name "server-security"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG Storage Admins,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "storage"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS aaa,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "aaa"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS admin,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "admin"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS facility-manager,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "facility-manager"
Complete-UcsTransaction


Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS kvm-only,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "kvm-only"
Complete-UcsTransaction


Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS network,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "network"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS operations,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "operations"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS server-equipment,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-equipment"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS server-profile,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-profile"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr ""`
-Name "CN=US-SG UCS server-security,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "server-security"
Complete-UcsTransaction



Start-UcsTransaction
$mo = Add-UcsLdapGroupMap -Descr "" -Name "CN=US-SG UCS storage,OU=CiscoUCS,OU=Security Groups,DC=us,DC=kworld,DC=kpmg,DC=com"
$mo_1 = $mo | Add-UcsUserRole -Descr "" -Name "storage"
Complete-UcsTransaction


Disconnect-Ucs