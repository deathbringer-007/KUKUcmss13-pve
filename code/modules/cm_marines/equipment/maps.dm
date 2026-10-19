GLOBAL_LIST_INIT(mapless_maps, list(MAP_RUNTIME, MAP_CHINOOK, MAIN_SHIP_DEFAULT_NAME) | SHIP_MAP_NAMES)

/obj/item/map
	name = "地图"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "map"
	item_state = "map"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_TINY
	// color = ... (Colors can be names - "red, green, grey, cyan" or a HEX color code "#FF0000")
	var/dat // Page content
	var/html_link = ""

/obj/item/map/attack_self(mob/user) //Open the map
	..()
	user.visible_message(SPAN_NOTICE("[user]打开了[src.name]。"))
	initialize_map()

/obj/item/map/attack()
	return

/obj/item/map/proc/initialize_map()
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl && html_link)
		dat = {"
				<!DOCTYPE html>
				<html>
				<head>
					<meta http-equiv="X-UA-Compatible" content="IE=edge">
					<meta charset="utf-8">
					<style>
						img {
							display: none;
							position: absolute;
							top: 30;
							left: 0;
							max-width: 100%;
							height: auto;
							overflow: hidden;
							border: 0;
						}
					</style>
				</head>
				<body>
				<script type="text/javascript">
					function pageloaded(obj) {
						document.getElementById("loading").style.display = "none";
						obj.style.display = "inline";
					}
				</script>
				<p id='loading'>你开始展开地图……</p>
					<img onload="pageloaded(this)" src="[wikiurl]/[html_link]?printable=yes&remove_links=1" id="main_frame" alt=""></img>
				</body>

				</html>
			"}
	show_browser(usr, dat, name, "papermap", width = 1280, height = 720)

/obj/item/map/lazarus_landing_map
	name = "\improper 拉撒路着陆区地图"
	desc = "LV-624 拉撒路着陆区殖民地的卫星图打印件。"
	html_link = "images/6/6f/LV624.png"

/obj/item/map/ice_colony_map
	name = "\improper 冰原殖民地地图"
	desc = "冰原殖民地的卫星图打印件。"
	html_link = "images/1/18/Map_icecolony.png"
	color = "cyan"

/obj/item/map/ice_colony_map/v1
	name = "\improper 空白地图"
	html_link = ""

/obj/item/map/ice_colony_map/v2
	name = "\improper 空白地图"
	html_link = ""

/obj/item/map/ice_colony_map_v3
	name = "\improper 希瓦雪球地图"
	desc = "美洲联盟殖民地希瓦雪球的正面扫描打印图，带有标注。"
	html_link = "images/1/18/Map_icecolony.png"
	color = "cyan"

/obj/item/map/whiskey_outpost_map
	name = "\improper 威士忌哨站地图"
	desc = "标有威士忌哨站防御阵地和位置的战术打印图。"
	html_link = "images/7/78/Whiskey_outpost.png"
	color = "grey"

/obj/item/map/big_red_map
	name = "\improper 索拉里斯山脊地图"
	desc = "经审查删改的索拉里斯山脊设施蓝图。"
	html_link = "images/9/9e/Solaris_Ridge.png"
	color = "#e88a10"

/obj/item/map/FOP_map
	name = "\improper 菲奥里纳轨道监狱地图"
	desc = "标有注释的菲奥里纳轨道监狱内部扫描图。"
	html_link = "images/4/4c/Map_Prison.png"
	color = "#e88a10"

/obj/item/map/FOP_map_v3
	name = "\improper 菲奥里纳轨道平民附属区地图"
	desc = "由阿尔迈耶号传感器阵列生成的菲奥里纳轨道监狱平民附属区扫描图。它似乎已经与空间站其余部分分离，目前正独自在行星同步轨道上运行。"
	html_link = "images/e/e0/Prison_Station_Science_Annex.png"
	color = "#e88a10"

/obj/item/map/desert_dam
	name = "\improper 特里金特大坝地图"
	desc = "特里金特大坝殖民地的轨道扫描打印图。"
	html_link = "images/9/92/Trijent_Dam.png"
	color = "#ad8d0e"

/obj/item/map/sorokyne_map
	name = "\improper 索罗基内地层地图"
	desc = "维兰德-汤谷索罗基内哨站殖民地的地图，当地通常被称为索罗基内地层。"
	html_link = "images/2/21/Sorokyne_Wiki_Map.jpg" //The fact that this is just a wiki-link makes me sad and amused.
	color = "cyan"

/obj/item/map/corsat
	name = "\improper CORSAT 地图"
	desc = "CORSAT 空间站的蓝图。"
	html_link = "images/8/8e/CORSAT_Satellite.png"
	color = "red"

/obj/item/map/kutjevo_map
	name = "\improper 库特耶沃精炼厂地图"
	desc = "库特耶沃精炼厂的轨道扫描图。"
	html_link = "images/0/0d/Kutjevo_a1.jpg"
	color = "red"

/obj/item/map/lv522_map
	name = "\improper LV-522 地图"
	desc = "LV-522 设施布局总览。"
	html_link = "images/b/bb/C_claim.png"
	color = "cyan"

/obj/item/map/new_varadero
	name = "\improper 新巴拉德罗地图"
	desc = "美洲联盟新巴拉德罗哨站的标注蓝图。"
	html_link = "images/9/94/New_Varadero.png"
	color = "red"

/obj/item/map/almayer
	name = "\improper 阿尔迈耶号地图"
	desc = "阿尔迈耶号的标注蓝图。"
	html_link = "images/5/54/USS_Almayer.png"
	color = "cyan"

/obj/item/map/canyon_32b
	name = "\improper 空白地图"
	desc = "一张空白地图，至少你觉得这张覆膜纸上本该有地图。"
	html_link = ""
	color = "white"

/obj/item/map/taipei
	name = "\improper 台北中转站地图"
	desc = "台北站的内部扫描打印图，带有标注。这是一个不起眼的中转站。"
	html_link = "images/f/f2/Taipei.png"
	color = "cyan"

/obj/item/map/oread_map
	name = "\improper 空白地图" // name = "\improper Oread Garrison map"
	desc = "一张失真的奥瑞亚德驻军基地轨道扫描图。"
	html_link = ""
	color = "cyan"

GLOBAL_LIST_INIT_TYPED(map_type_list, /obj/item/map, setup_all_maps())

/proc/setup_all_maps()
	return list(
		MAP_LV_624 = new /obj/item/map/lazarus_landing_map(),
		MAP_LV_624_REPAIRED = new /obj/item/map/lazarus_landing_map(),
		MAP_ICE_COLONY = new /obj/item/map/ice_colony_map(),
		MAP_ICE_COLONY_V1 = new /obj/item/map/ice_colony_map/v1(),
		MAP_ICE_COLONY_V2 = new /obj/item/map/ice_colony_map/v2(),
		MAP_ICE_COLONY_V3 = new /obj/item/map/ice_colony_map_v3(),
		MAP_WHISKEY_OUTPOST = new /obj/item/map/whiskey_outpost_map(),
		MAP_BIG_RED = new /obj/item/map/big_red_map(),
		MAP_PRISON_STATION = new /obj/item/map/FOP_map(),
		MAP_PRISON_STATION_V3 = new /obj/item/map/FOP_map_v3(),
		MAP_DESERT_DAM = new /obj/item/map/desert_dam(),
		MAP_SOROKYNE_STRATA = new /obj/item/map/sorokyne_map(),
		MAP_CORSAT = new /obj/item/map/corsat(),
		MAP_KUTJEVO = new /obj/item/map/kutjevo_map(),
		MAP_LV522_CHANCES_CLAIM = new /obj/item/map/lv522_map(),
		MAP_LV522_CHANCES_CLAIM_FORECON = new /obj/item/map/lv522_map(),
		MAP_NEW_VARADERO = new /obj/item/map/new_varadero(),
		MAP_NEW_VARADERO_REPAIRED = new /obj/item/map/new_varadero(),
		MAP_DERELICT_ALMAYER = new /obj/item/map/almayer(),
		MAP_LV295_BLACKSITE = new /obj/item/map/lv522_map(),
		MAP_SI391_SEKHMET = new /obj/item/map/lazarus_landing_map(),
		MAP_BMG290_OTOGI_EGRESS_POINT = new /obj/item/map/new_varadero(),
		MAP_CANYON_32B = new /obj/item/map/canyon_32b(),
		MAP_BOSENMORI_BASHO = new /obj/item/map/lazarus_landing_map(),
		MAP_BIG_BLUE = new/obj/item/map/big_red_map(),
		MAP_CALLIOPE_HIGHWAY = new /obj/item/map/big_red_map(),
		MAP_CALLIOPE_DESERT_BUS = new /obj/item/map/big_red_map(),
		MAP_OREAD_GARRISON = new /obj/item/map/oread_map(),
		MAP_TAIPEI = new /obj/item/map/taipei(),
		MAP_REDEMPTION_VALLEY = new /obj/item/map/lazarus_landing_map(),
		MAP_BINHAI_SUPPLY_STATION = new /obj/item/map/FOP_map(),
	)

//used by marine equipment machines to spawn the correct map.
/obj/item/map/current_map

/obj/item/map/current_map/Initialize(mapload, ...)
	. = ..()

	var/map_name = SSmapping.configs[GROUND_MAP].map_name
	var/obj/item/map/map = GLOB.map_type_list[map_name]
	if (!map && (map_name in GLOB.mapless_maps))
		return // "Maps" we don't have maps for so we don't need to throw a runtime for (namely in unit_testing)
	name = map.name
	desc = map.desc
	desc_lore = map.desc_lore
	html_link = map.html_link
	color = map.color

// Landmark - Used for mapping. Will spawn the appropriate map for each gamemode (LV map items will spawn when LV is the gamemode, etc)
/obj/effect/landmark/map_item
	name = "地图物品"
	icon_state = "ipool"

/obj/effect/landmark/map_item/Initialize(mapload, ...)
	. = ..()
	GLOB.map_items += src

/obj/effect/landmark/map_item/Destroy()
	GLOB.map_items -= src
	return ..()

// Tac-map showing map, for those groundmaps which haven't got a proper map(item) made
/obj/item/tacmap_map
	name = "\improper 卫星扫描平板"
	desc = "显示当地作战区域轨道扫描图的手持电子设备。"
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "maptablet"
	item_state = "Cotablet"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/datum/tacmap/map
	///flags that we want to be shown when you interact with this table
	var/minimap_type = MINIMAP_FLAG_USCM
	///The faction that is intended to use this structure (determines type of tacmap used)
	var/faction = FACTION_MARINE

/obj/item/tacmap_map/Initialize(mapload, ...)
	. = ..()
	map = new(src, minimap_type)

/obj/item/tacmap_map/attack_self(mob/user) //Open the map
	..()
	user.visible_message(SPAN_NOTICE("[user]仔细查看了[src]。"))
	map.tgui_interact(user)

/obj/item/tacmap_map/attack(mob/attacked_mob, mob/user)
	. = ..()

	if(attacked_mob == user)
		return

	if(ishuman(attacked_mob))
		user.visible_message(SPAN_NOTICE("[user]向[attacked_mob]展示了[src]。"),SPAN_NOTICE("你向[attacked_mob]展示了[src]的屏幕。"))
		to_chat(attacked_mob, SPAN_NOTICE("[user]向你展示了[src]的屏幕。"))
		map.tgui_interact(attacked_mob)
		return

/obj/item/tacmap_map/Destroy()
	QDEL_NULL(map)
	return ..()
