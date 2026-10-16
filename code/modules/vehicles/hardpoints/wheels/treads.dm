/obj/item/hardpoint/locomotion/treads
	name = "\improper 履带"
	desc = "载具行驶所必需的部件。轻钢合金履带配有橡胶垫，适合公路和舰内使用，能让坦克行驶得更快，但也比其他型号更容易损坏。"

	icon_state = "treads"
	disp_icon = "tank"
	disp_icon_state = "treads"

	slot = HDPT_TREADS

	health = 1500

	//with this settings, takes 3 tiles to reach top speed
	move_delay = VEHICLE_SPEED_FASTER
	move_max_momentum = 3
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.6

/obj/item/hardpoint/locomotion/treads/robust
	name = "\improper 加固履带"
	desc = "这些履带采用更坚韧的钢基复合材料制成，更加耐用。不过，额外重量会让坦克稍微慢一点。"

	health = 2500
	acid_resistant = TRUE

	move_max_momentum = 5 //same top speed, but takes 5 tiles to reach it

/obj/item/hardpoint/locomotion/treads/on_install(obj/vehicle/multitile/V)
	for(var/obj/item/hardpoint/support/overdrive_enhancer/OD in V.hardpoints)
		if(OD.health > 0)
			OD.apply_buff(V)
	if(move_delay)
		V.move_delay = move_delay
	if(move_max_momentum)
		V.move_max_momentum = move_max_momentum
	if(move_momentum_build_factor)
		V.move_momentum_build_factor = move_momentum_build_factor
	if(move_turn_momentum_loss_factor)
		V.move_turn_momentum_loss_factor = move_turn_momentum_loss_factor

/obj/item/hardpoint/locomotion/treads/deactivate()
	for(var/obj/item/hardpoint/support/overdrive_enhancer/OD in owner.hardpoints)
		if(OD.health > 0)
			OD.remove_buff(owner)
	owner.move_delay = initial(owner.move_delay)
	owner.move_max_momentum = initial(owner.move_max_momentum)
	owner.move_momentum_build_factor = initial(owner.move_momentum_build_factor)
	owner.move_turn_momentum_loss_factor = initial(owner.move_turn_momentum_loss_factor)
