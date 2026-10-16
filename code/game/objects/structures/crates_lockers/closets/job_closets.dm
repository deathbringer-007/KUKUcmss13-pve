/* Closets for specific jobs
 * Contains:
 * Bartender
 * Janitor
 * Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "正装柜"
	desc = "用于存放正装的储物柜。"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/gmcloset/Initialize()
	. = ..()
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/hairflower
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/suit/storage/wcoat(src)
	new /obj/item/clothing/suit/storage/wcoat(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "保洁储物柜"
	desc = "用于存放保洁服装与装备的储物柜。"
	icon_state = "purple"
	icon_closed = "purple"
	icon_opened = "purple_open"

/obj/structure/closet/jcloset/Initialize()
	. = ..()
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/soft/purple(src)
	new /obj/item/clothing/head/beret/jan(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/tool/wet_sign(src)
	new /obj/item/tool/wet_sign(src)
	new /obj/item/tool/wet_sign(src)
	new /obj/item/tool/wet_sign(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "司法用品柜"
	desc = "用于存放法庭服装与用品的储物柜。"
	icon_state = "blue"
	icon_closed = "blue"
	icon_opened = "blue_open"

/obj/structure/closet/lawcloset/Initialize()
	. = ..()
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/bluesuit(src)
	new /obj/item/clothing/suit/storage/lawyer/bluejacket(src)
	new /obj/item/clothing/under/lawyer/purpsuit(src)
	new /obj/item/clothing/suit/storage/lawyer/purpjacket(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)

/obj/structure/closet/secure_closet/platoon_sergeant
	name = "分队士官储物柜"
	desc = "供分队士官使用的安全储物柜。"
	req_one_access = list(ACCESS_MARINE_LEADER)

/obj/structure/closet/secure_closet/platoon_sergeant/Initialize()
	. = ..()
	new /obj/item/clothing/head/helmet/marine/leader(src)
	new /obj/item/device/binoculars/range/designator/sergeant(src)
	new /obj/item/device/whistle(src)

/obj/structure/closet/secure_closet/platoon_sergeant_forecon
	name = "小队长储物柜"
	desc = "供小队长使用的安全储物柜。"
	req_one_access = list(ACCESS_MARINE_LEADER)

/obj/structure/closet/secure_closet/platoon_sergeant_forecon/Initialize()
	. = ..()
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/device/whistle(src)

/obj/structure/closet/secure_closet/squad_sergeant
	name = "小队士官储物柜"
	desc = "供小队士官使用的安全储物柜。"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_TL_PREP)

/obj/structure/closet/secure_closet/squad_sergeant/Initialize()
	. = ..()
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/device/whistle(src)

/obj/structure/closet/secure_closet/squad_sergeant_forecon
	name = "副小队长储物柜"
	desc = "供副小队长使用的安全储物柜。"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_TL_PREP)

/obj/structure/closet/secure_closet/squad_sergeant_forecon/Initialize()
	. = ..()
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/device/whistle(src)

/obj/structure/closet/secure_closet/smartgunner
	name = "智能机枪手储物柜"
	desc = "供智能机枪手使用的安全储物柜。"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SMARTPREP)

/obj/structure/closet/secure_closet/smartgunner/Initialize()
	. = ..()
	new /obj/item/weapon/gun/smartgun/empty(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/marine/smartgunner(src)
	new /obj/item/storage/belt/gun/smartgunner/garrow(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/clothing/glasses/night/m56_goggles/no_nightvision(src)
	new /obj/item/storage/large_holster/machete/smartgunner/full(src)
	new /obj/item/clothing/accessory/storage/webbing/m56(src)
	new /obj/item/clothing/accessory/storage/webbing/m56/grenade(src)

/obj/structure/closet/secure_closet/smartgunner_forecon
	name = "智能机枪手储物柜"
	desc = "供智能机枪手使用的安全储物柜。"
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SMARTPREP)

/obj/structure/closet/secure_closet/smartgunner_forecon/Initialize()
	. = ..()
	new /obj/item/weapon/gun/smartgun(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/marine/smartgunner/standard(src)
	new /obj/item/storage/belt/gun/smartgunner/garrow(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun(src)
	new /obj/item/clothing/glasses/night/m56_goggles/no_nightvision(src)
	new /obj/item/storage/large_holster/machete/smartgunner/full(src)
	new /obj/item/clothing/accessory/storage/webbing/m56(src)
	new /obj/item/clothing/accessory/storage/webbing/m56/grenade(src)

/obj/structure/closet/cryo/Initialize()
	. = ..()
	new /obj/item/clothing/under/marine(src)
	new /obj/item/clothing/under/marine(src)
	new /obj/item/clothing/shoes/marine/knife(src)
	new /obj/item/clothing/shoes/marine/knife(src)
	new /obj/item/device/radio/headset/almayer/marine(src)
	new /obj/item/device/radio/headset/almayer/marine(src)
	new /obj/item/clothing/glasses/night/m56_goggles/no_nightvision(src)

/obj/structure/closet/secure_closet/rmc_troop_sergeant
	name = "突击排士官储物柜"
	desc = "供皇家陆战突击队突击排资深士官使用的安全储物柜。"
	req_access = list(ACCESS_TWE_ARMORY, ACCESS_TWE_TLPREP)

/obj/structure/closet/secure_closet/rmc_troop_sergeant/Initialize()
	. = ..()
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/storage/backpack/rmc/frame(src)
	new /obj/item/storage/firstaid/adv(src)
	new /obj/item/ammo_box/magazine/nsg23(src)

/obj/structure/closet/secure_closet/rmc_section_leader
	name = "班长储物柜"
	desc = "供皇家陆战突击队班长使用的安全储物柜。"
	req_access = list(ACCESS_TWE_TLPREP, ACCESS_TWE_SQUAD_ONE)

/obj/structure/closet/secure_closet/rmc_section_leader/Initialize()
	. = ..()
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/device/whistle(src)

/obj/structure/closet/secure_closet/rmc_smartgunner
	name = "智能机枪手储物柜"
	desc = "供皇家陆战突击队智能机枪手使用的安全储物柜。"
	req_access = list(ACCESS_TWE_SQUAD_TWO, ACCESS_TWE_HEVWEAPPREP)

/obj/structure/closet/secure_closet/rmc_smartgunner/Initialize()
	. = ..()
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/marine/veteran/royal_marine/smartgun(src)
	new /obj/item/ammo_magazine/smartgun/holo_targeting(src)
	new /obj/item/ammo_magazine/smartgun/holo_targeting(src)
	new /obj/item/ammo_magazine/smartgun/holo_targeting(src)
	new /obj/item/clothing/glasses/night/m56_goggles/rmc(src)
