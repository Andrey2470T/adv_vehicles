adv_cars = {}

-- The method calculates new position for any car seat (for example, after a car turning)
adv_cars.rotate_point_around_other_point = function (circle_centre_pos, rotating_point_pos, fixed_point_yaw, current_point_yaw)
	local turn_angle = current_point_yaw - fixed_point_yaw
	local new_pos = {x=rotating_point_pos.x, y=circle_centre_pos.y, z=rotating_point_pos.z}
	new_pos.x = circle_centre_pos.x + (rotating_point_pos.x-circle_centre_pos.x) * math.cos(turn_angle) - (rotating_point_pos.z-circle_centre_pos.z) * math.sin(turn_angle)
	new_pos.z = circle_centre_pos.z + (rotating_point_pos.z-circle_centre_pos.z) * math.cos(turn_angle) + (rotating_point_pos.x-circle_centre_pos.x) * math.sin(turn_angle)
	return new_pos
end

-- The method attaches a player to the car
adv_cars.attach_player_to_car = function(player, car, seat_num, animation)
    if car.seats_list[seat_num].busy_by then
	    minetest.chat_send_player(player:get_player_name(), "This seat is busy by" .. car.seats_list[seat_num].busy_by .. "!")
	    return 
    end
    
    car.seats_list[seat_num].busy_by = player:get_player_name()
    local pos = car.object:get_pos()
    local car_rot = car.object:get_rotation()
    local fixed_car_yaw = car.fixed_car_rotate_angle
    local player_yaw = math.deg(player:get_look_horizontal())
    local new_seat_pos = adv_cars.rotate_point_around_other_point(pos, car.seats_list[seat_num][seat_num], fixed_car_yaw, math.deg(car_rot.y))
    new_seat_pos.y = pos.y
    car.seats_list[seat_num][seat_num] = new_seat_pos
    local new_player_rot = {x=math.deg(car_rot.x), y=math.deg(car_rot.y)+180, z=math.deg(car_rot.z)}
    player:set_attach(car.object, "", new_seat_pos, new_player_rot)
    local meta = player:get_meta()
    meta:set_string("is_sit", minetest.serialize({car_name, seat_num}))
    
    
    if animation then
	    player:set_properties({mesh=animation})
    end
end

-- The method detaches a player from the car
adv_cars.detach_player_from_car = function (player, car, seat_num, animation)
	if not car.seats_list[seat_num].busy_by then
		return
	end
	
	car.fixed_car_rotate_angle = math.deg(car.object:get_yaw())
	local meta = player:get_meta()
	meta:set_string("is_sit", "")
	car.seats_list[seat_num].busy_by = nil
	player:set_detach()
	player:set_properties({mesh=animation})
end

adv_cars.pave_vector = function (car)
	local pos = car.object:get_pos()
	local yaw = car.object:get_yaw()
	local pos2 = {x=0, y=0, z=0.25}
	
	local pos3 = adv_cars.rotate_point_around_other_point(pos, pos2, {x=0, y=0, z=0}, yaw)
	local vector = vector.new({0, 0, 0})
	local vector_coords = vector.direction(vector, pos3)
	return vector_coords
end

adv_cars.move_car = function (player, car)
	local vector_coords = adv_cars.pave_vector(car)
	local step = 0.25
	local times_acc = 4
	local time_exp = 0
	local time = 0
	minetest.register_globalstep(function (dtime)
		time = dtime + time
		if math.floor(time_exp + 0.3) == time then
			time = time_exp
			car.object:set_velocity()
			)
minetest.register_entity("adv_cars:simple_car", {
	visual = "mesh",
	physical = true,
	collide_with_objects = true,
	collisionbox = {-1.2, -0.5, -3.0, 1.2, 1.5, 3.0},
	mesh = "simple_car.b3d",
	textures = {"simple_car.png"},
	use_texture_alpha = true,
	on_activate = function (self, staticdata, dtime_s)
	        local car_pos = self.object:get_pos()
		local n_x_offset = 4.0
		local n_z_offset = -2.0
		local new_seat_pos
		local car_yaw = self.object:get_yaw()
		self.fixed_car_rotate_angle = 0
		self.seats_list = {["1"]={busy_by=nil}, ["2"]={busy_by=nil}}
		
		-- Calculates initial positions for each car seat after spawning the car
		for i = 1, 2 do
			self.seats_list[tostring(i)][tostring(i)] = {x=n_x_offset, y=car_pos.y, z=n_z_offset}
			n_x_offset = n_x_offset * -1
			
		end
			
	end,
	on_rightclick = function (self, clicker)
		local seats_list = self.seats_list
		for num, data in pairs(seats_list) do
			if data.busy_by == nil then
				adv_cars.attach_player_to_car(clicker, self, num, "driver.b3d")
				break
			elseif data.busy_by == clicker:get_player_name() then
				adv_cars.detach_player_from_car(clicker, self, num, "character.b3d")
				break
			end
		end
	end
})

--[[minetest.register_on_dieplayer(function (player)
	local meta = player:get_meta()
	if meta:get_string("is_sit") ~= (nil or "") then
		local attach = player:get_attach()
		local player_meta = meta:get_string("is_sit")
		adv_cars.detach_player_from_car(player, {attach[1], seats_list}))]]
minetest.register_craftitem("adv_cars:simple_car_inv", {
	description = "Simple Car",
	inventory_image = "simple_car_inv.png",
	on_place = function (itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
		    minetest.add_entity(pointed_thing.above, "adv_cars:simple_car")
		end
	end
})
                                                  
    
