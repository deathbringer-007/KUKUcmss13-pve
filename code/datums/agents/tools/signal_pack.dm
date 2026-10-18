/obj/item/storage/box/antag_signaller
	name = "可疑的盒子"
	desc = "一个小巧而可疑的盒子，小到能装进包里。"

	w_class = SIZE_MEDIUM

	storage_slots = 8

/obj/item/storage/box/antag_signaller/Initialize(mapload, ...)
	. = ..()
	new /obj/item/device/assembly/signaller(src)
	new /obj/item/device/assembly/signaller(src)
	new /obj/item/device/assembly/signaller(src)
	new /obj/item/device/assembly/signaller(src)
	new /obj/item/device/assembly/signaller(src)
	new /obj/item/tool/screwdriver(src)
	new /obj/item/device/multitool(src)
	new /obj/item/pamphlet/engineer/antag(src)
