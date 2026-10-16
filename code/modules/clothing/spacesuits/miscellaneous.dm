//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "圣诞老人帽"
	desc = "嚯嚯嚯，圣诞快乐！"
	icon_state = "santa_hat_red"
	flags_inventory = NOPRESSUREDMAGE|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEYES
	flags_armor_protection = BODY_FLAG_HEAD

/obj/item/clothing/head/helmet/space/santahat/green
	icon_state = "santa_hat_green"

/obj/item/clothing/suit/space/santa
	name = "圣诞老人服"
	desc = "节日气氛十足！"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	allowed = list(/obj/item) //for stuffing extra special presents

/obj/item/clothing/head/helmet/space/pressure
	name = "\improper 压力头盔"
	desc = "一顶沉重的太空头盔。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	light_range = 4
	light_power = 0.8
	item_state = "pressure_white"
	icon_state = "pressure_white"
	blood_overlay_type = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	actions_types = list(/datum/action/item_action/toggle)
	time_to_unequip = 10
	time_to_equip = 10
	var/helmet_color = "white"
	var/toggleable = TRUE
	var/can_be_broken = TRUE
	var/breaking_sound = 'sound/handling/click_2.ogg'

/obj/item/clothing/head/helmet/space/pressure/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/head/helmet/space/pressure/update_icon()
	. = ..()
	if(light_on)
		icon_state = "pressure_[helmet_color]_[light_on]"
		item_state = "pressure_[helmet_color]_[light_on]"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

/obj/item/clothing/head/helmet/space/pressure/attack_self(mob/user)
	. = ..()

	if(!toggleable)
		to_chat(user, SPAN_WARNING("你无法开关[src]。"))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("身处[user.loc]时无法[light_on ? "关闭" : "开启"]灯光。")) //To prevent some lighting anomalies.
		return FALSE

	turn_light(user, !light_on)

/obj/item/clothing/head/helmet/space/pressure/turn_light(mob/user, toggle_on)

	. = ..()
	if(. != CHECKS_PASSED)
		return

	set_light_on(toggle_on)

	update_icon()

	if(user == loc)
		user.update_inv_head()

	for(var/datum/action/current_action as anything in actions)
		current_action.update_button_icon()

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

/obj/item/clothing/head/helmet/space/pressure/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)

	if(!can_be_broken)
		return

	if(turn_light(attacking_xeno, toggle_on = FALSE) != CHECKS_PASSED)
		return

	if(!breaking_sound)
		return

	playsound(loc, breaking_sound, 25, 1)

/obj/item/clothing/suit/space/pressure
	name = "\improper 压力服"
	desc = "一套沉重笨拙的民用太空服，配有装甲板。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	item_state = "pressure_white"
	icon_state = "pressure_white"
	blood_overlay_type = "suit"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	time_to_unequip = 25
	time_to_equip = 25

/obj/item/clothing/head/helmet/space/pressure/orange
	item_state = "pressure_orange"
	icon_state = "pressure_orange"
	helmet_color = "orange"
/obj/item/clothing/suit/space/pressure/orange
	item_state = "pressure_orange"
	icon_state = "pressure_orange"

/obj/item/clothing/head/helmet/space/pressure/yellow
	item_state = "pressure_yellow"
	icon_state = "pressure_yellow"
	helmet_color = "yellow"

/obj/item/clothing/suit/space/pressure/yellow
	item_state = "pressure_yellow"
	icon_state = "pressure_yellow"

/obj/item/clothing/head/helmet/space/pressure/cyan
	item_state = "pressure_cyan"
	icon_state = "pressure_cyan"
	helmet_color = "cyan"

/obj/item/clothing/suit/space/pressure/cyan
	item_state = "pressure_cyan"
	icon_state = "pressure_cyan"

/obj/item/clothing/head/helmet/space/pressure/red
	item_state = "pressure_red"
	icon_state = "pressure_red"
	helmet_color = "red"

/obj/item/clothing/suit/space/pressure/red
	item_state = "pressure_red"
	icon_state = "pressure_red"

/obj/item/clothing/suit/space/pressure/dark
	item_state = "pressure_dark"
	icon_state = "pressure_dark"

/obj/item/clothing/head/helmet/space/pressure/dark
	item_state = "pressure_dark"
	icon_state = "pressure_dark"
	helmet_color = "dark"

/obj/item/clothing/head/helmet/space/pressure/uscm
	name = "\improper USCM MK.35压力头盔"
	desc = "一顶沉重的太空头盔，与美国殖民地海军陆战队及少数美国或美洲联盟组织使用的MK.35压力服配套。感觉能在里面闷着抽烟。"
	item_state = "pressure_uscm"
	icon_state = "pressure_uscm"
	helmet_color = "uscm"

/obj/item/clothing/suit/space/pressure/uscm
	name = "\improper USCM MK.35压力服"
	desc = "一套沉重笨拙的军用太空服，由美国殖民地海军陆战队及少数美国或美洲联盟组织使用。"
	item_state = "pressure_uscm"
	icon_state = "pressure_uscm"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/baton,/obj/item/restraint/handcuffs,/obj/item/tank)
	flags_inventory = SMARTGUN_HARNESS

/obj/item/clothing/head/helmet/space/pressure/upp
	name = "\improper UPPAC 猎鹰-KV2压力头盔"
	desc = "一顶沉重的太空头盔，与进步人民联盟联合武装力量及少数其他联盟组织使用的猎鹰-KV2压力服配套。"
	item_state = "pressure_upp"
	icon_state = "pressure_upp"
	helmet_color = "upp"

/obj/item/clothing/suit/space/pressure/upp
	name = "\improper UPPAC 猎鹰-KV2压力服"
	desc = "一套沉重笨拙的军用太空服，由进步人民联盟联合武装力量及少数其他联盟组织使用。"
	item_state = "pressure_upp"
	icon_state = "pressure_upp"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/baton,/obj/item/restraint/handcuffs,/obj/item/tank)
	flags_inventory = SMARTGUN_HARNESS

// Souto man

/obj/item/clothing/suit/space/souto
	name = "\improper 索托侠背心"
	desc = "索托侠穿的背心，和一罐美味的经典索托一样清爽！"
	item_state = "souto_man"
	icon_state = "souto_man"
	armor_melee = CLOTHING_ARMOR_HARDCORE
	armor_bullet = CLOTHING_ARMOR_HARDCORE
	armor_laser = CLOTHING_ARMOR_HARDCORE
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_bomb = CLOTHING_ARMOR_HARDCORE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = CANTSTRIP|BLOCKSHARPOBJ
	unacidable = TRUE
	flags_inv_hide = null
	slowdown = 0

/obj/item/clothing/head/helmet/space/souto
	name = "\improper 索托侠帽"
	desc = "索托侠戴的帽子，和新款24盎司罐装青柠索托一样高！"
	item_state = "souto_man"
	icon_state = "souto_man"
	armor_melee = CLOTHING_ARMOR_HARDCORE
	armor_bullet = CLOTHING_ARMOR_HARDCORE
	armor_laser = CLOTHING_ARMOR_HARDCORE
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_bomb = CLOTHING_ARMOR_HARDCORE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = CANTSTRIP|COVEREYES|COVERMOUTH|ALLOWINTERNALS|ALLOWREBREATH|BLOCKGASEFFECT|ALLOWCPR|BLOCKSHARPOBJ
	unacidable = TRUE
	flags_inv_hide = null
