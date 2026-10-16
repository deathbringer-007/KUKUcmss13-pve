/datum/caste_datum/carrier
	caste_type = XENO_CASTE_CARRIER
	caste_desc = "抱脸虫的携带者。"
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_5
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	available_strains = list(/datum/xeno_strain/eggsac)
	behavior_delegate_type = /datum/behavior_delegate/carrier_base

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_DRONE)
	throwspeed = SPEED_FAST
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	hugger_nurturing = TRUE
	huggers_max = 16
	eggs_max = 8

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2
	hugger_delay = 10
	egg_cooldown = 250

	minimum_evolve_time = 5 MINUTES

	minimap_icon = "carrier"

/mob/living/carbon/xenomorph/carrier
	caste_type = XENO_CASTE_CARRIER
	name = XENO_CASTE_CARRIER
	desc = "一只外形古怪的异形，身上携带着许多蟹状多足生物，它们不停地爬动。"
	icon_size = 64
	icon_xeno = 'icons/mob/xenos/carrier.dmi'
	icon_state = "Carrier Walking"
	plasma_types = list(PLASMA_PURPLE)

	drag_delay = 6 //pulling a big dead xeno is hard
	var/huggers_reserved = 0

	mob_size = MOB_SIZE_BIG
	tier = 2
	pixel_x = -16 //Needed for 2x2
	old_x = -16
	organ_value = 1000

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds, //1st macro
		/datum/action/xeno_action/onclick/place_trap, //2nd macro
		/datum/action/xeno_action/activable/throw_hugger, //3rd macro
		/datum/action/xeno_action/activable/retrieve_egg, //4th macro
		/datum/action/xeno_action/onclick/set_hugger_reserve,
		/datum/action/xeno_action/onclick/tacmap,
		)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xenonid = 'icons/mob/xenonids/carrier.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Carrier_1","Carrier_2","Carrier_3")
	weed_food_states_flipped = list("Carrier_1","Carrier_2","Carrier_3")

	var/list/hugger_image_index = list()
	var/mutable_appearance/hugger_overlays_icon
	var/mutable_appearance/eggsac_overlays_icon

	//Carrier specific vars
	var/threw_a_hugger = 0
	var/huggers_cur = 0
	var/eggs_cur = 0
	var/huggers_max = 0
	var/eggs_max = 0
	var/laid_egg = 0

/mob/living/carbon/xenomorph/carrier/proc/update_hugger_overlays()
	if(!hugger_overlays_icon)
		return

	overlays -= hugger_overlays_icon
	hugger_overlays_icon.overlays.Cut()

	if(!huggers_cur)
		hugger_image_index.Cut()
		return

	update_clinger_maths(floor(( huggers_cur / huggers_max ) * 3.999) + 1)

	for(var/i in hugger_image_index)
		if(stat == DEAD)
			hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Knocked Down")
		else if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				hugger_overlays_icon.overlays += icon(icon, "clinger_[i] Sleeping")
			else
				hugger_overlays_icon.overlays +=icon(icon, "clinger_[i] Knocked Down")
		else
			hugger_overlays_icon.overlays +=icon(icon, "clinger_[i]")

	overlays += hugger_overlays_icon

/mob/living/carbon/xenomorph/carrier/proc/update_clinger_maths(number)
	var/clinger_list = list(1,2,3,4)
	if(length(hugger_image_index) != number)
		if(length(hugger_image_index) > number)
			while(length(hugger_image_index) != number)
				hugger_image_index -= hugger_image_index[length(hugger_image_index)]
		else
			while(length(hugger_image_index) != number)
				for(var/i in hugger_image_index)
					if(locate(i) in clinger_list)
						clinger_list -= i
				hugger_image_index += clinger_list[rand(1,length(clinger_list))]

/mob/living/carbon/xenomorph/carrier/proc/update_eggsac_overlays()
	if(!eggsac_overlays_icon)
		return

	overlays -= eggsac_overlays_icon
	eggsac_overlays_icon.overlays.Cut()

	if(!eggs_cur)
		return

	///Simplified image index change.
	var/i = 0
	if(eggs_cur > 8)
		i = 3
	else if (eggs_cur > 4)
		i = 2
	else if (eggs_cur > 0)
		i = 1

	if(stat != DEAD)
		if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				eggsac_overlays_icon.overlays += icon(icon, "eggsac_[i] Sleeping")
			else
				eggsac_overlays_icon.overlays +=icon(icon, "eggsac_[i] Knocked Down")
		else
			eggsac_overlays_icon.overlays +=icon(icon, "eggsac_[i]")

	overlays += eggsac_overlays_icon

/mob/living/carbon/xenomorph/carrier/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	hugger_overlays_icon = mutable_appearance('icons/mob/xenos/overlay_effects64x64.dmi',"empty")
	eggsac_overlays_icon = mutable_appearance('icons/mob/xenos/overlay_effects64x64.dmi',"empty")
	huggers_cur = rand(3,16)
	update_hugger_overlays()

/mob/living/carbon/xenomorph/carrier/death(cause, gibbed)
	. = ..(cause, gibbed)
	if(.)
		var/chance = 75 //75% to drop an egg or hugger.

		if(huggers_cur)
			//Hugger explosion, like an egg morpher
			var/mob/living/carbon/xenomorph/facehugger/hugger
			visible_message(SPAN_XENOWARNING("一群吱吱叫的小异形正试图逃离[src]！"))
			for(var/i in 1 to huggers_cur)
				if(prob(chance))
					hugger = new(loc, null, hivenumber)
					step_away(hugger, src, 1)

		var/eggs_dropped = FALSE
		for(var/i in 1 to eggs_cur)
			if(prob(chance))
				new /obj/item/xeno_egg(loc, hivenumber)
				eggs_dropped = TRUE
		eggs_cur = 0

		if(eggs_dropped) //Checks whether or not to announce egg drop.
			xeno_message(SPAN_XENOANNOUNCE("[src]掉落了几枚珍贵的卵！"), 2, hive.hivenumber)

/mob/living/carbon/xenomorph/carrier/recalculate_actions()
	. = ..()
	huggers_max = caste.huggers_max
	eggs_max = caste.eggs_max

/mob/living/carbon/xenomorph/carrier/get_status_tab_items()
	. = ..()
	if(huggers_max > 0)
		. += "储存的抱脸虫：[huggers_cur] / [huggers_max]"
	. += "储存的卵：[eggs_cur] / [eggs_max]"

/mob/living/carbon/xenomorph/carrier/proc/store_hugger(obj/item/clothing/mask/facehugger/F)
	if(F.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("这只抱脸虫受到异巢污染！"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		if(F.stat != DEAD && !F.sterile)
			huggers_cur++
			to_chat(src, SPAN_NOTICE("我们收起抱脸虫，随身保护。当前储存：[huggers_cur] / [huggers_max]。"))
			update_icons()
			qdel(F)
		else
			to_chat(src, SPAN_WARNING("这只[F.name]看起来太虚弱了。"))
	else
		to_chat(src, SPAN_WARNING("我们无法携带更多抱脸虫了。"))

/mob/living/carbon/xenomorph/carrier/proc/store_huggers_from_egg_morpher(obj/effect/alien/resin/special/eggmorph/morpher)
	if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
		to_chat(src, SPAN_WARNING("那个卵化器受到异巢污染！"))
		return

	if(morpher.stored_huggers == 0)
		to_chat(src, SPAN_WARNING("卵化器是空的！"))
		return

	if(huggers_max > 0 && huggers_cur < huggers_max)
		var/huggers_to_transfer = min(morpher.stored_huggers, huggers_max-huggers_cur)
		huggers_cur += huggers_to_transfer
		morpher.stored_huggers -= huggers_to_transfer
		if(huggers_to_transfer == 1)
			to_chat(src, SPAN_NOTICE("我们收起一只抱脸虫，随身保护。当前储存：[huggers_cur] / [huggers_max]。"))
		else
			to_chat(src, SPAN_NOTICE("我们收起[huggers_to_transfer]只抱脸虫，随身保护。当前储存：[huggers_cur] / [huggers_max]。"))
		update_icons()
	else
		to_chat(src, SPAN_WARNING("我们无法携带更多抱脸虫了。"))


/mob/living/carbon/xenomorph/carrier/proc/throw_hugger(atom/T)
	if(!T)
		return

	if(!check_state())
		return

	face_atom(T)

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = T
		if(isturf(F.loc) && Adjacent(F))
			if(F.hivenumber != hivenumber)
				to_chat(src, SPAN_WARNING("那只抱脸虫受到异巢污染！"))
				drop_inv_item_on_ground(F)
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("我们身上着火时触碰[F]会烧伤它！"))
				return
			store_hugger(F)
			return

	//target an egg morpher to top up on huggers
	if(istype(T, /obj/effect/alien/resin/special/eggmorph))
		var/obj/effect/alien/resin/special/eggmorph/morpher = T
		if(Adjacent(morpher))
			if(morpher.linked_hive && (morpher.linked_hive.hivenumber != hivenumber))
				to_chat(src, SPAN_WARNING("那个卵化器受到异巢污染！"))
				return
			if(on_fire)
				to_chat(src, SPAN_WARNING("我们身上着火时触碰[morpher]会烧伤里面的抱脸虫！"))
				return
			store_huggers_from_egg_morpher(morpher)
			return

	var/obj/item/clothing/mask/facehugger/F = get_active_hand()
	if(!F) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(huggers_cur <= 0)
			to_chat(src, SPAN_WARNING("我们没有可用的抱脸虫！"))
			return

		if(on_fire)
			to_chat(src, SPAN_WARNING("我们身上着火时取出抱脸虫会烧伤它！"))
			return

		F = new(src, hivenumber)
		huggers_cur--
		put_in_active_hand(F)
		to_chat(src, SPAN_XENONOTICE("我们取出了一只储存的抱脸虫。当前储存：[huggers_cur] / [huggers_max]。"))
		update_icons()
		return

	if(!istype(F)) //something else in our hand
		to_chat(src, SPAN_WARNING("我们需要手里拿着抱脸虫才能投掷！"))
		return

	threw_a_hugger = TRUE
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

	if(!do_after(src, 1 SECONDS, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE))
		return

	var/turf/target_turf = get_turf(T)
	var/mob/living/carbon/xenomorph/facehugger/child = new(loc, null, hivenumber)

	huggers_cur--
	update_icons()

	visible_message(SPAN_XENOWARNING("[src]朝[target_turf]扔出了什么东西！"), \
		SPAN_XENOWARNING("我们朝[target_turf]投出了一只抱脸虫！"))

	playsound(loc, get_sfx("alien_tail_swipe"), 120, 1)
	child.throw_atom(target_turf, 6, caste.throwspeed)

	spawn(caste.hugger_delay)
		threw_a_hugger = 0
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()

/mob/living/carbon/xenomorph/carrier/proc/store_egg(obj/item/xeno_egg/E)
	if(E.hivenumber != hivenumber)
		to_chat(src, SPAN_WARNING("那枚卵受到异巢污染！"))
		return
	if(eggs_cur < eggs_max)
		if(stat == CONSCIOUS)
			eggs_cur++
			update_icons()
			to_chat(src, SPAN_NOTICE("我们收起异形卵，随身保护。当前储存：[eggs_cur] / [eggs_max]。"))
			qdel(E)
		else
			to_chat(src, SPAN_WARNING("这枚[E.name]看起来太虚弱了。"))
	else
		to_chat(src, SPAN_WARNING("我们无法携带更多卵了。"))

/mob/living/carbon/xenomorph/carrier/proc/retrieve_egg(atom/T)
	if(!T) return

	if(!check_state())
		return

	//target a hugger on the ground to store it directly
	if(istype(T, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/E = T
		if(isturf(E.loc) && Adjacent(E))
			var/turf/egg_turf = E.loc
			store_egg(E)
			//Grab all the eggs from the turf
			if(eggs_cur < eggs_max)
				for(E in egg_turf)
					if(eggs_cur < eggs_max)
						store_egg(E)
			return

	var/obj/item/xeno_egg/E = get_active_hand()
	if(!E) //empty active hand
		//if no hugger in active hand, we take one from our storage
		if(eggs_cur <= 0)
			to_chat(src, SPAN_WARNING("我们没有可用的卵！"))
			return
		E = new(src, hivenumber)
		eggs_cur--
		update_icons()
		put_in_active_hand(E)
		to_chat(src, SPAN_XENONOTICE("我们取出了一枚储存的卵。当前储存：[eggs_cur] / [eggs_max]。"))
		return

	if(!istype(E)) //something else in our hand
		to_chat(src, SPAN_WARNING("我们需要腾出一只手，才能取出储存的卵！"))
		return

/mob/living/carbon/xenomorph/carrier/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Hugger but wants info
	join_as_facehugger_from_this(user)

/mob/living/carbon/xenomorph/carrier/proc/join_as_facehugger_from_this(mob/dead/observer/user)
	if(!huggers_max) //Eggsac doesn't have huggers, do nothing!
		return
	if(stat == DEAD)
		to_chat(user, SPAN_WARNING("[src]已经死亡，它携带的抱脸虫也全都死了。"))
		return
	if(!huggers_cur)
		to_chat(user, SPAN_WARNING("[src]没有可供你接管的抱脸虫。"))
		return
	if(huggers_cur <= huggers_reserved)
		to_chat(user, SPAN_WARNING("[src]已将剩余的抱脸虫留给自己使用。"))
		return
	if(!GLOB.hive_datum[hivenumber].can_spawn_as_hugger(user))
		return
	//Need to check again because time passed due to the confirmation window
	if(!huggers_cur)
		to_chat(user, SPAN_WARNING("[src]没有可供你接管的抱脸虫。"))
		return
	GLOB.hive_datum[hivenumber].spawn_as_hugger(user, src)
	huggers_cur--

/datum/behavior_delegate/carrier_base
	name = "Base Carrier Behavior Delegate"

/datum/behavior_delegate/carrier_base/on_update_icons()
	var/mob/living/carbon/xenomorph/carrier/bound_carrier = bound_xeno
	bound_carrier.update_hugger_overlays()
