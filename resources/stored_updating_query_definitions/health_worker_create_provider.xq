import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
(:
import module namespace random = "http://basex.org/modules/random";
:)
import module namespace csd_blu = "https://github.com/openhie/openinfoman/csd_blu";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 
let $provs0 := if (exists($careServicesRequest/requestParams/id/@entityID)) then csd_bl:filter_by_primary_id(/CSD/providerDirectory/*,$careServicesRequest/requestParams/id) else ()  
return
  if (count($provs0) > 0) then (csd_blu:wrap_updating_providers(()))     (:do not allow duplicate ENTITYIDs:)
else
  let $entityID := 
    if (exists($careServicesRequest/requestParams/id/@entityID) and not($careServicesRequest/requestParams/id/@entityID = '')) then $careServicesRequest/requestParams/id/@entityID
  else concat('urn:uuid:', random:uuid())
  let $time :=current-dateTime()
  let $prov := 
  <provider entityID="{$entityID}">
    {(
      $careServicesRequest/requestParams/codedType,
      <demographic>
	{(
	  $careServicesRequest/requestParams/gender,
	  $careServicesRequest/requestParams/dateOfBirth
	 )}
	 </demographic>,
	 $careServicesRequest/requestParams/language,
         $careServicesRequest/requestParams/specialty,
	 if ($careServicesRequest/requestParams/status) 
	   then
	   <record created="{$time}" updated="{$time}" status="{$careServicesRequest/requestParams/status}" sourceDirectory="{$careServicesRequest/requestParams/sourceDirectory}"/>
	 else 
	   <record created="{$time}" updated="{$time}" status="Active" sourceDirectory="{$careServicesRequest/requestParams/sourceDirectory}"/>
     )}
  </provider>
  
  return (
    insert node $prov into /CSD/providerDirectory,  
    csd_blu:wrap_updating_providers(<provider entityID="{$entityID}"/>)
  )

