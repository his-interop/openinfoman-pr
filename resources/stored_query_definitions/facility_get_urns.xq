import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 
  let $facs0 := if (exists($careServicesRequest/requestParams/id)) then csd_bl:filter_by_primary_id(/CSD/facilityDirectory/*,$careServicesRequest/requestParams/id) else /CSD/facilityDirectory/*
  let $facs1 := if (exists($careServicesRequest/requestParams/otherID)) then csd_bl:filter_by_other_id($facs0,$careServicesRequest/requestParams/otherID) else $facs0
  let $facs2 := if (exists($careServicesRequest/requestParams/codedType)) then csd_bl:filter_by_coded_type($facs1,$careServicesRequest/requestParams/codedType)    else $facs1
  let $facs3 := if (exists($careServicesRequest/requestParams/address/addressLine)) then csd_bl:filter_by_address($facs2, $careServicesRequest/requestParams/address/addressLine) else $facs2
  let $facs4 := if (exists($careServicesRequest/requestParams/record)) then csd_bl:filter_by_record($facs3,$careServicesRequest/requestParams/record) else $facs3
  let $facs5 := if (exists($careServicesRequest/requestParams/start) and exists($careServicesRequest/requestParams/max)) then csd_bl:limit_items($facs4,$careServicesRequest/requestParams/start,$careServicesRequest/requestParams/max) else $facs4
  let $facs6 := for $entityID in $facs5/@entityID         
   return <facility entityID="{$entityID}"/>

  return csd_bl:wrap_facilities(($facs6))
