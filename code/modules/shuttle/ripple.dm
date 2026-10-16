/obj/effect/abstract/ripple
	name = "超空间涟漪"
	desc = "某个东西正穿越超空间，能看见周围的视觉扰动。无论穿行而来的是什么，最好别站在它抵达的位置。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield"
	anchored = TRUE
	density = FALSE
	layer = RIPPLE_LAYER
	mouse_opacity = MOUSE_OPACITY_ICON
	alpha = 0

/obj/effect/abstract/ripple/shadow
	name = "逼近的阴影"
	desc = "上方有庞然大物正在逼近。最好别待在它下面。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shadow_square"

/obj/effect/abstract/ripple/Initialize(mapload, time_left)
	. = ..()
	animate(src, alpha=255, time=time_left) // I wish the loop argument would override the sprite's setting
