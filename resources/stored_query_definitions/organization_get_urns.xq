import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 
  let $orgs0 := if (exists($careServicesRequest/id)) then csd_bl:filter_by_primary_id(/CSD/organizationDirectory/*,$careServicesRequest/id) else /CSD/organizationDirectory/*
  let $orgs1 := if (exists($careServicesRequest/otherID)) then csd_bl:filter_by_other_id($orgs0,$careServicesRequest/otherID) else $orgs0
  let $orgs2 := if (exists($careServicesRequest/codedType)) then csd_bl:filter_by_coded_type($orgs1,$careServicesRequest/codedType)    else $orgs1
  let $orgs3 := if (exists($careServicesRequest/address/addressLine)) then csd_bl:filter_by_address($orgs2, $careServicesRequest/address/addressLine) else $orgs2
  let $orgs4 := if (exists($careServicesRequest/record)) then csd_bl:filter_by_record($orgs3,$careServicesRequest/record) else $orgs3
  let $orgs5 := if (exists($careServicesRequest/start) and exists($careServicesRequest/max)) then csd_bl:limit_items($orgs4,$careServicesRequest/start,$careServicesRequest/max) else $orgs4
  let $orgs6 := for $entityID in $orgs5/@entityID         
   return <organization entityID="{$entityID}"/>

  return csd_bl:wrap_organizations(($orgs6))
