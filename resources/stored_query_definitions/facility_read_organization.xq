import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
   
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 

let $facs0 := if (exists($careServicesRequest/organization/@entityID)) then /CSD/facilityDirectory/*  else ()
let $facs1 := if (exists($careServicesRequest/id/@entityID)) then csd_bl:filter_by_primary_id($facs0,$careServicesRequest/id) else ()
let $facs2 := 
  if (count($facs1) = 1) 
    then 
    let $facility :=  $facs1[1] 
    return 
      <facility entityID="{$facility/@entityID}">
	  {
	    (
	    <organizations>
	      {
		for $org in $facility/organizations/organization[upper-case(@entityID) = upper-case($careServicesRequest/organization/@entityID ) ]
		return
		<organization entityID="{$org/@entityID}"></organization>
	      }
	    </organizations>
	       
	      ,
	      $facility/record
	    )
	  }
      </facility>
  else ()    
    
return csd_bl:wrap_facilities($facs2)
