/obj/item/device/flashlight
	name = "手电筒"
	desc = "手持式应急照明设备。"
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST

	matter = list("metal" = 50,"glass" = 20)
	light_color = "#dae2ff"
	light_range = 5
	light_power = 1
	ground_offset_x = 2
	ground_offset_y = 6

	actions_types = list(/datum/action/item_action/toggle)
	var/on = FALSE
	var/raillight_compatible = TRUE //Can this be turned into a rail light ?
	var/toggleable = TRUE
	///Should the flashlight rotate when thrown?
	var/rotation_on_throw = FALSE

	var/can_be_broken = TRUE //can xenos swipe at this to break it/turn it off?
	var/breaking_sound = 'sound/handling/click_2.ogg' //sound used when this happens

/obj/item/device/flashlight/Initialize()
	. = ..()
	update_icon()
	set_light_on(on)

/obj/item/device/flashlight/update_icon()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		item_state = "[initial(item_state)]-on"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

/obj/item/device/flashlight/animation_spin(speed = 5, loop_amount = -1, clockwise = TRUE, sections = 3, angular_offset = 0, pixel_fuzz = 0)
	if(rotation_on_throw)
		clockwise = pick(TRUE, FALSE)
		angular_offset = rand(360)
	return ..()

/obj/item/device/flashlight/proc/update_brightness(mob/user = null)
	if(on)
		set_light_range(light_range)
		set_light_on(TRUE)
		update_icon()
	else
		set_light_on(FALSE)

/obj/item/device/flashlight/attack_self(mob/user)
	..()

	if(!toggleable)
		to_chat(user, SPAN_WARNING("你无法开关[src.name]。"))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("身处[user.loc]时，你无法[on ? "关闭" : "开启"]照明。")) //To prevent some lighting anomalies.
		return FALSE

	on = !on
	set_light_on(on)
	update_icon()
	for(var/xman in actions)
		var/datum/action/active = xman
		active.update_button_icon()

	return TRUE

/obj/item/device/flashlight/proc/turn_off_light(mob/bearer)
	if(on)
		on = FALSE
		set_light_on(on)
		update_icon()
		for(var/xman in actions)
			var/datum/action/active = xman
			active.update_button_icon()
		return 1
	return 0

/obj/item/device/flashlight/attackby(obj/item/item as obj, mob/user as mob)
	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(!raillight_compatible) //No fancy messages, just no
			return
		if(on)
			to_chat(user, SPAN_WARNING("请先关闭[src]。"))
			return
		if(isstorage(loc))
			var/obj/item/storage/container = loc
			container.remove_from_storage(src)
		if(loc == user)
			user.drop_inv_item_on_ground(src) //This part is important to make sure our light sources update, as it calls dropped()
		var/obj/item/attachable/flashlight/flash = new(src.loc)
		user.put_in_hands(flash) //This proc tries right, left, then drops it all-in-one.
		to_chat(user, SPAN_NOTICE("你改装了[src]，现在可以把它安装到武器上。"))
		to_chat(user, SPAN_NOTICE("用螺丝刀调整[flash]即可将它改回原样。"))
		qdel(src) //Delete da old flashlight
		return
	else
		..()

/obj/item/device/flashlight/attack(mob/living/carbon/human/being as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_selected == "eyes")

		if((user.getBrainLoss() >= 60) && prob(50)) //too dumb to use flashlight properly
			return ..() //just hit them in the head

		if (!(ishuman(user) || SSticker) && SSticker.mode.name != "monkey") //don't have dexterity
			to_chat(user, SPAN_NOTICE("你的肢体不够灵巧，无法完成这个操作！"))
			return

		var/mob/living/carbon/human/beingB = being //mob has protective eyewear
		if(ishuman(beingB) && ((beingB.head && beingB.head.flags_inventory & COVEREYES) || (beingB.wear_mask && beingB.wear_mask.flags_inventory & COVEREYES) || (beingB.glasses && beingB.glasses.flags_inventory & COVEREYES)))
			to_chat(user, SPAN_NOTICE("你需要先取下[(beingB.head && beingB.head.flags_inventory & COVEREYES) ? "头盔" : (beingB.wear_mask && beingB.wear_mask.flags_inventory & COVEREYES) ? "面罩": "眼镜"]。"))
			return

		if(being == user) //they're using it on themselves
			being.flash_eyes()
			being.visible_message(SPAN_NOTICE("[being]用[src]照向自己的双眼。"), \
							SPAN_NOTICE("你在眼前晃动灯光！哇，眼前一阵迷幻！"))
			return

		user.visible_message(SPAN_NOTICE("[user]用[src]照向[being]的双眼。"), \
							SPAN_NOTICE("你用[src]照向[being]的双眼。"))

		if(ishuman_strict(being)) //robots and aliens are unaffected
			var/datum/internal_organ/eyes/eyes = being.internal_organs_by_name["eyes"]
			var/datum/internal_organ/brain/brain = being.internal_organs_by_name["brain"]
			if(being.stat == DEAD || being.sdisabilities & DISABILITY_BLIND || eyes.organ_status == ORGAN_BROKEN || brain.organ_status == ORGAN_BROKEN) //mob is dead, fully blind, or their eyes are
				to_chat(user, SPAN_NOTICE("[being]的瞳孔对光没有反应！"))
			else //they're okay! Well, probably
				being.flash_eyes()
				to_chat(user, SPAN_NOTICE("[being]的瞳孔收缩了。"))
				return
	else
		return ..()

/obj/item/device/flashlight/attack_alien(mob/living/carbon/xenomorph/being)
	. = ..()

	if(on && can_be_broken)
		if(breaking_sound)
			playsound(src.loc, breaking_sound, 25, 1)
		turn_off_light()

/obj/item/device/flashlight/on
	on = TRUE

/obj/item/device/flashlight/pen
	name = "医用笔灯"
	desc = "笔形照明工具，医护人员用它检查患者眼睛、大脑及整体意识状态。"
	icon_state = "penlight"
	item_state = ""
	flags_equip_slot = SLOT_WAIST|SLOT_EAR|SLOT_SUIT_STORE
	flags_atom = FPRINT|CONDUCT
	light_range = 2
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	matter = list("metal" = 10,"glass" = 5)
	raillight_compatible = 0

/obj/item/device/flashlight/pen/attack(mob/living/carbon/human/being as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(user.a_intent == INTENT_HELP)
		if(on && user.zone_selected == "eyes")
			if(!ishuman_strict(being)) //robots and aliens are unaffected
				return
			var/reaction = null
			if(isnull(being.internal_organs_by_name))
				reaction = "发现对方确实没有可供检查的器官"
				return // they have no organs somehow
			if(being == user) //they're using it on themselves
				being.flash_eyes()
				being.visible_message(SPAN_NOTICE("[being]用[src]照向自己的双眼。"), \
							SPAN_NOTICE("你在眼前晃动灯光！哇，眼前一阵迷幻！"))
				return
			if(being.stat == DEAD || (being.status_flags&FAKEDEATH))
				reaction = "判断对方双眼毫无生气，看来已经去世"
			else
				var/datum/internal_organ/eyes/eyes = being.internal_organs_by_name["eyes"]
				var/datum/internal_organ/brain/brain = being.internal_organs_by_name["brain"]
				if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
					if(eyes)
						switch(eyes.organ_status)
							if(ORGAN_LITTLE_BRUISED)
								being.flash_eyes()
								reaction = "注意到对方双眼<font color='yellow'>对光有反应</font>，但瞳孔似乎<font color='yellow'>反应迟缓，略有延迟</font>，视力可能<font color='yellow'>轻度受损</font>"
							if(ORGAN_BRUISED)
								being.flash_eyes()
								reaction = "观察到对方双眼<font color='orange'>对光反应不稳定</font>，瞳孔<font color='orange'>反应非常迟缓，延迟明显</font>，视力可能<font color='orange'>明显受损</font>"
							if(ORGAN_BROKEN)
								reaction = "注意到对方双眼<font color='red'>对光没有反应</font>，两眼瞳孔在光照下<font color='red'>完全不收缩</font>，对方可能已经<font color='red'>失明</font>"
							else
								being.flash_eyes()
								reaction = "发现对方双眼和瞳孔<font color='green'>对光反应正常</font>，视力应该<font color='green'>没有问题</font>"
					if(brain)
						if(reaction)
							reaction += "。你还"
						switch(brain.organ_status)
							if(ORGAN_LITTLE_BRUISED)
								being.flash_eyes()
								reaction += "注意到分别照射双眼时，瞳孔<font color='yellow'>间接对光反射明显延迟</font>，提示可能存在<font color='yellow'>轻微脑损伤</font>"
							if(ORGAN_BRUISED)
								being.flash_eyes()
								reaction += "注意到分别照射双眼时，瞳孔<font color='orange'>没有出现间接对光反射</font>，提示可能存在<font color='orange'>脑损伤</font>"
							if(ORGAN_BROKEN)
								reaction += "注意到瞳孔<font color='red'>大小不等且不对称</font>，提示可能存在<font color='red'>严重脑损伤</font>"
							else
								being.flash_eyes()
								reaction += "注意到分别照射双眼时，瞳孔<font color='green'>间接对光反射正常</font>，大脑<font color='green'>应该没有问题</font>"
					else
						reaction = "竟然什么也看不出来，真奇怪"
				else
					being.flash_eyes()
					reaction = "根本不知道该观察什么，你对医学一窍不通"
			user.visible_message("[user]用[src]照向[being]的双眼。", "你用[src]照向对方双眼，开始进一步检查……你[reaction]。")
	return ..()

/obj/item/device/flashlight/drone
	name = "低功率手电筒"
	desc = "可能是小型机器人使用的微型照明灯。"
	icon_state = "penlight"
	item_state = ""
	light_range = 2
	w_class = SIZE_TINY
	raillight_compatible = 0

//The desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "台灯"
	desc = "支架可调节的台灯。"
	icon_state = "lamp"
	item_state = "lamp"
	light_range = 5
	w_class = SIZE_LARGE
	on = 0
	raillight_compatible = 0

	breaking_sound = 'sound/effects/Glasshit.ogg'

/obj/item/device/flashlight/lamp/on
	on = TRUE

//Menorah!
/obj/item/device/flashlight/lamp/menorah
	name = "光明节烛台"
	desc = "用于庆祝光明节。"
	icon_state = "menorah"
	item_state = "menorah"
	light_range = 2
	light_color = LIGHT_COLOR_CANDLE
	w_class = SIZE_LARGE
	on = 1
	breaking_sound = null

//Generic Candelabra
/obj/item/device/flashlight/lamp/candelabra
	name = "多枝烛台"
	desc = "一个火灾隐患，还能让你肆无忌惮地拿它敲打东西。"
	icon_state = "candelabra"
	force = 15
	on = TRUE
	light_color = LIGHT_COLOR_CANDLE

	breaking_sound = null

//Green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "经典的绿色灯罩台灯。"
	icon_state = "lampgreen"
	item_state = "lampgreen"
	light_range = 5

/obj/item/device/flashlight/lamp/tripod
	name = "三脚架灯"
	desc = "安装在三脚架上的应急灯管，看起来永远不会熄灭。"
	icon_state = "tripod_lamp"
	light_range = 6//pretty good
	light_color = LIGHT_COLOR_XENON
	w_class = SIZE_LARGE
	on = 1

/obj/item/device/flashlight/lamp/tripod/grey
	icon_state = "tripod_lamp_grey"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "开关灯光"
	set category = "物品"
	set src in oview(1)

	if(istype(usr, /mob/living/carbon/xenomorph)) //Sneaky xenos turning off the lights
		attack_alien(usr)
		return

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "照明棒"
	desc = "USCM 配发的红色照明棒，侧面的说明写着“拉绳，发光”。"
	w_class = SIZE_SMALL
	light_power = 2
	light_range = 7
	icon_state = "flare"
	item_state = "flare"
	actions = list() //just pull it manually, neckbeard.
	raillight_compatible = 0
	can_be_broken = FALSE
	rotation_on_throw = TRUE
	var/burnt_out = FALSE
	var/fuel = 16 MINUTES
	var/fuel_rate = AMOUNT_PER_TIME(1 SECONDS, 1 SECONDS)
	var/on_damage = 7
	var/ammo_datum = /datum/ammo/flare

	/// Whether to use flame overlays for this flare type
	var/show_flame = TRUE
	/// Tint for the greyscale flare flame
	var/flame_tint = "#ffcccc"
	/// Color correction, added to the whole flame overlay
	var/flame_base_tint = "#ff0000"
	// "But, why are there two colors?"
	// The flame_tint is applied multiplicatively to the greyscale animation
	// However it represents levels within the flame, not the color of the flame as a whole.
	// To get around this, we additively apply flame_base_tint for coloring.

/obj/item/device/flashlight/flare/Initialize()
	. = ..()
	set_light_color(flame_tint)

/obj/item/device/flashlight/flare/update_icon()
	overlays?.Cut()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(show_flame)
			var/image/flame = image('icons/obj/items/lighting.dmi', src, "flare_flame")
			flame.color = flame_tint
			flame.appearance_flags = KEEP_APART|RESET_COLOR|RESET_TRANSFORM
			var/image/flame_base = image('icons/obj/items/lighting.dmi', src, "flare_flame")
			flame_base.color = flame_base_tint
			flame_base.appearance_flags = KEEP_APART|RESET_COLOR
			flame_base.blend_mode = BLEND_ADD
			flame.overlays += flame_base
			overlays += flame
	else if(burnt_out)
		icon_state = "[initial(icon_state)]-empty"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/flashlight/flare/dropped(mob/user)
	. = ..()
	if(iscarbon(user) && on)
		var/mob/living/carbon/flare_user = user
		flare_user.toggle_throw_mode(THROW_MODE_OFF)

/obj/item/device/flashlight/flare/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/flashlight/flare/process(delta_time)
	fuel -= fuel_rate * delta_time
	flare_burn_down()
	if(fuel <= 0 || !on)
		burn_out()

/obj/item/device/flashlight/flare/proc/flare_burn_down() //Controls the way in which flares slowly die out. Needs to be overriden by children, or they will be forced to use this light behavior.
	switch(fuel) //The code belows controls the timing on a flares burn out, and the corresponding reduction in effective range.
		if(15.25 MINUTES to 16 MINUTES)
			set_light_range(7)
		if(14.5 MINUTES to 15.24 MINUTES)
			set_light_range(6)
		if(6.5 MINUTES to 14.49 MINUTES)
			set_light_range(5)
		if(5.0 MINUTES to 6.49 MINUTES)
			set_light_range(4)
		if(3.5 MINUTES to 4.99 MINUTES)
			set_light_range(3)
		if(2.0 MINUTES to 3.49 MINUTES)
			set_light_range(2)
		if(0 MINUTES to 1.99 MINUTES)
			set_light_range(1)
			set_light_power(0.5) // A power of 2 results in no light at all, while .5 results in a small light.

// Causes flares to stop with a rotation offset for visual purposes
/obj/item/device/flashlight/flare/animation_spin(speed = 5, loop_amount = -1, clockwise = TRUE, sections = 3, angular_offset = 0, pixel_fuzz = 0)
	pixel_fuzz = 16
	return ..()
/obj/item/device/flashlight/flare/pickup()
	if(transform)
		apply_transform(matrix()) // reset rotation
	pixel_x = 0
	pixel_y = 0
	return ..()

/obj/item/device/flashlight/flare/proc/burn_out()
	turn_off()
	fuel = 0
	burnt_out = TRUE
	update_icon()
	add_to_garbage(src)
	STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/proc/turn_on()
	on = TRUE
	heat_source = 1500
	update_brightness()
	force = on_damage
	damtype = "fire"
	START_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = FALSE
	heat_source = 0
	force = initial(force)
	damtype = initial(damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/attack_self(mob/living/user)

	// Usual checks
	if(!fuel)
		to_chat(user, SPAN_NOTICE("燃料耗尽了。"))
		return FALSE
	if(on)
		if(!do_after(user, 2.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(!on)
			return
		var/hand = user.hand ? "l_hand" : "r_hand"
		user.visible_message(SPAN_WARNING("[user]熄灭了[src]。"),\
		SPAN_WARNING("你熄灭了[src]，烫伤了自己的手。"))
		user.apply_damage(7, BURN, hand)
		burn_out()
		//TODO: add snuff out sound so guerilla CLF snuffing flares get noticed
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(SPAN_NOTICE("[user]点燃了照明棒。"), SPAN_NOTICE("你拉动照明棒的拉绳，将它点燃！"))
		playsound(src,'sound/handling/flare_activate_2.ogg', 50, 1) //cool guy sound
		turn_on()
		var/mob/living/carbon/enjoyer = user
		if(istype(enjoyer) && !enjoyer.throw_mode)
			enjoyer.toggle_throw_mode(THROW_MODE_NORMAL)

/obj/item/device/flashlight/flare/proc/activate_signal(mob/living/carbon/human/user)
	return

/obj/item/device/flashlight/flare/on/Initialize()
	. = ..()
	turn_on()

/// Flares deployed by a flare gun
/obj/item/device/flashlight/flare/on/gun

//Special flare subtype for the illumination flare shell
//Acts like a flare, just even stronger, and set length
/obj/item/device/flashlight/flare/on/illumination
	name = "照明弹"
	desc = "亮得耀眼，而且够不着。"
	icon_state = "" //No sprite
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	show_flame = FALSE
	light_range = 7

/obj/item/device/flashlight/flare/on/illumination/Initialize()
	. = ..()
	fuel = rand(5.0 MINUTES, 6.0 MINUTES) // Approximately half the effective duration of a flare, but justified since it's invincible

/obj/item/device/flashlight/flare/on/illumination/flare_burn_down() // Empty proc to override parent.
	return

/obj/item/device/flashlight/flare/on/illumination/update_icon()
	return

/obj/item/device/flashlight/flare/on/illumination/turn_off()
	..()
	qdel(src)

/obj/item/device/flashlight/flare/on/illumination/ex_act(severity)
	return //Nope

/obj/item/device/flashlight/flare/on/starshell_ash
	name = "燃烧的照明弹灰烬"
	desc = "40 毫米照明弹留下的明亮燃烧灰烬。别碰，会烫伤的。"
	icon_state = "starshell_ash"
	anchored = TRUE//can't be picked up
	ammo_datum = /datum/ammo/flare/starshell
	show_flame = FALSE
	light_range = 6

/obj/item/device/flashlight/flare/on/starshell_ash/Initialize(mapload, ...)
	if(mapload)
		return INITIALIZE_HINT_QDEL
	. = ..()
	fuel = rand(6.0 MINUTES, 6.5 MINUTES)

/obj/item/device/flashlight/flare/on/starshell_ash/flare_burn_down() // Starshell's own burn_down curve, overrides parent flare.
	switch(fuel)
		if(6.0 MINUTES to 6.5 MINUTES)
			set_light_range(6)
		if(2.5 MINUTES to 5.99 MINUTES)
			set_light_range(5)
		if(2.0 MINUTES to 2.49 MINUTES)
			set_light_range(4)
		if(1.5 MINUTES to 1.99 MINUTES)
			set_light_range(3)
		if(1.0 MINUTES to 1.49 MINUTES)
			set_light_range(2)
		if(0 MINUTES to 0.99 MINUTES)
			set_light_range(1)
			set_light_power(0.5)

/obj/item/device/flashlight/flare/on/illumination/chemical
	name = "化学发光体"
	light_range = 0

/obj/item/device/flashlight/flare/on/illumination/chemical/Initialize(mapload, amount, color)
	. = ..()
	light_range = floor(amount * 0.04)
	if(!light_range)
		return INITIALIZE_HINT_QDEL
	set_light(light_range)
	fuel = amount * 5 SECONDS

/obj/item/device/flashlight/flare/upp
	name = "\improper R52 照明棒"
	desc = "UPPAC 配发的红色照明棒。"
	icon_state = "upp_flare"
	item_state = "upp_flare"

/obj/item/device/flashlight/flare/rmc
	name = "L96 照明棒"
	desc = "皇家陆战突击队配发的照明棒，燃烧时同时发出可见光和紫外光。侧面的说明写着“拉绳，发光”。"
	flame_tint = "#d79be5"
	flame_base_tint = "#6f00ff"

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "发光黏液"
	desc = "一个发光的小球，看上去像琥珀。"
	icon = 'icons/obj/items/lighting.dmi'
	// not a slime extract sprite but... something close enough!
	icon_state = "floor1"
	item_state = "slime"
	w_class = SIZE_TINY
	light_range = 6
	// Bio-luminesence has one setting, on.
	on = TRUE
	raillight_compatible = FALSE
	// Bio-luminescence does not toggle.
	toggleable = FALSE

/obj/item/device/flashlight/slime/Initialize()
	. = ..()
	set_light(light_range)
	update_brightness()
	icon_state = initial(icon_state)

//******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "矿灯"
	icon_state = "lantern"
	desc = "一盏采矿用提灯。"
	light_range = 6 // luminosity when on

//Signal Flare
/obj/item/device/flashlight/flare/signal
	name = "信号照明棒"
	desc = "USCM 配发的绿色信号照明棒。遥测计算机依靠释放烟雾与光的化学反应工作，因此只能在照明棒燃烧时运行。"
	icon_state = "cas_flare"
	item_state = "cas_flare"
	layer = ABOVE_FLY_LAYER
	ammo_datum = /datum/ammo/flare/signal
	light_range = 5
	var/faction = ""
	var/datum/cas_signal/signal
	var/activate_message = TRUE
	flame_base_tint = "#00aa00"
	flame_tint = "#aaccaa"

/obj/item/device/flashlight/flare/signal/Initialize()
	. = ..()
	fuel = rand(160 SECONDS, 200 SECONDS)

/obj/item/device/flashlight/flare/signal/flare_burn_down() // Empty proc to override parent.
	return

/obj/item/device/flashlight/flare/signal/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	. = ..()

	if(.)
		faction = user.faction
		addtimer(CALLBACK(src, PROC_REF(activate_signal), user), 5 SECONDS)

/obj/item/device/flashlight/flare/signal/activate_signal(mob/living/carbon/human/user)
	..()
	if(faction && GLOB.cas_groups[faction])
		signal = new(src)
		signal.target_id = ++GLOB.cas_tracking_id_increment
		name = "[user.assigned_squad ? user.assigned_squad.name : "X"]-[signal.target_id] 信号照明棒"
		signal.name = name
		signal.linked_cam = new(loc, name)
		GLOB.cas_groups[user.faction].add_signal(signal)
		anchored = TRUE
		if(activate_message)
			visible_message(SPAN_DANGER("[src]的火焰达到最大亮度，现已完全启用。"), null, 5)
		var/turf/target_turf = get_turf(src)
		msg_admin_niche("Flare target [src] has been activated by [key_name(user, 1)] at ([target_turf.x], [target_turf.y], [target_turf.z]). (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[target_turf.x];Y=[target_turf.y];Z=[target_turf.z]'>JMP LOC</a>)")
		log_game("Flare target [src] has been activated by [key_name(user, 1)] at ([target_turf.x], [target_turf.y], [target_turf.z]).")
		return TRUE

/obj/item/device/flashlight/flare/signal/attack_hand(mob/user)
	if (!user) return

	if(anchored)
		to_chat(user, "[src]太烫了，捡起来会烫伤你的手。")
		return
	..()

/obj/item/device/flashlight/flare/signal/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(signal)
		GLOB.cas_groups[faction].remove_signal(signal)
		QDEL_NULL(signal)
	return ..()

/obj/item/device/flashlight/flare/signal/turn_off()
	anchored = FALSE
	if(signal)
		GLOB.cas_groups[faction].remove_signal(signal)
		qdel(signal)
	..()

/obj/effect/landmark/rappel
	name = "索降点"
	var/datum/cas_signal/signal
	invisibility_value = SEE_INVISIBLE_OBSERVER
	icon_state = "o_green"

/obj/effect/landmark/rappel/New()
	. = ..()
	signal = new(src)
	signal.target_id = ++GLOB.cas_tracking_id_increment
	name = "索降点 #[signal.target_id]"
	signal.name = name
	GLOB.cas_groups[FACTION_MARINE].add_signal(signal)

/obj/effect/landmark/rappel/Destroy()
	if(signal)
		GLOB.cas_groups[FACTION_MARINE].remove_signal(signal)
		QDEL_NULL(signal)
	return ..()


/// Signal flares deployed by a flare gun
/obj/item/device/flashlight/flare/signal/gun
	activate_message = FALSE

/obj/item/device/flashlight/flare/signal/gun/activate_signal(mob/living/carbon/human/user)
	turn_on()
	faction = user.faction
	return ..()

/obj/item/device/flashlight/flare/signal/debug
	name = "debug signal flare"
	desc = "A signal flare used to test CAS runs. If you're seeing this, someone messed up."

/obj/item/device/flashlight/flare/signal/debug/Initialize()
	. = ..()
	fuel = INFINITY
	return INITIALIZE_HINT_ROUNDSTART

/obj/item/device/flashlight/flare/signal/debug/LateInitialize()
	activate_signal()

/obj/item/device/flashlight/flare/signal/debug/activate_signal()
	turn_on()
	faction = FACTION_MARINE
	signal = new(src)
	signal.target_id = ++GLOB.cas_tracking_id_increment
	name += " [rand(100, 999)]"
	signal.name = name
	signal.linked_cam = new(loc, name)
	GLOB.cas_groups[FACTION_MARINE].add_signal(signal)
	anchored = TRUE

/obj/item/device/flashlight/tnr
	name = "TNR 肩灯"
	desc = "一盏拆下来的 TNR 肩灯。"
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "tnr"
	item_state = "tnr"
	w_class = SIZE_MEDIUM
	flags_equip_slot = null
	raillight_compatible = 0

