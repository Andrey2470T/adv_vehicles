local modpath = minetest.get_modpath("adv_vehicles")
dofile(modpath.."/api.lua")

local function random_dropped_items_amount(player, itemstack, max_items_amount)
	local random_items_amount_to_give = math.random(max_items_amount)
        
        local stack = ItemStack(itemstack.. tostring(random_items_amount_to_give))
	local inv = minetest.get_inventory({type="player", name=player:get_player_name()})
	inv:add_item("main", stack)
end

minetest.register_craftitem("adv_vehicles:car_frame_material", {
	description = "Car Frame Material",
	inventory_image = "car_frame_material.png"
})

minetest.register_craftitem("adv_vehicles:wheel", {
	description = "Wheel",
	inventory_image = "wheel.png"
})

minetest.register_craftitem("adv_vehicles:steering_wheel", {
	description = "Steering Wheel",
	inventory_image = "steering_wheel.png"
})

minetest.register_craftitem("adv_vehicles:diesel_ice", {
	description = "Diesel ICE (Internal Combustion Engine)",
	inventory_image = "diesel_ice.png"
})

minetest.register_craftitem("adv_vehicles:cylinder", {
	description = "ICE Cylinder",
	inventory_image = "cylinder.png"
})

minetest.register_craftitem("adv_vehicles:crankshaft", {
	description = "ICE Crankshaft",
	inventory_image = "crankshaft.png"
})

minetest.register_craftitem("adv_vehicles:silicon_dust", {
	description = "Silicon Dust",
	inventory_image = "silicon_dust.png"
})

minetest.register_craftitem("adv_vehicles:aluminium_dust", {
	description = "Aluminium Dust",
	inventory_image = "aluminium_dust.png"
})

minetest.register_craftitem("adv_vehicles:aluminium_lump", {
	description = "Aluminium Lump",
	inventory_image = "aluminium_lump.png"
})

minetest.register_craftitem("adv_vehicles:silicon_lump", {
	description = "Silicon Lump",
	inventory_image = "silicon_lump.png"
})

minetest.register_craftitem("adv_vehicles:headlight_red", {
	description = "Red Headlight",
	inventory_image = "headlight_red.png"
})

minetest.register_craftitem("adv_vehicles:headlight_white", {
	description = "White Headlight",
	inventory_image = "headlight_white.png"
})

minetest.register_node("adv_vehicles:aluminium_ore", {
    description = "Aluminium Ore",
    tiles = {"default_stone.png^aluminium_ore.png"},
    is_ground_content = true,
    paramtype = "light",
    light_source = 1,
    drop="",
    groups = {cracky=3, oddly_breakable_by_hand=1},
    sounds = default.node_sound_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       random_dropped_items_amount(digger, "adv_vehicles:aluminium_lump ", 6)
    end
})

minetest.register_node("adv_vehicles:silicon_ore", {
    description = "Silicon Ore",
    tiles = {"default_stone.png^silicon_ore.png"},
    is_ground_content = true,
    paramtype = "light",
    light_source = 6,
    drop="",
    groups = {cracky=3, oddly_breakable_by_hand=1},
    sounds = default.node_sound_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       random_dropped_items_amount(digger, "adv_vehicles:silicon_lump ", 4)
    end
})

minetest.register_ore({
    ore_type = "sheet",
    ore = "adv_vehicles:aluminium_ore",
    wherein = "default:stone",
    clust_scarcity = 180,
    clust_num_ores = 7,
    clust_size = 4,
    height_min = -31000,
    height_max = -40
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "adv_vehicles:silicon_ore",
    wherein = "default:stone",
    clust_scarcity = 140,
    clust_num_ores = 5,
    clust_size = 3,
    height_min = -31000,
    height_max = -60
})

for i, v in pairs({"red", "white", "blue", "green"}) do
	minetest.register_craftitem("adv_vehicles:".. v .. "_led", {
		description = string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2) .. " LED",
		inventory_image = v .. "_led.png"
	})
end


local plastic_itemstring
if minetest.get_modpath("basic_materials") then
	plastic_itemstring = "basic_materials:plastic_sheet"
elseif minetest.get_modpath("luxury_decor") then
	plastic_itemstring = "luxury_decor:plastic_sheet"
else
	error("'plastic_sheet' crafting element is required to be registered!")
end

minetest.register_craft({
	output = "adv_vehicles:car_frame_material",
	recipe = {
                  {"default:steel_ingot", plastic_itemstring, "adv_vehicles:aluminium_dust"},
                  {"default:steel_ingot", plastic_itemstring, "adv_vehicles:aluminium_dust"},
                  {plastic_itemstring, "xpanes:pane_flat", ""}
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

minetest.register_craft({
	type="shapeless",
	output = "adv_vehicles:aluminium_dust",
	recipe = {"adv_vehicles:aluminium_lump"}
})

minetest.register_craft({
	type="shapeless",
	output = "adv_vehicles:silicon_dust",
	recipe = {"adv_vehicles:silicon_lump"}
})

minetest.register_craft({
	output = "adv_vehicles:red_led",
	recipe = {
		{"adv_vehicles:aluminium_dust", plastic_itemstring, "default:copper_ingot"},
		{"", "", ""},
		{"", "", ""}
	}
})

minetest.register_craft({
	output = "adv_vehicles:blue_led",
	recipe = {
		{"adv_vehicles:silicon_dust", plastic_itemstring, "default:copper_ingot"},
		{"", "", ""},
		{"", "", ""}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "adv_vehicles:white_led",
	recipe = {"adv_vehicles:red_led", "adv_vehicles:blue_led", "adv_vehicles:green_led"}
})

minetest.register_craft({
	output = "adv_vehicles:headlight_red",
	recipe = {
		{"adv_vehicles:red_led", "adv_vehicles:red_led", "adv_vehicles:red_led"},
		{"adv_vehicles:red_led", plastic_itemstring, "adv_vehicles:red_led"},
		{"adv_vehicles:red_led", "default:steel_ingot", "adv_vehicles:red_led"}
	}
})

minetest.register_craft({
	output = "adv_vehicles:headlight_white",
	recipe = {
		{"adv_vehicles:white_led", "adv_vehicles:white_led", "adv_vehicles:white_led"},
		{"adv_vehicles:white_led", plastic_itemstring, "adv_vehicles:white_led"},
		{"adv_vehicles:white_led", "default:steel_ingot", "adv_vehicles:white_led"}
	}
})
adv_vehicles.register_vehicle("bmw_118_two_seats", {
	hp_max = 60,
	mass = 1.3,
	acc_vector_length = 10.0,
	max_vel = 10,
	cbox = {-1.2, -0.5, -3.0, 1.2, 1.5, 3.0},
	model = "bmw_118_two_seats_redone.b3d",
	textures = {"bmw_118_two_seats_new_tex.png"},
	seats = {["driver"]={busy_by=nil, pos={x=4.0, z=-3.5}, eye_offset={x=-3.0, z=5.0}}, 
                 ["passenger"]={busy_by=nil, pos={x=-8.0, z=-3.5}, eye_offset={x=3.0, z=5.0}}}
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
	acc_vector_length = 6.5,
	max_vel = 3,
	cbox = {-1.2, -0.5, -4.5, 1.2, 2.0, 4.5},
	model = "volvo.b3d",
	textures = {"volvo.png"},
	seats = {["driver"]={busy_by=nil, pos={x=-4.5, z=-26.0}, eye_offset={x=4.0, z=31.0}}, 
                 ["passenger"]={busy_by=nil, pos={x=-3.5, z=-2.0}},
		 ["passenger"]={busy_by=nil, pos={x=3.5, z=-2.0}},
                 ["passenger"]={busy_by=nil, pos={x=-3.5, z=-1.0}},
                 ["passenger"]={busy_by=nil, pos={x=3.5, z=-1.0}},
                 ["passenger"]={busy_by=nil, pos={x=3.5, z=0}},
                 ["passenger"]={busy_by=nil, pos={x=-3.0, z=5.0}},
                 ["passenger"]={busy_by=nil, pos={x=3.0, z=5.0}}
                }
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
	acc_vector_length = 6.0,
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


