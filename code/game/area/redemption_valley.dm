//====================================================================================================Redemption Valley AREAS
//BASE
/area/redemptionvalley
	name = "救赎谷"
	icon_state = "lv-626"
	can_build_special = TRUE
	minimap_color = MINIMAP_AREA_COLONY
//=============================================================================================PARENT
/area/redemptionvalley/valley
	name = "室外"
	ceiling = CEILING_NONE
	powernet_name = "outpost"
/area/redemptionvalley/valleyroof
	name = "遮蔽区"
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	powernet_name = "settlement"
/area/redemptionvalley/caverns
	name = "洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	base_muffle = MUFFLE_HIGH
/area/redemptionvalley/outpost
	name = "救赎哨站"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	powernet_name = "outpost"
/area/redemptionvalley/oob
	name = "OOB"
	ceiling = CEILING_NO_PROTECTION
	minimap_color = MINIMAP_SOLID
//===============================================================================SHUTTLES
/area/redemptionvalley/shuttles/drop1
	name = "救赎谷 - 补给停机坪"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	powernet_name = "settlement"
/area/redemptionvalley/shuttles/drop2
	name = "军事基地 - 崖顶停机坪"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS
	powernet_name = "outpost"
//=============================================================================================VALLEY
/area/redemptionvalley/valley/proper
	name = "救赎谷主干道"
	icon_state = "south"
	powernet_name = "settlement"
/area/redemptionvalley/valley/checkpoint
	name = "救赎谷检查站"
	icon_state = "central"
/area/redemptionvalley/valley/Westbound
	name = "救赎谷西向道路"
	icon_state = "west"
/area/redemptionvalley/valley/cliff
	name = "救赎谷 - 崖顶"
	icon_state = "north"
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS
//=============================================================================================VALLEY ROOF
/area/redemptionvalley/valleyroof/store
	name = "救赎谷 - 商店"
	icon_state = "quart"
/area/redemptionvalley/valleyroof/security
	name = "救赎谷 - 安保办公室"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC
/area/redemptionvalley/valleyroof/medical
	name = "救赎谷 - 医疗区"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY
/area/redemptionvalley/valleyroof/admin
	name = "救赎谷 - 场地行政区"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_COMMAND
/area/redemptionvalley/valleyroof/server
	name = "救赎谷 - 场地服务器室"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE
/area/redemptionvalley/valleyroof/cafe
	name = "救赎谷 - 咖啡馆"
	icon_state = "cafeteria"
/area/redemptionvalley/valleyroof/laundro
	name = "救赎谷 - 自助洗衣店"
	icon_state = "janitor"
/area/redemptionvalley/valleyroof/engi
	name = "救赎谷 - 工程区"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI
/area/redemptionvalley/valleyroof/company
	name = "救赎谷 - 公司住宅区"
	icon_state = "purple"
/area/redemptionvalley/valleyroof/hydro
	name = "救赎谷 - 水培区"
	icon_state = "hydro"
/area/redemptionvalley/valleyroof/storage
	name = "救赎谷 - 舱体仓库"
	icon_state = "storage"
/area/redemptionvalley/valleyroof/houseone
	name = "救赎谷 - 一号住宅"
	icon_state = "green"
/area/redemptionvalley/valleyroof/housetwo
	name = "救赎谷 - 二号住宅"
	icon_state = "green"
/area/redemptionvalley/valleyroof/housethree
	name = "救赎谷 - 三号住宅"
	icon_state = "green"
/area/redemptionvalley/valleyroof/housefour
	name = "救赎谷 - 四号住宅"
	icon_state = "green"
/area/redemptionvalley/valleyroof/housefive
	name = "救赎谷 - 五号住宅"
	icon_state = "green"
/area/redemptionvalley/valleyroof/housesix
	name = "救赎谷 - 六号住宅"
	icon_state = "green"
/area/redemptionvalley/valleyroof/cliffcomms
	name = "崖顶 - 通讯区"
	icon_state = "yellow"
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS
	powernet_name = "outpost"
//=============================================================================================CAVERNS
/area/redemptionvalley/caverns/north
	name = "救赎谷 - 上层洞穴"
	icon_state = "cave"
	minimap_color = MINIMAP_SOLID
/area/redemptionvalley/caverns/east
	name = "救赎谷 - 山谷洞穴"
	icon_state = "cave"
	minimap_color = MINIMAP_SOLID
/area/redemptionvalley/caverns/bunker
	name = "救赎谷 - 地堡洞穴"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	icon_state = "cave"
/area/redemptionvalley/caverns/lake
	name = "救赎谷 - 湖泊洞穴"
	icon_state = "cave"
	minimap_color = MINIMAP_SOLID
/area/redemptionvalley/caverns/entry
	name = "救赎谷 - 中央洞穴"
	icon_state = "cave"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
/area/redemptionvalley/caverns/west
	name = "救赎谷 - 下层洞穴"
	icon_state = "cave"
	minimap_color = MINIMAP_SOLID
/area/redemptionvalley/caverns/ruin
	name = "山谷遗迹"
	icon_state = "cave"
//=============================================================================================OUTPOST
/area/redemptionvalley/outpost/elevup
	name = "军事基地 - 电梯上层"
	icon_state = "away3"
	soundscape_playlist = SCAPE_PL_LV522_INDOORS
/area/redemptionvalley/outpost/flight
	name = "军事基地 - 飞行控制区"
	icon_state = "purple"
	soundscape_playlist = SCAPE_PL_LV522_INDOORS
/area/redemptionvalley/outpost/ops
	name = "军事基地 - 作战室"
	icon_state = "blue"
	soundscape_playlist = SCAPE_PL_LV522_INDOORS
	minimap_color = MINIMAP_AREA_COMMAND
/area/redemptionvalley/outpost/elevlow
	name = "军事基地 - 电梯下层"
	icon_state = "away2"
/area/redemptionvalley/outpost/bunkwest
	name = "军事基地 - 西侧地堡"
	icon_state = "red"
/area/redemptionvalley/outpost/bunkeast
	name = "军事基地 - 东侧地堡"
	icon_state = "red"
/area/redemptionvalley/outpost/cavestruct
	name = "军事基地 - 洞穴建筑"
	icon_state = "red"
/area/redemptionvalley/outpost/entry
	name = "军事基地 - 入口"
	icon_state = "away1"
/area/redemptionvalley/outpost/halls
	name = "军事基地 - 走廊"
	icon_state = "green"
/area/redemptionvalley/outpost/armory
	name = "军事基地 - 军械库"
	icon_state = "armory"
	minimap_color = MINIMAP_AREA_SEC
/area/redemptionvalley/outpost/barracks
	name = "军事基地 - 营房"
	icon_state = "yellow"
/area/redemptionvalley/outpost/canteen
	name = "军事基地 - 食堂"
	icon_state = "cafeteria"
/area/redemptionvalley/outpost/toilet
	name = "军事基地 - 卫生间"
	icon_state = "toilet"
/area/redemptionvalley/outpost/medical
	name = "军事基地 - 医疗区"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY
/area/redemptionvalley/outpost/brief
	name = "军事基地 - 简报大厅"
	icon_state = "blue"
/area/redemptionvalley/outpost/cells
	name = "军事基地 - 拘留室"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC_CAVE
/area/redemptionvalley/outpost/engi
	name = "军事基地 - 工程区"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	soundscape_playlist = SCAPE_PL_ENG
//=============================================================================================OOB
/area/redemptionvalley/oob/buttons
	name = "Out of Bounds"
	icon_state = "mech"
	requires_power = FALSE
