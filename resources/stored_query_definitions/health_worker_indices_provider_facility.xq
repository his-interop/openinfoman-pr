import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 
  let $provs0 := 
    if (exists($careServicesRequest/requestParams/id/@entityID)) then 
      csd_bl:filter_by_primary_id(/CSD/providerDirectory/*,$careServicesRequest/requestParams/id) 
    else (/CSD/providerDirectory/*)
  let $provs1:=     
      for $provider in  $provs0
      return
      <provider entityID="{$provider/@entityID}">
	<facilities>
          {
	    for $fac in $provider/facilities/facility 
	    return
	    <facility entityID="{$fac/@entityID}"></facility>
	  }
	</facilities>
      </provider>
      
    return csd_bl:wrap_providers($provs1)
