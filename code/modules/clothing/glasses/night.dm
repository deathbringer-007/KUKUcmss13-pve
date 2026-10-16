// nightvision goggles

/obj/item/clothing/glasses/night
	name = "\improper TV1夜视镜"
	gender = PLURAL
	desc = "一副外形精致的民用夜视镜。"
	icon = 'icons/obj/items/clothing/glasses.dmi' //Why wasn't this on the parent item before?
	icon_state = "night"
	item_state = "night"
	deactive_state = "night_off"
	toggle_on_sound = 'sound/handling/toggle_nv1.ogg'
	toggle_off_sound = 'sound/handling/toggle_nv2.ogg'
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	darkness_view = 12
	vision_flags = SEE_TURFS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	fullscreen_vision = null
	eye_protection = EYE_PROTECTION_NEGATIVE
	var/headcam = FALSE
	var/obj/structure/machinery/camera/camera

/obj/item/clothing/glasses/night/Initialize()
	. = ..()
	camera = new /obj/structure/machinery/camera/overwatch(src)

/obj/item/clothing/glasses/night/equipped(mob/living/carbon/human/mob, slot)
	if(headcam && camera)
		camera.c_tag = mob.name
	..()

/obj/item/clothing/glasses/night/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/clothing/glasses/night/helmet //for the integrated NVGs that are in helmetgarb code
	name = "\improper M2夜视镜"
	desc = "M2夜视系统的目镜部分。"
	icon_state = "stub" //our actual icon is a part of our helmet.
	item_state = null
	vision_flags = SEE_TURFS
	flags_item = NODROP|DELONDROP|ITEM_ABSTRACT
	flags_inventory = CANTSTRIP

/obj/item/clothing/glasses/night/M49A
	name = "\improper M49A战斗瞄准镜"
	gender = NEUTER
	desc = "供M49A战斗步枪使用的头戴通讯与夜视系统。可增强周围环境成像，查看其他陆战队员的生命体征监测读数，并接入指挥控制网络。点击开关。"
	icon_state = "m49a_goggles"
	deactive_state = "m49a_goggles_0"
	vision_flags = SEE_TURFS
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_MEDICAL_BASIC)
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)
	headcam = TRUE

/obj/item/clothing/glasses/night/medhud
	name = "\improper Mark 4战地医护瞄准镜"
	gender = NEUTER
	desc = "集头戴通讯、夜视光学和生命体征读数于一体的系统。可增强周围环境成像，查看其他陆战队员的生命体征监测读数，并接入指挥控制网络。点击开关。"
	icon_state = "m4_goggles"
	deactive_state = "m4_goggles_0"
	vision_flags = SEE_TURFS
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_MEDICAL_ADVANCED)
	toggleable = TRUE
	fullscreen_vision = null
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_MEDIC
	actions_types = list(/datum/action/item_action/toggle)
	headcam = TRUE

/obj/item/clothing/glasses/night/medhud/no_nvg
	name = "\improper Mark 2战地医护瞄准镜"
	desc = "集头戴通讯和生命体征读数于一体的系统。可查看其他陆战队员的生命体征监测读数，并接入指挥控制网络。点击开关。"
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_MEDICAL_ADVANCED) // Need to redefine or it won't work
	darkness_view = 0
	vision_flags = 0
	lighting_alpha = 255

/obj/item/clothing/glasses/night/ghillie_goggles
	name = "\improper 比迈克斯M3昼夜两用镜"
	desc = "一套增强视觉护目镜，通常配发给殖民地陆战队侦察狙击小组的射手。可增强周围环境成像。点击开关。"
	icon_state = "ghillie_goggles"
	deactive_state = "ghillie_goggles_0"
	vision_flags = SEE_TURFS
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/night/m42_hms
	name = "\improper M42头戴式瞄准镜"
	gender = NEUTER
	desc = "通常安装在M56武器系统上的头戴式瞄准镜的独立版本。可增强周围环境成像，让佩戴者接入指挥控制网络，并提供抬头显示。点击开关。"
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY)
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)
	headcam = TRUE

/obj/item/clothing/glasses/night/m42_hms/rmc
	darkness_view = 0
	vision_flags = 0
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	hud_type = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)

/obj/item/clothing/glasses/night/m42_hms/no_nvg
	name = "\improper M42头戴式瞄准镜"
	desc = "通常安装在M56武器系统上的头戴式瞄准镜的独立版本。可接入指挥控制网络，并提供抬头显示。点击开关。"
	actions_types = list(/datum/action/item_action/toggle)
	darkness_view = 0
	vision_flags = 0
	lighting_alpha = 255

/obj/item/clothing/glasses/night/m42_hms/m42c
	name = "\improper M42C特种作战瞄准镜"
	desc = "M42侦察瞄准系统的特化改型，专为大威力M42C反坦克狙击步枪设计。可增强周围环境成像，并从极远处探测热信号。点击开关。"
	vision_flags = SEE_TURFS|SEE_MOBS
	hud_type = list(MOB_HUD_FACTION_PMC, MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)

/obj/item/clothing/glasses/night/m42_hms/upp
	name = "\improper 9式突击队护目镜"
	gender = PLURAL
	desc = "进步人民联盟部队使用的头戴通讯与夜视系统。可增强周围环境成像。点击开关。"
	icon_state = "upp_goggles"
	deactive_state = "upp_goggles_0"
	req_skill = null
	req_skill_level = null
	hud_type = list(MOB_HUD_FACTION_UPP)

/obj/item/clothing/glasses/night/m56_goggles
	name = "\improper M56头戴式瞄准镜"
	gender = NEUTER
	desc = "供M56智能机枪武器系统使用的头戴通讯与光学系统。配有低分辨率近距成像仪，可观察地形。"
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/m56_goggles/far_sight)
	vision_flags = SEE_TURFS
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY)
	flags_inventory = SMARTGUN_OPTIC
	fullscreen_vision = null
	eye_protection = EYE_PROTECTION_FLAVOR
	req_skill = SKILL_SPEC_WEAPONS
	req_skill_level = SKILL_SPEC_SMARTGUN
	headcam = TRUE
	var/far_sight = FALSE
	var/obj/item/weapon/gun/smartgun/linked_smartgun = null

/obj/item/clothing/glasses/night/m56_goggles/Destroy()
	QDEL_NULL(camera)
	linked_smartgun = null
	disable_far_sight()
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/proc/link_smartgun(mob/user)
	if(!QDELETED(user))
		linked_smartgun = locate() in user
		if(linked_smartgun)
			return TRUE
	return FALSE

/obj/item/clothing/glasses/night/m56_goggles/mob_can_equip(mob/user, slot)
	if(slot == WEAR_EYES)
		if(!link_smartgun(user))
			to_chat(user, SPAN_NOTICE("必须先装备智能机枪才能佩戴它。"))
			return FALSE
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/equipped(mob/user, slot)
	if(slot != SLOT_EYES)
		disable_far_sight(user)
	if(camera)
		camera.c_tag = user.name
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/dropped(mob/living/carbon/human/user)
	linked_smartgun = null
	disable_far_sight(user)
	return ..()

/obj/item/clothing/glasses/night/m56_goggles/proc/set_far_sight(mob/living/carbon/human/user, set_to_state = TRUE)
	if(set_to_state)
		if(user.glasses != src)
			to_chat(user, SPAN_WARNING("没有戴上[src]，无法开启远视！"))
			return
		if(!link_smartgun(user))
			to_chat(user, SPAN_WARNING("没有智能机枪，无法使用此设备！"))
			return
		far_sight = TRUE
		if(user)
			if(user.client)
				user.client.change_view(8, src)
		START_PROCESSING(SSobj, src)
	else
		linked_smartgun = null
		far_sight = FALSE
		if(user)
			if(user.client)
				user.client.change_view(GLOB.world_view_size, src)
		STOP_PROCESSING(SSobj, src)

	var/datum/action/item_action/m56_goggles/far_sight/FT = locate(/datum/action/item_action/m56_goggles/far_sight) in actions
	if(FT)
		FT.update_button_icon()

/obj/item/clothing/glasses/night/m56_goggles/proc/disable_far_sight(mob/living/carbon/human/user)
	if(!istype(user))
		user = loc
		if(!istype(user))
			user = null
	set_far_sight(user, FALSE)

/obj/item/clothing/glasses/night/m56_goggles/process(delta_time)
	var/mob/living/carbon/human/user = loc
	if(!istype(user))
		set_far_sight(null, FALSE)
		return PROCESS_KILL
	if(!link_smartgun(user))
		set_far_sight(user, FALSE)
		return PROCESS_KILL
	if(!linked_smartgun.drain_battery(25 * delta_time))
		set_far_sight(user, FALSE)

/datum/action/item_action/m56_goggles/far_sight/New()
	. = ..()
	name = "开关远视"
	action_icon_state = "far_sight"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/m56_goggles/far_sight/action_activate()
	. = ..()
	if(target)
		var/obj/item/clothing/glasses/night/m56_goggles/G = target
		G.set_far_sight(owner, !G.far_sight)
		to_chat(owner, SPAN_NOTICE("你[G.far_sight ? "开启" : "关闭"]了[G]的远视系统。"))

/datum/action/item_action/m56_goggles/far_sight/update_button_icon()
	if(!target)
		return
	var/obj/item/clothing/glasses/night/m56_goggles/G = target
	if(G.far_sight)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/obj/item/clothing/glasses/night/m56_goggles/no_nightvision
	actions_types = list(/datum/action/item_action/toggle)
	darkness_view = 0
	vision_flags = 0
	lighting_alpha = 255

/obj/item/clothing/glasses/night/m56_goggles/rmc
	name = "\improper L58A3头戴式枪瞄接口"
	desc = "供L58A3智能机枪武器系统使用的头戴通讯与光学系统。配有低分辨率近距成像仪，可观察地形。"
	actions_types = list(/datum/action/item_action/toggle)
	darkness_view = 0
	vision_flags = 0
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	hud_type = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)

/obj/item/clothing/glasses/night/m56_goggles/whiteout
	name = "\improper M56T头戴式瞄准镜"
	desc = "供M56T“终结者”智能机枪使用的头戴通讯与护目镜系统。配有微光视觉处理器，以及能透过实体表面探测热信号的系统。"
	vision_flags = SEE_TURFS|SEE_MOBS
	hud_type = list(MOB_HUD_FACTION_PMC, MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)

/obj/item/clothing/glasses/night/m56_goggles/upp
	name = "\improper RADIO头戴装置"
	desc = "为配合RFVS-37开发的自动步枪手综合光电装置，可让进步人民联盟特种部队的步枪手在低能见度环境中目视搜索目标，同时安全操作武器。"
	icon_state = "radio_head_rig"
	deactive_state = "radio_head_rig_0"
	hud_type = list(MOB_HUD_FACTION_UPP)

/obj/item/clothing/glasses/night/m56_goggles/upp/no_nightvision
	actions_types = list(/datum/action/item_action/toggle)
	darkness_view = 0
	vision_flags = 0
	lighting_alpha = 255

/obj/item/clothing/glasses/night/yautja
	name = "生物面具夜视层"
	gender = NEUTER
	desc = "生物面具生成的视觉覆盖层，用于低光照环境。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "visor_nvg"
	item_state = "securityhud"
	flags_inventory = COVEREYES
	flags_item = NODROP|DELONDROP
	fullscreen_vision = null
	actions_types = null

/obj/item/clothing/glasses/night/cultist
	name = "\improper 异常热成像护目镜"
	desc = "看起来像热成像护目镜，但设计很不寻常。光是看着它就让你恶心。"
	icon_state = "thermal"
	item_state = "thermal"
	w_class = SIZE_SMALL
	vision_flags = SEE_MOBS
	fullscreen_vision = null

/obj/item/clothing/glasses/night/cultist/mob_can_equip(mob/user, slot)
	if(slot == WEAR_EYES)
		if(iscarbon(user))
			var/mob/living/carbon/H = user
			if(!H.hivenumber)
				to_chat(user, SPAN_WARNING("你不想戴上它，它让你感到恶心。"))
				return FALSE
	return ..()

/obj/item/clothing/glasses/night/experimental_mesons
	name = "\improper 实验型介子护目镜"
	desc = "制式介子护目镜的实验改进型，由于结构更加复杂，只有合成人能够佩戴。提供完整夜视能力，可观察周围环境。点击开关。"
	icon_state = "refurb_meson"
	deactive_state = "degoggles"
	vision_flags = SEE_TURFS
	toggleable = TRUE
	fullscreen_vision = null
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/night/experimental_mesons/mob_can_equip(mob/user, slot)
	if(slot == WEAR_EYES)
		if(!issynth(user))
			to_chat(user, "实验型介子护目镜开始探查你的眼睛，寻找连接点，你立刻将它摘了下来。")
			return FALSE
	return ..()
