
//meson goggles

/obj/item/clothing/glasses/meson
	name = "光学介子扫描镜"
	desc = "保护佩戴者的眼睛免受有害电磁辐射，也可用作普通护目镜。无法提供足够的焊接防护。"
	icon_state = "meson"
	item_state = "glasses"
	deactive_state = "degoggles"
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE
	fullscreen_vision = /atom/movable/screen/fullscreen/meson

/obj/item/clothing/glasses/meson/prescription
	name = "矫正视力型光学介子扫描镜"
	desc = "保护佩戴者的眼睛免受有害电磁辐射，也可用作护目镜。配有矫正视力的镜片。"
	prescription = TRUE

/obj/item/clothing/glasses/meson/refurbished
	name = "翻新介子扫描镜"
	desc = "保护佩戴者的眼睛免受有害电磁辐射，也可用作普通护目镜。这款特殊型号升级了光学组件。"
	icon_state = "refurb_meson"
	item_state = "glasses"
	darkness_view = 12
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	vision_flags = SEE_TURFS
	flags_inventory = COVEREYES
	flags_item = MOB_LOCK_ON_EQUIP
	fullscreen_vision = /atom/movable/screen/fullscreen/meson/refurb
