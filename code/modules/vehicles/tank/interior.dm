// Tank interior stuff

// Wall
/obj/structure/interior_wall/tank
	name = "\improper 坦克内壁"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "wall"

// Props
/obj/structure/prop/tank
	name = "坦克机械设备"
	mouse_opacity = FALSE
	density = TRUE

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "prop0"

// Hatch
/obj/structure/interior_exit/vehicle/tank
	name = "坦克舱盖"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "hatch"

