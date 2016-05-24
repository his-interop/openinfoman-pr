import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 
  let $provs0 := if (exists($careServicesRequest/requestParams/id)) then csd_bl:filter_by_primary_id(/CSD/providerDirectory/*,$careServicesRequest/requestParams/id) else /CSD/providerDirectory/*
  let $provs1 := if (exists($careServicesRequest/requestParams/otherID)) then csd_bl:filter_by_other_id($provs0,$careServicesRequest/requestParams/otherID) else $provs0
  let $provs2 := if (exists($careServicesRequest/requestParams/commonName)) then csd_bl:filter_by_common_name($provs1,$careServicesRequest/requestParams/commonName) else $provs1
  let $provs3 := if (exists($careServicesRequest/requestParams/codedType)) then csd_bl:filter_by_coded_type($provs2,$careServicesRequest/requestParams/codedType)    else $provs2
  let $provs4 := if (exists($careServicesRequest/requestParams/address/addressLine)) then csd_bl:filter_by_address($provs3, $careServicesRequest/requestParams/address/addressLine) else $provs3
  let $provs5 := if (exists($careServicesRequest/requestParams/record)) then csd_bl:filter_by_record($provs4,$careServicesRequest/requestParams/record) else $provs4
  let $provs6 := if (exists($careServicesRequest/requestParams/start) and exists($careServicesRequest/requestParams/max)) then csd_bl:limit_items($provs5,$careServicesRequest/requestParams/start,$careServicesRequest/requestParams/max) else $provs5
  let $provs7 := for $entityID in $provs6/@entityID         
   return <provider entityID="{$entityID}"/>

  return csd_bl:wrap_providers($provs7)
