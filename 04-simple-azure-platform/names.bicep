@export()
@description('''
  List the short names for the Azure locations (regions). The return value is an
  object where the keys are all the name of Azure locations and the values are
  the short names. For example: 'East US' => 'EUS'
''')
func listLocationShortNames() object => {
  eastus: 'EUS'
  southcentralus: 'SCUS'
  westus2: 'WUS2'
  westus3: 'WUS3'
  australiaeast: 'AE'
  southeastasia: 'SA'
  northeurope: 'NE'
  swedencentral: 'SC'
  uksouth: 'UKS'
  westeurope: 'WE'
  centralus: 'CUS'
  southafricanorth: 'SAN'
  centralindia: 'CI'
  eastasia: 'EA'
  japaneast: 'JE'
  koreacentral: 'KC'
  newzealandnorth: 'NZN'
  canadacentral: 'CC'
  francecentral: 'FC'
  germanywestcentral: 'GWC'
  italynorth: 'IN'
  norwayeast: 'NE'
  polandcentral: 'PC'
  spaincentral: 'SC'
  switzerlandnorth: 'SN'
  mexicocentral: 'MC'
  uaenorth: 'UAEN'
  brazilsouth: 'BS'
  israelcentral: 'IC'
  qatarcentral: 'QC'
  centralusstage: 'CUSS'
  eastusstage: 'EUSS'
  eastus2stage: 'EUS2S'
  northcentralusstage: 'NCUSS'
  southcentralusstage: 'SCUSS'
  westusstage: 'WUSS'
  westus2stage: 'WUS2S'
  asia: 'A'
  asiapacific: 'AP'
  australia: 'A'
  brazil: 'B'
  canada: 'C'
  europe: 'E'
  france: 'F'
  germany: 'G'
  global: 'G'
  india: 'I'
  israel: 'I'
  italy: 'I'
  japan: 'J'
  korea: 'K'
  newzealand: 'NZ'
  norway: 'N'
  poland: 'P'
  qatar: 'Q'
  singapore: 'S'
  southafrica: 'SA'
  sweden: 'S'
  switzerland: 'S'
  uae: 'UAE'
  uk: 'UK'
  unitedstates: 'US'
  unitedstateseuap: 'USEUAP'
  eastasiastage: 'EAS'
  southeastasiastage: 'SAS'
  brazilus: 'BUS'
  eastus2: 'EUS2'
  eastusstg: 'EUSSTG'
  northcentralus: 'NCUS'
  westus: 'WUS'
  japanwest: 'JW'
  jioindiawest: 'JIW'
  centraluseuap: 'CUSEUAP'
  eastus2euap: 'EUS2EUAP'
  southcentralusstg: 'SCUSSTG'
  westcentralus: 'WCUS'
  southafricawest: 'SAW'
  australiacentral: 'AC'
  australiacentral2: 'AC2'
  australiasoutheast: 'AS'
  jioindiacentral: 'JIC'
  koreasouth: 'KS'
  southindia: 'SI'
  westindia: 'WI'
  canadaeast: 'CE'
  francesouth: 'FS'
  germanynorth: 'GN'
  norwaywest: 'NW'
  switzerlandwest: 'SW'
  ukwest: 'UKW'
  uaecentral: 'UAEC'
  brazilsoutheast: 'BS'
}

@export()
@description('Format a numeric index into a three digit, zero-filled string.')
func formatIndex(index int) string =>
  format('0,D3', index)

@export()
@description('Derive a short name for an Azure location (region). For example: \'East US\' => \'EUS\'')
func nameLocation(location string) string =>
  listLocationShortNames()[location]

@export()
@description('Derive a name for a Virtual Network. For example: vnet-<subscription purpose>-<region>-<000>')
func nameNetworkVnet(location string, purpose string, index int) string =>
  'vnet-${toLower(purpose)}-${nameLocation(location)}-${formatIndex(index)}'

@export()
@description('Derive a name for a Subnet. For example: snet-<subscription purpose>-<region>-<000>')
func nameNetworkSubnet(location string, purpose string, index int) string =>
  'snet-${toLower(purpose)}-${nameLocation(location)}-${formatIndex(index)}'

func nameNetworkSecurityGroup(policyName string, index int) string =>
  'nsg-${replace(policyName, ' ', '_')}-${formatIndex(index)}'
