# Advanced Vehicles
Adds smart different cars (passenger cars, trucks, buses, service). This mod introduces little API to register cars with analogical parameters that use the mod (see *API Documentation)

## API Documentation
###adv_vehicles.register_vehicle(vehicle_name, vehicle_properties, vehicle_item)

*vehicle_name* is entity string.
*vehicle_properties* is a table with following fields:
     hp_max,
     mass,   is a property that sets a value of vehicle mass in tons. Necessary for calculating of the gravity.
     max_vel,  measured in metres in sec.
     cbox,  is collision box.
     model,
     textures,
     seats, is a table that contains a data about each seat (busy_by, pos fields). Key should be string containing a sort of seat (driver or passenger).
     player_eye_offset, is pos table
*vehicle_item* is a table with item spawner data. Fields: description, inv_image, craft_recipe.



*This documentation is in working progress.*
     
     
