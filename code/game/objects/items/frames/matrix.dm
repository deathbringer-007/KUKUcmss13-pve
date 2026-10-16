/obj/item/frame/matrix_frame
	name = "矩阵框架"
	desc = "运输艇摄像矩阵的组件，安装于武器控制台内。复杂的透镜组使光线能够穿过其中的液体。\n小瓶中的液体会均匀散布在内部，因此插入后就无法再取出。"
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "matrix"
	matter = list("metal" = 7500)
	var/state = ASSEMBLY_EMPTY
	var/upgrade = MATRIX_DEFAULT //upgrade type
	var/power //power of the property
	var/matrixcol // related to the upgrade color and zoom amount
	var/matrixsize

//Upgrade types
//Matrix default - the default dropship camera system you start with
//Matrix NVG - guidance camera gets NVG filter depending on the potency of the property
//Matrix wide - gives a wider view which depends on the potency of the proeprty

/obj/item/frame/matrix_frame/attackby(obj/item/W, mob/user as mob)
	switch(state)
		if(ASSEMBLY_EMPTY)
			if(istype(W, /obj/item/reagent_container/glass/beaker/vial) && W.reagents.total_volume == 30 && length(W.reagents.reagent_list) == 1)
				user.drop_held_item(W)
				W.forceMove(src)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("你把小瓶装入矩阵，检测指示灯亮起了绿光。"))
				desc = initial(desc) + "\n小瓶已装入，但尚未拧紧。"
				var/datum/reagent/S = W.reagents.reagent_list[1]
				if(S.get_property(PROPERTY_PHOTOSENSITIVE) && !S.get_property(PROPERTY_CRYSTALLIZATION))
					var/datum/chem_property/G = S.get_property(PROPERTY_PHOTOSENSITIVE)
					power = G.level
					if(power <= 3)
						matrixcol = "#19c519"
					else if (power >= 4)
						matrixcol= "#7aff7a"
					upgrade = MATRIX_NVG
					return
				else if (S.get_property(PROPERTY_CRYSTALLIZATION))
					var/datum/chem_property/G = S.get_property(PROPERTY_CRYSTALLIZATION)
					power = G.level
					upgrade = MATRIX_WIDE
					return
				else
					upgrade = MATRIX_DEFAULT
					return
			else if(W.reagents.total_volume < 30)
				to_chat(user, SPAN_WARNING("检测指示灯亮起了红光！容器必须装满！"))
				return
			else if (length(W.reagents.reagent_list) > 1)
				to_chat(user, SPAN_WARNING("检测指示灯亮起了红光！容器中必须是纯净样本！"))

		if(ASSEMBLY_UNLOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_LOCKED
				to_chat(user, SPAN_NOTICE("你锁好了矩阵组件。"))
				desc = initial(desc) + "\n小瓶已装入并拧紧固定。"
		if(ASSEMBLY_LOCKED)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				state = ASSEMBLY_UNLOCKED
				to_chat(user, SPAN_NOTICE("你解锁了矩阵组件。"))
