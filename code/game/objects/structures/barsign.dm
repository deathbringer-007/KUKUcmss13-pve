/obj/structure/sign/double/barsign
	icon = 'icons/obj/structures/props/barsigns.dmi'
	icon_state = "empty"
	anchored = TRUE

/obj/structure/sign/double/barsign/New()
	..()
	ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum", "meadbay", "thedamnwall", "thecavern", "cindikate", "theorchard", "thesaucyclown", "theclownshead", "whiskeyimplant", "carpecarp", "robustroadhouse", "greytide", "theredshirt"))
	return

/obj/structure/sign/double/barsign/proc/ChangeSign(Text)
	src.icon_state = "[Text]"
	//on = 0
	//brightness_on = 4 //uncomment these when the lighting fixes get in
	return

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/card = I
		if(ACCESS_CIVILIAN_PUBLIC in card.GetAccess())
			var/list/sign_options = list("关闭" = "Off", "粉红火烈鸟" = "Pink Flamingo", "熔岩海" = "Magma Sea", "虚无之境" = "Limbo", "锈斧" = "Rusty Axe", "阿莫克酒吧" = "Armok Bar", "破鼓" = "Broken Drum", "蜜酒湾" = "Mead Bay", "该死的墙" = "The Damn Wall", "洞窟" = "The Cavern", "辛迪凯特" = "Cindi Kate", "果园" = "The Orchard", "放肆小丑" = "The Saucy Clown", "小丑之首" = "The Clowns Head", "威士忌植入物" = "Whiskey Implant", "抓住鲤鱼" = "Carpe Carp", "硬汉路边酒馆" = "Robust Roadhouse", "灰潮" = "Greytide", "红衫" = "The Redshirt")
			var/sign_type = sign_options[tgui_input_list(user, "要换成哪块酒吧招牌？", "酒吧招牌", sign_options)]
			if(sign_type == null)
				return
			else
				sign_type = replacetext(lowertext(sign_type), " ", "") // lowercase, strip spaces - along with choices for user options, avoids huge if-else-else
				src.ChangeSign(sign_type)
				to_chat(user, "你更换了酒吧招牌。")
