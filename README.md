# Advanced Vehicles
Adds smart different cars (passenger cars, trucks, buses, service). This mod introduces little API to register cars with analogical parameters that use the mod (see *API Documentation)

## API Documentation
###adv_vehicles.register_vehicle(vehicle_name, vehicle_properties, vehicle_item)
--Registers a vehicle in the game.

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

###adv_vehicles.rotate_point_around_other_point(circle_center_pos, rotating_point_pos, fixed_point_yaw, current_point_yaw)
--This method implements affine transformation of a point *rotating_point_pos* rotation along a circle with *circle_center_pos* center.

*circle_center_pos* is position table.
*rotating_point_pos* is position table.
*fixed_point_yaw* is the last fixed yaw of a vehicle (saving in self.fixed_veh_rotate_angle).
*current_point_yaw* is current yaw of a vehicle.

###adv_vehicles.attach_player_to_veh(player, vehicle, seated, model, animation)
--Attaches a player to the vehicle.

*player* is PlayerObjectRef.
*vehicle* is ObjectRef.
*seated* is "driver" or "passenger" keys depending on which field in *seats_list* used.
*model* is vehicle model (.b3d format).
*aniamtion* is animation table.
*This documentation is in working progress.*
     
     
