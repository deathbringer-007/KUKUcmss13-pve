

//-----USS Almayer Walls ---//

/turf/closed/wall/almayer
	name = "舰体"
	desc = "用于分隔舱室并构成舰体的金属墙。"
	icon = 'icons/turf/walls/almayer.dmi'
	icon_state = "testwall"
	walltype = WALL_HULL

	damage = 0
	damage_cap = HEALTH_WALL //Wall will break down to girders if damage reaches this point

	opacity = TRUE
	density = TRUE

	tiles_with = list(
		/turf/closed/wall,
		/obj/structure/window/framed,
		/obj/structure/window_frame,
		/obj/structure/girder,
		/obj/structure/machinery/door,
		/obj/structure/machinery/cm_vending/sorted/attachments/blend,
		/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend,
		/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend,
	)

	/// The type of wall decoration we use, to avoid the wall changing icon all the time
	var/decoration_type

/turf/closed/wall/almayer/Initialize(mapload, ...)
	if(!special_icon && prob(20))
		decoration_type = rand(0,3)
	return ..()

/turf/closed/wall/almayer/update_icon()
	if(decoration_type == null)
		return ..()
	if(neighbors_list in list(EAST|WEST))
		special_icon = TRUE
		icon_state = "almayer_deco_wall[decoration_type]"
	else // Wall connection was broken, return to normality
		special_icon = FALSE
	return ..()

/turf/closed/wall/almayer/take_damage(dam, mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "指纹中混有少量金属屑和污物。")

	..()

/turf/closed/wall/almayer/reinforced
	name = "加固舰体"
	desc = "用于分隔舱室并构成舰体的加固金属墙。"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/// Acts like /turf/closed/wall/almayer/outer until post-hijack where it reverts to /turf/closed/wall/almayer/reinforced.
/turf/closed/wall/almayer/reinforced/temphull
	name = "重型加固舰体"
	desc = "用于分隔舱室并构成舰体的高强度加固金属墙。只有猛烈撞击才能削弱它。"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "temphull"
	hull = TRUE

/turf/closed/wall/almayer/reinforced/temphull/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(de_hull))

/turf/closed/wall/almayer/reinforced/temphull/proc/de_hull()
	SIGNAL_HANDLER
	hull = FALSE
	desc = "用于分隔舱室并构成舰体的高强度加固金属墙，已被猛烈撞击削弱。"

/turf/closed/wall/almayer/outer
	name = "外层舰体"
	desc = "将舰船与太空隔开的金属墙。"
	icon_state = "hull" //Codersprite to make it more obvious in the map maker what's a hull wall and what's not
	//icon_state = "testwall0_debug" //Uncomment to check hull in the map editor.
	walltype = WALL_HULL
	hull = 1 //Impossible to destroy or even damage. Used for outer walls that would breach into space, potentially some special walls

/turf/closed/wall/almayer/outer/gear
	icon_state = "almayer_elevator"
	walltype = null
	special_icon = 1

/turf/closed/wall/almayer/outer/friegt
	icon_state = "almayer_friegt"
	walltype = null
	special_icon = 1

/turf/closed/wall/almayer/no_door_tile
	tiles_with = list(/turf/closed/wall,/obj/structure/window/framed,/obj/structure/window_frame,/obj/structure/girder)

/turf/closed/wall/almayer/outer/take_damage(dam, mob/M)
	return

/turf/closed/wall/almayer/white
	walltype = WALL_WHITE
	icon = 'icons/turf/walls/almayer_white.dmi'
	icon_state = "wwall"

/turf/closed/wall/almayer/white/reinforced
	name = "加固舰体"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/turf/closed/wall/almayer/white/outer_tile
	tiles_with = list(/turf/closed/wall/almayer/white,/turf/closed/wall/almayer/outer)

/turf/closed/wall/almayer/white/hull
	name = "超强加固舰体"
	desc = "用于隔离潜在危险区域的超强加固金属墙。"
	hull = 1
	icon_state = "hull"

/turf/closed/wall/almayer/research/can_be_dissolved()
	return 0

/turf/closed/wall/almayer/research/containment/wall
	name = "隔离舱墙"
	icon = 'icons/turf/almayer.dmi'
	tiles_with = null
	walltype = null
	special_icon = 1

/turf/closed/wall/almayer/research/containment/wall/ex_act(severity, explosion_direction)
	if(severity <= EXPLOSION_THRESHOLD_MEDIUM) // Wall is resistant to explosives (and also crusher charge)
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/take_damage(dam, mob/M)
	if(isxeno(M))
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/attackby(obj/item/W, mob/user)
	if(isxeno(user))
		return
	. = ..()

/turf/closed/wall/almayer/research/containment/wall/attack_alien(mob/living/carbon/xenomorph/user)
	return

/turf/closed/wall/almayer/research/containment/wall/corner
	icon_state = "containment_wall_corner"

/turf/closed/wall/almayer/research/containment/wall/divide
	icon_state = "containment_wall_divide"
	var/operating = FALSE

/turf/closed/wall/almayer/research/containment/wall/divide/proc/open()
	if(operating)
		return
	operating = TRUE
	flick("containment_wall_divide_lowering", src)
	icon_state = "containment_wall_divide_lowered"
	set_opacity(0)
	density = FALSE
	operating = FALSE
	change_weeds()

/turf/closed/wall/almayer/research/containment/wall/divide/proc/close()
	if(operating)
		return
	operating = TRUE
	flick("containment_wall_divide_rising", src)
	icon_state = "containment_wall_divide"
	set_opacity(1)
	density = TRUE
	operating = FALSE

	change_weeds()

/turf/closed/wall/almayer/research/containment/wall/divide/proc/change_weeds()
	for(var/obj/effect/alien/W in src) // Destroy all alien things on the divider (traps, special structures, etc)
		playsound(src, "alien_resin_break", 25)
		qdel(W)


/turf/closed/wall/almayer/research/containment/wall/south
	icon_state = "containment_wall_south"

/turf/closed/wall/almayer/research/containment/wall/west
	icon_state = "containment_wall_w"

/turf/closed/wall/almayer/research/containment/wall/connect_e
	icon_state = "containment_wall_connect_e"

/turf/closed/wall/almayer/research/containment/wall/connect3
	icon_state = "containment_wall_connect3"

/turf/closed/wall/almayer/research/containment/wall/connect_w
	icon_state = "containment_wall_connect_w"

/turf/closed/wall/almayer/research/containment/wall/connect_w2
	icon_state = "containment_wall_connect_w2"

/turf/closed/wall/almayer/research/containment/wall/east
	icon_state = "containment_wall_e"

/turf/closed/wall/almayer/research/containment/wall/north
	icon_state = "containment_wall_n"

/turf/closed/wall/almayer/research/containment/wall/connect_e2
	name = "\improper 隔离舱墙"
	icon_state = "containment_wall_connect_e2"

/turf/closed/wall/almayer/research/containment/wall/connect_s1
	icon_state = "containment_wall_connect_s1"

/turf/closed/wall/almayer/research/containment/wall/connect_s2
	icon_state = "containment_wall_connect_s2"

/turf/closed/wall/almayer/research/containment/wall/purple
	name = "隔离舱观察窗"
	icon_state = "containment_window"
	opacity = FALSE

//AI Core

/turf/closed/wall/almayer/aicore
	walltype = WALL_AICORE
	icon = 'icons/turf/walls/almayer_aicore.dmi'
	icon_state = "aiwall"

/turf/closed/wall/almayer/aicore/reinforced
	name = "加固舰体"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/turf/closed/wall/almayer/aicore/hull
	name = "超强加固舰体"
	desc = "用于隔离潜在危险区域的超强加固金属墙。"
	hull = TRUE
	icon_state = "hull"

/turf/closed/wall/almayer/aicore/white
	walltype = WALL_AICORE
	icon = 'icons/turf/walls/almayer_aicore_white.dmi'
	icon_state = "aiwall"

/turf/closed/wall/almayer/aicore/white/reinforced
	name = "加固舰体"
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "reinforced"

/turf/closed/wall/almayer/aicore/white/hull
	name = "超强加固舰体"
	desc = "用于隔离潜在危险区域的超强加固金属墙。"
	hull = TRUE
	icon_state = "hull"


//Sulaco walls.
/turf/closed/wall/sulaco
	name = "飞船舰体"
	desc = "将飞船舱室与冰冷真空隔开的金属墙。"
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "sulaco"
	hull = 0 //Can't be deconstructed

	damage_cap = HEALTH_WALL
	walltype = WALL_SULACO //Changes all the sprites and icons.

/turf/closed/wall/sulaco/hull
	name = "外层舰体"
	desc = "加固的外层舰体，大概是为了防止船体破裂。"
	hull = 1
	walltype = WALL_SULACO


/turf/closed/wall/sulaco/unmeltable
	name = "外层舰体"
	desc = "加固的外层舰体，大概是为了防止船体破裂。"
	hull = 1
	walltype = WALL_SULACO




/turf/closed/wall/indestructible
	name = "墙"
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	hull = 1



/turf/closed/wall/indestructible/bulkhead
	name = "舱壁"
	desc = "一面巨大的金属舱壁。"
	icon_state = "hull"

/turf/closed/wall/indestructible/fakeglass
	name = "窗户"
	icon_state = "fakewindows"
	opacity = FALSE

INITIALIZE_IMMEDIATE(/turf/closed/wall/indestructible/splashscreen)

/turf/closed/wall/indestructible/splashscreen
	name = "大厅插画"
	desc = "各式插画作品。"
	icon = 'icons/lobby/title_loading.dmi'
	icon_state = "title"
	layer = FLY_LAYER
	special_icon = TRUE

/turf/closed/wall/indestructible/splashscreen/Initialize()
	. = ..()
	tag = "LOBBYART"

/proc/force_lobby_art(art_id)
	GLOB.displayed_lobby_art = art_id
	var/turf/closed/wall/indestructible/splashscreen/lobby_art = locate("LOBBYART")
	var/list/lobby_arts = CONFIG_GET(str_list/lobby_art_images)
	var/list/lobby_authors = CONFIG_GET(str_list/lobby_art_authors)
	lobby_art.icon = 'icons/lobby/title.dmi'
	lobby_art.icon_state = lobby_arts[GLOB.displayed_lobby_art]
	lobby_art.desc = "插画作者：[lobby_authors[GLOB.displayed_lobby_art]]"
	lobby_art.pixel_x = -288
	lobby_art.pixel_y = -288
	for(var/client/player in GLOB.clients)
		if(GLOB.displayed_lobby_art != -1)
			var/author = lobby_authors[GLOB.displayed_lobby_art]
			if(author != "Unknown")
				to_chat_forced(player, SPAN_ROUNDBODY("<hr>本回合的大厅插画由[author]提供<hr>"))

/turf/closed/wall/indestructible/other
	icon_state = "r_wall"

/turf/closed/wall/indestructible/invisible
	icon_state = "invisible"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT




// Mineral Walls

/turf/closed/wall/mineral
	name = "矿物墙"
	desc = "这东西不该存在。"
	icon = 'icons/turf/walls/stone.dmi'
	icon_state = "stone"
	walltype = WALL_STONE
	var/mineral
	var/last_event = 0
	var/active = null
	tiles_with = list(/turf/closed/wall/mineral)

/turf/closed/wall/mineral/gold
	name = "金墙"
	desc = "表面镀金的墙。真阔气！"
	icon = 'icons/turf/walls/walls.dmi'
	icon_state = "gold0"
	walltype = WALL_GOLD
	mineral = "gold"
	//var/electro = 1
	//var/shocked = null

/turf/closed/wall/mineral/silver
	name = "银墙"
	desc = "表面镀银的墙。闪闪发亮！"
	mineral = "silver"
	color = "#e5e5e5"
	//var/electro = 0.75
	//var/shocked = null

/turf/closed/wall/mineral/diamond
	name = "钻石墙"
	desc = "表面镶嵌钻石的墙。你可真奢侈。"
	mineral = "diamond"
	color = "#3d9191"

/turf/closed/wall/mineral/diamond/thermitemelt(mob/user)
	return


/turf/closed/wall/mineral/sandstone
	name = "砂岩墙"
	desc = "表面覆有砂岩的墙。"
	mineral = "sandstone"
	color = "#c6a480"
	baseturfs = /turf/open/gm/dirt

/turf/closed/wall/mineral/sandstone/runed
	name = "砂岩神庙墙"
	desc = "厚重的砂岩墙。"
	mineral = "runed sandstone"
	color = "#b29082"
	damage_cap = HEALTH_WALL_REINFORCED//Strong, but only available to Hunters, can can still be blown up or melted by boilers.
	baseturfs = /turf/open/floor/sandstone/runed

/turf/closed/wall/mineral/sandstone/runed/attack_alien(mob/living/carbon/xenomorph/user)
	visible_message("[user] 用爪子徒劳地刮擦着 [src]。")
	return

/turf/closed/wall/mineral/sandstone/runed/decor
	name = "符文砂岩神庙墙"
	desc = "厚重的砂岩墙，表面刻有精美雕饰和符文。"
	icon = 'icons/turf/walls/runedstone.dmi'
	icon_state = "runedstone"
	walltype = "runedstone"

/turf/closed/wall/mineral/sandstone/runed/can_be_dissolved()
	return 2

/turf/closed/wall/mineral/uranium
	name = "铀墙"
	desc = "表面覆有铀的墙。这大概不是什么好主意。"
	mineral = "uranium"
	color = "#1b4506"

/turf/closed/wall/mineral/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/L in range(3,src))
				L.apply_effect(12,IRRADIATE,0)
			for(var/turf/closed/wall/mineral/uranium/T in range(3,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return

/turf/closed/wall/mineral/uranium/leaking
	name = "破损的铀墙"
	damage = 666
	desc = "表面覆有铀的墙，正泄漏着什么。光是看着它就让人头晕。"
	color = "#660202"

/turf/closed/wall/mineral/uranium/attack_hand(mob/user as mob)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/attackby(obj/item/W as obj, mob/user as mob)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/Collided(atom/movable/AM)
	radiate()
	..()

/turf/closed/wall/mineral/phoron
	name = "弗燃素墙"
	desc = "表面覆有弗燃素的墙。这绝对不是什么好主意。"
	mineral = "phoron"
	color = "#9635aa"


//BONE RESIN WALLS

/turf/closed/wall/mineral/bone_resin //mineral wall because, reasons bro.
	name = "骨状树脂"
	icon = 'icons/turf/walls/prison/bone_resin.dmi'
	icon_state = "bone_resin"
	walltype = WALL_BONE_RESIN
	hull = 1
	unacidable = TRUE
	desc = "由蜕落的陈旧树脂构成的墙。这里比你更有生命力。"

/turf/closed/wall/mineral/bone/is_weedable()
	return NOT_WEEDABLE

//Misc walls

/turf/closed/wall/cult
	name = "墙"
	desc = "你试图看清墙上的刻纹，它们却仿佛在移动。你感到一阵恶心。"
	icon = 'icons/turf/walls/cult.dmi'
	icon_state = "cult"
	walltype = WALL_CULT
	color = "#3c3434"

/turf/closed/wall/cult/make_girder(destroyed_girder)
	return

/turf/closed/wall/vault
	icon_state = "rockvault"

/turf/closed/wall/vault/Initialize()
	. = ..()
	icon_state = "[type]vault"


//Hangar walls
/turf/closed/wall/hangar
	name = "机库墙"
	icon = 'icons/turf/walls/hangar.dmi'
	icon_state = "hangar"
	walltype = WALL_HANGAR

//Prison wall

/turf/closed/wall/prison
	name = "金属墙"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

//Biodome wall

/turf/closed/wall/biodome
	name = "金属墙"
	icon = 'icons/turf/walls/corsat.dmi'
	icon_state = "dome"
	walltype = WALL_DOME

//Wood wall

/turf/closed/wall/wood
	name = "木墙"
	icon = 'icons/turf/walls/wood.dmi'
	icon_state = "wood"
	walltype = WALL_WOOD
	baseturfs = /turf/open/floor/wood

/turf/closed/wall/wood/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_list in list(EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		if(r1 >= 9)
			overlays += image(icon, icon_state = "wood_variant")

//Colorable rocks. Looks like moonsand.

/turf/closed/wall/rock
	name = "岩壁"
	icon = 'icons/turf/walls/cave.dmi'
	icon_state = "cavewall"
	desc = "由坚硬岩石构成的粗糙岩壁。"
	walltype = WALL_CAVE
	hull = 1
	color = "#535963"

/turf/closed/wall/rock/brown
	color = "#826161"

/turf/closed/wall/rock/orange
	color = "#994a16"
	desc = "由花岗岩与砂岩构成的粗糙岩壁。"

/turf/closed/wall/rock/red
	color = "#822d21"

/turf/closed/wall/rock/ice
	name = "致密冰墙"
	color = "#4b94b3"

/turf/closed/wall/rock/ice/thin
	alpha = 166

//Strata New Blendy Ice

/turf/closed/wall/strata_ice
	name = "冰柱"
	icon = 'icons/turf/walls/strata_ice.dmi'
	icon_state = "strata_ice"
	desc = "一片无比巨大的冰柱群。凝视得越久，冰层就显得越深。"
	walltype = WALL_STRATA_ICE //Not a metal wall
	hull = 1 //Can't break this ice.

/turf/closed/wall/strata_ice/dirty
	icon_state = "strata_ice_dirty"
	desc = "冰柱与峭壁层层堆叠，仿佛不屈地直指苍穹，却又被滴落的冰冷融水阻住了去路。"
	walltype = WALL_STRATA_ICE_DIRTY

/turf/closed/wall/strata_ice/jungle
	name = "丛林植被"
	icon = 'icons/turf/walls/jungle_veg.dmi'
	icon_state = "jungle_veg"
	desc = "异常茂密的植被，完全无法看穿。"
	walltype = WALL_JUNGLE_UPDATED //Not a metal wall
	hull = 1

/turf/closed/wall/strata_outpost_ribbed //this guy is our reinforced replacement
	name = "肋状前哨墙"
	icon = 'icons/turf/walls/strata_outpost.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "厚重的金属墙，表面布满棱角分明的加强筋。"
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/strata_outpost
	name = "光面前哨墙"
	icon = 'icons/turf/walls/strata_outpost.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "厚重的金属墙，表面光秃而威严。"
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/strata_outpost/reinforced
	name = "肋状前哨墙"
	icon_state = "strata_ribbed_outpost_"
	desc = "厚重的金属墙，表面布满棱角分明的加强筋。"
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/strata_outpost/reinforced/hull
	hull = 1
	icon_state = "strata_hull"
	desc = "厚重的金属墙。仅凭所处位置和那股不可撼动的气势，它就完全无法摧毁。"

//SOLARIS RIDGE TILESET//

/turf/closed/wall/solaris
	name = "殖民地墙"
	icon = 'icons/turf/walls/solaris/solaris.dmi'
	icon_state = "solaris_interior"
	desc = "看起来坚固的墙，自建成那天起就饱经风沙。它见证了人类的意志。"
	walltype = WALL_SOLARIS

/turf/closed/wall/solaris/reinforced
	name = "加固殖民地墙"
	icon_state = "solaris_interior_r"
	walltype = WALL_SOLARISR
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/solaris/reinforced/hull
	name = "重型加固殖民地墙"
	icon_state = "solaris_interior_h"
	hull = 1

/turf/closed/wall/solaris/reinforced/hull/lv522
	name = "殖民地挡风墙"

/turf/closed/wall/solaris/rock
	name = "岩壁"
	icon_state = "solaris_rock"
	walltype = WALL_SOLARIS_ROCK
	hull = 1



//GREYBOX DEVELOPMENT WALLS

/turf/closed/wall/dev
	name = "灰盒墙"
	icon = 'icons/turf/walls/dev/dev.dmi'
	icon_state = "devwall"
	desc = "就像橙盒里的那种！"
	walltype = WALL_DEVWALL

/turf/closed/wall/dev/reinforced
	name = "灰盒加固墙"
	icon_state = "devwall_r"
	desc = "就像橙盒里的那种！这面还经过加固。"
	walltype = WALL_DEVWALL_R
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/dev/reinforced/hull
	name = "灰盒舰体墙"
	desc = "就像橙盒里的那种！这面无法摧毁。"
	hull = 1

//KUTJEVO DESERT WALLS / SHARED TRIJENT TILESET

/turf/closed/wall/kutjevo/rock
	name = "岩壁"
	desc = "高大的砂岩。威严、壮观，令人无法忽视。"
	icon = 'icons/turf/walls/kutjevo/kutjevo.dmi'
	icon_state = "rock"
	walltype = WALL_KUTJEVO_ROCK
	hull = 1

/turf/closed/wall/kutjevo/rock/border
	icon_state = "rock_border"//no sandy edges
	walltype = WALL_KUTJEVO_ROCK_BORDER

/turf/closed/wall/kutjevo/colony
	name = "殖民地墙"
	icon = 'icons/turf/walls/kutjevo/kutjevo.dmi'
	icon_state = "colony"
	desc = "布满尘土的破旧墙体，建造时本打算让它经久耐用。"
	walltype = WALL_KUTJEVO_COLONY

/turf/closed/wall/kutjevo/colony/reinforced
	name = "加固殖民地墙"
	icon_state = "colonyr"
	desc = "布满尘土的破旧墙体，建造时本打算让它经久耐用。这面还经过加固。"
	walltype = WALL_KUTJEVO_COLONYR
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/kutjevo/colony/reinforced/hull
	icon_state = "colonyh"
	name = "加固殖民地墙"
	desc = "布满尘土的破旧墙体，建造时本打算让它经久耐用。这面无法摧毁。"
	hull = 1

//ICE COLONY, AKA SHIVA'S SNOWBALL TOBLERONE WALLS
/turf/closed/wall/shiva
	icon = 'icons/turf/walls/ice_colony/shiva_turfs.dmi'

/turf/closed/wall/shiva/ice
	name = "黑冰板层"
	icon_state = "shiva_ice"
	desc = "脏污的黑冰层层覆盖着古老岩层。夏季时，永久冻土的厚度在12至20英寸之间变化。"
	walltype = WALL_SHIVA_ICE //Not a metal wall
	hull = 1 //Can't break this ice.

/turf/closed/wall/shiva/prefabricated
	name = "预制建筑墙"
	icon_state = "shiva_fab"
	desc = "由金属支撑杆和坚韧的聚合凯夫纶塑料制成的建筑结构。这种塑料衍生自美洲联盟防弹背心、殖民地陆战队与进步人民联盟制服的用料。墙面绷紧并经过加固，形成了更持久的建筑结构。"
	walltype = WALL_SHIVA_FAB
	damage_cap = HEALTH_WALL

/turf/closed/wall/shiva/prefabricated/reinforced
	name = "加固预制建筑墙"
	icon_state = "shiva_fab_r"
	desc = "建筑结构由金属支撑杆组成，聚合凯夫纶已被金属板取代，以提高强度。"
	walltype = WALL_SHIVA_FAB_R
	damage_cap = HEALTH_WALL + HEALTH_WALL_XENO_THICK

/turf/closed/wall/shiva/prefabricated/reinforced/hull
	name = "加固预制建筑墙"
	icon_state = "shiva_fab_r_h"
	desc = "你现有的任何手段都无法将其摧毁。也许向神明祈祷会有用。"
	walltype = WALL_SHIVA_FAB_R
	hull = TRUE

/turf/closed/wall/shiva/prefabricated/orange
	icon_state = "shiva_fab_oj"
	walltype = WALL_SHIVA_FAB_ORANGE

/turf/closed/wall/shiva/prefabricated/blue
	icon_state = "shiva_fab_blu"
	walltype = WALL_SHIVA_FAB_BLUE

/turf/closed/wall/shiva/prefabricated/pink
	icon_state = "shiva_fab_pnk"
	walltype = WALL_SHIVA_FAB_PINK

/turf/closed/wall/shiva/prefabricated/white
	icon_state = "shiva_fab_wht"
	walltype = WALL_SHIVA_FAB_WHITE

/turf/closed/wall/shiva/prefabricated/red
	icon_state = "shiva_fab_red"
	walltype = WALL_SHIVA_FAB_RED


//Xenomorph's Resin Walls

/turf/closed/wall/resin
	name = "树脂墙"
	desc = "奇怪的黏液凝固成了一面墙。"
	icon = 'icons/mob/xenos/structures.dmi'
	icon_state = "resin"
	walltype = WALL_RESIN
	damage_cap = HEALTH_WALL_XENO
	layer = RESIN_STRUCTURE_LAYER
	blend_turfs = list(/turf/closed/wall/resin)
	blend_objects = list(/obj/structure/mineral_door/resin)
	repair_materials = list()
	unacidable = TRUE
	var/hivenumber = XENO_HIVE_NORMAL
	var/should_track_build = FALSE
	var/datum/cause_data/construction_data
	turf_flags = TURF_ORGANIC

/turf/closed/wall/resin/Initialize(mapload)
	. = ..()

	for(var/obj/effect/alien/weeds/node/weed_node in contents)
		qdel(weed_node)

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

/turf/closed/wall/resin/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/turf/closed/wall/resin/pillar
	name = "树脂柱节段"
	hull = TRUE

/turf/closed/wall/resin/proc/set_resin_builder(mob/M)
	if(istype(M) && should_track_build)
		construction_data = create_cause_data(initial(name), M)

/turf/closed/wall/resin/make_girder()
	return

/turf/closed/wall/resin/flamer_fire_act(dam = BURN_LEVEL_TIER_1)
	take_damage(dam)

//this one is only for map use
/turf/closed/wall/resin/ondirt
	baseturfs = /turf/open/gm/dirt
//strata specifics
/turf/closed/wall/resin/strata/on_tiles
	baseturfs = /turf/open/floor/strata

/turf/closed/wall/resin/thick
	name = "厚树脂墙"
	desc = "奇怪的黏液凝固成了一面厚墙。"
	damage_cap = HEALTH_WALL_XENO_THICK
	icon_state = "thickresin"
	walltype = WALL_THICKRESIN
	unacidable = TRUE

/turf/closed/wall/resin/tutorial
	name = "教程树脂墙"
	desc = "奇怪的黏液凝固成了一面墙。它异常坚韧。"
	hivenumber = XENO_HIVE_TUTORIAL

/turf/closed/wall/resin/tutorial/attack_alien(mob/living/carbon/xenomorph/xeno)
	return

/turf/closed/wall/resin/membrane
	name = "树脂膜"
	desc = "奇怪的半透明黏液，能让光线透过。"
	icon_state = "membrane"
	walltype = WALL_MEMBRANE
	damage_cap = HEALTH_WALL_XENO_MEMBRANE
	opacity = FALSE
	alpha = 180

/turf/closed/wall/resin/membrane/can_bombard(mob/living/carbon/xenomorph/X)
	if(!istype(X))
		return FALSE

	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	return hive.is_ally(X)

/turf/closed/wall/resin/membrane/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_GLASS

/datum/movable_wall_group
	var/list/obj/structure/alien/movable_wall/walls

	var/push_delay = 4
	var/next_push = 0
	var/is_moving = FALSE

/datum/movable_wall_group/New(list/datum/movable_wall_group/merge)
	. = ..()
	for(var/i in merge)
		var/datum/movable_wall_group/MWG = i
		for(var/wall in MWG.walls)
			add_structure(wall)

/datum/movable_wall_group/proc/add_structure(obj/structure/alien/movable_wall/MW)
	if(MW.group)
		MW.group.remove_structure(MW, TRUE)
	LAZYOR(walls, MW)
	MW.group = src
	MW.update_connections(TRUE)
	MW.update_icon()

/datum/movable_wall_group/Destroy(force)
	QDEL_NULL_LIST(walls)
	return ..()

/datum/movable_wall_group/proc/remove_structure(obj/structure/alien/movable_wall/MW, merge)
	LAZYREMOVE(walls, MW)
	MW.group = null
	if(!walls)
		qdel(src)
	else if(!merge)
		var/obj/structure/alien/movable_wall/current
		var/obj/structure/alien/movable_wall/connected
		var/list/current_walls = walls.Copy()
		for(var/i in current_walls)
			current = i
			if(!current.group || current.group == src)
				var/datum/movable_wall_group/MWG = new()
				MWG.add_structure(current)

			for(var/dir in GLOB.cardinals)
				connected = locate() in get_step(current, dir)
				if(connected in current_walls)
					if(connected.group == src)
						current.group.add_structure(connected)
					else if(connected.group != current.group)
						new /datum/movable_wall_group(list(current.group, connected.group))

		if(!QDELETED(src))
			qdel(src)


/datum/movable_wall_group/proc/try_move_in_direction(dir, list/forget)
	var/turf/T
	var/obj/structure/alien/movable_wall/MW
	var/failed = FALSE
	var/on_weeds = FALSE

	if(is_moving)
		return FALSE

	is_moving = TRUE
	for(var/i in walls)
		MW = i
		T = get_step(MW, dir)

		if(T.weeds)
			on_weeds = TRUE

		if(LinkBlocked(MW, MW.loc, T, forget=forget))
			failed = TRUE

		for(var/a in T)
			var/atom/movable/A = a

			if(A.loc != T)
				continue

			if(MW.pulledby == A)
				var/mob/M = A
				M.stop_pulling()

			if((A in forget) || A.anchored)
				continue

			if(ismob(A))
				var/mob/M = A
				if(M.stat == DEAD)
					continue

				var/result = M.Move(get_step(T, dir), dir)
				if(A.density && !result)
					failed = TRUE
			else if(A.density && !A.Move(get_step(T, dir), dir))
				failed = TRUE

	is_moving = FALSE

	if(failed || !on_weeds)
		return FALSE

	for(var/i in walls)
		MW = i
		T = get_step(MW, dir)
		MW.forceMove(T)
	next_push = world.time + push_delay

	return TRUE


// Not a turf because it is movable, but still very much an obstacle/wall.
/obj/structure/alien/movable_wall
	name = "移位树脂墙"
	desc = "能够移动位置的树脂墙。"
	icon = 'icons/turf/walls/xeno.dmi'
	health = HEALTH_WALL_XENO
	icon_state = "resin"
	var/wall_type = "resin"

	flags_obj = OBJ_ORGANIC

	var/max_walls = 7
	var/datum/movable_wall_group/group

	density = TRUE
	anchored = TRUE
	opacity = TRUE

	var/turf/tied_turf
	var/list/wall_connections = list("0", "0", "0", "0")
	drag_delay = 4


	var/hivenumber = XENO_HIVE_NORMAL

/obj/structure/alien/movable_wall/Initialize(mapload, hive)
	. = ..()
	if(hive)
		hivenumber = hive
		set_hive_data(src, hive)
	recalculate_structure()
	update_tied_turf(loc)
	RegisterSignal(src, COMSIG_ATOM_TURF_CHANGE, PROC_REF(update_tied_turf))
	RegisterSignal(src, COMSIG_MOVABLE_XENO_START_PULLING, PROC_REF(allow_xeno_drag))
	RegisterSignal(src, COMSIG_MOVABLE_PULLED, PROC_REF(continue_allowing_drag))

/obj/structure/alien/movable_wall/ex_act(severity, direction)
	take_damage(severity)

/obj/structure/alien/movable_wall/proc/continue_allowing_drag(_, mob/living/L)
	if(isxeno(L))
		return COMPONENT_IGNORE_ANCHORED

/obj/structure/alien/movable_wall/proc/allow_xeno_drag(_, mob/living/carbon/xenomorph/X)
	return COMPONENT_ALLOW_PULL

/obj/structure/alien/movable_wall/update_icon()
	overlays.Cut()

	icon_state = "blank"
	var/image/I

	for(var/i = 1 to 4)
		I = image(icon, "[wall_type][wall_connections[i]]", dir = 1<<(i-1))
		overlays += I

	if(health < initial(health))
		var/image/img = image(icon = 'icons/turf/walls/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = ((1-health/initial(health)) * 255)
		overlays += img

/obj/structure/alien/movable_wall/proc/update_connections(propagate = FALSE)
	var/list/wall_dirs = list()

	for(var/dir in GLOB.alldirs)
		var/obj/structure/alien/movable_wall/MW = locate() in get_step(src, dir)
		if(!(MW in group.walls))
			continue

		wall_dirs |= dir
		if(propagate)
			MW.update_connections()
			MW.update_icon()

	wall_connections = dirs_to_corner_states(wall_dirs)

/obj/structure/alien/movable_wall/proc/take_damage(damage)
	health -= damage
	if(health <= 0)
		deconstruct(FALSE)
	else
		update_icon()

/obj/structure/alien/movable_wall/attack_alien(mob/living/carbon/xenomorph/M)
	if(islarva(M))
		return FALSE

	if(M.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	M.visible_message(SPAN_XENONOTICE("[M]用爪子猛抓[src]！"), \
	SPAN_XENONOTICE("你用爪子抓挠[src]。"))
	playsound(src, "alien_resin_break", 25)
	if (M.hivenumber == hivenumber)
		take_damage(ceil(HEALTH_WALL_XENO * 0.25)) //Four hits for a regular wall
	else
		take_damage(M.melee_damage_lower*RESIN_XENO_DAMAGE_MULTIPLIER)
	return XENO_ATTACK_ACTION

/obj/structure/alien/movable_wall/attackby(obj/item/W, mob/living/user)
	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force*RESIN_MELEE_DAMAGE_MULTIPLIER*W.demolition_mod, user)
		playsound(src, "alien_resin_break", 25)
	else
		return attack_hand(user)

/obj/structure/alien/movable_wall/get_projectile_hit_boolean(obj/projectile/P)
	return TRUE

/obj/structure/alien/movable_wall/bullet_act(obj/projectile/P)
	. = ..()
	take_damage(P.damage)

/obj/structure/alien/movable_wall/proc/recalculate_structure()
	var/list/found_structures = list()
	var/current_walls = 0
	for(var/i in GLOB.cardinals)
		var/turf/T = get_step(src, i)
		var/obj/structure/alien/movable_wall/MW = locate() in T
		if(!MW)
			continue

		if(MW.group && !(MW.group in found_structures))
			found_structures += MW.group
			current_walls += length(MW.group.walls)

	if(current_walls > max_walls)
		found_structures = null

	var/datum/movable_wall_group/MWG = new(found_structures)
	MWG.add_structure(src)

/obj/structure/alien/movable_wall/Destroy()
	if(!QDELETED(group))
		group.remove_structure(src)
	else
		group = null

	return ..()

/obj/structure/alien/movable_wall/proc/update_tied_turf(turf/T)
	SIGNAL_HANDLER

	if(!T)
		return

	if(tied_turf)
		UnregisterSignal(tied_turf, COMSIG_TURF_ENTER)
	RegisterSignal(T, COMSIG_TURF_ENTER, PROC_REF(check_for_move))
	tied_turf = T

/obj/structure/alien/movable_wall/forceMove(atom/dest)
	. = ..()
	update_tied_turf(loc)

/obj/structure/alien/movable_wall/proc/check_for_move(turf/T, atom/movable/mover)
	if(group.next_push > world.time)
		return

	var/target_dir = get_dir(mover, T)

	if(isxeno(mover))
		var/mob/living/carbon/xenomorph/X = mover
		if(X.hivenumber != hivenumber || X.throwing)
			return

		if(X.pulling == src)
			X.stop_pulling()

		if(group.try_move_in_direction(target_dir, list(mover)))
			return COMPONENT_TURF_ALLOW_MOVEMENT

/obj/structure/alien/movable_wall/Move(NewLoc, direct)
	if(!(direct in GLOB.cardinals))
		return
	group.try_move_in_direction(direct)

/obj/structure/alien/movable_wall/BlockedPassDirs(atom/movable/mover, target_dir)
	if(!group)
		return ..()

	if(mover in group.walls)
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/alien/movable_wall/membrane
	name = "移位树脂膜"
	health = HEALTH_WALL_XENO_MEMBRANE
	icon_state = "membrane"
	wall_type = "membrane"

	opacity = FALSE

/obj/structure/alien/movable_wall/thick
	name = "移位厚树脂墙"
	health = HEALTH_WALL_XENO_THICK
	icon_state = "thickresin"
	wall_type = "thickresin"

/obj/structure/alien/movable_wall/membrane/thick
	name = "移位厚树脂膜"
	health = HEALTH_WALL_XENO_MEMBRANE_THICK
	icon_state = "thickmembrane"
	wall_type = "thickmembrane"

/turf/closed/wall/resin/reflective
	name = "反射树脂墙"
	desc = "奇怪的硬化黏液凝固成了一面细腻光滑的墙。"
	icon = 'icons/turf/walls/prison/bone_resin.dmi'
	icon_state = "resin"
	walltype = WALL_BONE_RESIN
	damage_cap = HEALTH_WALL_XENO_MEMBRANE
	should_track_build = TRUE

	// 75% chance of reflecting projectiles
	var/chance_to_reflect = 75
	var/reflect_range = 10

	var/brute_multiplier = 0.3
	var/explosive_multiplier = 0.3
	var/reflection_multiplier = 0.5

/turf/closed/wall/resin/reflective/bullet_act(obj/projectile/P)
	if(src in P.permutated)
		return

	//Ineffective if someone is sitting on the wall
	if(locate(/mob) in contents)
		return ..()

	if(!prob(chance_to_reflect))
		if(P.ammo.damage_type == BRUTE)
			P.damage *= brute_multiplier
		return ..()
	if(P.runtime_iff_group || P.ammo.flags_ammo_behavior & AMMO_NO_DEFLECT)
		// Bullet gets absorbed if it has IFF or can't be reflected.
		return

	var/obj/projectile/new_proj = new(src, construction_data ? construction_data : create_cause_data(initial(name)))
	new_proj.generate_bullet(P.ammo)
	new_proj.damage = P.damage * reflection_multiplier // don't make it too punishing
	new_proj.accuracy = HIT_ACCURACY_TIER_7 // 35% chance to hit something

	// Move back to who fired you.
	RegisterSignal(new_proj, COMSIG_BULLET_PRE_HANDLE_TURF, PROC_REF(bullet_ignore_turf))
	new_proj.permutated |= src

	var/angle = Get_Angle(src, P.firer) + rand(30, -30)
	var/atom/target = get_angle_target_turf(src, angle, get_dist(src, P.firer))
	new_proj.projectile_flags |= PROJECTILE_SHRAPNEL
	new_proj.fire_at(target, P.firer, src, reflect_range, speed = P.ammo.shell_speed)

	return TRUE

/turf/closed/wall/resin/reflective/proc/bullet_ignore_turf(obj/projectile/P, turf/T)
	SIGNAL_HANDLER
	if(T == src)
		return COMPONENT_BULLET_PASS_THROUGH

/turf/closed/wall/resin/reflective/ex_act(severity, explosion_direction, source, mob/source_mob)
	return ..(severity * explosive_multiplier, explosion_direction, source, source_mob)

//this one is only for map use
/turf/closed/wall/resin/membrane/ondirt
	baseturfs = /turf/open/gm/dirt
//strata specifics
/turf/closed/wall/resin/membrane/strata/on_tiles
	baseturfs = /turf/open/floor/strata

/turf/closed/wall/resin/membrane/thick
	name = "厚树脂膜"
	desc = "奇怪的厚黏液，透明度仅够让光线透过。"
	damage_cap = HEALTH_WALL_XENO_MEMBRANE_THICK
	icon_state = "thickmembrane"
	walltype = WALL_THICKMEMBRANE
	alpha = 210


/turf/closed/wall/resin/hitby(atom/movable/AM)
	..()
	if(isxeno(AM))
		return
	visible_message(SPAN_DANGER("[src]被[AM]击中了。"), \
	SPAN_DANGER("你击中了[src]。"))
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else if (isobj(AM))
		var/obj/O = AM
		tforce = O.throwforce
	playsound(src, "alien_resin_break", 25)
	take_damage(tforce)


/turf/closed/wall/resin/attack_alien(mob/living/carbon/xenomorph/M)
	if(SEND_SIGNAL(src, COMSIG_WALL_RESIN_XENO_ATTACK, M) & COMPONENT_CANCEL_XENO_ATTACK)
		return XENO_NO_DELAY_ACTION

	if(islarva(M)) //Larvae can't do shit
		return
	if(M.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	M.visible_message(SPAN_XENONOTICE("[M]用爪子猛抓[src]！"), \
	SPAN_XENONOTICE("我们用爪子抓挠[src]。"))
	playsound(src, "alien_resin_break", 25)
	if (M.hivenumber == hivenumber)
		take_damage(ceil(HEALTH_WALL_XENO * 0.25)) //Four hits for a regular wall
	else
		take_damage(M.melee_damage_lower*RESIN_XENO_DAMAGE_MULTIPLIER)
	return XENO_ATTACK_ACTION


/turf/closed/wall/resin/attack_animal(mob/living/M)
	M.visible_message(SPAN_DANGER("[M]撕扯着[src]！"), \
	SPAN_DANGER("你撕扯着[name]。"))
	playsound(src, "alien_resin_break", 25)
	M.animation_attack_on(src)
	take_damage(80)


/turf/closed/wall/resin/attack_hand(mob/user)
	if(isxeno(user) && istype(user.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/grab_item_dummy = user.get_active_hand()
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(grab_item_dummy.grabbed_thing, src)

	to_chat(user, SPAN_WARNING("你徒劳地刮擦着[src]。"))

/turf/closed/wall/resin/attackby(obj/item/W, mob/living/user)
	if(SEND_SIGNAL(src, COMSIG_WALL_RESIN_ATTACKBY, W, user) & COMPONENT_CANCEL_RESIN_ATTACKBY)
		return

	if(!(W.flags_item & NOBLUDGEON))
		user.animation_attack_on(src)
		take_damage(W.force*RESIN_MELEE_DAMAGE_MULTIPLIER*W.demolition_mod, user)
		playsound(src, "alien_resin_break", 25)
	else
		return attack_hand(user)

/turf/closed/wall/resin/ChangeTurf(newtype, ...)
	var/hive = hivenumber
	. = ..()
	if(.)
		var/turf/T
		for(var/i in GLOB.cardinals)
			T = get_step(src, i)
			if(!istype(T)) continue
			for(var/obj/structure/mineral_door/resin/R in T)
				R.check_resin_support()

		var/turf/closed/wall/resin/W = .
		if (istype(W))
			W.hivenumber = hive
			set_hive_data(W, W.hivenumber)

/turf/closed/wall/resin/weak
	name = "脆弱树脂墙"
	desc = "奇怪的黏液凝固成了一面墙，看起来已经摇摇欲坠……"
	damage_cap = HEALTH_WALL_XENO_WEAK
	var/duration = 5 SECONDS


/turf/closed/wall/resin/weak/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		ScrapeAway()
		return
	addtimer(CALLBACK(src, PROC_REF(ScrapeAway)), duration)


/turf/closed/wall/resin/can_be_dissolved()
	return FALSE

/turf/closed/wall/huntership
	name = "猎船墙"
	desc = "构成铁血战士猎船舰体的墙，几乎坚不可摧。"
	icon = 'icons/turf/walls/hunter.dmi'
	icon_state = "metal"//DMI specific name
	walltype = WALL_HUNTERSHIP
	hull = 1

/turf/closed/wall/huntership/destructible
	name = "老化猎船墙"
	color = "#c5beb4"
	desc = "这些古老得难以想象的墙构成了一艘非人类舰船的舰体。不过，它们仍和其他不透明障碍一样，可以用塑性炸药炸毁。"
	hull = 0

/turf/closed/wall/upp_wall
	name = "加固墙"
	icon = 'icons/turf/walls/upp_green.dmi'
	icon_state = "uppwall_interior"
	desc = "厚重的金属墙，表面布满棱角分明的加强筋。"
	walltype = WALL_UPP_GREEN
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/upp_wall/hull
	name = "肋状舰体墙"
	icon = 'icons/turf/walls/upp_green.dmi'
	icon_state = "uppwall_hull"
	desc = "厚重的金属墙，表面布满棱角分明的加强筋。"
	hull = 1

/turf/closed/wall/upp_wall/grey
	name = "加固墙"
	icon = 'icons/turf/walls/upp_grey.dmi'
	icon_state = "uppwall_interior"
	desc = "厚重的金属墙，表面光秃而威严。"
	walltype = WALL_UPP_GREY
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/upp_wall/grey/hull
	name = "肋状舰体墙"
	icon = 'icons/turf/walls/upp_grey.dmi'
	icon_state = "uppwall_hull"
	desc = "厚重的金属墙，表面光秃而威严。"
	hull = 1

