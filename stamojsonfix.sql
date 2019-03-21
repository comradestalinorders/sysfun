select  
  -- from building_objects
  bo.building_id, bo.busyness_id,
  bo.id, bo.type_id,  bo.has_water, bo.is_active, bo.has_drains,
  bo.create_date, bo.is_building, bo.object_area, bo.name, bo.update_date,
  bo.condition_id, bo.description, bo.designation_id, bo.has_isolation, bo.has_telephone,
  bo.has_electricity, 
  bo.has_air_condition, bo.has_local_heating,
  price.price, --??,
  bo.percent_ideal_part, bo.has_central_heating,
  --bo.building_objects_type, bo.has_lux_casement, bo.contract_objects,
  bo.condition_description, bo.repair_needs_description,
  
  --from building
  b.name bname,
  b.floors,
  b.property_id, b.built_size,
  b.total_area,
  b.is_building bis_building,
  b.property_id bproperty_id,
  b.building_date, b.type_id bTypeId,
  b.total_area_arch, b.builtup_area_map , b.construction_id,
  b.acquisition_date, b.percent_ideal_part  bpercent_ideal_part, b.floors_above_ground,
  --b.building_construct
  
  --from property
  p.id pid,
  p.branch_id,
  p.end_date,
  p.latitude,
  p.address_id padr_id,
  p.longitude,
  p.start_date,
  p.has_end_date,
  p.cadaster_uid,
  p.condition_id  pcondition_id,
  p.description  pdescription,
  p.designation_id,
  p.admin_address_id,
  p.property_name,
  p.end_date_reason_id,
  p.municipal_zone_id,
  p.owner_document,
  p.owner_document_number,
  p.property_number,
  --p.cadaster_address
  p.end_date_reason_id,
  p.municipal_zone_id , 
  
  --"OwnerDocumentDate":"2019-01-27T00:00:00",
    --     "OwnerDocumentType":null,
      --   "PropertyCondition":null,
  p.owner_document_number,      -- "OwnerDocumentNumber":"1212",
  p.owner_document_type_id,        --"--OwnerDocumentTypeId":1,
         --"ConditionDescription":null,
         --"ConstructionDocument":null,
  p.construction_document_id,      
  p.percent_shared_ownership,    
  p.repair_needs_description,  
  
  --from address
  
  
  padr.id padrId, --,      
     --"$id":"4",
  padr.floor,   
  padr.area_id,     
  padr.city_id,       
  padr.block_no,          
  padr.entrance,          
  padr.street_no,          
  padr.country_id,         
  padr.appartment,       
  padr.street_name,      
  padr.complex_name,       
  padr.foreign_city,       
  padr.full_address      
         
  
  
from rentals_migr.building_objects bo 
join rentals_migr.building_object_price price on price.building_object_id = bo.id
join rentals_migr.buildings b on bo.building_id = b.id
join rentals_migr.properties p on b.property_id  = p.id
join rentals_migr.address padr on p.address_id = padr.id

--limit 10


