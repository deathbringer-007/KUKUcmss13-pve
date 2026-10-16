
/obj/item/reagent_container/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	volume = 60
	var/reagent = ""


/obj/item/reagent_container/glass/bottle/robot/inaprovaline
	name = "内置因纳普罗伐林药瓶"
	desc = "一个小药瓶。装着用于稳定患者状态的因纳普罗伐林。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle16"
	reagent = "inaprovaline"

/obj/item/reagent_container/glass/bottle/robot/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 60)
	return


/obj/item/reagent_container/glass/bottle/robot/antitoxin
	name = "内置抗毒素药瓶"
	desc = "一小瓶抗毒素。既能解毒，又能修复损伤，真是神药。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle17"
	reagent = "anti_toxin"

/obj/item/reagent_container/glass/bottle/robot/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 60)
	return
