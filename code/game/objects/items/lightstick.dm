

//Lightsticks----------
//Blue
/obj/item/lightstick
	name = "蓝色荧光棒"
	desc = "可以插在地上。"
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "lightstick_blue0"
	light_range = 2
	light_color = COLOR_BLUE
	var/s_color = "blue"
	var/trample_chance = 30
	var/can_trample = TRUE

/obj/item/lightstick/Initialize(mapload, ...)
	. = ..()

	if(!light_on)
		set_light_range(0)

/obj/item/lightstick/Crossed(mob/living/O)
	if(anchored && prob(trample_chance) && can_trample)
		if(!istype(O,/mob/living/carbon/xenomorph/larva))
			visible_message(SPAN_DANGER("[O]踩踏了[src]！"))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			if(istype(O,/mob/living/carbon/xenomorph))
				if(prob(40))
					deconstruct(FALSE)
				else
					anchored = FALSE
					icon_state = "lightstick_[s_color][anchored]"
					set_light_range(0)
					pixel_x = 0
					pixel_y = 0
			else
				anchored = FALSE
				icon_state = "lightstick_[s_color][anchored]"
				set_light_range(0)
				pixel_x = 0
				pixel_y = 0

	//Removing from turf
/obj/item/lightstick/attack_hand(mob/user)
	..()
	if(!anchored)//If planted
		return

	to_chat(user, "你开始拔出[src]。")
	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	anchored = FALSE
	user.visible_message("[user.name]把[src]从地上拔了出来。", "你把[src]从地上拔了出来。")
	icon_state = "lightstick_[s_color][anchored]"
	set_light(0)
	pixel_x = 0
	pixel_y = 0
	playsound(user, 'sound/weapons/Genhit.ogg', 25, TRUE)

//Red
/obj/item/lightstick/planted
	icon_state = "lightstick_blue1"
	anchored = TRUE
	light_on = TRUE

/obj/item/lightstick/red
	name = "红色荧光棒"
	icon_state = "lightstick_red0"
	s_color = "red"
	light_color = COLOR_RED

/obj/item/lightstick/red/planted
	icon_state = "lightstick_red1"
	anchored = TRUE
	light_on = TRUE

/obj/item/lightstick/red/spoke
	name = "红色荧光棒"
	icon_state = "lightstick_spoke0"
	s_color = "red"
	can_trample = FALSE

/obj/item/lightstick/red/spoke/planted
	icon_state = "lightstick_spoke1"
	anchored = TRUE
	light_on = TRUE

/obj/item/lightstick/red/variant
	name = "红色荧光棒"
	icon_state = "lightstick_red_variant0"
	s_color = "red"

/obj/item/lightstick/red/variant/planted
	icon_state = "lightstick_red_variant1"
	anchored = TRUE
	light_on = TRUE

/obj/item/lightstick/variant //blue
	name = "蓝色荧光棒"
	icon_state = "lightstick_blue_variant0"
	s_color = "blue"

/obj/item/lightstick/variant/planted
	icon_state = "lightstick_blue_variant1"
	anchored = TRUE
	light_on = TRUE
