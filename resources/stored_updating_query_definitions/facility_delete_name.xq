import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
import module namespace csd_blu = "https://github.com/openhie/openinfoman/csd_blu";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 
  if (exists($careServicesRequest/primaryName/@position)) 
    then 
    let $facilities := if (exists($careServicesRequest/id/@entityID)) then csd_bl:filter_by_primary_id(/CSD/facilityDirectory/*,$careServicesRequest/id) else ()
    return
      if ( count($facilities) = 1 )
	then
	let  $name :=  $facilities[1]/primaryName[position() = $careServicesRequest/primaryName/@position]
	return if (exists($name)) then (delete node $name) else ()
      else  ()
    else ()      
