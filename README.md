# Advanced Vehicles 1.0.0-Release Candidate #2

## Description
------------------------------
Adds smart different cars (passenger cars, trucks, buses, service). This mod introduces little API to register cars with analogical parameters that use the mod (see *API Documentation)

## API Documentation
------------------------------
###adv_vehicles.register_vehicle(vehicle_name, vehicle_properties, vehicle_item)
--Registers a vehicle in the game as an entity and an item spawner for it.

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
*animation* is a table with x, y fields

###adv_vehicles.detach_player_from_veh(player, vehicle, seated, model, animation)
--Opposite to *adv_vehicles.attach_player_to_car*. Detaches a player from the car and the same arguments.

###adv_vehicles.pave_vector(vehicle, vect_length, old_yaw)
--Paves the vector from '0' point relatively to the car origin towards to *vect_length*.
*old_yaw* is a integer value that saving in self.fixed_veh_rotate_angle.
This method should be caused continuously per 0.1 second to recalculate the car direction.

###adv_vehicles.rotate_collisionbox(vehicle, yaw)
This method is WIP and doesnt work properly currently.

*This documentation is in working progress.*

## Crafting Recipes Guide
-----------------------------
L/B = Luxury Decor or Basic Materials

### Basic Items
Items that needed to craft any of vehicle sort.

***Car Frame***  
Basic element of crafting of all vehicles. Available only **before** 1.0.0-RC2.

-------------------
L/B plastic_sheet L/B plastic_sheet L/B plastic_sheet

L/B plastic_sheet L/B plastic_sheet L/B plastic_sheet

L/B plastic_sheet

-------------------
  
***Car Frame Material***  
Basic element of crafting of all vehicles. Available only **since** 1.0.0-RC2.

-------------------
default:steel_ingot === L/B plastic_sheet === adv_vehicles:aluminium_dust

default:steel_ingot === L/B plastic_sheet === adv_vehicles:aluminium_dust

L/B plastic_sheet === xpanes:pane_flat

L/B plastic_sheet

-------------------

***Tires Bunch***
A group of *tires* items. An element is needed for crafting of all vehicles. Just made to save a room in the crafting grid for other items.

-------------------
adv_vehicles:tire === adv_vehicles:tire === adv_vehicles:tire

adv_vehicles:tire

-------------------

***Two Red Headlights***
A group of *red headlights*. Just made to save a room in the crafting grid for other items.

-------------------
adv_vehicles:headlight_red === adv_vehicles:headlight_red

-------------------

***Two White Headlights***
A group of *white headlights*. Just made to save a room in the crafting grid for other items.

-------------------
adv_vehicles:headlight_white === adv_vehicles:headlight_white

-------------------

***Diesel ICE (Internal Combustion Engine)***
An important part of any vehicle without that no one can move in real. Crafted from *aluminium dust*, four *cylinders* and two *steel ingots*.

-------------------
adv_vehicles:cylinder === default:steel_ingot === default:steel_ingot

adv_vehicles:cylinder === adv_vehicles:cylinder

adv_vehicles:cylinder === adv_vehicles:aluminium_dust

-------------------

***Steering Wheel***
Needed for crafting of any vehicle.

-------------------
L/B plastic_sheet === L/B plastic_sheet === adv_vehicles:aluminium_dust

dye:black

-------------------


### Ores Generation and their stuff
Heres about the ores generation and all recipes what concerned to using these ores.

***Aluminium***
*Generates below -40 y coord.*
*Introduces itself a long sheet of ores.*
*Gives 1-6 *aluminium lumps*.
*Generates rarer than *silicon*.

***Silicon***
*Generates below -60 y coord.*
*Shapes small clusts of ores.*
*Gives 1-4 *silicon lumps*.
*Most frequently generated*.

***Phosphorus***
*Generates below -100 y coord.*
*Introduces blobs of ores.*
*Gives 1-3 *phosphorus lumps*.
*Very rare*

***Aluminium Lump***
Mined *aluminium ore*.

***Aluminium Dust***
Crafted from one *aluminium lump*.

***Silicon Lump***
Mined from *silicon ore*.

***Silicon Dust***
Crafted from *silicon lump*.

***Phosphorus Lump***
Mined from *aluminium ore*.

***Phosphorus Dust***
Mined from *phosphorus lump*.

***Aluminium and Silicon Dusts***
A group of *aluminium dust* and *silicon dust*. Needed for alloying of *silumin*.

***Silumin Ingot***
An alloy is consisted of *aluminium* and *silicon* dusts. Needed for crafting of *piston*, *crankshaft* and *cylinder*.

***Red LED***
A light-emitting diode of red color.

-------------------
adv_vehicles:aluminium_dust === L/B plastic_sheet === default:copper_ingot

-------------------

***Green LED***
A light-emitting diode of green color.

-------------------
adv_vehicles:phosphorus_dust === L/B plastic_sheet === default:copper_ingot

-------------------

***Blue LED***
A light-emitting diode of blue color.

-------------------
adv_vehicles:silicon_dust === L/B plastic_sheet === default:copper_ingot

-------------------

***White LED***
A light-emitting diode of white color. 

-------------------
adv_vehicles:red_led === adv_vehicles:blue_led === adv_vehicles:green_led

-------------------


### ICE (Internal Combustion Engine) Components.
Here are listed crafting recipes of ICE components.

***Piston***
A piston that implements fuel compression.

-------------------
default:steel_ingot === default:steel_ingot === default:steel_ingot

adv_vehicles:silumin_ingot === adv_vehicles:silumin_ingot

adv_vehicles:silumin_ingot

-------------------

***Crankshaft***

-------------------
default:steel_ingot === default:steel_ingot

adv_vehicles:silumin_ingot 

adv_vehicles:silumin_ingot

-------------------

***Cylinder***
A working chamber of the ICE.

-------------------
adv_vehicles:piston

adv_vehicles:crankshaft

adv_vehicles:silumin_ingot

-------------------


### Vehicles.
A list of crafting recipes of vehicles.

***BMW 118 Car***
Before 1.0.0-RC2.

-------------------
adv_vehicles:car_frame dye:blue

adv_vehicles:wheel adv_vehicles:wheel adv_vehicles:wheel

adv_vehicles:wheel L/B plastic_sheet

-------------------

***Volvo Bus***
Before 1.0.0-RC2.

-------------------
adv_vehicles:car_frame dye:yellow dye:yellow

adv_vehicles:wheel adv_vehicles:wheel adv_vehicles:wheel

adv_vehicles:wheel L/B plastic_sheet default:steel_ingot

-------------------

***Kamaz Truck***
Before 1.0.0-RC2.

-------------------
adv_vehicles:car_frame dye:grey dye:white

adv_vehicles:wheel adv_vehicles:wheel adv_vehicles:wheel

adv_vehicles:wheel L/B plastic_sheet default:steel_ingot

-------------------

***BMW 118 Car***
Since 1.0.0-RC2.

-------------------
adv_vehicles:car_frame_material === adv_vehicles:tires_bunch === adv_vehicles:two_red_headlights

adv_vehicles:car_frame_material === adv_vehicles:diesel_ice === adv_vehicles:two_white_headlights

adv_vehicles:car_frame_material === adv_vehicles:steering_wheel === dye:blue

-------------------

***Volvo Bus***
Since 1.0.0-RC2.

-------------------
adv_vehicles:car_frame_material === adv_vehicles:tires_bunch === adv_vehicles:two_red_headlights

adv_vehicles:car_frame_material === adv_vehicles:diesel_ice === adv_vehicles:two_white_headlights

adv_vehicles:car_frame_material === adv_vehicles:steering_wheel === dye:yellow

-------------------

***Kamaz Truck***
Since 1.0.0-RC2.

-------------------
adv_vehicles:car_frame_material === adv_vehicles:tires_bunch === adv_vehicles:two_red_headlights

adv_vehicles:car_frame_material === adv_vehicles:diesel_ice === adv_vehicles:two_white_headlights

adv_vehicles:car_frame_material === adv_vehicles:steering_wheel === dye:white

-------------------


### Miscellaneous Stuff

***Tire***
An element that intended for crafting of *tires bunch*

-------------------
L/B plastic_sheet === L/B plastic_sheet === dye:dark_green

default:steel_ingot === L/B plastic_sheet

-------------------

***Wheel***
An element of crafting of all vehicles. Available only **before** 1.0.0-RC2.

-------------------
L/B plastic_sheet === L/B plastic_sheet === dye:dark_green

default:steel_ingot === L/B plastic_sheet

-------------------

***Red Headlight***
Back car headlight. Crafted from seven *red_leds*, one *plastic_sheet* and one *steel ingot*.

-------------------
adv_vehicles:red_led === adv_vehicles:red_led === adv_vehicles:red_led
adv_vehicles:red_led === L/B plastic_sheet === adv_vehicles:red_led
adv_vehicles:red_led === default:steel_ingot === adv_vehicles:red_led

-------------------

***White Headlight***
Front car headlight. Crafted from four *white leds*, one *plastic_sheet* and one *steel ingot*.

-------------------
adv_vehicles:white_led === adv_vehicles:white_led === adv_vehicles:white_led
adv_vehicles:white_led === L/B plastic_sheet === adv_vehicles:white_led
adv_vehicles:white_led === default:steel_ingot === adv_vehicles:white_led

-------------------
