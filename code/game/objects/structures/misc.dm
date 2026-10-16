/obj/structure/showcase
	name = "展示架"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "支架上用螺栓固定着一具空的机器人躯壳。"
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	health = 250

/obj/structure/showcase/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno]将[src]切成碎片！"),
		SPAN_DANGER("我们将[src]切成碎片！"), null, 5, CHAT_TYPE_XENO_COMBAT)
		deconstruct(FALSE)
		return XENO_ATTACK_ACTION
	else
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION

/obj/structure/showcase/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY

/obj/structure/showcase/bullet_act(obj/projectile/P)
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return 1

/obj/structure/showcase/proc/explode()
	src.visible_message(SPAN_DANGER("<B>[src]炸成了碎片！</B>"), null, null, 1)
	deconstruct(FALSE)

/obj/structure/showcase/deconstruct(disassembled = TRUE)
	if(!disassembled)
		var/turf/Tsec = get_turf(src)

		new /obj/item/stack/sheet/metal(Tsec)
		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/rods(Tsec)

		new /obj/effect/spawner/gibspawner/robot(Tsec)
	return ..()

/obj/structure/showcase/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/showcase/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/target
	name = "射击靶"
	anchored = FALSE
	desc = "一个射击靶。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_a"
	density = FALSE
	unslashable = TRUE
	health = 5000

/obj/structure/target/syndicate
	icon_state = "target_s"
	desc = "外形像敌方特工的射击靶。"
	health = 7500

/obj/structure/target/alien
	icon_state = "target_q"
	desc = "轮廓颇具威胁感的射击靶。"
	health = 6500

/obj/structure/monorail
	name = "单轨轨道"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "monorail"
	density = FALSE
	anchored = TRUE
	unslashable = TRUE
	layer = ATMOS_PIPE_LAYER + 0.01


//ICE COLONY RESEARCH DECORATION-----------------------//
//Most of icons made by ~Morrinn
/obj/structure/xenoautopsy
	name = "研究杂物"
	icon = 'icons/obj/structures/props/alien_autopsy.dmi'
	icon_state = "jarshelf_9"
	unslashable = TRUE

/obj/structure/xenoautopsy/jar_shelf
	name = "样品罐架"
	icon_state = "jarshelf_0"
	var/randomise = 1 //Random icon

/obj/structure/xenoautopsy/jar_shelf/New()
	if(randomise)
		icon_state = "jarshelf_[rand(0,9)]"

/obj/structure/xenoautopsy/tank
	name = "低温储罐"
	icon_state = "tank_empty"
	desc = "里面是空的。"

/obj/structure/xenoautopsy/tank/broken
	name = "低温储罐"
	icon_state = "tank_broken"
	desc = "有什么东西打破了它……"

/obj/structure/xenoautopsy/tank/alien
	name = "低温储罐"
	icon_state = "tank_alien"
	desc = "里面有个大家伙……"

/obj/structure/xenoautopsy/tank/hugger
	name = "低温储罐"
	icon_state = "tank_hugger"
	desc = "里面有个像蜘蛛的东西……"

/obj/structure/xenoautopsy/tank/larva
	name = "低温储罐"
	icon_state = "tank_larva"
	desc = "里面有个像蠕虫的东西……"

/obj/item/alienjar
	name = "样品罐"
	icon = 'icons/obj/structures/props/alien_autopsy.dmi'
	icon_state = "jar_sample"
	desc = "用于储存并保存有机样本。"

/obj/item/alienjar/Initialize(mapload, ...)
	. = ..()

	var/image/I
	I = image('icons/obj/structures/props/alien_autopsy.dmi', "sample_[rand(0,11)]")
	I.layer = src.layer - 0.1
	overlays += I
	pixel_x += rand(-3,3)
	pixel_y += rand(-3,3)


//stairs

/obj/structure/stairs
	name = "楼梯"
	icon = 'icons/obj/structures/structures.dmi'
	desc = "楼梯，供你上下行走。"
	icon_state = "rampbottom"
	gender = PLURAL
	unslashable = TRUE
	unacidable = TRUE
	health = null
	layer = ABOVE_TURF_LAYER//Being on turf layer was causing issues with cameras. This SHOULDN'T cause any problems.
	plane = FLOOR_PLANE
	density = FALSE
	opacity = FALSE

/obj/structure/stairs/perspective //instance these for the required icons
	icon = 'icons/obj/structures/stairs/perspective_stairs.dmi'
	icon_state = "np_stair"

/obj/structure/stairs/perspective/kutjevo
	icon = 'icons/obj/structures/stairs/perspective_stairs_kutjevo.dmi'

/obj/structure/stairs/perspective/ice
	icon = 'icons/obj/structures/stairs/perspective_stairs_ice.dmi'


// Prop
/obj/structure/ore_box
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "orebox0"
	name = "矿石箱"
	desc = "用于存放矿石的沉重箱子。"
	density = TRUE
	anchored = FALSE
	unslashable = TRUE

/obj/structure/ore_box/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_OVER_THROW_ITEM

/obj/structure/computer3frame
	density = TRUE
	anchored = FALSE
	unslashable = TRUE
	name = "计算机机架"
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "0"
	var/state = 0

/obj/structure/computer3frame/server
	name = "服务器机架"

/obj/structure/computer3frame/wallcomp
	name = "壁挂计算机机架"

/obj/structure/computer3frame/laptop
	name = "笔记本电脑框架"

// Dartboard
#define DOUBLE_BAND 2
#define TRIPLE_BAND 3

/obj/structure/dartboard
	name = "飞镖靶"
	desc = "一个固定得不太牢的飞镖靶。"
	icon = 'icons/obj/structures/props/props.dmi'
	icon_state = "dart_board"
	density = TRUE
	unslashable = TRUE

/obj/structure/dartboard/get_examine_text()
	. = ..()
	if(length(contents))
		var/is_are = "着"
		if(length(contents) != 1)
			is_are = "着"

		. += SPAN_NOTICE("[src]上嵌[is_are][length(contents)]件物品。")

/obj/structure/dartboard/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	..()
	if(pass_flags)
		pass_flags.flags_can_pass_all = PASS_MOB_IS

/obj/structure/dartboard/get_projectile_hit_boolean(obj/projectile/projectile)
	. = ..()
	visible_message(SPAN_DANGER("[projectile]击中[src]，将它打落了！"))
	collapse()

/obj/structure/dartboard/proc/flush_contents()
	for(var/atom/movable/embedded_items as anything in contents)
		embedded_items.forceMove(loc)

/obj/structure/dartboard/proc/collapse()
	playsound(src, 'sound/effects/thud1.ogg', 50)
	new /obj/item/dartboard/(loc)
	qdel(src)

/obj/structure/dartboard/attack_hand(mob/user)
	if(length(contents))
		user.visible_message(SPAN_NOTICE("[user]开始从[src]上取回物品……"), SPAN_NOTICE("你开始从[src]上取回物品……"))
		if(do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, user, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			flush_contents()
	else
		to_chat(user, SPAN_WARNING("[src]上没有嵌入任何东西！"))

/obj/structure/dartboard/Destroy()
	flush_contents()
	.  = ..()

/obj/structure/dartboard/hitby(obj/item/thrown_item)
	if(thrown_item.sharp != IS_SHARP_ITEM_ACCURATE && !istype(thrown_item, /obj/item/weapon/dart))
		visible_message(SPAN_DANGER("[thrown_item]击中[src]，将它打落了！"))
		collapse()
		return

	contents += thrown_item
	playsound(src, 'sound/weapons/tablehit1.ogg', 50)
	var/score = rand(1,21)
	if(score == 21)
		visible_message(SPAN_DANGER("[thrown_item]扎进[src]，正中靶心！50分。"))
		return

	var/band = "单倍区"
	var/band_number = rand(1,3)
	score *= band_number
	switch(band_number)
		if(DOUBLE_BAND)
			band = "双倍区"
		if(TRIPLE_BAND)
			band = "三倍区"
	visible_message(SPAN_DANGER("[thrown_item]扎进[src]的[band]，得[score]分。"))

/obj/structure/dartboard/attackby(obj/item/item, mob/user)
	user.visible_message(SPAN_DANGER("[user]用[item]击中[src]，将它打落了！"), SPAN_DANGER("你用[item]将[src]打落了！"))
	collapse()

/obj/structure/dartboard/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object != usr || !Adjacent(usr))
		return

	if(!ishuman(usr))
		return

	visible_message(SPAN_NOTICE("[usr]松开了[src]的固定件。"))
	var/obj/item/dartboard/unsecured_board = new(loc)
	usr.put_in_hands(unsecured_board)
	qdel(src)

/obj/item/dartboard
	name = "飞镖靶"
	desc = "用于投掷飞镖的靶盘。"
	icon = 'icons/obj/structures/props/props.dmi'
	icon_state = "dart_board"

/obj/item/dartboard/attack_self(mob/user)
	. = ..()

	var/turf_ahead = get_step(user, user.dir)
	if(!istype(turf_ahead, /turf/closed))
		to_chat(user, SPAN_WARNING("[src]需要固定在墙上！"))
		return

	var/obj/structure/dartboard/secured_board = new(user.loc)
	switch(user.dir)
		if(NORTH)
			secured_board.pixel_y = 32
		if(EAST)
			secured_board.pixel_x = 32
		if(SOUTH)
			secured_board.pixel_y = -32
		if(WEST)
			secured_board.pixel_x = -32

	to_chat(user, SPAN_NOTICE("你将[secured_board]固定在了[turf_ahead]上。"))
	qdel(src)

#undef DOUBLE_BAND
#undef TRIPLE_BAND
