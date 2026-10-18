/obj/structure/cargo_container
	name = "货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n你本不该看到这个。"
	icon = 'icons/obj/structures/props/contain.dmi'
	bound_width = 32
	bound_height = 64
	density = TRUE
	health = 200
	opacity = TRUE
	anchored = TRUE
	unslashable = TRUE
//Note, for Watatsumi, Grant, and Arious, "left" and "leftmid" are both the left end of the container, but "left" is generic and "leftmid" has the Sat Mover mark on it
/obj/structure/cargo_container/watatsumi
	name = "海神货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自生产各类电子与机械产品的海神公司。\n至少箱子上是这么写的。你从来没听说过这家公司。"

/obj/structure/cargo_container/watatsumi/left
	icon_state = "watatsumi_l"

/obj/structure/cargo_container/watatsumi/leftmid
	icon_state = "watatsumi_lm"

/obj/structure/cargo_container/watatsumi/mid
	icon_state = "watatsumi_m"

/obj/structure/cargo_container/watatsumi/rightmid
	icon_state = "watatsumi_rm"

/obj/structure/cargo_container/watatsumi/right
	icon_state = "watatsumi_r"

/obj/structure/cargo_container/grant
	name = "格兰特公司货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自生产医疗与生物技术零部件的格兰特公司。\n你记得听说过他们最新的一款药，以及它有多危险……不过他们声称快找到解决办法了。"

/obj/structure/cargo_container/grant/left
	icon_state = "grant_l"

/obj/structure/cargo_container/grant/leftmid
	icon_state = "grant_lm"

/obj/structure/cargo_container/grant/rightmid
	icon_state = "grant_rm"

/obj/structure/cargo_container/grant/right
	icon_state = "grant_r"

/obj/structure/cargo_container/arious
	name = "阿里乌斯货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自生产计算机零件与动态探测仪的阿里乌斯公司。\n你仍想不明白，为什么这里会有一整箱旧动态探测仪，它们还能用吗？"

/obj/structure/cargo_container/arious/left
	icon_state = "arious_l"

/obj/structure/cargo_container/arious/leftmid
	icon_state = "arious_lm"

/obj/structure/cargo_container/arious/mid
	icon_state = "arious_m"

/obj/structure/cargo_container/arious/rightmid
	icon_state = "arious_rm"

/obj/structure/cargo_container/arious/right
	icon_state = "arious_r"

/obj/structure/cargo_container/wy
	name = "维兰德-汤谷货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自维兰德-汤谷公司，你大概听说过他们。"

/obj/structure/cargo_container/wy/left
	icon_state = "wy_l"

/obj/structure/cargo_container/wy/mid
	icon_state = "wy_m"

/obj/structure/cargo_container/wy/right
	icon_state = "wy_r"

/obj/structure/cargo_container/wy2
	name = "维兰德-汤谷货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自维兰德-汤谷公司，你大概听说过他们。"

/obj/structure/cargo_container/wy2/left
	icon_state = "wy2_l"

/obj/structure/cargo_container/wy2/mid
	icon_state = "wy2_m"

/obj/structure/cargo_container/wy2/right
	icon_state = "wy2_r"

/obj/structure/cargo_container/armat
	name = "ARMAT货运集装箱"
	desc = "一个大型工业集装箱。它来自生产M41A及其他陆战队武器的国防承包商ARMAT。"

/obj/structure/cargo_container/armat/left
	icon_state = "armat_l"

/obj/structure/cargo_container/armat/mid
	icon_state = "armat_m"

/obj/structure/cargo_container/armat/right
	icon_state = "armat_r"

/obj/structure/cargo_container/hd
	name = "海普代恩系统货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自生产合成人、义肢及武器的海普代恩系统公司。\n我们不谈他们过去与进步人民联盟的关系。"

/obj/structure/cargo_container/hd/left
	icon_state = "hd_l"

/obj/structure/cargo_container/hd/left/alt
	icon_state = "hd_l_alt"

/obj/structure/cargo_container/hd/mid
	icon_state = "hd_m"

/obj/structure/cargo_container/hd/mid/alt
	icon_state = "hd_m_alt"

/obj/structure/cargo_container/hd/right
	icon_state = "hd_r"

/obj/structure/cargo_container/hd/right/alt
	icon_state = "hd_r_alt"

/obj/structure/cargo_container/trijent
	name = "特里金特公司货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自特里金特公司的采矿业务。\n如果箱子破了，你最好别吸入里面的东西。"

/obj/structure/cargo_container/trijent/left
	icon_state = "trijent_l"

/obj/structure/cargo_container/trijent/left/alt
	icon_state = "trijent_l_alt"

/obj/structure/cargo_container/trijent/mid
	icon_state = "trijent_m"

/obj/structure/cargo_container/trijent/mid/alt
	icon_state = "trijent_m_alt"

/obj/structure/cargo_container/trijent/right
	icon_state = "trijent_r"

/obj/structure/cargo_container/trijent/right/alt
	icon_state = "trijent_r_alt"

/obj/structure/cargo_container/kelland //The container formerly known as 'gorg'
	name = "凯兰德矿业货运集装箱"
	desc = "一个小型工业货运集装箱。\n除了LV-178采矿作业发生的那起事故，你对凯兰德矿业所知甚少。"
	bound_height = 32 //It's smaller than the rest
	layer = ABOVE_XENO_LAYER //Due to size, needs to be above player and xenos

/obj/structure/cargo_container/kelland/left
	icon_state = "kelland_l"

/obj/structure/cargo_container/kelland/right
	icon_state = "kelland_r"

/obj/structure/cargo_container/ferret
	name = "雪貂重工货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自生产地面履带车辆及动力装载机的雪貂重工。\n不幸的是，公司破产了。幸运的是，这些箱子现在很便宜。"

/obj/structure/cargo_container/ferret/left
	icon_state = "ferret_l"

/obj/structure/cargo_container/ferret/mid
	icon_state = "ferret_m"

/obj/structure/cargo_container/ferret/right
	icon_state = "ferret_r"

/obj/structure/cargo_container/lockmart
	name = "洛克马特公司货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自生产太空船及其零件的洛克希德·马丁公司。\n他们制造了USCSS诺斯特罗莫号……说起来，那艘船后来怎样了？"

/obj/structure/cargo_container/lockmart/left
	icon_state = "lockmart_l"

/obj/structure/cargo_container/lockmart/mid
	icon_state = "lockmart_m"

/obj/structure/cargo_container/lockmart/right
	icon_state = "lockmart_r"

/obj/structure/cargo_container/seegson
	name = "西格森公司货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自西格森，他们几乎什么都造。\n箱子上有张快脱落的便条，说里面的东西是几十年前从另一座空间站转来的。它到底在这里放了多久？"

/obj/structure/cargo_container/seegson/left
	icon_state = "seegson_l"

/obj/structure/cargo_container/seegson/mid
	icon_state = "seegson_m"

/obj/structure/cargo_container/seegson/right
	icon_state = "seegson_r"

/obj/structure/cargo_container/canc
	name = "CANC货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自后来被并入进步人民联盟的中国与亚洲国家合作体。其庞大的工业产量使印有该标志与名称的集装箱至今仍随处可见。"
/obj/structure/cargo_container/canc/left
	icon_state = "canc_g_l"

/obj/structure/cargo_container/canc/mid
	icon_state = "canc_g_m"

/obj/structure/cargo_container/canc/right
	icon_state = "canc_g_r"

/obj/structure/cargo_container/canc/tan
	name = "CANC货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它来自后来被并入进步人民联盟的中国与亚洲国家合作体。其庞大的工业产量使印有该标志与名称的集装箱至今仍随处可见。"

/obj/structure/cargo_container/canc/tan/left
	icon_state = "canc_t_l"

/obj/structure/cargo_container/canc/tan/mid
	icon_state = "canc_t_m"

/obj/structure/cargo_container/canc/tan/right
	icon_state = "canc_t_r"

/obj/structure/cargo_container/upp
	name = "进步人民联盟货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n侧面巨大的标志表明，它来自进步人民联盟。"

/obj/structure/cargo_container/upp/left
	icon_state = "upp_l"

/obj/structure/cargo_container/upp/mid
	icon_state = "upp_m"

/obj/structure/cargo_container/upp/right
	icon_state = "upp_r"

/obj/structure/cargo_container/upp/tan
	name = "进步人民联盟货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n侧面巨大的标志表明，它来自进步人民联盟。"

/obj/structure/cargo_container/upp/tan/left
	icon_state = "upp_t_l"

/obj/structure/cargo_container/upp/tan/mid
	icon_state = "upp_t_m"

/obj/structure/cargo_container/upp/tan/right
	icon_state = "upp_t_r"

/obj/structure/cargo_container/upp/mk6
	name = "太空安全部货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它属于进步人民联盟太空安全部。"

/obj/structure/cargo_container/upp/mk6/left
	icon_state = "mk6_l"

/obj/structure/cargo_container/upp/mk6/mid
	icon_state = "mk6_m"

/obj/structure/cargo_container/upp/mk6/right
	icon_state = "mk6_r"

/obj/structure/cargo_container/uscm
	name = "美国殖民地海军陆战队货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n它属于美洲联盟的美国海军陆战队。"

/obj/structure/cargo_container/uscm/sanfran/left
	name = "美国殖民地海军陆战队货运集装箱"

	icon_state = "uscm1_l"

/obj/structure/cargo_container/uscm/sanfran/mid
	icon_state = "uscm1_m"

/obj/structure/cargo_container/uscm/borodino/left
	name = "美国殖民地海军陆战队货运集装箱"

	icon_state = "uscm2_l"

/obj/structure/cargo_container/uscm/borodino/mid
	icon_state = "uscm2_m"

/obj/structure/cargo_container/uscm/tartarus/left
	name = "美国殖民地海军陆战队货运集装箱"

	icon_state = "uscm3_l"

/obj/structure/cargo_container/uscm/tartarus/mid
	icon_state = "uscm3_m"

/obj/structure/cargo_container/uscm/chinook/left
	name = "美国殖民地海军陆战队货运集装箱"

	icon_state = "uscm4_l"

/obj/structure/cargo_container/uscm/chinook/mid
	icon_state = "uscm4_m"

/obj/structure/cargo_container/uscm/crestus/left
	name = "美国殖民地海军陆战队货运集装箱"

	icon_state = "uscm5_l"

/obj/structure/cargo_container/uscm/crestus/mid
	icon_state = "uscm5_m"

/obj/structure/cargo_container/uscm/micor/left
	name = "美国殖民地海军陆战队货运集装箱"

	icon_state = "uscm6_l"

/obj/structure/cargo_container/uscm/mid
	icon_state = "uscm_m"

/obj/structure/cargo_container/uscm/right
	icon_state = "uscm_r"

/obj/structure/cargo_container/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/clang.ogg', 25, 1)

	var/damage_dealt
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))

			user.visible_message(SPAN_WARNING("[user]猛砸[src]，毫无效果。"), \
					SPAN_WARNING("你猛砸[src]，毫无效果。"), \
					"你听到金属扭曲的声音。")

	if(!damage_dealt)
		user.visible_message(SPAN_WARNING("[user]敲打[src]，毫无效果。"), \
					SPAN_WARNING("[user]敲打[src]。"), \
					"你听到金属扭曲的声音。")

/obj/structure/cargo_container/horizontal
	name = "货运集装箱"
	desc = "一个巨大的工业货运集装箱。"
	icon = 'icons/obj/structures/props/containHorizont.dmi'
	bound_width = 64
	bound_height = 32
	density = TRUE
	health = 200
	opacity = TRUE

/obj/structure/cargo_container/horizontal/blue
	name = "通用货运集装箱"
	desc = "一个巨大的工业货运集装箱。\n虽然侧面显然有标志，但标志没有朝南，所以你看不到。"

/obj/structure/cargo_container/horizontal/blue/top
	icon_state = "blue_t"

/obj/structure/cargo_container/horizontal/blue/middle
	icon_state = "blue_m"

/obj/structure/cargo_container/horizontal/blue/bottom
	icon_state = "blue_b"
