local modpath = minetest.get_modpath("adv_vehicles")
dofile(modpath.."/api.lua")

minetest.register_craftitem("adv_vehicles:car_frame", {
	description = "Car Frame (raw)",
	inventory_image = "car_frame.png"
})

minetest.register_craftitem("adv_vehicles:wheel", {
	description = "Wheel",
	inventory_image = "wheel.png"
})

local plastic_itemstring
if minetest.get_modpath("basic_materials") then
	plastic_itemstring = "basic_materials:plastic_sheet"
elseif minetest.get_modpath("luxury_decor") then
	plastic_itemstring = "luxury_decor:plastic_sheet"
else
	error("'plastic_sheet' crafting element is required to be registered!")
end

minetest.register_craft({
	output = "adv_vehicles:car_frame",
	recipe = {
                  {plastic_itemstring, plastic_itemstring, plastic_itemstring},
                  {plastic_itemstring, plastic_itemstring, plastic_itemstring},
                  {plastic_itemstring, "", ""}
                 }
})

minetest.register_craft({
	output = "adv_vehicles:wheel",
	recipe = {
                  {plastic_itemstring, plastic_itemstring, "dye:dark_grey"},
                  {"default:steel_ingot", plastic_itemstring, ""},
                  {"", "", ""}
                 }
                        })


adv_vehicles.register_vehicle("bmw_118_two_seats", {
	hp_max = 60,
	mass = 1.3,
	max_vel = 5,
	cbox = {-1.2, -0.5, -3.0, 1.2, 1.5, 3.0},
	model = "bmw_118_two_seats_redone.b3d",
	textures = {"bmw_118_two_seats_new_tex.png"},
	seats = {["driver"]={busy_by=nil, pos={x=-3.5, z=3.5}}, 
                 ["passenger"]={busy_by=nil, pos={x=3.5, z=3.5}}},
	player_eye_offset = {x=-3.5, y=0, z=3.5}
                                                   }, {
                                                    
	description = "BMW 118 two-seater",
	inv_image = "bmw_118_two_seats_inv.png",
	craft_recipe = {
                        {"adv_vehicles:car_frame", "dye:blue", ""},
                        {"adv_vehicles:wheel", "adv_vehicles:wheel", "adv_vehicles:wheel"},
                        {"adv_vehicles:wheel", plastic_itemstring, ""}
	}})
	
--[[minetest.register_craftitem("adv_vehicles:bmw_two_seats_inv", {
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
})]]

adv_vehicles.register_vehicle("volvo", {
	hp_max = 130,
	mass = 25,
	max_vel = 3,
	cbox = {-1.2, -0.5, -4.5, 1.2, 2.0, 4.5},
	model = "volvo.b3d",
	textures = {"volvo.png"},
	seats = {["driver"]={busy_by=nil, pos={x=3.5, z=-13.0}}, 
                 ["passenger"]={busy_by=nil, pos={x=-3.5, z=-2.0}},
		 ["passenger"]={busy_by=nil, pos={x=3.5, z=-2.0}},
                 ["passenger"]={busy_by=nil, pos={x=-3.5, z=-1.0}},
                 ["passenger"]={busy_by=nil, pos={x=3.5, z=-1.0}},
                 ["passenger"]={busy_by=nil, pos={x=3.5, z=0}},
                 ["passenger"]={busy_by=nil, pos={x=-3.0, z=5.0}},
                 ["passenger"]={busy_by=nil, pos={x=3.0, z=5.0}}
                },
	player_eye_offset = {x=-3.5, y=0, z=-3.5}
                                                   }, {
                                                                                                
	description = "Volvo Bus",
	inv_image = "volvo_inv.png",
	craft_recipe = {
                        {"adv_vehicles:car_frame", "dye:yellow", "dye:yellow"},
                        {"adv_vehicles:wheel", "adv_vehicles:wheel", "adv_vehicles:wheel"},
                        {"adv_vehicles:wheel", plastic_itemstring, "default:steel_ingot"}
	}})


adv_vehicles.register_vehicle("kamaz", {
	hp_max = 160,
	mass = 40,
	max_vel = 1.5,
	cbox = {-1.5, -0.5, -3.5, 1.5, 2.5, 3.5},
	model = "kamaz.b3d",
	textures = {"kamaz.png"},
	seats = {["driver"]={busy_by=nil, pos={x=0, z=-18.0}}, 
	},
	player_eye_offset = {x=0, y=0, z=-18.0}
	}, {
                                           
		description = "Kamaz Truck",
		inv_image = "kamaz_inv.png",
                craft_recipe = {
                            {"adv_vehicles:car_frame", "dye:grey", "dye:white"},
                            {"adv_vehicles:wheel", "adv_vehicles:wheel", "adv_vehicles:wheel"},
                            {"adv_vehicles:wheel", plastic_itemstring, "default:steel_ingot"}
                           }
	})


