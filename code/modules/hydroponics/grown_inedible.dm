// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/grown // Grown things that are not edible
	name = "grown_weapon"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	var/plantname
	var/potency = 1

/obj/item/grown/Initialize()
	. = ..()

	create_reagents(50)

	// Fill the object up with the appropriate reagents.
	if(!isnull(plantname))
		var/datum/seed/S = GLOB.seed_types[plantname]
		if(!S || !S.chems)
			return

		potency = S.potency

		for(var/rid in S.chems)
			var/list/reagent_data = S.chems[rid]
			var/rtotal = reagent_data[1]
			if(length(reagent_data) > 1 && potency > 0)
				rtotal += floor(potency/reagent_data[2])
			reagents.add_reagent(rid,max(1,rtotal))

/obj/item/grown/log
	name = "towercap"
	name = "塔冠菇原木"
	desc = "这可不是坏东西，明明是好东西！"
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "logs"
	force = 5
	flags_atom = NO_FLAGS
	throwforce = 5
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_VERY_FAST
	throw_range = 3

	attack_verb = list("猛击", "殴打", "砸击", "敲打")

/obj/item/grown/log/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_BIG)
		user.show_message(SPAN_NOTICE("你把[src]加工成木板！"), SHOW_MESSAGE_VISIBLE)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/sheet/wood/NG = new (user.loc)
			for (var/obj/item/stack/sheet/wood/G in user.loc)
				if(G==NG)
					continue
				if(G.amount>=G.max_amount)
					continue
				G.attackby(NG, user)
				to_chat(usr, "你将新制成的木板加入这摞木板，现在共有[NG.amount]块。")
		qdel(src)
		return

/obj/item/grown/sunflower // FLOWER POWER!
	plantname = "sunflowers"
	name = "向日葵"
	desc = "真漂亮！如果你踩坏了这些花，某个人可能会把你活活打死。"
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	damtype = "fire"
	force = 0
	flags_atom = NO_FLAGS
	throwforce = 1
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 3

/obj/item/grown/sunflower/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='green'><b>[user]用向日葵拍打你！</font><font color='yellow'><b>花朵之力！<b></font>")
	to_chat(user, "<font color='green'>你的向日葵释放出</font><font color='yellow'><b>花朵之力</b></font><font color='green'>，击中了[M]！</font>")

/obj/item/grown/nettle // -- Skie
	plantname = "nettle"
	desc = "赤手触碰它恐怕<B>不</B>太明智……"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	name = "荨麻"
	icon_state = "nettle"
	damtype = "fire"
	force = 15
	flags_atom = NO_FLAGS
	throwforce = 1
	w_class = SIZE_SMALL
	throw_speed = SPEED_FAST
	throw_range = 3

	attack_verb = list("蜇刺")
	hitsound = ""

	var/potency_divisior = 5

/obj/item/grown/nettle/Initialize()
	. = ..()
	force = round((5+potency/potency_divisior), 1)

/obj/item/grown/nettle/pickup(mob/living/carbon/human/user as mob)
	. = ..()
	if(istype(user) && !user.gloves)
		to_chat(user, SPAN_DANGER("荨麻灼伤了你裸露的手！"))
		if(istype(user, /mob/living/carbon/human))
			var/organ = ((user.hand ? "l_":"r_") + "arm")
			var/obj/limb/affecting = user.get_limb(organ)
			if(affecting.take_damage(0,force))
				user.UpdateDamageIcon()
		else
			user.take_limb_damage(0,force)
		return 1
	return 0

/obj/item/grown/nettle/proc/lose_leaves(mob/user)
	if(force > 0)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1)
		force -= rand(1,(force/3)+1) // When you whack someone with it, leaves fall off

	sleep(1)

	if(force <= 0)
		if(user)
			to_chat(user, "猛烈的挥打让[src]的叶子全部脱落了。")
			user.temp_drop_inv_item(src)
		qdel(src)

/obj/item/grown/nettle/death // -- Skie
	plantname = "deathnettle"
	desc = "这株发光的荨麻光是看着就让你<B>怒火中烧</B>！"
	name = "致命荨麻"
	icon_state = "deathnettle"

	potency_divisior = 2.5

/obj/item/grown/nettle/death/pickup(mob/living/carbon/human/user as mob)

	if(..() && prob(50))
		user.apply_effect(5, PARALYZE)
		to_chat(user, SPAN_DANGER("你试图拿起致命荨麻，却被它震晕了！"))

/obj/item/grown/nettle/attack(mob/living/carbon/M as mob, mob/user as mob)

	if(!..()) return

	lose_leaves(user)

/obj/item/grown/nettle/death/attack(mob/living/carbon/M as mob, mob/user as mob)

	if(!..()) return

	if(istype(M, /mob/living))
		to_chat(M, SPAN_WARNING("致命荨麻的强酸让你陷入眩晕！"))

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had the [src.name] used on them by [key_name(user)]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] on [key_name(M)]</font>")
		msg_admin_attack("[key_name(user)] used the [src.name] on [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		M.EyeBlur(force/7)
		if(prob(20))
			M.apply_effect(force/6, PARALYZE)
			M.apply_effect(force/15, WEAKEN)
		M.drop_held_item()

/obj/item/corncob
	name = "玉米芯"
	desc = "这是吃过玉米留下的痕迹。"
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = SIZE_SMALL
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/corncob/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_ACCURATE)
		to_chat(user, SPAN_NOTICE("你用[W]把玉米芯做成了烟斗！"))
		new /obj/item/clothing/mask/cigarette/pipe/cobpipe (user.loc)
		qdel(src)
	else
		return ..()
