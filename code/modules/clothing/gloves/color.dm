/obj/item/clothing/gloves/yellow
	desc = "这副手套能保护佩戴者免遭电击。"
	name = "绝缘手套"
	icon_state = "insulated"
	item_state = "insulated"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

/obj/item/clothing/gloves/fyellow  //Cheap Chinese Crap
	desc = "这是那种抢手手套的廉价仿品，戴上肯定不会出什么事吧。"
	name = "廉价绝缘手套"
	icon_state = "insulated"
	item_state = "insulated"
	siemens_coefficient = 1 //Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05

/obj/item/clothing/gloves/fyellow/New()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)
	..()

/obj/item/clothing/gloves/black
	desc = "这副手套具有防火性能。"
	name = "黑色手套"
	icon_state = "black"
	item_state = "bgloves"
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT


/obj/item/clothing/gloves/orange
	name = "橙色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "orange"
	item_state = "orangegloves"

/obj/item/clothing/gloves/red
	name = "红色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "red"
	item_state = "redgloves"

/obj/item/clothing/gloves/rainbow
	name = "彩虹手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "rainbow"
	item_state = "rainbowgloves"

/obj/item/clothing/gloves/blue
	name = "蓝色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "blue"
	item_state = "bluegloves"

/obj/item/clothing/gloves/purple
	name = "紫色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "purple"
	item_state = "purplegloves"

/obj/item/clothing/gloves/green
	name = "绿色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "green"
	item_state = "greengloves"

/obj/item/clothing/gloves/grey
	name = "灰色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "gray"
	item_state = "graygloves"

/obj/item/clothing/gloves/light_brown
	name = "浅棕色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "lightbrown"
	item_state = "lightbrowngloves"

/obj/item/clothing/gloves/brown
	name = "棕色手套"
	desc = "一副手套，看起来没什么特别之处。"
	icon_state = "brown"
	item_state = "browngloves"
