
/*
CONTAINS:
CANDLES
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/




/*
	candle, match, lighter
*/


/obj/item/tool/candle
	name = "红蜡烛"
	desc = "一支蜡烛。"
	icon = 'icons/obj/items/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = SIZE_TINY

	var/wax = 3000

/obj/item/tool/candle/update_icon()
	var/i
	if(wax>1500)
		i = 1
	else if(wax>250)
		i = 2
	else i = 3
	icon_state = "candle[i][heat_source ? "_lit" : ""]"

/obj/item/tool/candle/Destroy()
	if(heat_source)
		STOP_PROCESSING(SSobj, src)

	. = ..()

/obj/item/tool/candle/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a blowtorch
			light(SPAN_NOTICE("[user]随手用[W]点燃了[src]。"))
	else if(W.heat_source > 400)
		light()
	else
		return ..()

/obj/item/tool/candle/proc/light(flavor_text)
	if(!heat_source)
		heat_source = 1000
		if(!flavor_text)
			flavor_text = SPAN_NOTICE("[usr]点燃了[src]。")
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, SHOW_MESSAGE_VISIBLE)
		set_light(CANDLE_LUM)
		update_icon()
		START_PROCESSING(SSobj, src)

/obj/item/tool/candle/process()
	if(!heat_source)
		STOP_PROCESSING(SSobj, src)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		qdel(src)
		return
	update_icon()

/obj/item/tool/candle/attack_self(mob/user)
	..()

	if(heat_source)
		heat_source = 0
		update_icon()
		set_light(0)
		STOP_PROCESSING(SSobj, src)

///////////
//MATCHES//
///////////
/obj/item/tool/match
	name = "火柴"
	desc = "一根普通火柴，用于点燃上好的烟草制品。"
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "match"
	var/burnt = 0
	var/smoketime = 10 SECONDS
	var/burnt_name = "烧过的火柴"
	w_class = SIZE_TINY
	light_range = 2
	light_power = 1

	attack_verb = list("灼烧", "燎烧")

/obj/item/tool/match/afterattack(atom/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(istype(user) && istype(target, /obj/item/clothing/shoes/marine) && user.shoes == target && light_match())
		if(prob(5))
			user.visible_message(SPAN_NOTICE("<b>[user]</b>在自己的[target.name]上划[src]，结果它碎成了几截！"), SPAN_NOTICE("你在自己的[target.name]上划[src]，结果它碎成了几截！"), max_distance = 3)
			qdel(src)
		else
			user.visible_message(SPAN_NOTICE("<b>[user]</b>在自己的[target.name]上划着了[src]！"), SPAN_NOTICE("你在自己的[target.name]上划着了[src]！"), max_distance = 3)
		return
	return ..()

/obj/item/tool/match/process(delta_time)
	smoketime -= delta_time SECONDS
	if(smoketime < 1)
		burn_out()
		return

/obj/item/tool/match/Destroy()
	if(heat_source)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/tool/match/dropped(mob/user)
	if(heat_source)
		burn_out(user)
	return ..()

/obj/item/tool/match/turn_light(mob/user, toggle_on)
	. = ..()
	if(. == NO_LIGHT_STATE_CHANGE)
		return

	set_light_on(toggle_on)

/obj/item/tool/match/proc/light_match()
	if(heat_source || burnt)
		return
	heat_source = 1000
	playsound(src.loc,"match",15, 1, 3)
	damtype = "burn"
	icon_state = "[initial(icon_state)]_lit"
	turn_light(toggle_on = TRUE)
	START_PROCESSING(SSobj, src)
	update_icon()
	return TRUE

/obj/item/tool/match/proc/burn_out(mob/user)
	heat_source = 0
	burnt = 1
	damtype = "brute"
	icon_state = "[initial(icon_state)]_burnt"
	item_state = "cigoff"
	turn_light(toggle_on = FALSE)
	name = burnt_name
	desc = "一根火柴，已经烧得不成样子了。"
	STOP_PROCESSING(SSobj, src)

/obj/item/tool/match/paper
	name = "纸火柴"
	desc = "一根普通火柴，用于点燃上好的烟草制品。"
	icon_state = "papermatch"
	burnt_name = "烧过的纸火柴"

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "香烟"
	desc = "用纸包裹烟草和填料制成的烟卷，末端带有过滤嘴。据说吸入烟雾能让人心情愉快。"
	icon_state = "cigoff"
	throw_speed = SPEED_AVERAGE
	item_state = "cigoff"
	w_class = SIZE_TINY
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EAR | SLOT_FACE
	flags_obj = parent_type::flags_obj|OBJ_IS_HELMET_GARB
	flags_atom = CAN_BE_SYRINGED
	attack_verb = list("灼烧", "燎烧")
	blood_overlay_type = ""
	light_color = LIGHT_COLOR_ORANGE
	/// Note - these are in masks.dmi not in cigarette.dmi
	var/icon_on = "cigon"
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/trash/cigbutt
	var/lastHolder = null
	var/smoketime = 10 MINUTES
	var/chem_volume = 15

/obj/item/clothing/mask/cigarette/Initialize()
	. = ..()
	flags_atom |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	reagents.add_reagent("nicotine",10)
	if(w_class == SIZE_TINY)
		AddElement(/datum/element/mouth_drop_item)

/obj/item/clothing/mask/cigarette/attackby(obj/item/W, mob/user)
	..()
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())//Badasses dont get blinded while lighting their cig with a blowtorch
			light(SPAN_NOTICE("[user]随手用[W]点燃了[name]。"))

	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			light(SPAN_ROSE("[user]手腕一甩，用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/L = W
		if(L.heat_source)
			light(SPAN_NOTICE("[user]终于用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			light(SPAN_NOTICE("[user]用自己的[W]点燃了[name]。"))

	else if(istype(W, /obj/item/weapon/energy/sword))
		var/obj/item/weapon/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user]挥动[W]，险些削到自己的鼻子，顺势点燃了[name]。"))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user]摆弄了一番[W]，终于点燃了自己的[name]。"))

	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(!(F.flags_gun_features & GUN_TRIGGER_SAFETY))
			light(SPAN_NOTICE("[user]用[F]的引火焰点燃了自己的[name]。"))
		else
			to_chat(user, SPAN_WARNING("先点燃引火焰！"))

	else if(isgun(W))
		var/obj/item/weapon/gun/G = W
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
				light(SPAN_NOTICE("[user]用[G.attachments[slot]]点燃了自己的[name]。"))
				break

	else if(istype(W, /obj/item/tool/surgery/cautery))
		light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == icon_on)
			light(SPAN_NOTICE("尝试了几次后，[user]用[C]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			light(SPAN_NOTICE("尝试了几次后，[user]用[W]点燃了自己的[name]。"))

	return


/obj/item/clothing/mask/cigarette/afterattack(atom/target, mob/living/user, proximity)
	..()
	if(!proximity) return
	if(istype(target, /obj/item/reagent_container/glass)) //you can dip cigarettes into beakers
		var/obj/item/reagent_container/glass/glass = target
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered) //if reagents were transfered, show the message
			to_chat(user, SPAN_NOTICE("你将[src]浸入[glass]中。"))
		else //if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass]是空的。"))
			else
				to_chat(user, SPAN_NOTICE("[src]已经吸满了。"))

	else if(isturf(target))
		var/turf/T = target
		if(locate(/obj/flamer_fire) in T.contents)
			light(SPAN_NOTICE("[user]借着地上的火点燃了自己的[src]。"))

	else if(isliving(target))
		var/mob/living/M = target
		if(M.on_fire)
			if(user == M)
				light(SPAN_NOTICE("[user]借着自己身上的火点燃了[src]，简直疯了！"))
			else
				light(SPAN_NOTICE("[user]借着[M]身上的火点燃了自己的[src]，真是冷酷无情。"))

	else if(istype(target, /obj/structure/machinery/light))
		var/obj/structure/machinery/light/fixture = target
		if(fixture.is_broken())
			light(SPAN_NOTICE("[user]借着破损灯具点燃了自己的[src]。"))

/obj/item/clothing/mask/cigarette/proc/light(flavor_text)
	SIGNAL_HANDLER

	if(!heat_source)
		heat_source = 1000
		damtype = "fire"
		if(reagents.handle_volatiles())
			qdel(src)
			return
		flags_atom &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		set_light_range(1)
		set_light_power(0.5)
		set_light_on(TRUE)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if(C.r_hand == src)
				C.update_inv_r_hand()
			else if(C.l_hand == src)
				C.update_inv_l_hand()
			else if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				if(H.wear_mask == src)
					H.update_inv_wear_mask()
		if(flavor_text)
			var/turf/T = get_turf(src)
			T.visible_message(flavor_text)
		START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/cigarette/process(delta_time)
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	smoketime -= delta_time SECONDS
	if(smoketime < 1)
		smoketime = 0
		go_out()
		return

	if(reagents && reagents.total_volume) // check if it has any reagents at all
		if(iscarbon(loc) && (src == loc:wear_mask)) // if it's in the human/monkey mouth, transfer reagents to the mob
			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				if(H.species.flags & IS_SYNTHETIC)
					return
			var/mob/living/carbon/C = loc

			if(prob(15))
				reagents.reaction(C, INGEST)
			reagents.trans_to(C, REAGENTS_METABOLISM)
		else // else just remove some of the reagents
			reagents.remove_any(REAGENTS_METABOLISM)
	return


/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(heat_source)
		go_out(user)
	return ..()

/obj/item/clothing/mask/cigarette/proc/go_out(mob/user, silent = FALSE)
	var/mob/living/M
	if(ismob(loc))
		M = loc
		if(!silent)
			if(user == M)
				user.visible_message(SPAN_NOTICE(type_butt ? "[user]镇定地丢下点燃的[src]，一脚将它踩灭。" : "[user]熄灭了[src]。"))
			else
				to_chat(M, SPAN_NOTICE("你的[src.name]熄灭了。"))
	STOP_PROCESSING(SSobj, src)
	if(type_butt)
		var/turf/T = get_turf(src)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		//if(M)
			//M.temp_drop_inv_item(src) //un-equip it so the overlays can updat
		qdel(src)
		. = butt
	else
		set_light_on(FALSE)
		heat_source = 0
		icon_state = icon_off
		item_state = icon_off
	if(M)
		M.update_inv_wear_mask()

/obj/item/clothing/mask/cigarette/flamer_fire_act()
	. = ..()
	if(!heat_source)
		light()

/obj/item/clothing/mask/cigarette/extinguish()
	. = ..()
	if(heat_source)
		go_out()

/obj/item/clothing/mask/cigarette/proc/handle_extinguish()
	SIGNAL_HANDLER

	if(heat_source)
		go_out()

/obj/item/clothing/mask/cigarette/pickup(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_IGNITION, PROC_REF(light))
	RegisterSignal(user, COMSIG_HUMAN_EXTINGUISH, PROC_REF(handle_extinguish))

/obj/item/clothing/mask/cigarette/dropped(mob/user)
	. = ..()
	if(loc != user)
		UnregisterSignal(user, list(COMSIG_LIVING_IGNITION, COMSIG_HUMAN_EXTINGUISH))

/obj/item/clothing/mask/cigarette/ucigarette
	icon_on = "ucigon"
	icon_off = "ucigoff"
	type_butt = /obj/item/trash/cigbutt/ucigbutt
	name = "香烟"
	desc = "一支没有过滤嘴的烟卷，内含烟草和尼古丁。抽它会让更多焦油和烟尘进入你的口中。"
	item_state = "cigoff"
	icon_state = "ucigoff"

/obj/item/clothing/mask/cigarette/bcigarette
	icon_on = "bcigon"
	icon_off = "bcigoff"
	type_butt = /obj/item/trash/cigbutt/bcigbutt
	name = "香烟"
	desc = "一支装在精致黑色包装中的烟卷，内含烟草、尼古丁和少许荧光材料。点燃后，荧光材料会让烟头发出蓝光。"
	item_state = "bcigoff"
	icon_state = "bcigoff"

////////////
//  WEED  //
////////////
/obj/item/clothing/mask/cigarette/weed
	name = "大麻烟卷"
	desc = "用光滑的卷烟纸包裹大麻制成的烟卷。"
	chem_volume = 39
	smoketime = 20 MINUTES

/obj/item/clothing/mask/cigarette/weed/Initialize()
	. = ..()
	reagents.add_reagent("space_drugs",15)
	reagents.add_reagent("bicaridine", 8)
	reagents.add_reagent("kelotane", 1)

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "\improper 高级雪茄"
	desc = "一大卷棕色烟草和其他可供吸食的材料。抽起来让你觉得自己像个真正的殖民地陆战队中士。"
	icon_state = "cigar_off"
	icon_on = "cigar_on"
	icon_off = "cigar_off"
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_FACE
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	throw_speed = SPEED_VERY_FAST
	item_state = "cigar_off"
	smoketime = 50 MINUTES
	chem_volume = 20
	black_market_value = 15

/obj/item/clothing/mask/cigarette/cigar/classic
	name = "经典雪茄"
	desc = "这东西上面满是灰尘，还有疑似工具箱里留下的污渍。适合怀旧人士。"
	icon_state = "cigar2_off"
	icon_on = "cigar2_on"
	icon_off = "cigar2_off"
	smoketime = 120 MINUTES
	black_market_value = 30

/obj/item/clothing/mask/cigarette/cigar/tarbacks
	name = "\improper 焦背雪茄"
	desc = "赖斯兰烟草公司出品的焦背雪茄。卫生局局长声称，吸食焦背雪茄可能危害健康。赖斯兰烟草公司则声称，卫生局局长就是个婊子。在哥伦比亚卷制。"
	icon_state = "tarback_off"
	icon_on = "tarback_on"
	icon_off = "tarback_off"
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	item_state = "tarback_off"
	smoketime = 30 MINUTES

/obj/item/clothing/mask/cigarette/cigar/Initialize()
	. = ..()
	reagents.add_reagent("nicotine",10)

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper 高希霸罗布图雪茄"
	desc = "你对一支雪茄的期望，它几乎全都能满足。"

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "高级哈瓦那雪茄"
	desc = "只有顶尖人物才配得上的雪茄。"
	smoketime = 7200
	chem_volume = 30

/obj/item/clothing/mask/cigarette/cigar/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())
			light(SPAN_NOTICE("[user]居然用[W]点燃[name]，简直是在糟蹋它。"))

	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			light(SPAN_ROSE("[user]手腕一甩，用自己的[W]点燃了[name]。"))

	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/L = W
		if(L.heat_source)
			light(SPAN_NOTICE("[user]竟然用[W]点燃自己的[name]，实在有辱它的身价。"))

	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			light(SPAN_NOTICE("[user]用自己的[W]点燃了[name]。"))

	else if(istype(W, /obj/item/weapon/energy/sword))
		var/obj/item/weapon/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user]挥动[W]，险些削到自己的鼻子，顺势点燃了[name]。"))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user]摆弄了一番[W]，借助科学的力量点燃了自己的[name]。"))

	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]。要是先把它装到什么东西上，肯定会更帅！"))

	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(!(F.flags_gun_features & GUN_TRIGGER_SAFETY))
			light(SPAN_NOTICE("[user]用[F]的引火焰点燃了自己的[name]，眼中闪烁着纵火狂般的光芒。"))
		else
			to_chat(user, SPAN_WARNING("先点燃引火焰！"))

	else if(isgun(W))
		var/obj/item/weapon/gun/G = W
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
				light(SPAN_NOTICE("[user]用[G.attachments[slot]]点燃了自己的[src]，一副十足的狠角色模样。"))
				break

	else if(istype(W, /obj/item/tool/surgery/cautery))
		light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]，这下可谈不上无菌了！"))

	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == icon_on)
			light(SPAN_NOTICE("尝试了几次后，[user]用[C]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			light(SPAN_NOTICE("尝试了几次后，[user]用[W]点燃了自己的[name]。"))

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "烟斗"
	desc = "用来抽烟的烟斗。大概是用海泡石之类的材料制成的。"
	icon_state = "pipeoff"
	item_state = "pipeoff"
	/// Note - these are in masks.dmi
	icon_on = "pipeon"
	icon_off = "pipeoff"
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_FACE
	type_butt = null
	smoketime = 200 SECONDS
	var/ash = FALSE

/obj/item/clothing/mask/cigarette/pipe/get_examine_text(mob/user)
	. = ..()
	if(ash)
		. += "里面装满了烟灰。"
	else if(smoketime <= 0)
		. += "里面是空的。"

/obj/item/clothing/mask/cigarette/pipe/go_out()
	..()
	if(smoketime <= 0)
		ash = TRUE

/// Refills the pipe. Can be changed to an attackby later, if loose tobacco is added to vendors or something.
/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user)
	if(ash)
		user.visible_message("[user]倒掉了[src]里的烟灰。", "你倒掉了[src]里的烟灰。")
		new /obj/effect/decal/cleanable/ash(get_turf(user))
		ash = FALSE
	else if(smoketime <= 0)
		to_chat(user, SPAN_NOTICE("你重新往烟斗里填满烟草。"))
		smoketime = initial(smoketime)
	..()

/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())//
			light(SPAN_NOTICE("[user]莽撞地用[W]点燃了[name]。"))

	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			light(SPAN_ROSE("[user]小心翼翼地用自己的[W]点燃了[name]。"))

	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			light(SPAN_NOTICE("[user]用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/L = W
		if(L.heat_source)
			light(SPAN_NOTICE("[user]终于用[W]点燃了自己的[name]。"))

	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			light(SPAN_NOTICE("[user]用自己的[W]点燃了[name]。"))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user]摆弄了一番[W]，借助科学的力量点燃了自己的[name]。"))

/obj/item/clothing/mask/cigarette/pipe/light()
	if(smoketime > 0)
		return ..()
	to_chat(usr, SPAN_WARNING("[src]是空的！"))
	return

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "玉米芯烟斗"
	desc = "一种深受乡野居民喜爱的尼古丁摄入工具。多亏了太空潮人，它在现代乃至未来仍然流行。"
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	/// Note - these are in masks.dmi
	icon_on = "cobpipeon"
	icon_off = "cobpipeoff"
	smoketime = 800 SECONDS

/obj/item/clothing/mask/electronic_cigarette
	name = "电子烟"
	desc = "美国烟草公司生产的电子烟，该公司也生产好彩香烟。"
	icon_state = "cigoff"
	item_state = "cigoff"
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_EAR|SLOT_FACE
	var/icon_on = "cigon"
	var/icon_off = "cigoff"
	var/enabled = FALSE

/obj/item/clothing/mask/electronic_cigarette/update_icon()
	. = ..()
	if(enabled)
		icon_state = icon_on
		item_state = icon_on
		return
	icon_state = icon_off
	item_state = icon_off

/obj/item/clothing/mask/electronic_cigarette/attack_self(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("你[enabled ? "关闭" : "开启"]了[src]。"))
	enabled = !enabled
	update_icon()

/obj/item/clothing/mask/electronic_cigarette/cigar
	name = "电子雪茄"
	desc = "一支标签被刮掉的奢华电子雪茄。这会是从哪儿来的？"
	icon_state = "cigar_off"
	item_state = "cigar_off"
	icon_on = "cigar_on"
	icon_off = "cigar_off"

/////////
//ZIPPO//
/////////
/obj/item/tool/lighter
	name = "廉价打火机"
	desc = "便宜得像白送的打火机。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "lighter_g"
	item_state = "lighter_g"
	light_color = LIGHT_COLOR_LAVA
	var/icon_on = "lighter_g_on"
	var/icon_off = "lighter_g"
	var/clr = "g"
	w_class = SIZE_TINY
	throwforce = 4
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	flags_obj = parent_type::flags_obj|OBJ_IS_HELMET_GARB
	attack_verb = list("灼烧", "燎烧")

/obj/item/tool/lighter/zippo
	name = "\improper 芝宝打火机"
	desc = "精致的钢制芝宝打火机，点火也要有格调。"
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"
	var/engraved = FALSE

/obj/item/tool/lighter/zippo/attackby(obj/item/W as obj, mob/user as mob)
	. = ..()
	if(istype(W, /obj/item/attachable/bayonet))
		if(engraved)
			to_chat(user, SPAN_NOTICE("[src]上已经刻过字了。"))
			return

		var/str = copytext(reject_bad_text(input(user,"要刻什么字？", "设置刻字", "")), 1)
		if(length(str) == 0 || length(str) > 32)
			to_chat(user, SPAN_NOTICE("你没拿稳[W]，再试一次吧？"))
			return
		desc += "\n上面刻着“[str]”"
		engraved = TRUE
		to_chat(user, SPAN_NOTICE("你在[src]上刻下了“[str]”。"))

		log_admin("[user] has engraved \the [src] with engraving \"[str]\". (CKEY: ([user.ckey]))")

/obj/item/tool/lighter/zippo/black
	name = "黑色芝宝打火机"
	desc = "精致的黑色芝宝打火机，点火也要有格调。"
	icon_state = "blackzippo"
	item_state = "blackzippo"
	icon_on = "blackzippoon"
	icon_off = "blackzippo"

/obj/item/tool/lighter/zippo/blue
	name = "蓝色芝宝打火机"
	desc = "精致的蓝色芝宝打火机，点火也要有格调。"
	icon_state = "bluezippo"
	item_state = "bluezippo"
	icon_on = "bluezippoon"
	icon_off = "bluezippo"

/obj/item/tool/lighter/zippo/gold
	name = "金色芝宝打火机"
	desc = "经阳极氧化处理、呈现金色的芝宝打火机。虽然浮夸，但确实醒目。"
	icon_state = "goldzippo"
	item_state = "goldzippo"
	icon_on = "goldzippoon"
	icon_off = "goldzippo"
	black_market_value = 30

/obj/item/tool/lighter/zippo/executive
	name = "维兰德-汤谷高管款芝宝打火机"
	desc = "出众的芝宝打火机，采用公司的黑金配色装饰。"
	icon_state = "execzippo"
	item_state = "execzippo"
	icon_on = "execzippoon"
	icon_off = "execzippo"
	black_market_value = 40

/obj/item/tool/lighter/random

/obj/item/tool/lighter/random/Initialize()
		. = ..()
		clr = pick("r","c","y","g")
		icon_on = "lighter_[clr]_on"
		icon_off = "lighter_[clr]"
		icon_state = icon_off

/obj/item/tool/lighter/attack_self(mob/living/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!heat_source)
			heat_source = 1500
			icon_state = icon_on
			item_state = icon_on
			if(istype(src, /obj/item/tool/lighter/zippo) )
				user.visible_message(SPAN_ROSE("[user]连脚步都没停，便流畅地翻开并点着了[src]。"))
				playsound(src.loc,"zippo_open",10, 1, 3)
			else
				playsound(src.loc,"lighter",10, 1, 3)
				if(prob(95))
					user.visible_message(SPAN_NOTICE("尝试了几次后，[user]终于点着了[src]。"))

				else
					to_chat(user, SPAN_WARNING("你点打火机时烫伤了自己。"))
					if (user.l_hand == src)
						user.apply_damage(2,BURN,"l_hand")
					else
						user.apply_damage(2,BURN,"r_hand")
					user.visible_message(SPAN_NOTICE("尝试了几次后，[user]终于点着了[src]，却也烫到了手指。"))

			set_light_range(2)
			set_light_on(TRUE)
			START_PROCESSING(SSobj, src)
		else
			turn_off(user, 0)
	else
		return ..()
	return

/obj/item/tool/lighter/proc/turn_off(mob/living/bearer, silent = 1)
	if(heat_source)
		heat_source = 0
		icon_state = icon_off
		item_state = icon_off
		if(!silent)
			if(istype(src, /obj/item/tool/lighter/zippo) )
				bearer.visible_message(SPAN_ROSE("你听到轻轻一声咔哒，[bearer]看都没看就关上了[src]。"))
				playsound(src.loc,"zippo_close",10, 1, 3)
			else
				bearer.visible_message(SPAN_NOTICE("[bearer]悄悄关掉了[src]。"))

		set_light_on(FALSE)
		STOP_PROCESSING(SSobj, src)
		return 1
	return 0

/obj/item/tool/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!isliving(M))
		return
	M.IgniteMob()
	if(!istype(M, /mob))
		return

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_selected == "mouth" && heat_source)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/tool/lighter/zippo))
				cig.light(SPAN_ROSE("[user]迅速掏出[name]，为[M]举着火。"))
			else
				cig.light(SPAN_NOTICE("[user]将[name]伸向[M]，点燃了[cig.name]。"))
	else
		..()
