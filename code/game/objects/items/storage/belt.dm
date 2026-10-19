/obj/item/storage/belt
	name = "腰带"
	desc = "可以容纳各种物品。"
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi'
	)
	item_state = "utility"
	flags_equip_slot = SLOT_WAIST
	attack_verb = list("鞭打", "抽打", "惩戒")
	w_class = SIZE_LARGE
	storage_flags = STORAGE_FLAGS_POUCH
	cant_hold = list(/obj/item/weapon/throwing_knife)
	///TRUE Means that it closes a flap over its contents, and therefore update_icon should lift that flap when opened. If it doesn't have _half and _full iconstates, this doesn't matter either way.
	var/flap = TRUE

/obj/item/storage/belt/gun/flaregun/dump_into(obj/item/storage/origin_storage, mob/user)

	if(length(holstered_guns) < 1 && length(contents) >= (storage_slots-1))

		to_chat(user, SPAN_WARNING("[src]已经装满。"))
		return FALSE
	return ..()

/obj/item/storage/belt/gun/flaregun/handle_item_insertion(obj/item/new_item, prevent_warning = FALSE, mob/user)

	if(istype(new_item, /obj/item/device/flashlight/flare) && length(holstered_guns) < 1 && length(contents) >= (storage_slots-1))
		return FALSE
	return ..()

/obj/item/storage/belt/gun/flaregun/has_room(obj/item/new_item, W_class_override = null)

	if(istype(new_item, /obj/item/device/flashlight/flare) && length(holstered_guns) < 1 && length(contents) >= (storage_slots-1))
		return FALSE //No slot open because gun in holster.
	return ..()

/obj/item/storage/belt/equipped(mob/user, slot)
	switch(slot)
		if(WEAR_WAIST, WEAR_J_STORE, WEAR_BACK)
			mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
	..()

/obj/item/storage/belt/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

/obj/item/storage/belt/update_icon()
	overlays.Cut()
	if(!length(contents))
		return
	if(content_watchers && flap) //If it has a flap and someone's looking inside it, don't close the flap.
		return
	else if(length(contents) <= storage_slots * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"

/obj/item/storage/belt/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		if(/obj/item/ammo_magazine/handful in src.can_hold)
			var/obj/item/ammo_magazine/shotgun/M = W
			dump_ammo_to(M,user, M.transfer_handful_amount)
			return
	. = ..()


/obj/item/storage/belt/champion
	name = "冠军腰带"
	desc = "向全世界证明你是最强的！"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(/obj/item/clothing/mask/luchador)






//============================//MARINE BELTS\\==================================\\
//=======================================================================\\


/obj/item/storage/belt/utility
	name = "M276 式工具携行腰带" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号没有战斗功能，常用于工程人员携带重要工具。"
	icon_state = "utilitybelt"
	item_state = "utility"
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/tool/extinguisher/mini,
		/obj/item/tool/shovel/etool,
		/obj/item/stack/cable_coil,
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/cell,
		/obj/item/circuitboard,
		/obj/item/stock_parts,
		/obj/item/device/demo_scanner,
		/obj/item/device/reagent_scanner,
		/obj/item/device/assembly,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/explosive/plastic,
		/obj/item/device/lightreplacer,
	)
	bypass_w_limit = list(
		/obj/item/tool/shovel/etool,
		/obj/item/device/lightreplacer,
	)
	storage_slots = 10

/obj/item/storage/belt/utility/full/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))
	new /obj/item/device/multitool(src)


/obj/item/storage/belt/utility/atmostech/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/t_scanner(src)

/obj/item/storage/belt/utility/construction
	name = "M277 式建筑工具挂具"
	desc = "M277 是专业战斗工兵携带材料和其他物资使用的少见挂具，由模块化腰带与多种挂扣组成。此型号牺牲储物空间，换取专用材料装载夹。"
	storage_slots = 6
	can_hold = list(
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/tool/extinguisher/mini,
		/obj/item/tool/shovel/etool,
		/obj/item/stack/cable_coil,
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/cell,
		/obj/item/circuitboard,
		/obj/item/stock_parts,
		/obj/item/device/demo_scanner,
		/obj/item/device/reagent_scanner,
		/obj/item/device/assembly,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/explosive/plastic,
		/obj/item/device/lightreplacer,
		/obj/item/stack/sheet,
		/obj/item/stack/sandbags_empty,
		/obj/item/stack/sandbags,
		/obj/item/stack/barbed_wire,
		/obj/item/defenses/handheld/sentry,
		/obj/item/ammo_magazine/sentry,
		/obj/item/device/sentry_computer,
		/obj/item/stack/rods,
		/obj/item/stack/tile,
	)

	bypass_w_limit = list(
		/obj/item/tool/shovel/etool,
		/obj/item/device/lightreplacer,
		/obj/item/stack/sheet,
		/obj/item/stack/sandbags_empty,
		/obj/item/stack/sandbags,
		/obj/item/defenses/handheld/sentry,
	)

/obj/item/storage/belt/utility/construction/full/fill_preset_inventory()
	new /obj/item/stack/sheet/plasteel(src, 30)
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/barbed_wire(src, 20)
	new /obj/item/defenses/handheld/sentry(src)
	new /obj/item/ammo_magazine/sentry(src)
	new /obj/item/device/sentry_computer(src)

/obj/item/storage/belt/utility/full/pred
	name = "\improper 铁血战士工具腰带"
	desc = "带有各种挂扣的模块化腰带。这一型不具备狩猎功能，通常由工程师用来携带重要工具。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "utilitybelt_pred"
	item_state = "utility"

/obj/item/storage/belt/medical
	name = "M276 式医疗携行挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号较少见，用于运输体积较大的医疗用品。\n右键点击图标，选择“切换腰带模式”，即可通过点击药瓶直接取出药片。"
	icon_state = "medicalbelt"
	item_state = "medical"
	storage_slots = 14
	max_w_class = SIZE_MEDIUM
	max_storage_space = 28
	var/mode = 1 //Picking from pill bottle mode

	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/syringe,
		/obj/item/tool/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/gloves/latex,
		/obj/item/storage/syringe_case,
		/obj/item/device/flashlight/flare,
		/obj/item/reagent_container/hypospray,
		/obj/item/bodybag,
		/obj/item/device/defibrillator,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/device/reagent_scanner,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/roller,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/reagent_container/glass/minitank,
		/obj/item/storage/surgical_case,
		/obj/item/reagent_container/blood,
	)

/obj/item/storage/belt/medical/only_scanner/fill_preset_inventory()
	new /obj/item/device/healthanalyzer/soul(src)

/obj/item/storage/belt/medical/full/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/verb/toggle_mode() //A verb that can (should) only be used if in hand/equipped
	set category = "Object"
	set name = "Toggle belt mode"
	set src in usr
	if(src && ishuman(usr))
		mode = !mode
		to_chat(usr, SPAN_NOTICE("现在你会[mode ? "直接从药瓶中取药片": "停止直接从药瓶中取药片"]。"))

/obj/item/storage/belt/medical/full/with_defib_and_analyzer/fill_preset_inventory()
	. = ..()
	new /obj/item/device/defibrillator(src)
	new /obj/item/device/healthanalyzer/soul(get_turf(src))

/obj/item/storage/belt/medical/full/with_suture_and_graft/fill_preset_inventory()
	. = ..()
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)

/obj/item/storage/belt/medical/get_examine_text()
	. = ..()
	. += SPAN_NOTICE("腰带当前设置为[mode ? "直接从药瓶中取药片": "不直接从药瓶中取药片"]。")

/obj/item/storage/belt/medical/upp
	name = "41 式医疗携行挂具"
	desc = "41 式是 UPP 军方的标准携行装备，由模块化腰带与多种挂扣组成。此配置较少见，用于运输医疗用品与手枪弹药。\n右键点击图标，选择“切换腰带模式”，即可通过点击药瓶直接取出药片。"
	icon_state = "medicalbelt_upp"
	item_state = "upp_belt"

/obj/item/storage/belt/medical/upp/full/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver
	name = "M276 式救生医疗包"
	desc = "M276 是 USCM 的标准携行装备。此配置带有装满各类注射器和轻便医疗用品的提包，在医疗兵中很常见。\n右键点击图标，选择“切换腰带模式”，即可通过点击药瓶直接取出药片。"
	icon_state = "medicbag"
	item_state = "medicbag"
	storage_slots = 21 //can hold 3 "rows" of very limited medical equipment, but it *should* give a decent boost to squad medics.
	max_storage_space = 42
	max_w_class = SIZE_SMALL
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/bodybag,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_container/hypospray/autoinjector,
		/obj/item/stack/medical,
		/obj/item/device/defibrillator/compact,
		/obj/item/device/reagent_scanner,
		/obj/item/device/analyzer/plant_analyzer,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/medical/lifesaver/standard
	has_gamemode_skin = FALSE

/obj/item/storage/belt/medical/lifesaver/standard/full/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver/full/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver/full/dutch/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/storage/pill_bottle/tricord(src)
	new /obj/item/storage/pill_bottle/imidazoline(src)
	new /obj/item/storage/pill_bottle/alkysine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver/full/forecon/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/alkysine(src)
	new /obj/item/storage/pill_bottle/imidazoline(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver/upp
	name = "41 式救生医疗包"
	desc = "41 式携行挂具是 UPP 军方的标准携行装备。此配置带有装满各类注射器和轻便医疗用品的提包，在医疗兵中很常见。"
	icon_state = "medicbag_u"
	item_state = "medicbag_u"
	has_gamemode_skin = FALSE

/obj/item/storage/belt/medical/lifesaver/upp/full/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver/upp/partial/fill_preset_inventory()
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)

/obj/item/storage/belt/medical/lifesaver/upp/synth/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/alkysine(src)
	new /obj/item/storage/pill_bottle/imidazoline(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/iron(src)

/obj/item/storage/belt/medical/lifesaver/upp/lesser/fill_preset_inventory()
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)

/obj/item/storage/belt/security
	name = "执勤腰带"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此配置常见于 USCM 宪兵和维和人员，也能携带少量轻型弹药。"
	icon_state = "securitybelt"
	item_state = "security"//Could likely use a better one.
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	storage_slots = 7
	max_w_class = SIZE_MEDIUM
	max_storage_space = 21
	can_hold = list(
		/obj/item/reagent_container/spray/pepper,
		/obj/item/restraint/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/handful,
		/obj/item/weapon/baton,
		/obj/item/weapon/classic_baton,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/device/flashlight,
		/obj/item/device/clue_scanner,
		/obj/item/notepad/blue,
	)

/obj/item/storage/belt/security/full/fill_preset_inventory()
	new /obj/item/weapon/baton(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/belt/security/MP
	name = "M276 式宪兵挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号布满小袋，用于携带非致命装备和束缚器材。"
	storage_slots = 8
	max_w_class = SIZE_MEDIUM
	max_storage_space = 30

/obj/item/storage/belt/security/MP/full/fill_preset_inventory()
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/ammo_magazine/pistol/vp70(src)
	new /obj/item/ammo_magazine/pistol/vp70(src)

/obj/item/storage/belt/security/MP/full/synth/fill_preset_inventory()
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/device/clue_scanner(src)
	new /obj/item/restraint/handcuffs(src)

/obj/item/storage/belt/security/MP/UPP
	name = "43 式宪兵挂具"
	desc = "43 式是 UPP 的标准携行装备，由模块化腰带与多种挂扣组成。此型号布满小袋，用于携带非致命装备和束缚器材。"

/obj/item/storage/belt/security/MP/UPP/full/fill_preset_inventory()
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/ammo_magazine/pistol/t73(src)
	new /obj/item/ammo_magazine/pistol/t73(src)
	new /obj/item/ammo_magazine/pistol/t73(src)

/obj/item/storage/belt/security/MP/CMB
	name = "警务执勤腰带"
	desc = "殖民地执法局及其他执法机构使用的优质黑色执勤腰带。"
	storage_slots = 6
	max_w_class = SIZE_MEDIUM
	max_storage_space = 30

/obj/item/storage/belt/security/MP/CMB/full/fill_preset_inventory()
	new /obj/item/weapon/baton(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/notepad/blue(src)

/obj/item/storage/belt/security/MP/CMB/full/revolver/fill_preset_inventory()
	new /obj/item/weapon/baton(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/notepad/blue(src)
	new /obj/item/ammo_magazine/revolver/spearhead(src)

/obj/item/storage/belt/security/MP/CMB/synth/fill_preset_inventory()
	new /obj/item/weapon/baton(src)
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/device/clue_scanner(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/notepad/blue(src)

/obj/item/storage/belt/security/MP/colonist
	name = "安保执勤腰带"
	desc = "私人安保组织使用的黑色执勤腰带。"
	storage_slots = 5
	max_storage_space = 30

/obj/item/storage/belt/security/MP/colonist/fill_preset_inventory()
	new /obj/item/reagent_container/spray/pepper(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/notepad/black(src)

/obj/item/storage/belt/marine
	name = "M276 式弹药携行挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。这是标准型号，用于大量携带弹药。"
	icon_state = "marinebelt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 5
	max_w_class = SIZE_MEDIUM
	max_storage_space = 20
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/knife,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/m60,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks,
		/obj/item/ammo_magazine/plasma,
	)
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/plasma,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/marine/standard
	has_gamemode_skin = FALSE

/obj/item/storage/belt/marine/m41a/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle (src)

/obj/item/storage/belt/marine/m41amk1/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m41aMK1 (src)

/obj/item/storage/belt/marine/m41e2ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/hpr_box/ap (src)

/obj/item/storage/belt/marine/m39/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/m39 (src)

/obj/item/storage/belt/marine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M,user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/marine/dutch
	name = "弹药携行具"
	desc = "适合在炎热丛林中携带额外弹药，由特殊防腐面料制成。"

/obj/item/storage/belt/marine/dutch/m16/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16 (src)

/obj/item/storage/belt/marine/dutch/m16/ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16/ap (src)

/obj/item/storage/belt/marine/dutch/m60/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/m60 (src)

// Outer Rim Weapon Belts

/obj/item/storage/belt/marine/ar10/fill_preset_inventory() // AR-10
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/ar10 (src)
/obj/item/storage/belt/marine/m16/fill_preset_inventory() // M16
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16 (src)

/obj/item/storage/belt/marine/m16/ap/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/m16/ap (src)

/obj/item/storage/belt/marine/mar40/fill_preset_inventory() // Mar40
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/mar40 (src)

/obj/item/storage/belt/marine/mar40/drum/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/mar40/lmg (src)

/obj/item/storage/belt/marine/mar40/extended/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/mar40/extended (src)

/obj/item/storage/belt/marine/mp5/fill_preset_inventory() // MP5
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/mp5 (src)
/obj/item/storage/belt/marine/uzi/fill_preset_inventory() // uzi
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/uzi (src)
/obj/item/storage/belt/marine/boltaction/fill_preset_inventory() // Hunting Rifle
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/boltaction(src)

/obj/item/storage/belt/marine/fp9000/fill_preset_inventory() // FP9000
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/smg/fp9000(src)

/obj/item/storage/belt/marine/nsg23/fill_preset_inventory() // NSG23
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/nsg23(src)

/obj/item/storage/belt/marine/shotgun_ammo/fill_preset_inventory() // shotgun ammo for survs, cursed but we want non-optimal storage on purpose
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/buckshot(src)

/obj/item/storage/belt/marine/svd/fill_preset_inventory() // SVD
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/sniper/svd(src)

/obj/item/storage/belt/marine/svd/pve/fill_preset_inventory() // SVD
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/sniper/svd/pve(src)

/obj/item/storage/belt/marine/smartgunner
	name = "M280 式智能机枪手弹鼓腰带"
	desc = "尽管弹鼓既不符合人体工学，又需要极高加工精度才能通用（剧透：实际做不到，这还助长了“智能机枪有脾气”的传言），USCM 仍决定配发改良陆战队腰带，正式编号 M280。它带有适配 M56B 弹鼓的挂钩与防尘盖，对普通大兵来说过于复杂。只要弹鼓提扣没被油腻的魔术贴卡住，这套挂具确实能装不少弹鼓。可到头来，与标准挂具相比……还是难用。不过，当陆战队员不就是这么回事吗？"
	icon_state = "sgbelt_ammo"
	storage_slots = 6
	bypass_w_limit = list(
		/obj/item/ammo_magazine/smartgun,
	)
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/smartgun,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks,
	)

/obj/item/storage/belt/marine/smartgunner/fill_preset_inventory()
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

/obj/item/storage/belt/marine/smartgunner/full/fill_preset_inventory()
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

/obj/item/storage/belt/marine/smartgunner/standard
	has_gamemode_skin = FALSE

/obj/item/storage/belt/marine/smartgunner/upp
	name = "\improper 90 式机枪手腰带"
	desc = "进步人民联盟军队近期采用的腰带，让机枪手能携带更多弹药箱。使用 23 式霰弹枪的特战破门手也会使用。"
	icon_state = "upp_machinegun"
	item_state = "upp_machinegun"
	storage_slots = 7
	bypass_w_limit = list(
		/obj/item/ammo_magazine/pkp,
	)
	can_hold = list(
		/obj/item/attachable/bayonet,
		/obj/item/device/flashlight/flare,
		/obj/item/ammo_magazine/pkp,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/handful,
		/obj/item/explosive/grenade,
		/obj/item/explosive/mine,
		/obj/item/reagent_container/food/snacks,
	)

	has_gamemode_skin = FALSE
	item_state_slots = list(
		WEAR_L_HAND = "upp_belt",
		WEAR_R_HAND = "upp_belt")

/obj/item/storage/belt/marine/smartgunner/upp/fill_preset_inventory()
	return

/obj/item/storage/belt/marine/quackers
	name = "嘎嘎先生"
	desc = "嘎嘎先生，我们今天要干什么？"
	icon_state = "inflatable"
	item_state = "inflatable"
	item_state_slots = list(
		WEAR_L_HAND = "marinebelt",
		WEAR_R_HAND = "marinebelt")
	has_gamemode_skin = FALSE

/obj/item/storage/belt/marine/upp
	name = "41 式携行挂具"
	desc = "41 式携行挂具是 UPP 军方制式携行装备，主要方便在行动中取用 71 式弹匣。虽然为 71 式武器系统设计，模块化收纳袋也足以容纳其他弹药与装备。"
	icon_state = "upp_belt"
	item_state = "upp_belt"
	has_gamemode_skin = FALSE

//version full of type 71 mags
/obj/item/storage/belt/marine/upp/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/type71(src)

/obj/item/storage/belt/marine/upp/scarce/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)
	new /obj/item/ammo_magazine/rifle/type71(src)

/obj/item/storage/belt/marine/upp/heap/fill_preset_inventory()
	new /obj/item/ammo_magazine/rifle/type71/heap(src)
	new /obj/item/ammo_magazine/rifle/type71/heap(src)
	new /obj/item/ammo_magazine/rifle/type71/heap(src)
	new /obj/item/ammo_magazine/rifle/type71/heap(src)
	new /obj/item/ammo_magazine/rifle/type71/heap(src)

// M56E HMG gunner belt
/obj/item/storage/belt/marine/m2c
	name = "M804 重机枪手储物挂具"
	desc = "M804 重机枪手储物挂具由 M276 式工具腰带改装而成，用于携带重机枪系统弹药和机枪手的工程工具。"
	icon_state = "m2c_ammo_rig"
	item_state = "m2c_ammo_rig"
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	storage_slots = 7
	max_w_class = SIZE_LARGE
	max_storage_space = 30
	can_hold = list(
		/obj/item/tool/weldingtool,
		/obj/item/tool/wrench,
		/obj/item/tool/screwdriver,
		/obj/item/tool/crowbar,
		/obj/item/tool/extinguisher/mini,
		/obj/item/explosive/plastic,
		/obj/item/explosive/mine,
		/obj/item/ammo_magazine/m2c,
		/obj/item/tool/wirecutters,
		/obj/item/ammo_magazine/m56d,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/shotgun
	name = "M276 式霰弹装填挂具"
	desc = "用于装载霰弹或散装子弹的弹药腰带。"
	icon_state = "shotgunbelt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 14 // Make it FLUSH with the UI. *scream
	max_w_class = SIZE_SMALL
	max_storage_space = 28
	can_hold = list(/obj/item/ammo_magazine/handful)
	flap = FALSE
	has_gamemode_skin = FALSE

/obj/item/storage/belt/shotgun/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/slug(src)

/obj/item/storage/belt/shotgun/full/random/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		var/random_shell_type = pick(GLOB.shotgun_handfuls_12g)
		new random_shell_type(src)

/obj/item/storage/belt/shotgun/full/random/reasonable/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		var/random_shell_type = pick(GLOB.shotgun_handfuls_12g_reasonable)
		new random_shell_type(src)

/obj/item/storage/belt/shotgun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/shotgun))
		var/obj/item/ammo_magazine/shotgun/M = W
		dump_ammo_to(M, user, M.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/shotgun/upp
	name = "\improper 42 式霰弹装填携行具"
	desc = "用于携带霰弹枪弹药的弹药带，主要适配 23 式霰弹枪。"
	icon_state = "shotgunbelt" //placeholder
	item_state = "marinebelt"
	storage_slots = 10

/obj/item/storage/belt/shotgun/upp/heavybuck/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(src)

/obj/item/storage/belt/shotgun/upp/heavyslug/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src)

/obj/item/storage/belt/shotgun/van_bandolier
	name = "2 号口径弹带"
	desc = "用于携带极重炮弹的皮革弹带，可固定在护甲上、背在背后，或扣在腰带环上。"
	icon_state = "van_bandolier_5"
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	storage_slots = null
	max_storage_space = 20
	can_hold = list(/obj/item/ammo_magazine/handful/shotgun/twobore)
	has_gamemode_skin = FALSE
	item_state_slots = list(
		WEAR_J_STORE = "van_bandolier_10",
		WEAR_BACK = "van_bandolier_10",
		WEAR_WAIST = "van_bandolier_10"
		)

/obj/item/storage/belt/shotgun/van_bandolier/update_icon()
	var/mob/living/carbon/human/user = loc
	icon_state = "van_bandolier_[round(length(contents) * 0.5, 1)]"
	var/new_state = "van_bandolier_[length(contents)]"
	for(var/I in item_state_slots)
		LAZYSET(item_state_slots, I, new_state)

	if(!istype(user))
		return
	if(src == user.s_store)
		user.update_inv_s_store()
	else if(src == user.belt)
		user.update_inv_belt()
	else if(src == user.back)
		user.update_inv_back()

/obj/item/storage/belt/shotgun/van_bandolier/fill_preset_inventory()
	for(var/i in 1 to max_storage_space * 0.5)
		new /obj/item/ammo_magazine/handful/shotgun/twobore(src)


/obj/item/storage/belt/shotgun/lever_action
	name = "\improper M276 式 .45-70 装填携行具"
	desc = "用于携带 R4T 杠杆式步枪所需大型 .45-70 Govt. 弹药的弹药带。"
	icon_state = "r4t-ammobelt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 14
	max_w_class = SIZE_SMALL
	max_storage_space = 28
	can_hold = list(/obj/item/ammo_magazine/handful)

/obj/item/storage/belt/shotgun/lever_action/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/lever_action))
		var/obj/item/ammo_magazine/lever_action/M = W
		dump_ammo_to(M, user, M.transfer_handful_amount)

	if(istype(W, /obj/item/storage/belt/gun/m44/lever_action/attach_holster))
		if(length(contents) || length(W.contents))
			to_chat(user, SPAN_WARNING("安装枪套前，枪套和腰带都必须清空！"))
			return
		to_chat(user, SPAN_NOTICE("你将枪套装上腰带，牺牲部分储物空间，换取携带 M44 左轮及快速装弹器的能力。"))
		var/obj/item/storage/belt/gun/m44/lever_action/new_belt = new /obj/item/storage/belt/gun/m44/lever_action
		qdel(W)
		qdel(src)
		user.put_in_hands(new_belt)
		update_icon(user)
	else
		return ..()

/obj/item/storage/belt/shotgun/xm88
	name = "M300 式 .458 SOCOM 装弹挂具"
	desc = "专为携带 XM88 重型步枪使用的大口径 .458 SOCOM 子弹设计的弹药腰带。"
	icon_state = "boomslang-belt"
	item_state = "marinebelt"
	w_class = SIZE_LARGE
	storage_slots = 14
	max_w_class = SIZE_SMALL
	max_storage_space = 28
	can_hold = list(/obj/item/ammo_magazine/handful)

/obj/item/storage/belt/shotgun/xm88/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/lever_action/xm88))
		var/obj/item/ammo_magazine/lever_action/xm88/B = W
		dump_ammo_to(B, user, B.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/shotgun/full/quackers
	icon_state = "inflatable"
	item_state = "inflatable"
	item_state_slots = list(
		WEAR_L_HAND = "marinebelt",
		WEAR_R_HAND = "marinebelt")
	name = "嘎嘎夫人"
	desc = "她的脾气总是更坏。"
	has_gamemode_skin = FALSE

/obj/item/storage/belt/knifepouch
	name="M276 式刀具携行挂具"
	desc="M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号专门存放刀具，配发不常见，但仍在服役。"
	icon_state = "knifebelt"
	item_state = "marinebelt" // aslo temp, maybe somebody update these icons with better ones?
	w_class = SIZE_LARGE
	storage_slots = 12
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW
	max_w_class = SIZE_SMALL
	max_storage_space = 48
	can_hold = list(
		/obj/item/weapon/throwing_knife,
		/obj/item/attachable/bayonet,
	)
	cant_hold = list()
	flap = FALSE

	COOLDOWN_DECLARE(draw_cooldown)

/obj/item/storage/belt/knifepouch/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/throwing_knife(src)

/obj/item/storage/belt/knifepouch/_item_insertion(obj/item/new_item, prevent_warning = FALSE)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/belt/knifepouch/_item_removal(obj/item/W, atom/new_location)
	..()
	playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)

/obj/item/storage/belt/knifepouch/attack_hand(mob/user, mods)
	if(COOLDOWN_FINISHED(src, draw_cooldown))
		..()
		COOLDOWN_START(src, draw_cooldown, BAYONET_DRAW_DELAY)
		playsound(src, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
	else
		to_chat(user, SPAN_WARNING("你需要稍等才能再拔一把刀！"))
		return FALSE

/obj/item/storage/belt/grenade
	name="M276 式 M40 手榴弹携行挂具"
	desc="M276 是美洲联盟武装部队的标准携行装备，由模块化腰带与多种挂扣组成。此型号专为大量携带 M40 式及 AGM 式手榴弹设计。"
	icon_state = "grenadebelt" // temp
	item_state = "grenadebelt"
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	w_class = SIZE_LARGE
	storage_slots = 14
	max_w_class = SIZE_MEDIUM
	can_hold = list(/obj/item/explosive/grenade)


/obj/item/storage/belt/grenade/full/fill_preset_inventory()
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary/airburst(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive/airburst(src)
	new /obj/item/explosive/grenade/high_explosive/airburst(src)

/obj/item/storage/belt/grenade/army/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/explosive/grenade/high_explosive(src)

/obj/item/storage/belt/grenade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_box/magazine/nade_box) || istype(W, /obj/item/storage/backpack/marine/grenadepack))
		dump_into(W,user)
	else
		return ..()

/obj/item/storage/belt/grenade/large
	name="M276 式 M40 手榴弹携行挂具 Mk. II"
	desc="M276 Mk. II 是 M276 手榴弹挂具的升级版，储物容量更大。"
	storage_slots = 18
	max_storage_space = 54

/obj/item/storage/belt/grenade/large/full/fill_preset_inventory()
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/incendiary(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive(src)
	new /obj/item/explosive/grenade/high_explosive/impact/tmfrag(src)
	new /obj/item/explosive/grenade/high_explosive/impact/tmfrag(src)
	new /obj/item/explosive/grenade/high_explosive/impact/tmfrag(src)
	new /obj/item/explosive/grenade/high_explosive/impact/tmfrag(src)
	new /obj/item/explosive/grenade/high_explosive/impact/tmfrag(src)
	new /obj/item/explosive/grenade/high_explosive/impact/tmfrag(src)

/obj/item/storage/belt/grenade/large/dutch
	name = "\improper 达奇的掷弹兵携行具"
	desc = "大容量携行具，塞满你能想到的各种炸药。还能奢求什么呢？"

/obj/item/storage/belt/grenade/large/dutch/full/fill_preset_inventory()
	for(var/i in 1 to 6)
		new /obj/item/explosive/grenade/incendiary/impact(src)
		new /obj/item/explosive/grenade/high_explosive/impact(src)
		new /obj/item/explosive/grenade/high_explosive/airburst/buckshot(src)



////////////////////////////// GUN BELTS /////////////////////////////////////

/obj/item/storage/belt/gun
	name = "手枪腰带"
	desc = "腰带枪套组件，可容纳一把手枪和两个弹匣。"
	icon_state = "m4a3_holster"
	item_state = "marinebelt" //see post_skin_selection() - this is used for inhand states, the belt sprites use the same filename as the icon state.
	use_sound = null
	w_class = SIZE_LARGE
	storage_slots = 5
	max_storage_space = 11
	max_w_class = SIZE_MEDIUM
	storage_flags = STORAGE_FLAGS_POUCH|STORAGE_ALLOW_QUICKDRAW
	///Array of holster slots and stats to use for them. First layer is "1", "2" etc. Guns are stored in both the slot and the holstered_guns list which keeps track of which was last inserted.
	var/list/list/obj/item/weapon/gun/holster_slots = list(
		"1" = list(
			"gun" = null,
			"underlay_sprite" = null,
			"underlay_transform" = null,
			"icon_x" = 0,
			"icon_y" = 0))

	var/list/holstered_guns = list()

	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	///Used to get flap overlay states as inserting a gun changes icon state.
	var/base_icon
	var/gun_has_gamemode_skin
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol,
	)

/obj/item/storage/belt/gun/post_skin_selection()
	base_icon = icon_state
	//Saving current inhands, since we'll be switching item_state around for belt onmobs.
	LAZYSET(item_state_slots, WEAR_L_HAND, item_state)
	LAZYSET(item_state_slots, WEAR_R_HAND, item_state)
	//And switch to correct belt state in case we aren't spawning with a gun inserted.
	item_state = icon_state

/obj/item/storage/belt/gun/update_icon()
	overlays.Cut()

	if(content_watchers && flap)
		return
	var/magazines = length(contents) - length(holstered_guns)
	if(!magazines)
		return
	if(magazines <= (storage_slots - length(holster_slots)) * 0.5) //Don't count slots reserved for guns, even if they're empty.
		overlays += "+[base_icon]_half"
	else
		overlays += "+[base_icon]_full"

/obj/item/storage/belt/gun/on_stored_atom_del(atom/movable/AM)
	if(!isgun(AM))
		return
	holstered_guns -= AM
	for(var/slot in holster_slots)
		if(AM == holster_slots[slot]["gun"])
			holster_slots[slot]["gun"] = null

			update_gun_icon(slot)
			return

/obj/item/storage/belt/gun/attack_hand(mob/user, mods)
	if(length(holstered_guns) && ishuman(user) && loc == user)
		var/obj/item/I
		if(mods && mods[ALT_CLICK] && length(contents) > length(holstered_guns)) //Withdraw the most recently inserted magazine, if possible.
			var/list/magazines = contents - holstered_guns
			I = magazines[length(magazines)]
		else //Otherwise find and draw the last-inserted gun.
			I = holstered_guns[length(holstered_guns)]
		I.attack_hand(user)
		return

	..()

/obj/item/storage/belt/gun/proc/update_gun_icon(slot) //We do not want to use regular update_icon as it's called for every item inserted. Not worth the icon math.
	var/mob/living/carbon/human/user = loc
	var/obj/item/weapon/gun/current_gun = holster_slots[slot]["gun"]
	if(current_gun)
		/*
		Have to use a workaround here, otherwise images won't display properly at all times.
		Reason being, transform is not displayed when right clicking/alt+clicking an object,
		so it's necessary to pre-load the potential states so the item actually shows up
		correctly without having to rotate anything. Preloading weapon icons also makes
		sure that we don't have to do any extra calculations.
		*/
		playsound(src, drawSound, 7, TRUE)
		var/image/gun_underlay = image(icon, current_gun.base_gun_icon)
		if(gun_has_gamemode_skin)
			switch(SSmapping.configs[GROUND_MAP].camouflage_type)
				if("snow")
					gun_underlay = image(icon, "s_" + current_gun.base_gun_icon)
				if("desert")
					gun_underlay = image(icon, "d_" + current_gun.base_gun_icon)
				if("classic")
					gun_underlay = image(icon, "c_" + current_gun.base_gun_icon)
		gun_underlay.pixel_x = holster_slots[slot]["icon_x"]
		gun_underlay.pixel_y = holster_slots[slot]["icon_y"]
		gun_underlay.color = current_gun.color
		gun_underlay.transform = holster_slots[slot]["underlay_transform"]
		holster_slots[slot]["underlay_sprite"] = gun_underlay
		underlays += gun_underlay

		icon_state += "_g"
		item_state = icon_state
	else
		playsound(src, sheatheSound, 7, TRUE)
		underlays -= holster_slots[slot]["underlay_sprite"]
		holster_slots[slot]["underlay_sprite"] = null

		icon_state = copytext(icon_state,1,-2)
		item_state = icon_state

	if(istype(user))
		if(src == user.belt)
			user.update_inv_belt()
		else if(src == user.s_store)
			user.update_inv_s_store()

//There are only two types here that can be inserted, and they are mutually exclusive. We only track the gun.
/obj/item/storage/belt/gun/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE) //We don't need to stop messages, but it can be left in.
	. = ..()
	if(!.)
		return

	if(isgun(W))
		for(var/slot in holster_slots)
			if(!holster_slots[slot]["gun"]) //Open holster.
				return

		if(!stop_messages) //No open holsters.
			if(length(holster_slots) == 1)
				to_chat(usr, SPAN_WARNING("[src]已经装有一把枪。"))
			else
				to_chat(usr, SPAN_WARNING("[src]没有空枪套。"))
		return FALSE

	else if(length(contents) - length(holstered_guns) >= storage_slots - length(holster_slots)) //Compare amount of nongun items in storage with usable ammo pockets.
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src]装不下更多弹药。"))
		return FALSE

/obj/item/storage/belt/gun/_item_insertion(obj/item/W, prevent_warning = FALSE)
	if(isgun(W))
		holstered_guns += W
		for(var/slot in holster_slots)
			if(holster_slots[slot]["gun"])
				continue
			holster_slots[slot]["gun"] = W
			update_gun_icon(slot)
			break
	..()

/obj/item/storage/belt/gun/_item_removal(obj/item/W, atom/new_location)
	if(isgun(W))
		holstered_guns -= W
		for(var/slot in holster_slots)
			if(holster_slots[slot]["gun"] != W)
				continue
			holster_slots[slot]["gun"] = null
			update_gun_icon(slot)
			break
	..()

/obj/item/storage/belt/gun/dump_ammo_to(obj/item/ammo_magazine/ammo_dumping, mob/user, amount_to_dump)
	if(user.action_busy)
		return

	if(ammo_dumping.flags_magazine & AMMUNITION_CANNOT_REMOVE_BULLETS)
		to_chat(user, SPAN_WARNING("你无法从[ammo_dumping]中取出弹药！"))
		return

	if(ammo_dumping.flags_magazine & AMMUNITION_HANDFUL_BOX)
		var/handfuls = round(ammo_dumping.current_rounds / amount_to_dump, 1) //The number of handfuls, we round up because we still want the last one that isn't full
		if(ammo_dumping.current_rounds != 0)
			if(length(contents) < storage_slots - 1) //this is because it's a gunbelt and the final slot is reserved for the gun
				to_chat(user, SPAN_NOTICE("你开始用[ammo_dumping]给[src]补充弹药。"))
				if(!do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
				for(var/i = 1 to handfuls)
					if(length(contents) < storage_slots - 1)
						var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
						var/transferred_handfuls = min(ammo_dumping.current_rounds, amount_to_dump)
						new_handful.generate_handful(ammo_dumping.default_ammo, ammo_dumping.caliber, amount_to_dump, transferred_handfuls, ammo_dumping.gun_type)
						ammo_dumping.current_rounds -= transferred_handfuls
						handle_item_insertion(new_handful, TRUE,user)
						update_icon(-transferred_handfuls)
					else
						break
				playsound(user.loc, "rustle", 15, TRUE, 6)
				ammo_dumping.update_icon()
			else
				to_chat(user, SPAN_WARNING("[src]已经装满。"))


/obj/item/storage/belt/gun/m4a3
	name = "M276 式通用手枪枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号的枪套可携带最常见的手枪，侧袋可存放大多数手枪弹匣。"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy/super,
		/obj/item/ammo_magazine/pistol/heavy/super/highimpact,
	)
	cant_hold = list(
		/obj/item/weapon/gun/pistol/smart,
		/obj/item/ammo_magazine/pistol/smart,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/m4a3/standard
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/m4a3/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/belt/gun/m4a3/commander/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3/custom())
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/ap(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)

/obj/item/storage/belt/gun/m4a3/vp70/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp70())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/vp70(src)

/obj/item/storage/belt/gun/m4a3/vp70_near_empty/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp70())
	for(var/i = 1 to 3)
		new /obj/item/ammo_magazine/pistol/vp70(src)

/obj/item/storage/belt/gun/m4a3/vp78/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/vp78(src)

/obj/item/storage/belt/gun/m4a3/m1911/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m1911())
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/belt/gun/m4a3/m1911/forecon_officer/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m1911/socom/officer())
	new /obj/item/ammo_magazine/pistol/m1911/super(src)
	new /obj/item/ammo_magazine/pistol/m1911/super(src)
	new /obj/item/ammo_magazine/pistol/m1911/super(src)
	new /obj/item/ammo_magazine/pistol/m1911/super(src)
	new /obj/item/ammo_magazine/pistol/m1911/super(src)
	new /obj/item/ammo_magazine/pistol/m1911/super(src)

/obj/item/storage/belt/gun/m4a3/m1911/socom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m1911/socom/equipped())
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)
	new /obj/item/ammo_magazine/pistol/m1911(src)

/obj/item/storage/belt/gun/m4a3/heavy/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/heavy())
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)
	new /obj/item/ammo_magazine/pistol/heavy(src)

/obj/item/storage/belt/gun/m4a3/heavy/co/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/heavy/co())
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap(src)

/obj/item/storage/belt/gun/m4a3/heavy/co_golden/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/heavy/co/gold())
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap(src)
	new /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap(src)

/obj/item/storage/belt/gun/m4a3/highpower/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower(src)

/obj/item/storage/belt/gun/m4a3/highpower/black/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower/black())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower/black(src)

/obj/item/storage/belt/gun/m4a3/highpower/automag/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower/automag())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower/automag(src)

/obj/item/storage/belt/gun/m4a3/highpower/automag/tactical/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/highpower/automag/tactical())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/highpower/automag(src)

/obj/item/storage/belt/gun/m4a3/army/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/b92fs())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/b92fs(src)

/obj/item/storage/belt/gun/m4a3/nailgun
	name = "定制射钉枪枪套"
	desc = "拆解 M276 手枪枪套和工程工具腰带后拼成的独特腰带，可收纳一把紧凑型射钉枪和两个备用射钉枪弹匣。"
	icon_state = "nailgun_holster"
	storage_slots = 3
	can_hold = list(
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/ammo_magazine/smg/nailgun,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/m4a3/nailgun/prefilled/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/nailgun/compact())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/smg/nailgun(src)

/obj/item/storage/belt/gun/m39
	name = "M276 式 M39 枪套挂具"
	desc = "M276 特别配发型号，可携带一把 M39 冲锋枪和两个备用弹匣。少量配发给 USCM 支援及专家人员。"
	icon_state = "m39_armor"
	item_state = "s_marinebelt"
	storage_slots = 3
	max_w_class = 5
	can_hold = list(
		/obj/item/weapon/gun/smg/m39,
		/obj/item/ammo_magazine/smg,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = -11,
			"icon_y" = -5))

/obj/item/storage/belt/gun/m39/forecon/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/m39/forecon())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/smg/m39/extended(src)

#define MAXIMUM_MAGAZINE_COUNT 2

/obj/item/storage/belt/gun/xm51
	name = "M276 式 XM51 枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号便于收纳 XM51 破障霰弹枪，另有可放两个弹匣和额外霰弹的袋子。"
	icon_state = "xm51_holster"
	has_gamemode_skin = FALSE
	gun_has_gamemode_skin = FALSE
	storage_slots = 8
	max_w_class = 5
	can_hold = list(
		/obj/item/weapon/gun/rifle/xm51,
		/obj/item/ammo_magazine/rifle/xm51,
		/obj/item/ammo_magazine/handful,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = 10,
			"icon_y" = -1))

	//Keep a track of how many magazines are inside the belt.
	var/magazines = 0

/obj/item/storage/belt/gun/xm51/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/ammo_magazine/shotgun/buckshot/light))
		var/obj/item/ammo_magazine/shotgun/buckshot/light/ammo_box = item
		dump_ammo_to(ammo_box, user, ammo_box.transfer_handful_amount)
	else
		return ..()

/obj/item/storage/belt/gun/xm51/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE)
	. = ..()
	if(magazines >= MAXIMUM_MAGAZINE_COUNT && istype(item, /obj/item/ammo_magazine/rifle/xm51))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src]装不下更多弹匣。"))
		return FALSE

/obj/item/storage/belt/gun/xm51/handle_item_insertion(obj/item/item, prevent_warning = FALSE, mob/user)
	. = ..()
	if(istype(item, /obj/item/ammo_magazine/rifle/xm51))
		magazines++

/obj/item/storage/belt/gun/xm51/remove_from_storage(obj/item/item as obj, atom/new_location)
	. = ..()
	if(istype(item, /obj/item/ammo_magazine/rifle/xm51))
		magazines--

//If a magazine disintegrates due to acid or something else while in the belt, remove it from the count.
/obj/item/storage/belt/gun/xm51/on_stored_atom_del(atom/movable/item)
	if(istype(item, /obj/item/ammo_magazine/rifle/xm51))
		magazines--

#undef MAXIMUM_MAGAZINE_COUNT

/obj/item/storage/belt/gun/shotgunholster
	name = "\improper M276 式霰弹枪套携行具"
	desc = "M276 是美国殖民地陆战队制式携行装备，由模块化腰带和各种挂扣组成。这一型用拆下的 L44 霰弹枪鞘和弹药袋拼成了临时霰弹枪套。"
	icon_state = "shotgunholster"
	has_gamemode_skin = FALSE
	gun_has_gamemode_skin = FALSE
	storage_slots = 4
	max_w_class = 5
	can_hold = list(
		/obj/item/ammo_magazine/handful,
		/obj/item/weapon/gun/shotgun/pump,
		/obj/item/weapon/gun/shotgun/combat,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = 10,
			"icon_y" = -1))

/obj/item/storage/belt/gun/m44
	name = "M276 式通用左轮手枪枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号通用可调，适配不同左轮手枪，并带有六个快速装弹器小袋。隐约有股干草味。"
	icon_state = "m44r_holster"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
	)
	has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/m44/standard
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/m44/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/custom/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/custom())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/mp/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/mp())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/gunslinger
	name = "定制雕花枪手腰带"
	desc = "总有<i>某个地方</i>正值正午决斗时刻。"
	icon_state = "gunslinger_holster"
	storage_slots = 6
	can_hold = list(
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
	)
	has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list("icon_x" = -9, "icon_y" = -3),
		"2" = list("icon_x" = 9, "icon_y" = -3))

/obj/item/storage/belt/gun/m44/gunslinger/Initialize()
	var/matrix/M = matrix()
	M.Scale(-1, 1) //Flip the sprite of the second gun.
	holster_slots["2"]["underlay_transform"] = M
	. = ..()

/obj/item/storage/belt/gun/m44/gunslinger/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44())
	for(var/i = 1 to storage_slots - 2)
		new /obj/item/ammo_magazine/revolver/marksman(src)

/obj/item/storage/belt/gun/m44/lever_action
	name = "\improper M276 式 .45-70 左轮携行具"
	desc = "用于携带 R4T 杠杆式步枪所需大型 .45-70 Govt. 弹药的弹药带。这一型牺牲容量，换装了完整的左轮枪套。"
	icon_state = "r4t-cowboybelt"
	item_state = "r4t-cowboybelt"
	w_class = SIZE_LARGE
	storage_slots = 11
	max_storage_space = 28
	can_hold = list(
		/obj/item/ammo_magazine/handful,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
	)
	flap = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = 10,
			"icon_y" = 3))

/obj/item/storage/belt/gun/m44/lever_action/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_magazine/lever_action))
		var/obj/item/ammo_magazine/lever_action/M = W
		dump_ammo_to(M,user, M.transfer_handful_amount)
	else
		return ..()


/obj/item/storage/belt/gun/m44/lever_action/verb/detach_holster()
	set category = "Object"
	set name = "Detach revolver holster"
	set src in usr
	if(ishuman(usr))
		if(length(contents))
			to_chat(usr, SPAN_WARNING("拆下枪套前必须完全清空腰带！"))
			return
		to_chat(usr, SPAN_NOTICE("你从腰带上拆下了枪套。"))
		var/obj/item/storage/belt/shotgun/lever_action/new_belt = new /obj/item/storage/belt/shotgun/lever_action
		var/obj/item/storage/belt/gun/m44/lever_action/attach_holster/new_holster = new /obj/item/storage/belt/gun/m44/lever_action/attach_holster
		qdel(src)
		usr.put_in_hands(new_belt)
		usr.put_in_hands(new_holster)
		update_icon(usr)
	else
		return

/obj/item/storage/belt/gun/m44/lever_action/attach_holster
	name = "\improper M276 左轮枪套配件"
	desc = "可立即装到空 M276 .45-70 携行具上的枪套，牺牲部分储物空间以携带副武器。你愿意的话，也可单独扣在腰带上。"
	icon_state = "r4t-attach-holster"
	item_state = "r4t-attach-holster"
	w_class = SIZE_LARGE
	storage_slots = 1
	max_storage_space = 1
	can_hold = list(
		/obj/item/weapon/gun/revolver,
	)

/obj/item/storage/belt/gun/mateba
	name = "M276 式马特巴枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号供威力强大的马特巴马格南左轮手枪使用，并有五个快速装弹器袋。这一件老化严重，似乎是库存剩余装备，上面盖着“第三‘沙尘突袭者’营”的印记。"
	icon_state = "s_cmateba_holster"
	item_state = "s_marinebelt"
	storage_slots = 7
	max_w_class = SIZE_MEDIUM
	can_hold = list(
		/obj/item/weapon/gun/revolver/mateba,
		/obj/item/ammo_magazine/revolver/mateba/highimpact,
		/obj/item/ammo_magazine/revolver/mateba,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/mateba/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)

/obj/item/storage/belt/gun/mateba/cmateba
	name = "M276 式马特巴枪套挂具"
	desc = "M276 是美国殖民地陆战队制式携行装备，由模块化腰带和各种挂扣组成。这一型专为强大的马特巴马格南左轮设计，并有五个小袋存放快速装弹器。二十二世纪七十年代初，它随邮购陆战队版马特巴自动左轮一同附送。"
	icon_state = "cmateba_holster"
	item_state = "marinebelt"
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/mateba/cmateba/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba())
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)

/obj/item/storage/belt/gun/mateba/cmateba/special

/obj/item/storage/belt/gun/mateba/cmateba/special/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/special())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)

/obj/item/storage/belt/gun/mateba/council
	name = "上校 M276 式马特巴枪套携行具"
	desc = "M276 是美国殖民地陆战队制式携行装备。 \
	它由模块化腰带和各种挂扣组成。这一型用于携带强大的马特巴马格南左轮， \
	附带五个快速装弹器小袋。这件为高级官员深度定制，采用黑色配金色雕纹。"

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/council/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/engraved())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)

/obj/item/storage/belt/gun/mateba/general
	name = "将军 M276 式马特巴枪套携行具"
	desc = "M276 是美国殖民地陆战队制式携行装备。 \
	它由模块化腰带和各种挂扣组成。这一型用于携带强大的马特巴马格南左轮， \
	附带五个快速装弹器小袋。这件为高级官员深度定制，采用黑色配金色雕纹。"

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/general/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)

/obj/item/storage/belt/gun/mateba/general/impact/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)

/obj/item/storage/belt/gun/mateba/general/santa/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general/santa())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)

/obj/item/storage/belt/gun/mateba/pmc
	name = "私人军事公司 M276 式马特巴枪套携行具"
	desc = "M276 是美国殖民地陆战队制式携行装备。 \
	它由模块化腰带和各种挂扣组成。这一型用于携带强大的马特巴马格南左轮， \
	附带五个快速装弹器小袋。这件为高级官员深度定制，采用黑色配金色雕纹。"

	icon_state = "amateba_holster"
	item_state = "s_marinebelt"

/obj/item/storage/belt/gun/mateba/pmc/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/general())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/explosive(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)

/obj/item/storage/belt/gun/type47
	name = "47 式手枪枪套挂具"
	desc = "UPP 设计的副武器挂具，可稳妥贴合地容纳 73 式、NP92 或 ZHNK-72 及其弹匣或快速装弹器，但对其他武器缺乏通用性。"
	icon_state = "korovin_holster"
	item_state = "upp_belt"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73_impact,
		/obj/item/weapon/gun/pistol/np92,
		/obj/item/ammo_magazine/pistol/np92,
		/obj/item/ammo_magazine/pistol/np92/tranq,
		/obj/item/weapon/gun/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp/shrapnel,
	)
	holster_slots = list("1" = list("icon_x" = -1))

/obj/item/storage/belt/gun/type47/np92/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/np92())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/np92(src)

/obj/item/storage/belt/gun/type47/np92/suppressed/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/np92/suppressed())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/np92/suppressed(src)

/obj/item/storage/belt/gun/type47/t73/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/t73())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/t73(src)

/obj/item/storage/belt/gun/type47/t73/leader/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/t73/leader())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/t73_impact(src)

/obj/item/storage/belt/gun/type47/revolver/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/upp())
	for(var/total_storage_slots in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp(src)

/obj/item/storage/belt/gun/type47/revolver/shrapnel/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/upp/shrapnel())
	for(var/total_storage_slots in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/upp/shrapnel(src)

//Crazy Ivan's belt reskin
/obj/item/storage/belt/gun/type47/ivan
	name = "刑架"
	desc = "无形虚空中，诞生出比元素本身更古老的存在。它所过之处，风暴随行。"
	icon_state = "ivan_belt"
	storage_slots = 56
	max_storage_space = 56
	has_gamemode_skin = FALSE
	max_w_class = SIZE_MASSIVE
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine,
	)

/obj/item/storage/belt/gun/type47/ivan/Initialize()
	. = ..()
	var/list/bad_mags = typesof(/obj/item/ammo_magazine/hardpoint) + /obj/item/ammo_magazine/handful + /obj/item/ammo_magazine/handful/shotgun/custom_color + /obj/item/ammo_magazine/flamer_tank/empty + /obj/item/ammo_magazine/flamer_tank/large/empty + /obj/item/ammo_magazine/flamer_tank/custom + /obj/item/ammo_magazine/rocket/custom + /obj/item/ammo_magazine/smg
	var/list/sentry_mags = typesof(/obj/item/ammo_magazine/sentry) + typesof(/obj/item/ammo_magazine/sentry_flamer) + /obj/item/ammo_magazine/m56d + /obj/item/ammo_magazine/m2c
	var/list/internal_mags = (typesof(/obj/item/ammo_magazine/internal) + /obj/item/ammo_magazine/handful)
	var/list/training_mags = list(
		/obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/m49a/rubber,
		/obj/item/ammo_magazine/smg/m39/rubber,
		/obj/item/ammo_magazine/pistol/rubber,
		/obj/item/ammo_magazine/pistol/vp70/rubber) //Ivan doesn't bring children's ammo.

	var/list/picklist = subtypesof(/obj/item/ammo_magazine) - (internal_mags + bad_mags + sentry_mags + training_mags)
	var/random_mag = pick(picklist)
	var/guntype = pick(subtypesof(/obj/item/weapon/gun/revolver) + subtypesof(/obj/item/weapon/gun/pistol) - list(/obj/item/weapon/gun/pistol/m4a3/training, /obj/item/weapon/gun/pistol/vp70/training))
	handle_item_insertion(new guntype())
	for(var/total_storage_slots in 2 to storage_slots) //minus templates
		new random_mag(src)
		random_mag = pick(picklist)

/obj/item/storage/belt/gun/smartpistol
	name = "M276 式 SU-6 智能手枪枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号供 SU-6 智能手枪使用。"
	icon_state = "smartpistol_holster"
	storage_slots = 7
	holster_slots = list(
		"1" = list(
			"icon_x" = -5,
			"icon_y" = -2))
	can_hold = list(
		/obj/item/weapon/gun/pistol/smart,
		/obj/item/ammo_magazine/pistol/smart,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartpistol/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/smart())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/smart(src)

/obj/item/storage/belt/gun/smartpistol/full_nogun/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/smart(src)

/obj/item/storage/belt/gun/flaregun
	name = "M276 式 M82F 信号枪枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此型号供 M82F 信号枪使用。"
	storage_slots = 28
	max_storage_space = 31
	icon_state = "m82f_holster"
	item_state = "s_marinebelt"
	can_hold = list(
		/obj/item/weapon/gun/flare,
		/obj/item/device/flashlight/flare,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/flaregun/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/flare())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/belt/gun/flaregun/full_nogun/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/belt/gun/flaregun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/flare))
		var/obj/item/storage/box/flare/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/belt/gun/webley
	name = "\improper 韦伯利 Mk VI 枪带"
	desc = "精工英国皮革、一把韦伯利和六个 .455 快速装弹器。足以杀死任何长腿的东西。"
	icon_state = "m44r_holster"
	storage_slots = 7
	can_hold = list(
		/obj/item/weapon/gun/revolver/m44/custom/webley,
		/obj/item/ammo_magazine/revolver,
	)
	has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/webley/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/m44/custom/webley())
	for(var/i in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/revolver/webley(src)

/obj/item/storage/belt/gun/smartgunner
	name = "M802 式智能机枪手副武器挂具"
	desc = "M802 是 USCM 限量配发的携行装备型号，专为携带智能机枪弹药和副武器设计。"
	icon_state = "sgbelt"
	flags_equip_slot = SLOT_WAIST
	holster_slots = list(
		"1" = list(
			"icon_x" = 5,
			"icon_y" = -2))
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartgunner/standard
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartgunner/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/m4a3())
	new /obj/item/ammo_magazine/pistol/hp(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

/obj/item/storage/belt/gun/smartgunner/army
	name = "\improper M802 式智能机枪手副武器携行具"
	desc = "M802 是限量配发的携行装备，仅见于 M56A2 武器系统操作员，设计用于携带智能机枪弹药与副武器。"
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartgunner/army/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/b92fs())
	new /obj/item/ammo_magazine/pistol/b92fs(src)
	new /obj/item/ammo_magazine/pistol/b92fs(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

#define MAXIMUM_MAGAZINE_COUNT 2

/obj/item/storage/belt/gun/smartgunner/garrow
	name = "\improper M802 式智能机枪手副武器携行具"
	desc = "M802 是限量配发的美国殖民地陆战队携行装备，可携带少量智能机枪及手枪弹药，以及一把副武器。"
	icon_state = "sgbelt"

	//Keep a track of how many magazines are inside the belt.
	var/magazines = 0

/obj/item/storage/belt/gun/smartgunner/garrow/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE)
	. = ..()
	if(magazines >= MAXIMUM_MAGAZINE_COUNT && istype(item, /obj/item/ammo_magazine/smartgun))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src]装不下更多弹鼓。"))
		return FALSE

/obj/item/storage/belt/gun/smartgunner/garrow/handle_item_insertion(obj/item/item, prevent_warning = FALSE, mob/user)
	. = ..()
	if(istype(item, /obj/item/ammo_magazine/smartgun))
		magazines++

/obj/item/storage/belt/gun/smartgunner/garrow/remove_from_storage(obj/item/item as obj, atom/new_location)
	. = ..()
	if(istype(item, /obj/item/ammo_magazine/smartgun))
		magazines--

//If a magazine disintegrates due to acid or something else while in the belt, remove it from the count.
/obj/item/storage/belt/gun/smartgunner/garrow/on_stored_atom_del(atom/movable/item)
	if(istype(item, /obj/item/ammo_magazine/smartgun))
		magazines--

#undef MAXIMUM_MAGAZINE_COUNT

/obj/item/storage/belt/gun/smartgunner/pmc
	name = "\improper M802 式“脏家伙”智能机枪手副武器携行具"
	desc = "标准 M802 携行装备的改型，用于携带智能机枪弹药与副武器。"
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver/mateba,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartgunner/pmc/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp70())
	new /obj/item/ammo_magazine/pistol/vp70(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

/obj/item/storage/belt/gun/smartgunner/wo/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78())
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)

/obj/item/storage/belt/gun/smartgunner/whiteout
	name = "\improper M802 式“终结者”智能机枪手副武器携行具"
	desc = "标准 M802 携行装备的改型，用于携带智能机枪弹药与马特巴左轮。"
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver/mateba,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartgunner/whiteout/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba/pmc())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact/ap(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)
	new /obj/item/ammo_magazine/smartgun/dirty(src)

/obj/item/storage/belt/gun/smartgunner/clf
	name = "\improper M802 式“自由”智能机枪手副武器携行具"
	desc = "标准 M802 携行装备的改型，用于携带智能机枪弹药与马特巴左轮。这件的制造标记被刻上了殖民地解放阵线徽记。"
	can_hold = list(
		/obj/item/device/flashlight/flare,
		/obj/item/weapon/gun/flare,
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver/mateba,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/smartgun,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/belt/gun/smartgunner/clf/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/revolver/mateba())
	new /obj/item/ammo_magazine/revolver/mateba/highimpact(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)

#define MAXIMUM_MAGAZINE_COUNT 4

/obj/item/storage/belt/gun/smartgunner/upp
	name = "\improper 92 式机枪手副武器携行具"
	desc = "92 式是配发给进步人民联盟机枪手的实验弹药携行具，将副武器枪套与容量有限的方形弹药袋结合在一起。"
	icon_state = "upp_machinegun_pistol"
	storage_slots = 6
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/ammo_magazine/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/pkp,
		/obj/item/ammo_magazine/smartgun/upp,
	)
	has_gamemode_skin = FALSE
	item_state_slots = list(
		WEAR_L_HAND = "upp_belt",
		WEAR_R_HAND = "upp_belt")

	//Keep a track of how many magazines are inside the belt.
	var/magazines = 0

/obj/item/storage/belt/gun/smartgunner/upp/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE)
	. = ..()
	if(magazines >= MAXIMUM_MAGAZINE_COUNT && istype(item, /obj/item/ammo_magazine/pkp))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src]装不下更多弹药箱。"))
		return FALSE


/obj/item/storage/belt/gun/smartgunner/upp/handle_item_insertion(obj/item/item, prevent_warning = FALSE, mob/user)
	. = ..()
	if(istype(item, /obj/item/ammo_magazine/pkp))
		magazines++

/obj/item/storage/belt/gun/smartgunner/upp/remove_from_storage(obj/item/item as obj, atom/new_location)
	. = ..()
	if(istype(item, /obj/item/ammo_magazine/pkp))
		magazines--
#undef MAXIMUM_MAGAZINE_COUNT


/obj/item/storage/belt/gun/mortarbelt
	name="M276 式迫击炮手腰带"
	desc="配置为携带 M402 迫击炮弹药及一把副武器的 M276 携行挂具。"
	icon_state="mortarbelt"
	holster_slots = list("1" = list("icon_x" = 11))
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/weapon/gun/flare,
		/obj/item/mortar_shell,
	)
	bypass_w_limit = list(/obj/item/mortar_shell, /obj/item/device/binoculars)
	has_gamemode_skin = FALSE
	storage_slots = 8

/obj/item/storage/belt/gun/mortarbelt/full_upp/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/np92/unloaded())
	new /obj/item/mortar_shell/flare(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)
	new /obj/item/mortar_shell/incendiary(src)

/obj/item/storage/belt/gun/utility
	name = "M276 式战斗工具携行腰带"
	desc = "M276 式战斗工具腰带是 USCM 工兵在战区维修时使用的替代携行装备。模块化腰带带有多种工具挂扣、收纳袋及副武器枪套。由于副武器占用空间，能装的工具少于标准型号。"
	storage_slots = 9
	icon_state = "combatutility"
	item_state= "utility"
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/weapon/gun/flare,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/tool/shovel/etool,
		/obj/item/tool/extinguisher/mini,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/stack/cable_coil,
		/obj/item/cell,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/handful,
	)
	bypass_w_limit = list(
		/obj/item/tool/shovel/etool,
		/obj/item/device/lightreplacer,
	)
	holster_slots = list(
		"1" = list(
			"icon_x" = -9,
			"icon_y" = -6))


/obj/item/storage/belt/gun/utility/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp70())
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/device/multitool(src)

////////////OTHER BELTS//////////////

/obj/item/storage/belt/tank
	name = "M103 式载具弹药挂具"
	desc = "M103 是 USCM 限量配发的携行装备型号，专供乘员携带载具弹药。"
	icon_state = "tankbelt"
	item_state = "tankbelt"
	item_state_slots = list(
		WEAR_L_HAND = "utility",
		WEAR_R_HAND = "utility")
	storage_slots = 2 //can hold 2 only two large items such as Tank Ammo.
	max_w_class = SIZE_LARGE
	max_storage_space = 2
	can_hold = list(
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
		/obj/item/ammo_magazine/hardpoint/m56_cupola,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
	)

/obj/item/storage/belt/souto
	name = "\improper 索托腰带"
	desc = "索托侠可靠的多用途腰带，带有可摘取的索托饮料罐，取下后不能放回。"
	icon_state = "souto_man"
	item_state = "souto_man"
	item_state_slots = list(
		WEAR_L_HAND = "s_marinebelt",
		WEAR_R_HAND = "s_marinebelt")
	flags_equip_slot = SLOT_WAIST
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD
	storage_slots = 8
	flags_inventory = CANTSTRIP
	max_w_class = 0 //this belt cannot hold anything

/obj/item/storage/belt/souto/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new /obj/item/reagent_container/food/drinks/cans/souto/classic(src)

/obj/item/storage/belt/souto/update_icon()
	var/mob/living/carbon/human/user = loc
	item_state = "souto_man[length(contents)]"
	if(istype(user))
		user.update_inv_belt() //Makes sure the onmob updates.



//ROYAL MARINES COMMNADO

/obj/item/storage/belt/marine/rmc
	name = "L70 式弹药携行挂具"
	desc = "适合在炎热丛林中携带额外弹药，采用特殊防腐面料。"
	icon_state = "rmc_ammo"
	item_state = "rmc_ammo"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	has_gamemode_skin = FALSE

/obj/item/storage/belt/marine/rmc/nsg/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/rifle/nsg23(src)

/obj/item/storage/belt/medical/rmc
	name = "L75 式医疗携行挂具"
	desc = "L75 是 RMC 的标准携行装备，由模块化腰带和宽敞收纳袋组成，用于运输体积较大的医疗用品。\n右键点击图标，选择“切换腰带模式”，即可通过点击药瓶直接取出药片。"
	icon_state = "rmc_medical"
	item_state = "rmc_medical"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE

/obj/item/storage/belt/medical/rmc/full/fill_preset_inventory()
	new /obj/item/storage/pill_bottle/merabica(src)
	new /obj/item/storage/pill_bottle/dexalin(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/storage/pill_bottle/keloderm(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/peridaxon(src)
	new /obj/item/storage/pill_bottle/imialk(src)
	new /obj/item/reagent_container/blood/OMinus(src)
	new /obj/item/reagent_container/blood/OMinus(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/splint(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)

/obj/item/storage/belt/gun/l905
	name = "L165 枪械腰带"
	desc = "精细加工的皮革腰带，配有枪套与收纳袋，可携带大多数副武器及相应弹药。"
	icon_state = "rmc_pistol"
	item_state = "rmc_pistol"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	storage_slots = 7
	has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = -1,
			"icon_y" = -3))

/obj/item/storage/belt/gun/l905/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78/rmc())
	for(var/i in 1 to storage_slots - 1)
		new /obj/item/ammo_magazine/pistol/vp78/rmc(src)

#define MAXIMUM_MORTARSHELL_COUNT 3

/obj/item/storage/belt/gun/mortarbelt/rmc
	name = "L84 式弹药携行挂具"
	desc = "配置为携带 L53A1 轻型迫击炮或 L164A3 多发榴弹发射器支援弹药的 L84 式携行挂具，还能带一把副武器和弹匣。采用特殊防腐面料。"
	icon_state = "mortarutility"
	item_state = "s_mortarbelt"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	has_gamemode_skin = FALSE
	holster_slots = list(
		"1" = list(
			"icon_x" = -9,
			"icon_y" = -6))
	can_hold = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/weapon/gun/revolver,
		/obj/item/weapon/gun/flare,
		/obj/item/mortar_shell,
		/obj/item/storage/box/packet/rmc/mini,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/handful,
	)
	bypass_w_limit = list(
		/obj/item/mortar_shell,
		/obj/item/storage/box/packet/rmc/mini,
	)

	//Keep a track of how many mortar shells are inside the belt.
	var/shells = 0

/obj/item/storage/belt/gun/mortarbelt/rmc/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE)
	. = ..()
	if(shells >= MAXIMUM_MORTARSHELL_COUNT && istype(item, /obj/item/mortar_shell))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src]装不下更多迫击炮弹。"))
		return FALSE
	else if(shells >= MAXIMUM_MORTARSHELL_COUNT && istype(item, /obj/item/storage/box/packet/rmc/mini))
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("[src]装不下更多手榴弹包。"))
		return FALSE

/obj/item/storage/belt/gun/mortarbelt/rmc/handle_item_insertion(obj/item/item, prevent_warning = FALSE, mob/user)
	. = ..()
	if(istype(item, /obj/item/mortar_shell))
		shells++
	else if(istype(item, /obj/item/storage/box/packet/rmc/mini))
		shells++

/obj/item/storage/belt/gun/mortarbelt/rmc/remove_from_storage(obj/item/item as obj, atom/new_location)
	. = ..()
	if(istype(item, /obj/item/mortar_shell))
		shells--
	else if(istype(item, /obj/item/storage/box/packet/rmc/mini))
		shells--

//If a magazine disintegrates due to acid or something else while in the belt, remove it from the count.
/obj/item/storage/belt/gun/mortarbelt/rmc/on_stored_atom_del(atom/movable/item)
	if(istype(item, /obj/item/mortar_shell))
		shells--
	else if(istype(item, /obj/item/storage/box/packet/rmc/mini))
		shells--

/obj/item/storage/belt/gun/mortarbelt/rmc/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78/rmc())
	new /obj/item/ammo_magazine/pistol/vp78/rmc(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/he(src)
	new /obj/item/mortar_shell/smoke(src)

/obj/item/storage/belt/gun/mortarbelt/rmc/full/gl/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/pistol/vp78/rmc())
	new /obj/item/ammo_magazine/pistol/vp78/rmc(src)
	new /obj/item/storage/box/packet/rmc/mini(src)
	new /obj/item/storage/box/packet/rmc/mini/frag(src)
	new /obj/item/storage/box/packet/rmc/mini/holo(src)

#undef MAXIMUM_MORTARSHELL_COUNT
