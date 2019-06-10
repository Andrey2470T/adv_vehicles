local modpath = minetest.get_modpath("adv_vehicles")
dofile(modpath.."/api.lua")

adv_vehicles.register_car("bmw_118_two_seats", {
	hp_max = 100,
	mass = 1.3,
	max_vel = 5,
	cbox = {-1.2, -0.5, -3.0, 1.2, 1.5, 3.0},
	model = "bmw_118_two_seats.b3d",
	textures = {"bmw_118_two_seats.png"},
	seats = {["driver"]={busy_by=nil}, ["passenger"]={busy_by=nil}},
	player_eye_offset = {x=-3.5, y=0, z=-3.5}
})
	
minetest.register_craftitem("adv_vehicles:bmw_two_seats_inv", {
	description = "BMW 118 two-seater",
	inventory_image = "bmw_two_seats_inv.png",
	on_place = function (itemstack, placer, pointed_thing)
	if pointed_thing.type == "node" then
		local object = minetest.add_entity(pointed_thing.above, "adv_vehicles:bmw_118_two_seats")
		local yaw = math.deg(placer:get_look_horizontal())
		object:set_yaw(math.rad(yaw+180))
		minetest.debug(math.deg(object:get_yaw()))
                                                       
	end
end
})
