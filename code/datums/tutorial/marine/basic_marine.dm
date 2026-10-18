/datum/tutorial/marine/basic
	name = "陆战队员——基础"
	desc = "帮助你熟悉地面陆战队岗位最基础玩法的教学。"
	tutorial_id = "marine_basic_1"
	tutorial_template = /datum/map_template/tutorial/s8x9/no_baselight
	/// How many items need to be vended from the clothing vendor for the script to continue, if something vends 2 items (for example), increase this number by 2.
	var/clothing_items_to_vend = 8
	/// How many items need to be vended from the gun vendor to continue
	var/gun_items_to_vend = 2

// START OF SCRIPTING

/datum/tutorial/marine/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	var/obj/item/device/flashlight/flashlight = new(loc_from_corner(2, 3))
	flashlight.anchored = TRUE
	flashlight.set_light_power(4)
	flashlight.set_light_range(12)
	flashlight.icon = null
	flashlight.set_light_on(TRUE)
	add_to_tracking_atoms(flashlight)

	init_mob()
	message_to_player("这是陆战队步枪兵教程。按<b>[retrieve_bind("North")]</b>或<b>[retrieve_bind("East")]</b>离开休眠舱，继续教程。")
	update_objective("按[retrieve_bind("North")]或[retrieve_bind("East")]离开休眠舱。")
	RegisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT, PROC_REF(on_cryopod_exit))

/datum/tutorial/marine/basic/proc/on_cryopod_exit()
	SIGNAL_HANDLER

	UnregisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT)
	message_to_player("很好。你可能注意到了屏幕右侧黄色的“食物”图标。前往高亮的<b>食品售货机</b>，领取<b>USCM蛋白棒</b>。")
	update_objective("从高亮的ColMarTech食品售货机领取一根USCM蛋白棒。")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	add_highlight(food_vendor)
	food_vendor.req_access = list()
	RegisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_food_vend))

/datum/tutorial/marine/basic/proc/on_food_vend(datum/source, obj/structure/machinery/cm_vending/vendor, list/itemspec, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	UnregisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
	remove_highlight(food_vendor)
	food_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
	message_to_player("现在手持<b>USCM蛋白棒</b>点击自己的角色，直到吃完。如果不小心切换了手，按<b>[retrieve_bind("swap_hands")]</b>切换回来。")
	update_objective("手持USCM蛋白棒点击自己，直到把它吃完。")
	RegisterSignal(tutorial_mob, COMSIG_MOB_EATEN_SNACK, PROC_REF(on_foodbar_eaten))

/datum/tutorial/marine/basic/proc/on_foodbar_eaten(datum/source, obj/item/reagent_container/food/snacks/eaten_food)
	SIGNAL_HANDLER

	if(!istype(eaten_food, /obj/item/reagent_container/food/snacks/protein_pack) || eaten_food.reagents.total_volume)
		return

	UnregisterSignal(source, COMSIG_MOB_EATEN_SNACK)
	message_to_player("很好。现在前往高亮的售货机，领取里面的所有物品。")
	update_objective("领取ColMarTech自动装备柜里的全部物品。")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial, clothing_vendor)
	add_highlight(clothing_vendor)
	clothing_vendor.req_access = list()
	RegisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_clothing_vend))

/datum/tutorial/marine/basic/proc/on_clothing_vend(datum/source)
	SIGNAL_HANDLER

	clothing_items_to_vend--
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial, clothing_vendor)
		UnregisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		clothing_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(clothing_vendor)
		message_to_player("现在房间会变暗。空手点击<b>照明弹袋</b>取出一枚<b>照明弹</b>，然后按<b>[retrieve_bind("activate_inhand")]</b>使用手中的照明弹，将其点燃。")
		update_objective("点击照明弹袋取出一枚照明弹，然后在手中使用。")
		var/obj/item/storage/pouch/flare/flare_pouch = locate(/obj/item/storage/pouch/flare) in tutorial_mob.contents
		if(flare_pouch)
			add_highlight(flare_pouch)
		RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(on_flare_light))
		addtimer(CALLBACK(src, PROC_REF(dim_room)), 2.5 SECONDS)

/datum/tutorial/marine/basic/proc/on_flare_light(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/device/flashlight/flare))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)
	var/obj/item/storage/pouch/flare/flare_pouch = locate(/obj/item/storage/pouch/flare) in tutorial_mob.contents
	if(flare_pouch)
		remove_highlight(flare_pouch)

	message_to_player("现在<b>点击</b>附近的地面扔出<b>照明弹</b>，或按<b>[retrieve_bind("drop_item")]</b>将其丢下。")
	update_objective("点击附近的地面扔出照明弹，或按[retrieve_bind("drop_item")]将其丢下。")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_DROPPED, PROC_REF(on_flare_throw))

/datum/tutorial/marine/basic/proc/on_flare_throw(datum/source, obj/item/thrown)
	SIGNAL_HANDLER

	if(!istype(thrown, /obj/item/device/flashlight/flare))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_DROPPED)
	message_to_player("很好。现在房间会重新亮起来。前往高亮的售货机，领取一把<b>M41A MK2脉冲步枪</b>和一个<b>弹匣</b>。")
	update_objective("领取ColMarTech自动武器架里的全部物品。")
	addtimer(CALLBACK(src, PROC_REF(brighten_room)), 1.5 SECONDS)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
	gun_vendor.req_access = list()
	add_highlight(gun_vendor)
	RegisterSignal(gun_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_gun_vend))

/datum/tutorial/marine/basic/proc/on_gun_vend(datum/source)
	SIGNAL_HANDLER

	gun_items_to_vend--
	if(gun_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
		gun_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(gun_vendor)
		UnregisterSignal(gun_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		message_to_player("现在将<b>弹匣</b>装入<b>M41A脉冲步枪</b>：用当前操作的手拿住<b>弹匣</b>，点击<b>脉冲步枪</b>。如果弹匣在另一只手，按<b>[retrieve_bind("swap_hands")]</b>切换。")
		update_objective("用手持的M41A弹匣点击M41A脉冲步枪，将弹匣装入。")
		RegisterSignal(tutorial_mob, COMSIG_MOB_RELOADED_GUN, PROC_REF(on_magazine_insert))

/datum/tutorial/marine/basic/proc/on_magazine_insert(datum/source, atom/attacked, obj/item/attacked_with)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_RELOADED_GUN)
	message_to_player("很好。现在按<b>[retrieve_bind("activate_inhand")]</b>使用手中的枪，将其改为双手持握。")
	update_objective("当前操作的手拿着枪时，按[retrieve_bind("activate_inhand")]双手持枪。")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(on_gun_wield))

/datum/tutorial/marine/basic/proc/on_gun_wield(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/weapon/gun/rifle/m41a))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)
	message_to_player("现在向高亮的<b>异形</b>射击，直到将其击杀。")
	update_objective("射杀异形。")
	var/mob/living/carbon/xenomorph/drone/tutorial/xeno_dummy = new(loc_from_corner(4, 5))
	add_to_tracking_atoms(xeno_dummy)
	add_highlight(xeno_dummy, COLOR_VIVID_RED)
	RegisterSignal(xeno_dummy, COMSIG_MOB_DEATH, PROC_REF(on_xeno_death))
	RegisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY, PROC_REF(on_magazine_empty)) // I'd like to prevent unwilling softlocks as much as I can

/// Non-contiguous part of the script, called if the user manages to run out of ammo in the gun without the xeno dying
/datum/tutorial/marine/basic/proc/on_magazine_empty(obj/item/weapon/gun/empty_gun)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY)
	message_to_player("你的枪没子弹了。从<b>武器售货机</b>补充弹药，再击杀<b>异形</b>。")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
	gun_vendor.req_access = list()
	gun_vendor.load_ammo() // 99 magazines, to make sure that the xeno dies

/datum/tutorial/marine/basic/proc/on_xeno_death(datum/source)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/xenomorph/drone/tutorial, xeno_dummy)
	UnregisterSignal(xeno_dummy, COMSIG_MOB_DEATH)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY)
	remove_highlight(xeno_dummy)
	addtimer(CALLBACK(src, PROC_REF(disappear_xeno)), 2.5 SECONDS)
	message_to_player("很好。本教程到此结束。接下来可以学习<b>医疗基础</b>教程。你即将返回大厅。")
	update_objective("")
	tutorial_end_in(7.5 SECONDS, TRUE)


// END OF SCRIPTING
// START OF SCRIPT HELPERS

/datum/tutorial/marine/basic/proc/dim_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight, flashlight)
	flashlight.set_light_on(FALSE)

/datum/tutorial/marine/basic/proc/brighten_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight, flashlight)
	flashlight.set_light_on(TRUE)

/datum/tutorial/marine/basic/proc/disappear_xeno()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/xenomorph/drone/tutorial, xeno_dummy)
	animate(xeno_dummy, time = 5 SECONDS, alpha = 0)
	remove_from_tracking_atoms(xeno_dummy)
	QDEL_IN(xeno_dummy, 5.5 SECONDS)

// END OF SCRIPT HELPERS

/datum/tutorial/marine/basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	tutorial_pod.go_in_cryopod(tutorial_mob, TRUE, FALSE)


/datum/tutorial/marine/basic/init_map()
	var/obj/structure/machinery/cryopod/tutorial/tutorial_pod = new(bottom_left_corner)
	add_to_tracking_atoms(tutorial_pod)
	var/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial/food_vendor = new(loc_from_corner(0, 2))
	add_to_tracking_atoms(food_vendor)
	var/obj/structure/machinery/cm_vending/clothing/tutorial/clothing_vendor = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(clothing_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial/gun_vendor = new(loc_from_corner(0, 5))
	add_to_tracking_atoms(gun_vendor)
