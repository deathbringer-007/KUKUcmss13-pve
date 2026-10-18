/obj/item/storage/box/badass_kit
	name = "可疑的盒子"
	desc = "一个小巧而可疑的盒子，小到能装进包里。"

	w_class = SIZE_MEDIUM

	storage_slots = 2


/obj/item/storage/box/badass_kit/Initialize()
	. = ..()
	new/obj/item/device/encryptionkey/sec(src)
	new/obj/item/clothing/glasses/sunglasses/antag(src)

/obj/item/clothing/glasses/sunglasses/antag
	flags_equip_slot = SLOT_EYES

	flags_armor_protection = BODY_FLAG_EYES|BODY_FLAG_FACE

	armor_energy = CLOTHING_ARMOR_HARDCORE
	eye_protection = EYE_PROTECTION_WELDING
