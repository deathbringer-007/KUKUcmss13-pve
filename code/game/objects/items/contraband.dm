//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "快乐药丸"
	gender = PLURAL
	desc = "严禁持有的毒品。想看见彩虹的时候就用它。"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/happy/Initialize()
	. = ..()
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )
	new /obj/item/reagent_container/pill/happy( src )

/obj/item/storage/pill_bottle/zombie_powder
	name = "可疑的药瓶"
	icon_state = "pill_canister10"
	pill_type_to_fill = /obj/item/reagent_container/pill/zombie_powder
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "??"

/obj/item/reagent_container/food/drinks/flask/weylandyutani/poison
	desc = "印有维兰德-汤谷标志的金属酒壶，大概是某个公司马屁精下令把它塞进美国军舰食堂售货机的。这一壶闻起来不太对劲……"

/obj/item/reagent_container/food/drinks/flask/weylandyutani/poison/Initialize()
	. = ..()
	reagents.remove_any(60)
	reagents.add_reagent("souto_classic", 30)
	reagents.add_reagent("neurotoxin", 30)

/obj/item/reagent_container/food/drinks/bottle/holywater/bong
	name = "一壶嬉皮水"
	desc = "原本是随军牧师的一壶圣水，如今被换成了……某种看起来差不多的东西。"

/obj/item/reagent_container/food/drinks/bottle/holywater/bong/Initialize()
	. = ..()
	reagents.remove_any(100)
	reagents.add_reagent("hippiesdelight", 100)

/obj/item/weapon/baton/damaged
	name = "损坏的电击警棍"
	desc = "用于制服他人的电击警棍。这根看起来破烂不堪，尤其是开关附近……"
	force = 12
	has_user_lock = FALSE
