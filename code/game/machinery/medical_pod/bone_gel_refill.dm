/obj/structure/machinery/gel_refiller
	name = "仿骨晶格制造机"
	desc = "叫不顺全名的人通常直接称它为骨胶补充机。这台机器会合成并储存骨胶供日后使用。把骨胶瓶插进前方槽口即可补充。"
	desc_lore = "为了防止非维兰德-汤谷制造的“假冒”骨胶瓶——也就是普通瓶子——被拿来补充骨胶，制造机内置了芯片读取器，每个正品瓶子也装有验证芯片。然而，机器质量欠佳，加上专有零件让维修无从下手，故障频发。其中一种故障出在芯片读取器上：机器识别不出直接放上去的瓶子，因而无法启动。使用者只好站在旁边，手举着瓶子保持在合适高度，才能灌满。"
	icon_state = "bone_gel_vendor"
	density = TRUE

/obj/structure/machinery/gel_refiller/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/tool/surgery/bonegel))
		return ..()
	var/obj/item/tool/surgery/bonegel/gel = attacking_item
	gel.refill_gel(src, user)
