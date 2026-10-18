/obj/item/explosive/grenade/decoy
	AUTOWIKI_SKIP(TRUE)

	name = "诱饵手榴弹"
	desc = "通常用于分散敌人注意力的手榴弹，会发出巨响。5秒后引爆，可使用3次。"

	icon_state = "grenade_training"
	item_state = "grenade_training"

	det_time = 5 SECONDS
	harmful = FALSE

	var/decoy_strength = 500
	var/uses = 3

/obj/item/explosive/grenade/decoy/prime(force)
	playsound(get_turf(loc), 'sound/effects/explosionfar.ogg', 100, 1, decoy_strength)
	playsound(get_turf(loc), "explosion", 90, 1, max(decoy_strength, 7))

	uses--

	if(!uses)
		qdel(src)
	else
		active = 0 //so we can reuse it
		overlays.Cut()
		icon_state = initial(icon_state)
		det_time = initial(det_time) //these can be modified when fired by UGL
		throw_range = initial(throw_range)
		w_class = initial(w_class)
