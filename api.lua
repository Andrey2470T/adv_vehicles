-- Advanced Vehicles by Andrey01

adv_vehicles = {}
global_nodenames_list = {}

-- Creates a list with all registered nodes.
local i = 0
for node_name, def in pairs(minetest.registered_nodes) do
	i = i+1
	global_nodenames_list[i] = node_name
end

-- DEPRECATED Rounds 'num' to the tenth and return the rounded number.
local function round_num(num)
	local int, frac = math.modf(num)
	local to_str = tostring(num)
	local to_str_frac = tostring(frac)
	local dot_ind = string.find(to_str_frac, '.')
	local tenth_rank = string.sub(to_str_frac, dot_ind+2, dot_ind+2)
	local new_frac = string.gsub(to_str_frac, tenth_rank, "0")
	local new_frac_to_int = tonumber(new_frac)
	local new_frac2 = string.gsub(to_str, tenth_rank, tostring(tonumber(tenth_rank)+1))
	local rounded_num = (new_frac_to_int < 0.05 and num-new_frac) or (new_frac_to_int >= 0.05 and tonumber(string.sub(new_frac2, 1, dot_ind+2)))
	return rounded_num
end

local is_car_driven = nil
-- The method calculates new position for any car seat (for example, after a car turning)
adv_vehicles.rotate_point_around_other_point = function (circle_centre_pos, rotating_point_pos, fixed_point_yaw, current_point_yaw)
	local turn_angle = current_point_yaw-fixed_point_yaw
	local new_pos = {x=rotating_point_pos.x, y=circle_centre_pos.y, z=rotating_point_pos.z}
	new_pos.x = circle_centre_pos.x + (rotating_point_pos.x-circle_centre_pos.x) * math.cos(turn_angle) - (rotating_point_pos.z-circle_centre_pos.z) * math.sin(turn_angle)
	new_pos.z = circle_centre_pos.z + (rotating_point_pos.z-circle_centre_pos.z) * math.cos(turn_angle) + (rotating_point_pos.x-circle_centre_pos.x) * math.sin(turn_angle)
	return new_pos
end

-- The method attaches a player to the car
adv_vehicles.attach_player_to_veh = function(player, vehicle, seated, model, animation)
    if vehicle.seats_list[seated].busy_by then
	    minetest.chat_send_player(player:get_player_name(), "This seat is busy by" .. vehicle.seats_list[seated].busy_by .. "!")
	    return 
    end
    
    vehicle.seats_list[seated].busy_by = player:get_player_name()
    local veh_rot = vehicle.object:get_rotation()
    local new_seat_pos = adv_vehicles.rotate_point_around_other_point({x=0, y=0, z=0}, vehicle.seats_list[seated].pos, vehicle.fixed_veh_rotate_angle, veh_rot.y)
    new_seat_pos.y = 9
    vehicle.seats_list[seated].pos = new_seat_pos
    local meta = player:get_meta()
    meta:set_string("is_sit", minetest.serialize({veh_name, seated}))
    local new_player_rot = {x=math.deg(veh_rot.x), y=veh_rot.y+180, z=math.deg(veh_rot.z)}
    local p=vehicle.object:get_pos()
    --player:set_pos({x=p.x+new_seat_pos.x, y=p.y, z=p.z+new_seat_pos.z})
    local eye_offset_fi, eye_offset_th = player:get_eye_offset()
    if vehicle.seats_list[seated].eye_offset then
	    local eye_off = vehicle.seats_list[seated].eye_offset
	    player:set_eye_offset({x=eye_offset_fi.x+eye_off.x, y=eye_offset_fi.y+(eye_off.y or 0), z=eye_offset_fi.z+eye_off.z}, eye_offset_th)
    end
    player:set_attach(vehicle.object, "", new_seat_pos, new_player_rot)
    
    --[[if not vehicle.seats_list[seated].eye_offset then
            player:set_eye_offset({x=vehicle.seats_list[seated].pos.x, y=0, z=vehicle.seats_list[seated].pos.z}, eye_offset)
    else
	    player:set_eye_offset({z=vehicle.seats_list[seated].eye_offset.x, y=0, z=vehicle.seats_list[seated].eye_offset.z}, eye_offset)
    end]]
	    
    --player:set_eye_offset({x=-4.0, y=-3.0, z=3.0}, eye_offset)
    
    
    if model then
	    player:set_properties({mesh=model})
    end
    if animation then
	    player:set_animation({x=animation.x, y=animation.y})
    end
end

-- The method detaches a player from the car
adv_vehicles.detach_player_from_veh = function (player, vehicle, seated, model, animation)
	if not vehicle.seats_list[seated].busy_by then
		return
	end
	local meta = player:get_meta()
	meta:set_string("is_sit", "")
	vehicle.seats_list[seated].busy_by = nil
	player:set_detach()
	player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
	if model then
		player:set_properties({mesh=model})
	end
	if animation then
		player:set_animation({x=animation.x, y=animation.y})
	end
end

-- Moves a point around the centre dependently on the rotation angle and returns derived new position of that point.
-- *old_yaw is a fixed_veh_rotation_angle is saved in an entity.
-- *old_acc_vect_pos is an acceleration vector position is also saved in the entity.
adv_vehicles.pave_vector = function (vehicle, old_acc_vect_pos, old_yaw)
	local yaw = vehicle.object:get_yaw()
	if yaw == old_yaw then
		return vehicle.acc_vector_pos, yaw
	end
	local new_acc_vect_pos = adv_vehicles.rotate_point_around_other_point({x=0, y=0, z=0}, old_acc_vect_pos, old_yaw, yaw)
	return new_acc_vect_pos, yaw
end

-- WARNING! This method doesn`t work properly currently. 
adv_vehicles.rotate_collisionbox = function (vehicle, yaw) 
	if yaw % 90 ~= 0 then
		return
	end
	local veh_cbox = vehicle.object:get_properties().collisionbox
	local cur_cbox_dir = vehicle.collisionbox_yaw.along_axis
	local axle_num 
	local new_axle_num = 1
	local axises_table = {"z", "x", "-z", "-x"}
	for num, axis in pairs(axises_table) do
		if axis == cur_cbox_dir then
			axle_num = num
			break
		end
	end
	local times = yaw / 90
	for i = 1, math.abs(times)+1 do
		if times < 0 then
			if axises_table[1] == cur_cbox_dir then
				new_axle_num = axises_table[#axises_table]
			else
				new_axle_num = new_axle_num - 1
			end
		else
			if axises_table[#axises_table] == cur_cbox_dir then
				new_axle_num = axises_table[1]
			else
				new_axle_num = new_axle_num + 1
			end
		end
	end
	
	local new_cbox_dir = axises_table[new_axle_num]
	local cboxes = {
		["z"] = {veh_cbox[1], veh_cbox[2], veh_cbox[3], veh_cbox[4], veh_cbox[5], veh_cbox[6]},
		["x"] = {veh_cbox[3], veh_cbox[2], veh_cbox[1], veh_cbox[6], veh_cbox[5], veh_cbox[4]},
		["-z"] = {veh_cbox[1]*-1, veh_cbox[2], veh_cbox[3]*-1, veh_cbox[4]*-1, veh_cbox[5], veh_cbox[6]*-1},
		["-x"] = {veh_cbox[3]*-1, veh_cbox[2], veh_cbox[1]*-1, veh_cbox[6]*-1, veh_cbox[5], veh_cbox[4]*-1}
	}
	local new_cbox = cboxes[new_cbox_dir]
	vehicle.object:set_properties({collisionbox=new_cbox})
	local old_cbox_yaw = vehicle.collisionbox_yaw.val
	vehicle.collisionbox_yaw = {val=old_cbox_yaw+yaw, along_axis=new_cbox_dir}
end
	
local is_fallen
-- Bounces a car only due to the falling.
adv_vehicles.collide = function (vehicle)
	local vel = vehicle.object:get_velocity()
	local fixed_vel = vehicle.y_vel
	local seats_list = vehicle.seats_list
	local hp = vehicle.object:get_hp()
	if vel.y == 0 and fixed_vel ~= 0 then
		if not is_fallen then
		is_fallen = true
		local acc = vehicle.object:get_acceleration()
		vehicle.object:set_acceleration({x=acc.x, y=math.abs(fixed_vel)*10, z=acc.z})
		vehicle.object:set_hp(hp-math.abs(math.ceil(fixed_vel)), {type="fall"})
		for seated, data in pairs(seats_list) do
			if seated.busy_by then
			     local player = minetest.get_player_by_name(seated.busy_by)
			     local player_hp = player:get_hp()
			     player:set_hp(player_hp-math.abs(math.ceil(fixed_vel)), {type="fall"})
			end
		end
		end
	else
		is_fallen = nil
	end
end
	
-- Called in each 0.1 second in the globalstep, decelerates the vehicle speed.
-- *vector_l is a vector length
adv_vehicles.vehicle_braking = function (vehicle, vector_l)
	local obj = vehicle.object
	local vel = obj:get_velocity()
	local vel_l = vector.length(vel)
	local acc_x = -(vel.x*vector_l/vel_l)
	local acc_z = -(vel.z*vector_l/vel_l)
	local acc_y = obj:get_acceleration().y
	obj:set_acceleration({x=acc_x, y=acc_y, z=acc_z})
	
	local new_acc = obj:get_acceleration()
	local new_vel = obj:get_velocity()
	if vector.length(new_vel) < 0.03 and not is_car_driven then
		obj:set_velocity({x=0, y=new_vel.y, z=0})
		obj:set_acceleration({x=0, y=new_acc.y, z=0})
	end
end
	
-- Implements vehicle controls (turning, moving forward/backwards).
adv_vehicles.vehicle_handle = function (vehicle, controls, yaw)
	local vel_l = vector.length(vehicle.object:get_velocity())
	local new_yaw=math.deg(yaw)
	if controls.right and vel_l ~= 0 then
		vehicle.object:set_yaw(yaw-math.rad(1))
		new_yaw = math.deg(vehicle.object:get_yaw())
		local fixed_cbox_yaw = vehicle.collisionbox_yaw.val
		if new_yaw-fixed_cbox_yaw <= -90 then
			--minetest.debug("1")
		      adv_vehicles.rotate_collisionbox(vehicle, -90)
		end
	end
	if controls.left and vel_l ~= 0 then
		vehicle.object:set_yaw(yaw+math.rad(1))
		new_yaw = math.deg(vehicle.object:get_yaw())
		local fixed_cbox_yaw = vehicle.collisionbox_yaw.val
		if new_yaw+fixed_cbox_yaw >= 90 then
			--minetest.debug("2")
		      adv_vehicles.rotate_collisionbox(vehicle, 90)
		end
	end
	
	local acc = vehicle.object:get_acceleration()
	local up_and_down_vals = {controls.up, controls.down}
	local t = {1, -1}
	local s
	for i, v in pairs(up_and_down_vals) do
		if v then
			s = t[i]
		end
	end
	
	if (controls.up and s) or (controls.down and s) then
		is_car_driven=true
		vehicle.object:set_acceleration({x=vehicle.acc_vector_pos.x*s, y=acc.y, z=vehicle.acc_vector_pos.z*s})
	else
		is_car_driven=nil
	end
		
	--[[if controls.up then
		is_car_driven=true
		vehicle.object:set_acceleration({x=vehicle.acc_vector_pos.x, y=acc.y, z=vehicle.acc_vector_pos.z})
	else
		is_car_driven=nil
	end
	
	if controls.down then
		is_car_driven=true
		vehicle.object:set_acceleration({x=vehicle.acc_vector_pos.x*-1, y=acc.y, z=vehicle.acc_vector_pos.z*-1})
	else
		is_car_driven=nil
	end	]]
	return math.rad(new_yaw)
end
	                            
		
--[[adv_cars.nearby_nodes_are = function (car)
	local vel = car.object:get_velocity()
	local pos = car.object:get_pos()
	local meta = minetest.deserialize(minetest.get_meta():get_string("is_sit"))
	local z_face = minetest.registered_entities[meta.car_name].collisionbox[6]
	if (vel.x and vel.y and vel.z) ~= 0 then
		
		local nearby_nodes = minetest.find_node_near(pos, z_face, global_nodenames_list)]]

-- Registers a vehicle to the world and creates a spawner item for it with a crafting recipe.
adv_vehicles.register_vehicle = function (vehname, veh_properties, veh_item)
	minetest.register_entity("adv_vehicles:"..vehname, {
		visual = "mesh",
		physical = true,
		mass = veh_properties.mass or 2000,
		acc_vector_length = veh_properties.acc_vector_length,
		max_vel = veh_properties.max_vel or 120,
		collide_with_objects = true,
		collisionbox = veh_properties.cbox,
		selectionbox = veh_properties.sbox or veh_properties.cbox,
		pointable=true,
		mesh = veh_properties.model,
		textures = veh_properties.textures,
		visual_size = veh_properties.visual_size or {x=1, y=1, z=1},
		use_texture_alpha = true,
		on_activate = function (self, staticdata, dtime_s)
			-- Fixed vehicle rotation angle (in rads). Necessary for calculating a point position.
			self.fixed_veh_rotate_angle = math.rad(0)
			self.collisionbox_yaw = {val=0, along_axis="z"}
			-- Entitysting of an object. 
			self.entity_name = "adv_vehicles:"..vehname
			-- List of a vehicle seats. Fields: 'driver'/'passenger', both keep 'busy_by' (playername) and 'pos' (of the seat) inside.
			self.seats_list = {}
			for seated, data in pairs(veh_properties.seats) do
				self.seats_list[seated] = data
				self.seats_list[seated].pos.y = 0
			end
			self.y_vel = 0
			local acc = self.object:get_acceleration()
			local gravity_strength = veh_properties.mass * -9.8
			self.object:set_acceleration({x=acc.x, y=gravity_strength, z=acc.z})
			local acc2 = self.object:get_acceleration()
			-- Original acceleration vector position (along to -z dir).
			self.acc_vector_pos = {x=0, y=acc2.y, z=veh_properties.acc_vector_length*-1}
			yaw = self.object:get_yaw()
			--Called in each 0.1 second.
			minetest.register_globalstep(function(dtime)
				local entity = self.object:get_luaentity()
				if entity then
				local obj = entity.object
				local vel = obj:get_velocity()
				if vel.y ~= 0 then
				    entity.y_vel = vel.y
				end
				local acc = obj:get_acceleration()
				if acc.y > 0 then
				obj:set_acceleration({x=acc.x, y=gravity_strength, z=acc.z})
				end
				adv_vehicles.collide(entity)
				
				-- Further it will get new position for the acceleration vector dependently on fixed rotation angle and fix new rotation angles.
				entity.acc_vector_pos, entity.fixed_veh_rotate_angle = adv_vehicles.pave_vector(entity, entity.acc_vector_pos, entity.fixed_veh_rotate_angle)
				if entity.seats_list["driver"].busy_by then
					local player = minetest.get_player_by_name(entity.seats_list["driver"].busy_by)
					yaw = entity.on_handle(entity, player:get_player_control(), yaw)
				end
				
				-- If a length of the velocity vector exceeds a 'max_vel' value, sets to zero the acceleration vector.
				local vel_length = vector.length(vel)
				if vel_length >= veh_properties.max_vel then
					obj:set_acceleration({x=0, y=gravity_strength, z=0})
				end
				if not is_car_driven and vel_length ~= 0 then
					adv_vehicles.vehicle_braking(entity, 8)
				end
				end
				
			end)
		end,
		on_handle = adv_vehicles.vehicle_handle,
		on_death = function (self, killer)
			for seated, data in pairs(self.seats_list) do
				if self.seats_list[seated].busy_by and minetest.get_player_by_name(self.seats_list[seated].busy_by) then 
					local player = minetest.get_player_by_name(self.seats_list[seated].busy_by)
					adv_vehicles.detach_player_from_veh(player, self, seated, "character.b3d") end
		        end
		end,
		--[[on_attach_child = function (self, child)
			local meta = minetest.deserialize(child:get_meta():get_string("is_sit"))
			minetest.debug(dump(meta))
			if meta.passenger then minetest.debug(child:get_player_name()) return end
			minetest.register_globalstep(function(dtime)
				local entity = self.object:get_luaentity()
				if entity then
					if entity.seats_list.driver.busy_by then
					local yaw = entity.object:get_yaw()
					local new_yaw = self.on_handle(entity, child:get_player_control(), yaw)
					yaw = new_yaw
					end
										
				end
			end)
		end,  ]]
		on_rightclick = function (self, clicker)
			local seats_list = self.seats_list
			for seated, data in pairs(seats_list) do
				if data.busy_by == nil  then
					if seated == "driver" then 
						adv_vehicles.attach_player_to_veh(clicker, self, seated, "driver.b3d")
						self.is_veh_stopping=nil
					else adv_vehicles.attach_player_to_veh(clicker, self, seated, nil, {x=81, y=81}) end
					break
				elseif data.busy_by == clicker:get_player_name() then
					if seated == "driver" then 
						adv_vehicles.detach_player_from_veh(clicker, self, seated, "character.b3d")
						self.is_veh_stopping=true
					else adv_vehicles.detach_player_from_veh(clicker, self, seated, nil, {x=1, y=80}) end
					break
				end
			end
		end
	})
		
	if veh_item then
		minetest.register_craftitem("adv_vehicles:"..vehname, {
			description = veh_item.description,
			inventory_image = veh_item.inv_image,
			on_place = function (itemstack, placer, pointed_thing)
				if pointed_thing.type == "node" then
					local object = minetest.add_entity(pointed_thing.above, "adv_vehicles:"..vehname)
					local yaw = math.deg(placer:get_look_horizontal())
					object:set_yaw(math.rad(yaw+180))
				end
			end
		})
		
		minetest.register_craft({
			output = "adv_vehicles:"..vehname,
			recipe = veh_item.craft_recipe
		})
	end
end

--[[minetest.register_on_joinplayer(function (player)
	local meta = player:get_meta()
	local attach = player:get_attach()
	if attach then
		local parent = attach[1]
		local entity = parent:get_luaentity()
		if entity then
		     local seat_num = meta:get_string("is_sit").seat_num
		     entity.seats_list[seat_num] = nil
		     adv_cars.attach_player_to_car(player, parent, seat_num, "driver.b3d")
		end
	end
end)]]
	
minetest.register_on_dieplayer(function (player)
	local meta = player:get_meta()
	if meta:get_string("is_sit") ~= (nil or "") then
		local attach = player:get_attach()
		local player_meta = minetest.deserialize(meta:get_string("is_sit"))
		local seated = player_meta.seated
		adv_vehicles.detach_player_from_veh(player, attach[1], seated, "character.b3d")
        end
end)

                                                  
    
