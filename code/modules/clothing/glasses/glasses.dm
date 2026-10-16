/obj/item/clothing/glasses
	name = "眼镜"
	gender = PLURAL
	icon = 'icons/obj/items/clothing/glasses.dmi'
	w_class = SIZE_SMALL
	var/vision_flags = 0
	var/darkness_view = 0 //Base human is 2
	/// The amount of nightvision these glasses have. This should be a number between 0 and 1.
	var/lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	var/invisa_view = FALSE
	var/prescription = FALSE
	var/toggleable = FALSE
	var/toggle_on_sound = 'sound/machines/click.ogg'
	var/toggle_off_sound = 'sound/machines/click.ogg'
	var/active = TRUE
	flags_inventory = COVEREYES
	flags_obj = OBJ_IS_HELMET_GARB
	flags_equip_slot = SLOT_EYES
	flags_armor_protection = BODY_FLAG_EYES
	var/deactive_state
	var/has_tint = FALSE //whether it blocks vision like a welding helmet
	var/fullscreen_vision
	var/req_skill
	var/req_skill_level
	var/req_skill_explicit = FALSE

/obj/item/clothing/glasses/Initialize(mapload, ...)
	. = ..()
	if(prescription)
		AddElement(/datum/element/poor_eyesight_correction)

/obj/item/clothing/glasses/get_icon_state(mob/user_mob, slot)
	var/item_state_slot_state = LAZYACCESS(item_state_slots, slot)
	if(item_state_slot_state)
		return item_state_slot_state
	else
		return icon_state

/obj/item/clothing/glasses/update_clothing_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()
		M.update_inv_wear_mask() //For when you have eyewear in the mask slot

/obj/item/clothing/glasses/update_icon()
	if(!deactive_state || active)
		icon_state = initial(icon_state)
	else
		icon_state = deactive_state
	..()

/obj/item/clothing/glasses/proc/can_use_active_effect(mob/living/carbon/human/user)
	if(req_skill && req_skill_level && !(!req_skill_explicit && skillcheck(user, req_skill, req_skill_level)) && !(req_skill_explicit && skillcheckexplicit(user, req_skill, req_skill_level)))
		return FALSE
	else
		return TRUE

/obj/item/clothing/glasses/proc/toggle_glasses_effect()
	active = !active
	clothing_traits_active = !clothing_traits_active
	update_icon()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.glasses == src)
			if(has_tint)
				H.update_tint()
			H.update_sight()
			H.update_glass_vision(src)
			update_clothing_icon()

			if(hud_type)
				for(var/type in hud_type)
					var/datum/mob_hud/MH = GLOB.huds[type]
					if(active)
						MH.add_hud_to(H, src)
						playsound(H, 'sound/handling/hud_on.ogg', 25, 1)
					else
						MH.remove_hud_from(H, src)
						playsound(H, 'sound/handling/hud_off.ogg', 25, 1)
			if(active) //turning it on? then add the traits
				for(var/trait in clothing_traits)
					ADD_TRAIT(H, trait, TRAIT_SOURCE_EQUIPMENT(flags_equip_slot))
			else //turning it off - take away its traits
				for(var/trait in clothing_traits)
					REMOVE_TRAIT(H, trait, TRAIT_SOURCE_EQUIPMENT(flags_equip_slot))

	for(var/X in actions)
		var/datum/action/A = X
		if(istype(A, /datum/action/item_action/toggle))
			A.update_button_icon()

/obj/item/clothing/glasses/proc/try_make_offhand_prescription(mob/user)
	if(!prescription)
		return FALSE

	var/obj/item/clothing/glasses/offhand = user.get_inactive_hand()
	if(istype(offhand) && !offhand.prescription)
		if(tgui_alert(user, "要取出视力矫正镜片并装入[offhand]吗？", "安装视力矫正镜片", list("是", "否")) == "是")
			if(QDELETED(src) || offhand != user.get_inactive_hand())
				return FALSE
			offhand.prescription = TRUE
			offhand.AddElement(/datum/element/poor_eyesight_correction)
			offhand.desc += " 配有视力矫正镜片。"
			user.visible_message(SPAN_DANGER("[user]从[src]中取出镜片，装入[offhand]。"), SPAN_NOTICE("你从[src]中取出镜片，装入[offhand]。"))
			qdel(src)
			return TRUE

	return FALSE

/obj/item/clothing/glasses/sunglasses/prescription/attack_self(mob/user)
	if(try_make_offhand_prescription(user))
		return

	return ..()

/obj/item/clothing/glasses/regular/attack_self(mob/user)
	if(try_make_offhand_prescription(user))
		return

	return ..()

/obj/item/clothing/glasses/equipped(mob/user, slot)
	if(active && slot == WEAR_EYES)
		if(!can_use_active_effect(user))
			toggle_glasses_effect()
			to_chat(user, SPAN_WARNING("你完全看不懂这些数据，赶在头晕恶心之前关掉了设备。"))

		else if(hud_type)
			for(var/type in hud_type)
				var/datum/mob_hud/MH = GLOB.huds[type]
				MH.add_hud_to(user, src)
	user.update_sight()
	..()

/obj/item/clothing/glasses/dropped(mob/living/carbon/human/user)
	if(hud_type && active && istype(user))
		if(src == user.glasses) //dropped is called before the inventory reference is updated.
			for(var/type in hud_type)
				var/datum/mob_hud/H = GLOB.huds[type]
				H.remove_hud_from(user, src)
				user.glasses = null
				user.update_inv_glasses()
	user.update_sight()
	return ..()

/obj/item/clothing/glasses/attack_self(mob/user)
	..()

	if(!toggleable)
		return
	if(!can_use_active_effect(user))
		to_chat(user, SPAN_WARNING("你不知道如何使用[src]。"))
		return

	if(active)
		to_chat(user, SPAN_NOTICE("你关闭了[src]的光学矩阵。"))
		playsound_client(user.client, toggle_off_sound, null, 75)
	else
		to_chat(user, SPAN_NOTICE("你开启了[src]的光学矩阵。"))
		playsound_client(user.client, toggle_on_sound, null, 75)

	toggle_glasses_effect()

/obj/item/clothing/glasses/science
	name = "试剂扫描抬头显示护目镜" //science goggles
	desc = "这副护目镜大概适合那些没有端着步枪、主动缩短自己战场寿命的人。"
	icon_state = "purple"
	item_state = "glasses"
	deactive_state = "purple_off"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE
	flags_inventory = COVEREYES
	req_skill = SKILL_RESEARCH
	req_skill_level = SKILL_RESEARCH_TRAINED
	clothing_traits = list(TRAIT_REAGENT_SCANNER)

/obj/item/clothing/glasses/science/prescription
	name = "试剂扫描抬头显示护目镜（视力矫正型）"
	desc = "这副护目镜大概适合那些没有端着步枪、主动缩短自己战场寿命的人。配有视力矫正镜片。"
	prescription = TRUE

/obj/item/clothing/glasses/science/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("佩戴时，可通过查看物品获知其内含的试剂。")

/obj/item/clothing/glasses/kutjevo
	name = "库特耶沃护目镜"
	desc = "用于保护库特耶沃工人眼睛的护目镜，通过N95Z等级认证。"
	icon_state = "kutjevo_goggles"
	item_state = "kutjevo_goggles"

/obj/item/clothing/glasses/eyepatch
	name = "独眼眼罩"
	gender = NEUTER
	desc = "曾是旧日侠盗的装束，如今更多让人联想到一位传奇人物。据说他既“大”又是个“首领”。厉害吧？可别让宪兵看见你戴这种不合规定的东西。"
	icon_state = "eyepatch"
	item_state = "eyepatch"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	var/toggled = FALSE
	var/original_state = "eyepatch"
	var/toggled_state = "eyepatch_left"
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/eyepatch/ui_action_click()
	toggle_state()

/obj/item/clothing/glasses/eyepatch/verb/toggle_state()
	set name = "切换眼罩方向"
	set category = "物品"
	set src in usr
	if(usr.stat == DEAD)
		return

	toggled = !toggled
	if(toggled)
		icon_state = toggled_state
		item_state = toggled_state
		to_chat(usr, SPAN_NOTICE("你将眼罩转到左眼。"))
	else
		icon_state = original_state
		item_state = original_state
		to_chat(usr, SPAN_NOTICE("你将眼罩转到右眼。"))

	update_clothing_icon() // Updates the on-mob appearance

/obj/item/clothing/glasses/eyepatch/green
	icon_state = "eyepatch_green"
	item_state = "eyepatch_green"
	original_state = "eyepatch_green"
	toggled_state = "eyepatch_green_left"

/obj/item/clothing/glasses/monocle
	name = "单片眼镜"
	gender = NEUTER
	desc = "多么潇洒的目镜！"
	icon_state = "monocle"
	item_state = "headset" // lol
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/material
	name = "光学材料扫描镜"
	desc = "戴上它就能看见物体……就和肉眼一样。话说，造这东西到底是为了什么？"
	icon_state = "material"
	item_state = "glasses"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE

/obj/item/clothing/glasses/regular
	name = "陆战队RPG眼镜"
	desc = "军方称它为制式视力矫正眼镜，你却知道它的真正用途是防止发情——戴上就没人看得上你。"
	icon_state = "mBCG"
	item_state = "mBCG"
	prescription = TRUE
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/regular/hipster
	name = "视力矫正眼镜"
	desc = "无聊的眼镜，让你显得聪明，或许还挺可靠。"
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/threedglasses
	desc = "很久以前，人们戴这种眼镜让屏幕上的画面呈现立体效果。"
	name = "3D眼镜"
	icon_state = "3d"
	item_state = "3d"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/gglasses
	name = "绿色眼镜"
	desc = "森林绿的眼镜，很适合在策划阴谋时佩戴。"
	icon_state = "gglasses"
	item_state = "gglasses"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/jensen
	name = "增强型太阳镜"
	desc = "拆除了抬头显示器的增强型太阳镜。"
	icon_state = "jensenshades"
	item_state = "jensenshades"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/mbcg
	name = "陆战队RPG眼镜（视力矫正型）"
	desc = "军方称它为制式视力矫正眼镜，你却知道它的真正用途是防止发情——戴上就没人看得上你。这副确实配有合适度数的镜片。"
	icon_state = "mBCG"
	item_state = "mBCG"
	prescription = TRUE
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/m42_goggles
	name = "\improper M42侦察瞄准镜"
	gender = NEUTER
	desc = "供M42侦察步枪使用的头戴通讯与护目镜系统，可增强周围环境成像。点击开关。"
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/disco_fever
	name = "故障增强现实面罩"
	gender = NEUTER
	desc = "有人试图用这副增强现实头显观看黑市大角星成人电影，现在它彻底废了。和你不同，迪斯科永不消亡。\n侧面贴着某种癫痫警告标签。"
	icon_state = "discovision"
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	black_market_value = 25

	//These three vars are so that the flashing of the obj and onmob match what the wearer is seeing. They're actually vis_contents rather than overlays,
	//strictly speaking, since overlays can't be animate()-ed.
	var/list/onmob_colors
	var/obj/obj_glass_overlay
	var/obj/mob_glass_overlay

/obj/item/clothing/glasses/disco_fever/Initialize(mapload, ...)
	. = ..()

	obj_glass_overlay = new()
	obj_glass_overlay.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_ICON
	obj_glass_overlay.icon_state = "discovision_glass"
	obj_glass_overlay.layer = FLOAT_LAYER
	vis_contents += obj_glass_overlay

	mob_glass_overlay = new()
	mob_glass_overlay.icon = icon
	mob_glass_overlay.vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR
	mob_glass_overlay.icon_state = "discovision_glass_onmob"
	mob_glass_overlay.layer = FLOAT_LAYER

	//The overlays are painted in shades of pure red. These matrices convert them to various shades of the new color.
	onmob_colors = list(
		"base" = color_matrix_recolor_red("#5D5D5D"),
		"yellow" = color_matrix_recolor_red("#D4C218"),
		"green" = color_matrix_recolor_red("#0DB347"),
		"cyan" = color_matrix_recolor_red("#2AC1DB"),
		"blue" = color_matrix_recolor_red("#005BF7"),
		"indigo" = color_matrix_recolor_red("#9608D4"),
		)

	obj_glass_overlay.color = onmob_colors["base"]
	mob_glass_overlay.color = onmob_colors["base"]

/obj/item/clothing/glasses/disco_fever/equipped(mob/living/carbon/human/user, slot)
	. = ..()

	if(!ishuman(user) || slot != WEAR_EYES && slot != WEAR_FACE)
		return

	RegisterSignal(user, COMSIG_MOB_RECALCULATE_CLIENT_COLOR, PROC_REF(apply_discovision_handler))
	apply_discovision_handler(user)

	//Add the onmob overlay. Normal onmob images are handled by static overlays.
	//It's added to the head object so that glasses/mask overlays on the mob render above it, since vis_contents and overlays appear to use different layerings.
	var/obj/limb/head/user_head = user.get_limb("head")
	user_head?.vis_contents += mob_glass_overlay

///Ends existing animations in preparation for the funny. Looping animations don't seem to properly end if a new one is started on the same tick.
/obj/item/clothing/glasses/disco_fever/proc/apply_discovision_handler(mob/user)
	SIGNAL_HANDLER

	//User client has its looping animation ended by the login matrix update when ghosting.
	//For some reason the obj overlay doesn't end the loop properly when set to 0 seconds, but as long as the previous loop is ended the new one should
	//transition smoothly from whatever color it current has.
	animate(obj_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)
	animate(mob_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(apply_discovision), user), 0.1 SECONDS)

///Handles disco-vision. Normal client color matrix handling isn't set up for a continuous animation like this, so this is applied afterwards.
/obj/item/clothing/glasses/disco_fever/proc/apply_discovision(mob/user)
	//Caramelldansen HUD overlay.
	//Use of this filter in armed conflict is in direct contravention of the Geneva Suggestions (2120 revision)
	//Colors are based on a bit of the music video. Original version was a rainbow with #c20000 and #db6c03 as well.

	//Animate the obj and onmob in sync with the client.
	for(var/I in list(obj_glass_overlay, mob_glass_overlay))
		animate(I, color = onmob_colors["indigo"], time = 0.3 SECONDS, loop = -1)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["cyan"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["yellow"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["green"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["blue"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)
		animate(color = onmob_colors["yellow"], time = 0.3 SECONDS)
		animate(color = onmob_colors["base"], time = 0.3 SECONDS)

	if(!user.client) //Shouldn't happen but can't hurt to check.
		return

	var/base_colors
	if(!user.client.color) //No set client color.
		base_colors = color_matrix_saturation(1.35) //Crank up the saturation and get ready to party.
	else if(istext(user.client.color)) //Hex color string.
		base_colors = color_matrix_multiply(color_matrix_from_string(user.client.color), color_matrix_saturation(1.35))
	else //Color matrix.
		base_colors = color_matrix_multiply(user.client.color, color_matrix_saturation(1.35))

	var/list/colours = list(
		"yellow" = color_matrix_multiply(base_colors, color_matrix_from_string("#d4c218")),
		"green" = color_matrix_multiply(base_colors, color_matrix_from_string("#2dc404")),
		"cyan" = color_matrix_multiply(base_colors, color_matrix_from_string("#2ac1db")),
		"blue" = color_matrix_multiply(base_colors, color_matrix_from_string("#005BF7")),
		"indigo" = color_matrix_multiply(base_colors, color_matrix_from_string("#b929f7"))
		)

	//Animate the victim's client.
	animate(user.client, color = colours["indigo"], time = 0.3 SECONDS, loop = -1)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["cyan"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["yellow"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["green"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["blue"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)
	animate(color = colours["yellow"], time = 0.3 SECONDS)
	animate(color = base_colors, time = 0.3 SECONDS)

/obj/item/clothing/glasses/disco_fever/dropped(mob/living/carbon/human/user)
	. = ..()

	if(!ishuman(user))
		return

	UnregisterSignal(user, COMSIG_MOB_RECALCULATE_CLIENT_COLOR)

	animate(obj_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)
	animate(mob_glass_overlay, color = onmob_colors["base"], time = 0.3 SECONDS)

	user.update_client_color_matrices(0.3 SECONDS)
	var/obj/limb/head/user_head = user.get_limb("head")
	user_head?.vis_contents -= mob_glass_overlay

/obj/item/clothing/glasses/mgoggles
	name = "防弹护目镜"
	desc = "一副防日晒、防风、防尘护目镜，配有达到防弹标准的普通透明镜片。"
	icon_state = "mgoggles"
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_obj = OBJ_NO_HELMET_BAND|OBJ_IS_HELMET_GARB
	eye_protection = EYE_PROTECTION_FLAVOR
	var/activated = FALSE
	var/active_icon_state = "mgoggles_down"
	var/inactive_icon_state = "mgoggles"

	var/datum/action/item_action/activation
	var/obj/item/attached_item
	garbage = FALSE

/obj/item/clothing/glasses/mgoggles/prescription
	name = "防弹护目镜（视力矫正型）"
	desc = "一副防日晒、防风、防尘护目镜，配有专门定制、达到防弹标准的透明视力矫正镜片。"
	icon_state = "mgoggles"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/black
	name = "遮阳防弹护目镜"
	desc = "一副防日晒、防风、防尘护目镜，配有达到防弹标准的深色遮阳镜片。"
	icon_state = "mgogglesblk"
	active_icon_state = "mgogglesblk_down"
	inactive_icon_state = "mgogglesblk"
	eye_protection = EYE_PROTECTION_FLASH

/obj/item/clothing/glasses/mgoggles/black/prescription
	name = "遮阳防弹护目镜（视力矫正型）"
	desc = "一副防日晒、防风、防尘护目镜，配有专门定制、达到防弹标准的深色遮阳视力矫正镜片。"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/orange
	name = "防激光防弹护目镜"
	desc = "一副防日晒、防风、防尘护目镜，配有达到防弹和防激光标准的棕色镜片。"
	icon_state = "mgogglesorg"
	active_icon_state = "mgogglesorg_down"
	inactive_icon_state = "mgogglesorg"
	eye_protection = EYE_PROTECTION_FLASH

/obj/item/clothing/glasses/mgoggles/orange/prescription
	name = "防激光防弹护目镜（视力矫正型）"
	desc = "一副防日晒、防风、防尘护目镜，配有专门定制、达到防弹和防激光标准的棕色视力矫正镜片。"
	icon_state = "mgogglesorg"
	active_icon_state = "mgogglesorg_down"
	inactive_icon_state = "mgogglesorg"
	prescription = TRUE

/obj/item/clothing/glasses/mgoggles/green
	name = "防激光防弹护目镜"
	desc = "一副防日晒、防风、防尘护目镜，配有达到防弹和防激光标准的棕色镜片。"
	icon_state = "mgogglesgrn"
	active_icon_state = "mgogglesgrn_down"
	inactive_icon_state = "mgogglesgrn"
	eye_protection = EYE_PROTECTION_FLASH

/obj/item/clothing/glasses/mgoggles/green/prescription
	name = "防激光防弹护目镜（视力矫正型）"
	desc = "一副防日晒、防风、防尘护目镜，配有专门定制、达到防弹和防激光标准的棕色视力矫正镜片。"
	icon_state = "mgogglesgrn"
	active_icon_state = "mgogglesgrn_down"
	inactive_icon_state = "mgogglesgrn"
	eye_protection = EYE_PROTECTION_FLASH

/obj/item/clothing/glasses/mgoggles/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S))
		return

	remove_attached_item()

	attached_item = S.master_object
	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, PROC_REF(remove_attached_item))
	RegisterSignal(attached_item, COMSIG_ITEM_EQUIPPED, PROC_REF(wear_check))
	activation = new /datum/action/item_action/toggle(src, S.master_object)

	if(ismob(S.master_object.loc))
		activation.give_to(S.master_object.loc)

/obj/item/clothing/glasses/mgoggles/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()

/obj/item/clothing/glasses/mgoggles/proc/remove_attached_item()
	SIGNAL_HANDLER
	if(!attached_item)
		return

	UnregisterSignal(attached_item, COMSIG_PARENT_QDELETING)
	UnregisterSignal(attached_item, COMSIG_ITEM_EQUIPPED)
	qdel(activation)
	attached_item = null

/obj/item/clothing/glasses/mgoggles/ui_action_click(mob/owner, obj/item/holder)
	toggle_goggles(owner)
	activation.update_button_icon()

/obj/item/clothing/glasses/mgoggles/proc/wear_check(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_HEAD && prescription == TRUE && activated)
		ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription)) //Checks if dropped/unequipped for prescription.
	else
		REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription)) //Looks messy but potential for adding other cases for goggle types other than prescription in the future such as welding or helmet HUD attachments.

/obj/item/clothing/glasses/mgoggles/proc/toggle_goggles(mob/living/carbon/human/user)
	if(user.is_mob_incapacitated())
		return

	if(!attached_item)
		return

	activated = !activated
	if(activated)
		to_chat(user, SPAN_NOTICE("你将护目镜拉下。"))
		icon_state = active_icon_state
		if(prescription == TRUE && user.head == attached_item)
			ADD_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription))
	else
		to_chat(user, SPAN_NOTICE("你将护目镜推起。"))
		icon_state = inactive_icon_state
		if(prescription == TRUE)
			REMOVE_TRAIT(user, TRAIT_NEARSIGHTED_EQUIPMENT, TRAIT_SOURCE_EQUIPMENT(/obj/item/clothing/glasses/mgoggles/prescription))

	attached_item.update_icon()

/obj/item/clothing/glasses/mgoggles/upp
	name = "UPP防弹护目镜"
	desc = "进步人民联盟步兵的制式防弹护目镜。虽然经常只是装在头盔上面，但它确实能防止昆虫、灰尘等东西进入眼睛。"
	icon_state = "mgogglesupp"
	active_icon_state = "mgogglesupp_down"
	inactive_icon_state = "mgogglesupp"

/obj/item/clothing/glasses/mgoggles/upp/prescription
	name = "UPP防弹护目镜（视力矫正型）"
	prescription = TRUE


//welding goggles

/obj/item/clothing/glasses/welding
	name = "焊接护目镜"
	desc = "保护眼睛免受焊接强光伤害，疯狂科学家协会认证。"
	icon_state = "welding-g"
	item_state = "welding-g"
	deactive_state = "welding-gup"
	actions_types = list(/datum/action/item_action/toggle)
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEYES
	eye_protection = EYE_PROTECTION_WELDING
	has_tint = TRUE
	vision_impair = VISION_IMPAIR_MAX
	var/vision_impair_on = VISION_IMPAIR_MAX
	var/vision_impair_off = VISION_IMPAIR_NONE

/obj/item/clothing/glasses/welding/attack_self()
	..()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "物品"
	set name = "调整焊接护目镜"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	if(active)
		active = 0
		vision_impair = vision_impair_off
		flags_inventory &= ~COVEREYES
		flags_inv_hide &= ~HIDEEYES
		flags_armor_protection &= ~BODY_FLAG_EYES
		update_icon()
		eye_protection = EYE_PROTECTION_NONE
		to_chat(usr, "你将[src]从眼前推起。")
	else
		active = 1
		vision_impair = vision_impair_on
		flags_inventory |= COVEREYES
		flags_inv_hide |= HIDEEYES
		flags_armor_protection |= BODY_FLAG_EYES
		update_icon()
		eye_protection = initial(eye_protection)
		to_chat(usr, "你放下[src]，保护双眼。")


	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.glasses == src)
			H.update_tint()

	update_clothing_icon()

	for(var/X in actions)
		var/datum/action/A = X
		if(istype(A, /datum/action/item_action/toggle))
			A.update_button_icon()

/obj/item/clothing/glasses/welding/superior
	name = "高级焊接护目镜"
	desc = "用更昂贵材料制成的焊接护目镜，不知为何有股土豆味。"
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	vision_impair = VISION_IMPAIR_WEAK
	vision_impair_on = VISION_IMPAIR_WEAK
	vision_impair_off = VISION_IMPAIR_NONE

/obj/item/clothing/glasses/welding/superior/alt
	desc = "用更昂贵材料制成的焊接护目镜。"

/obj/item/clothing/glasses/welding/superior/prescription
	desc = "用更昂贵材料制成的焊接护目镜。镜框连着几乎看不见的视力矫正镜片，抬起护目镜后仍能看清。"
	prescription = TRUE
//sunglasses

/obj/item/clothing/glasses/sunglasses
	desc = "普通杂牌眼镜，提供基础眼部遮护。强化遮光层可以挡住多种闪光。"
	name = "太阳镜"
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = -1
	flags_equip_slot = SLOT_EYES|SLOT_FACE
	flags_inv_hide = HIDEEYES
	eye_protection = EYE_PROTECTION_FLAVOR

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "蒙眼布"
	gender = NEUTER
	desc = "遮住双眼，使人无法看见。"
	icon_state = "blindfold"
	item_state = "blindfold"
	//vision_flags = DISABILITY_BLIND // This flag is only supposed to be used if it causes permanent blindness, not temporary because of glasses

/obj/item/clothing/glasses/sunglasses/prescription
	desc = "将酷劲与矫正眼镜自带的书呆子气质混在一起，不知怎的把两者都遮住了。"
	name = "太阳镜（视力矫正型）"
	prescription = TRUE
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/big
	name = "\improper 比迈克斯偏光太阳镜"
	desc = "专为现代作战人员设计的太阳镜，线条利落、棱角分明。比迈克斯最新的“战术光学”系列配有先进偏光镜片和轻型防弹镜片，可抵挡小弹片冲击。它深受前线人员和深空侦察员喜爱，广告宣称“实战验证，行动认可”。有人传言，幸运的使用者靠多重反射镜片涂层从近距离激光射击中生还；比迈克斯的官方态度则是：“别站在激光前面。”"
	icon_state = "bimex_black"
	item_state = "bimex_black"
	eye_protection = EYE_PROTECTION_FLASH
	clothing_traits = list(TRAIT_BIMEX)
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/big/orange
	name = "\improper 比迈克斯战术太阳镜"
	desc = "一副昂贵的比迈克斯橙色镜片太阳镜，主要供美国陆军人员在靶场训练时防尘使用，也有一些流入了私人市场。"
	icon_state = "bimex_orange"
	item_state = "bimex_orange"

/obj/item/clothing/glasses/sunglasses/big/classic
	name = "比迈克斯经典防弹太阳镜"
	desc = "这款太阳镜曾在美国殖民地海军陆战队少量配发，采用坚固镜框和超材料镜片。自动偏光能抵御从狙击激光到核爆闪光的强光，复合结构则能抵挡碎片冲击并防止镜片碎裂。虽老，却永不过时。"
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"

/obj/item/clothing/glasses/sunglasses/aviator
	name = "飞行员太阳镜"
	desc = "一副棕褐色镜片的太阳镜。戴上后，仿佛能隐约听见80年代音乐。"
	icon_state = "aviator"
	item_state = "aviator"
	flags_equip_slot = SLOT_EYES|SLOT_FACE

/obj/item/clothing/glasses/sunglasses/sechud
	name = "安保抬头显示眼镜"
	desc = "搭载了殖民地陆战队在边疆能弄到的最好纳米技术的太阳镜，可显示你愿意多看一眼的任何人的信息。"
	icon_state = "sunhud"
	eye_protection = EYE_PROTECTION_FLASH
	hud_type = MOB_HUD_SECURITY_ADVANCED

/obj/item/clothing/glasses/sunglasses/sechud/prescription
	name = "安保抬头显示眼镜（视力矫正型）"
	desc = "搭载了殖民地陆战队在边疆能弄到的最好纳米技术的太阳镜，可显示你愿意多看一眼的任何人的信息。配有视力矫正镜片。"
	prescription = TRUE

/obj/item/clothing/glasses/sunglasses/sechud/eyepiece
	name = "安保抬头显示瞄准镜"
	gender = NEUTER
	desc = "经过改装的标准目镜，能直观显示安保信息，因此在宪兵中很常见，不过也有其他型号。"
	icon_state = "securityhud"
	item_state = "securityhud"
	eye_protection = EYE_PROTECTION_FLASH


/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "特警战术抬头显示器"
	gender = NEUTER
	desc = "内置战斗和安保信息显示功能的防闪光护目镜。"
	icon_state = "swatgoggles"

/obj/item/clothing/glasses/canc_monoscope
	name = "“妖怪”单目镜"
	desc = "一款与CANC智能瞄准镜系列共同开发的单目抬头显示器，配有安装在后脑的微型处理单元。没有它，智能瞄准镜的大部分功能都无法使用。"
	icon_state = "monoscope"
	item_state = "monoscope"
	flags_armor_protection = 0
	flags_equip_slot = SLOT_EYES
