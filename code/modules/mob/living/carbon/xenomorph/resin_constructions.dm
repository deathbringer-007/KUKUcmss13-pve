GLOBAL_VAR_INIT(resin_lz_allowed, FALSE)

/datum/resin_construction
	var/name
	var/desc
	var/construction_name // The name used in messages (to replace old resin2text proc)
	var/cost
	var/build_time = 2 SECONDS
	var/pass_hivenumber = TRUE

	var/build_overlay_icon
	var/build_animation_effect

	var/range_between_constructions
	var/build_path
	var/build_path_thick
	var/max_per_xeno = RESIN_CONSTRUCTION_NO_MAX

	var/thick_hiveweed = FALSE // if this is set, the thick variants will only work on hiveweeds
	var/can_build_on_doors = TRUE // if it can be built on a tile with an open door or not

/datum/resin_construction/proc/can_build_here(turf/T, mob/living/carbon/xenomorph/X)
	if(!istype(T) || T.is_weedable() < FULLY_WEEDABLE)
		to_chat(X, SPAN_WARNING("你不能在这里这样做。"))
		return FALSE

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		if(AR.flags_area & AREA_UNWEEDABLE)
			to_chat(X, SPAN_XENOWARNING("这片区域不适合虫巢生长！"))
			return
		to_chat(X, SPAN_XENOWARNING("现在还太早，无法将虫巢扩展到这么远。"))
		return FALSE

	if(!(AR.resin_construction_allowed)) //disable resin walls not weed, in special circumstances EG. Stairs and Dropship turfs
		to_chat(X, SPAN_WARNING("你感觉这片区域不适合扩展虫巢。"))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in T
	if(!alien_weeds)
		to_chat(X, SPAN_WARNING("你只能在菌毯上塑形，建造前先找一片树脂菌毯！"))
		return FALSE

	if(alien_weeds?.block_structures >= BLOCK_ALL_STRUCTURES)
		to_chat(X, SPAN_WARNING("[alien_weeds]阻止了所有建筑的建造！"))
		return FALSE

	var/obj/vehicle/V = locate() in T
	if(V)
		to_chat(X, SPAN_WARNING("你不能在[V]下方建造！"))
		return FALSE

	if(alien_weeds.linked_hive.hivenumber != X.hivenumber)
		to_chat(X, SPAN_WARNING("这些菌毯不属于你的虫巢！"))
		return FALSE

	if(istype(T, /turf/closed/wall)) // Can't build in walls with no density
		to_chat(X, SPAN_WARNING("这片区域太不稳定，无法支撑建筑。"))
		return FALSE

	if(!X.check_alien_construction(T, check_doors = !can_build_on_doors))
		return FALSE

	if(range_between_constructions)
		for(var/i in urange(range_between_constructions, T))
			var/atom/A = i
			if(A.type == build_path)
				to_chat(X, SPAN_WARNING("这里离另一座同类建筑太近了！"))
				return FALSE

	return TRUE

/datum/resin_construction/proc/build(turf/T, hivenumber, builder)
	return

/datum/resin_construction/proc/check_thick_build(turf/build_turf, hivenumber, mob/living/carbon/xenomorph/builder)
	var/can_build_thick = TRUE
	if(thick_hiveweed)
		var/obj/effect/alien/weeds/weeds = locate() in build_turf
		if(!weeds || weeds.hivenumber != hivenumber || weeds.weed_strength < WEED_LEVEL_HIVE)
			can_build_thick = FALSE

	if(build_path_thick && (can_build_thick || (SEND_SIGNAL(builder, COMSIG_XENO_THICK_RESIN_BYPASS) & COMPONENT_THICK_BYPASS)))
		return TRUE
	return FALSE

// Subtype encompassing all resin constructions that are of type /obj
/datum/resin_construction/resin_obj/build(turf/build_turf, hivenumber, mob/living/carbon/xenomorph/builder)
	var/path = check_thick_build(build_turf, hivenumber, builder) ? build_path_thick : build_path
	if(pass_hivenumber)
		return new path(build_turf, hivenumber, builder)
	return new path(build_turf)

// Subtype encompassing all resin constructions that are of type /turf
/datum/resin_construction/resin_turf/build(turf/build_turf, hivenumber, mob/living/carbon/xenomorph/builder)
	var/path = check_thick_build(build_turf, hivenumber, builder) ? build_path_thick : build_path

	build_turf.PlaceOnTop(path)

	var/turf/closed/wall/resin/resin_wall = build_turf
	if (istype(resin_wall) && pass_hivenumber)
		resin_wall.hivenumber = hivenumber
		resin_wall.set_resin_builder(builder)
		set_hive_data(resin_wall, hivenumber)

	return build_turf


// Resin Walls
/datum/resin_construction/resin_turf/wall
	name = "树脂墙"
	desc = "能阻挡通行的树脂墙。"
	construction_name = "resin wall"
	cost = XENO_RESIN_WALL_COST

	build_path = /turf/closed/wall/resin
	build_animation_effect = /obj/effect/resin_construct/weak

/datum/resin_construction/resin_turf/wall/thick
	name = "厚实树脂墙"
	desc = "比普通树脂墙更坚固的厚实树脂墙。"
	construction_name = "thick resin wall"
	cost = XENO_RESIN_WALL_THICK_COST

	build_path = /turf/closed/wall/resin/thick
	build_animation_effect = /obj/effect/resin_construct/thick

/datum/resin_construction/resin_turf/wall/queen
	name = "女皇树脂墙"
	desc = "能阻挡通行的树脂墙，建造类型取决于菌毯。"
	construction_name = "queen resin wall"

	cost = XENO_RESIN_WALL_QUEEN_COST

	build_path = /turf/closed/wall/resin
	build_path_thick = /turf/closed/wall/resin/thick
	thick_hiveweed = TRUE
	build_animation_effect = /obj/effect/resin_construct/weak

/datum/resin_construction/resin_turf/wall/reflective
	name = "反射树脂墙"
	desc = "能将所有弹丸反射回射手的反射树脂墙。"
	construction_name = "reflective resin wall"
	cost = XENO_RESIN_WALL_REFLECT_COST
	max_per_xeno = 5

	build_path = /turf/closed/wall/resin/reflective

// Resin Membrane
/datum/resin_construction/resin_turf/membrane
	name = "树脂膜"
	desc = "能透过它观察另一侧的树脂膜。"
	construction_name = "resin membrane"
	cost = XENO_RESIN_MEMBRANE_COST

	build_path = /turf/closed/wall/resin/membrane
	build_animation_effect = /obj/effect/resin_construct/transparent/weak

/datum/resin_construction/resin_turf/membrane/queen
	name = "女皇树脂膜"
	desc = "能透过它观察另一侧的树脂膜，建造类型取决于菌毯。"
	construction_name = "queen resin membrane"
	cost = XENO_RESIN_MEMBRANE_QUEEN_COST

	build_path = /turf/closed/wall/resin/membrane
	build_path_thick = /turf/closed/wall/resin/membrane/thick
	thick_hiveweed = TRUE
	build_animation_effect = /obj/effect/resin_construct/transparent/weak

/datum/resin_construction/resin_turf/membrane/thick
	name = "厚实树脂膜"
	desc = "坚固且能透过它观察另一侧的树脂膜。"
	construction_name = "thick resin membrane"
	cost = XENO_RESIN_MEMBRANE_THICK_COST

	build_path = /turf/closed/wall/resin/membrane/thick
	build_animation_effect = /obj/effect/resin_construct/transparent/thick

// Resin Doors
/datum/resin_construction/resin_obj/door
	name = "树脂门"
	desc = "只有姐妹们才能通过的树脂门。"
	construction_name = "resin door"
	cost = XENO_RESIN_DOOR_COST

	build_path = /obj/structure/mineral_door/resin
	build_animation_effect = /obj/effect/resin_construct/door

/datum/resin_construction/resin_obj/door/can_build_here(turf/T, mob/living/carbon/xenomorph/X)
	if (!..())
		return FALSE

	var/wall_support = FALSE
	for(var/D in GLOB.cardinals)
		var/turf/CT = get_step(T, D)
		if(CT)
			if(CT.density)
				wall_support = TRUE
				break
			else if(locate(/obj/structure/mineral_door/resin) in CT)
				wall_support = TRUE
				break

	if(!wall_support)
		to_chat(X, SPAN_WARNING("树脂门旁边必须有墙或另一扇树脂门才能成形。"))
		return FALSE

	return TRUE

/datum/resin_construction/resin_obj/door/queen
	name = "女皇树脂门"
	desc = "只有姐妹们才能通过的树脂门，建造类型取决于菌毯。"
	construction_name = "queen resin door"
	cost = XENO_RESIN_DOOR_QUEEN_COST

	build_path = /obj/structure/mineral_door/resin
	build_path_thick = /obj/structure/mineral_door/resin/thick
	thick_hiveweed = TRUE
	build_animation_effect = /obj/effect/resin_construct/door

/datum/resin_construction/resin_obj/door/thick
	name = "厚实树脂门"
	desc = "更耐用的厚实树脂门，只有姐妹们才能通过。"
	construction_name = "thick resin door"
	cost = XENO_RESIN_DOOR_THICK_COST

	build_path = /obj/structure/mineral_door/resin/thick
	build_animation_effect = /obj/effect/resin_construct/thickdoor

// Sticky Resin
/datum/resin_construction/resin_obj/sticky_resin
	name = "黏性树脂"
	desc = "高个宿主走过时会被减速的树脂。"
	construction_name = "sticky resin"
	cost = XENO_RESIN_STICKY_COST
	build_time = 1 SECONDS

	build_path = /obj/effect/alien/resin/sticky

// Fast Resin
/datum/resin_construction/resin_obj/fast_resin
	name = "加速树脂"
	desc = "姐妹们走过时会加速的树脂。"
	construction_name = "fast resin"
	cost = XENO_RESIN_FAST_COST
	build_time = 1 SECONDS

	build_path = /obj/effect/alien/resin/sticky/fast

/datum/resin_construction/resin_obj/resin_spike
	name = "树脂尖刺"
	desc = "高个宿主走过时会受到伤害的树脂。"
	construction_name = "resin spike"
	cost = XENO_RESIN_SPIKE_COST
	max_per_xeno = 15

	build_path = /obj/effect/alien/resin/spike

/datum/resin_construction/resin_obj/acid_pillar
	name = "酸液柱"
	desc = "高大的绿色柱体，能同时向多个目标发射弱酸液。"
	construction_name = "acid pillar"
	cost = XENO_RESIN_ACID_PILLAR_COST
	max_per_xeno = 1

	build_overlay_icon = /obj/effect/warning/alien/weak

	build_path = /obj/effect/alien/resin/acid_pillar
	build_time = 12 SECONDS

	range_between_constructions = 5

/datum/resin_construction/resin_obj/shield_dispenser
	name = "护盾柱"
	desc = "高大而奇异的柱体，能为与其互动的成员提供护盾，冷却时间较长。"
	construction_name = "shield pillar"
	cost = XENO_RESIN_SHIELD_PILLAR_COST
	max_per_xeno = 1

	build_path = /obj/effect/alien/resin/shield_pillar
	build_time = 12 SECONDS

/datum/resin_construction/resin_obj/shield_dispenser/New()
	. = ..()
	var/obj/effect/alien/resin/shield_pillar/SP = build_path
	range_between_constructions = initial(SP.range)*2

/datum/resin_construction/resin_obj/grenade
	name = "树脂酸液手榴弹"
	desc = "一枚酸液手榴弹。"
	construction_name = "acid grenade"
	cost = XENO_RESIN_ACID_GRENADE_COST
	max_per_xeno = 1

	build_path = /obj/item/explosive/grenade/alien/acid
	build_time = 6 SECONDS

//CHRISTMAS

/datum/resin_construction/resin_obj/festivizer
	name = "圣诞气氛棒"
	desc = "圣诞快乐！用它敲打任何东西，营造最欢乐的节日气氛！"
	construction_name = "christmas festivizer"
	max_per_xeno = 5
	build_path = /obj/item/toy/festivizer/xeno
	build_time = 2 SECONDS

/datum/resin_construction/resin_obj/movable
	construction_name = "resin wall"

	max_per_xeno = 7
	cost = XENO_RESIN_WALL_MOVABLE_COST
	build_time = 3 SECONDS

/datum/resin_construction/resin_obj/movable/wall
	name = "可移动树脂墙"
	desc = "只要有菌毯，就能移到任意相邻地格上的树脂墙。"
	construction_name = "resin wall"
	build_path = /obj/structure/alien/movable_wall

/datum/resin_construction/resin_obj/movable/membrane
	name = "可移动树脂膜"
	desc = "只要有菌毯，就能移到任意相邻地格上的树脂膜。"
	construction_name = "resin wall"
	build_path = /obj/structure/alien/movable_wall/membrane

/datum/resin_construction/resin_obj/movable/thick_wall
	name = "可移动厚实树脂墙"
	desc = "只要有菌毯，就能移到任意相邻地格上的厚实树脂墙。"
	construction_name = "thick resin wall"
	build_path = /obj/structure/alien/movable_wall/thick

/datum/resin_construction/resin_obj/movable/thick_membrane
	name = "可移动厚实树脂膜"
	desc = "只要有菌毯，就能移到任意相邻地格上的厚实树脂膜。"
	construction_name = "thick resin membrane"
	build_path = /obj/structure/alien/movable_wall/membrane/thick

// Remote Weed Nodes for originally coded for Resin Whisperers
/datum/resin_construction/resin_obj/resin_node
	name = "菌毯节点"
	desc = "引导能量，扩散我们的影响。"
	construction_name = "weed node"
	cost = (XENO_RESIN_MEMBRANE_THICK_COST * 2) // 3x the cost of a thick membrane. At the time of coding that is 95*2 = 190

	build_path = /obj/effect/alien/weeds/node
	build_overlay_icon = /obj/effect/warning/alien/weak
