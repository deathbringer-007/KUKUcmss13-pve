/obj/item/device/vulture_spotter_scope
	name = "\improper M707 观测镜"
	desc = "安装在三脚架上后，可用于协助 M707 射手搜索和确认目标的观测镜。"
	icon_state = "vulture_scope"
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	unacidable = TRUE
	indestructible = TRUE
	/// A weakref to the corresponding rifle
	var/datum/weakref/bound_rifle

/obj/item/device/vulture_spotter_scope/Initialize(mapload, datum/weakref/rifle)
	. = ..()
	if(rifle)
		bound_rifle = rifle

/obj/item/device/vulture_spotter_scope/attack_self(mob/user)
	. = ..()
	to_chat(user, SPAN_WARNING("[src]必须安装在三脚架上才能使用！"))

/obj/item/device/vulture_spotter_scope/skillless

/obj/item/device/vulture_spotter_tripod
	name = "\improper M707 观测镜三脚架"
	desc = "用于稳定 M707 反器材步枪配套观测镜的三脚架。"
	icon_state = "vulture_tripod"
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	unacidable = TRUE
	indestructible = TRUE

/obj/item/device/vulture_spotter_tripod/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("<b>在手中使用</b>即可架设[src]。")

/obj/item/device/vulture_spotter_tripod/attack_self(mob/user)
	. = ..()
	user.balloon_alert(user, "正在架设三脚架……")
	if(!do_after(user, 1.5 SECONDS, target = user))
		return

	new /obj/structure/vulture_spotter_tripod(get_turf(user))
	qdel(src)
