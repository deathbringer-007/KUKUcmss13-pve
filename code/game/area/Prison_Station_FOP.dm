//Base Instance
/area/prison
	name = "菲奥里纳轨道监狱主监区"
	ceiling = CEILING_GLASS
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_COLONY

//SECURITY
/area/prison/security
	name = "\improper 安保部"
	icon_state = "security"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_SEC

/area/prison/security/briefing
	name = "\improper 简报室"
	icon_state = "brig"

/area/prison/security/head
	name = "\improper 安保主管办公室"
	icon_state = "sec_hos"

/area/prison/security/armory/riot
	name = "\improper 防暴军械库"
	icon_state = "armory"

/area/prison/security/armory/lethal
	name = "\improper 致命武器库"
	icon_state = "Tactical"

/area/prison/security/armory/highsec_monitoring
	name = "\improper 高戒备监控区军械库"
	icon_state = "security_sub"

/area/prison/security/monitoring
	icon_state = "sec_prison"
	is_resin_allowed = TRUE

/area/prison/security/monitoring/lowsec/ne
	name = "\improper 东北低戒备监控区"

/area/prison/security/monitoring/lowsec/sw
	name = "\improper 西南低戒备监控区"

/area/prison/security/monitoring/medsec/south
	name = "\improper 中戒备监控区"
	ceiling = CEILING_GLASS

/area/prison/security/monitoring/medsec/central
	name = "\improper 中央中戒备监控区"

/area/prison/security/monitoring/highsec
	name = "\improper 高戒备监控区"

/area/prison/security/monitoring/maxsec
	name = "\improper 最高戒备监控区"

/area/prison/security/monitoring/maxsec/panopticon
	name = "\improper 全景敞视监控区"

/area/prison/security/monitoring/protective
	name = "\improper 保护性羁押监控区"

/area/prison/security/checkpoint
	icon_state = "checkpoint1"
	is_resin_allowed = TRUE

/area/prison/security/checkpoint/medsec
	name = "\improper 中戒备检查站"

/area/prison/security/checkpoint/highsec/n
	name = "\improper 北部高戒备检查站"

/area/prison/security/checkpoint/highsec/s
	name = "\improper 南部高戒备检查站"

/area/prison/security/checkpoint/vip
	name = "\improper 贵宾区检查站"

/area/prison/security/checkpoint/maxsec
	name = "\improper 最高戒备检查站"

/area/prison/security/checkpoint/highsec_medsec
	name = "\improper 高戒备至中戒备检查站"

/area/prison/security/checkpoint/maxsec_highsec
	name = "\improper 最高戒备至高戒备检查站"

/area/prison/security/checkpoint/hangar
	name = "\improper 主机库交通控制室"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/prison/storage
	icon_state = "engine_storage"

/area/prison/storage/medsec
	name = "\improper 中戒备储藏室"

/area/prison/storage/highsec/n
	name = "\improper 北部高戒备储藏室"

/area/prison/storage/highsec/s
	name = "\improper 南部高戒备储藏室"

/area/prison/storage/vip
	name = "\improper 贵宾区储藏室"

/area/prison/recreation
	icon_state = "party"

/area/prison/recreation/staff
	name = "\improper 员工休闲区"

/area/prison/recreation/medsec
	name = "\improper 中戒备休闲区"

/area/prison/recreation/highsec/n
	name = "\improper 北部高戒备休闲区"

/area/prison/recreation/highsec/s
	name = "\improper 南部高戒备休闲区"

/area/prison/execution
	name = "\improper 行刑室"
	icon_state = "dark"

/area/prison/store
	name = "\improper 监狱商店"
	icon_state = "bar"

/area/prison/chapel
	name = "\improper 礼拜堂"
	icon_state = "chapel"

/area/prison/holding/holding1
	name = "\improper 1号拘留室"
	icon_state = "blue-red2"
	minimap_color = MINIMAP_AREA_SEC

/area/prison/holding/holding2
	name = "\improper 2号拘留室"
	icon_state = "blue-red-d"
	minimap_color = MINIMAP_AREA_SEC

/area/prison/cleaning
	name = "\improper 清洁用品间"
	icon_state = "janitor"

/area/prison/command/office
	name = "\improper 监狱长办公室"
	icon_state = "Warden"

/area/prison/command/secretary_office
	name = "\improper 监狱长秘书办公室"
	icon_state = "blue"

/area/prison/command/quarters
	name = "\improper 监狱长宿舍"
	icon_state = "party"

/area/prison/toilet
	icon_state = "restrooms"

/area/prison/toilet/canteen
	name = "\improper 食堂卫生间"

/area/prison/toilet/security
	name = "\improper 安保部卫生间"
	is_resin_allowed = FALSE

/area/prison/toilet/research
	name = "\improper 科研区卫生间"

/area/prison/toilet/staff
	name = "\improper 员工卫生间"

/area/prison/maintenance
	icon_state = "asmaint"

/area/prison/maintenance/residential

/area/prison/maintenance/residential/nw
	name = "\improper 平民居住区西北维护区"

/area/prison/maintenance/residential/ne
	name = "\improper 平民居住区东北维护区"

/area/prison/maintenance/residential/sw
	name = "\improper 平民居住区西南维护区"

/area/prison/maintenance/residential/se
	name = "\improper 平民居住区东南维护区"

/area/prison/maintenance/residential/access/north
	name = "\improper 平民居住区北通道"

/area/prison/maintenance/residential/access/south
	name = "\improper 平民居住区南通道"

/area/prison/maintenance/staff_research
	name = "\improper 员工区至科研区维护通道"
	icon_state = "maint_research_starboard"
	is_resin_allowed = FALSE

/area/prison/maintenance/research_medbay
	name = "\improper 科研区至医务室维护通道"
	icon_state = "maint_research_port"

/area/prison/maintenance/hangar_barracks
	name = "\improper 机库至兵营维护通道"
	icon_state = "maint_e_shuttle"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/prison/canteen
	name = "\improper 食堂"
	icon_state = "cafeteria"

/area/prison/kitchen
	name = "\improper 厨房"
	icon_state = "kitchen"

/area/prison/laundry
	name = "\improper 洗衣房"
	icon_state = "bluenew"

/area/prison/library
	name = "\improper 图书馆"
	icon_state = "green"

/area/prison/engineering
	name = "\improper 工程部"
	icon_state = "engine"
	minimap_color = MINIMAP_AREA_ENGI

/area/prison/engineering/atmos
	name = "\improper 大气控制室"
	icon_state = "atmos"

/area/prison/intake
	name = "\improper 入监登记区"
	icon_state = "green"

/area/prison/parole/main
	name = "\improper 假释区"
	icon_state = "blue2"

/area/prison/parole/protective_custody
	name = "\improper 保护性羁押假释区"
	icon_state = "red2"

/area/prison/visitation
	name = "\improper 探视区"
	icon_state = "yellow"

/area/prison/yard
	name = "\improper 放风区"
	icon_state = "thunder"

/area/prison/hallway/entrance
	name = "\improper 入口走廊"
	icon_state = "entry"
	is_resin_allowed = FALSE

/area/prison/hallway/central
	name = "\improper 中央环廊"
	icon_state = "hallC1"

/area/prison/hallway/central/east
	name = "\improper 中央环廊东段"

/area/prison/hallway/central/north
	name = "\improper 中央环廊北段"

/area/prison/hallway/central/south
	name = "\improper 中央环廊南段"

/area/prison/hallway/central/west
	name = "\improper 中央环廊西段"

/area/prison/hallway/east
	name = "\improper 东走廊"
	icon_state = "east"

/area/prison/hallway/staff
	name = "\improper 员工走廊"
	icon_state = "hallS"

/area/prison/hallway/engineering
	name = "\improper 工程部走廊"
	icon_state = "dk_yellow"
	minimap_color = MINIMAP_AREA_ENGI

/area/prison/quarters/staff
	name = "\improper 员工宿舍"
	icon_state = "crew_quarters"

/area/prison/quarters/security
	name = "\improper 安保兵营"
	icon_state = "sec_backroom"

/area/prison/quarters/research
	name = "\improper 研究员宿舍"
	icon_state = "purple"
	minimap_color = MINIMAP_AREA_SEC

/area/prison/cellblock/lowsec
	minimap_color = MINIMAP_AREA_CELL_LOW

/area/prison/cellblock/lowsec/nw
	name = "\improper 西北低戒备监区"
	icon_state = "cells_low_nw"

/area/prison/cellblock/lowsec/ne
	name = "\improper 东北低戒备监区"
	icon_state = "cells_low_ne"

/area/prison/cellblock/lowsec/sw
	name = "\improper 西南低戒备监区"
	icon_state = "cells_low_sw"

/area/prison/cellblock/lowsec/se
	name = "\improper 东南低戒备监区"
	icon_state = "cells_low_se"

/area/prison/cellblock/mediumsec
	name = "\improper 中戒备监区"
	icon_state = "cells_med"
	minimap_color = MINIMAP_AREA_CELL_MED

/area/prison/cellblock/mediumsec/north
	name = "\improper 中戒备监区北部"
	icon_state = "cells_med_n"

/area/prison/cellblock/mediumsec/south
	name = "\improper 中戒备监区南部"
	icon_state = "cells_med_s"

/area/prison/cellblock/mediumsec/east
	name = "\improper 中戒备监区东部"
	icon_state = "cells_med_e"

/area/prison/cellblock/mediumsec/west
	name = "\improper 中戒备监区西部"
	icon_state = "cells_med_w"

/area/prison/cellblock/highsec
	minimap_color = MINIMAP_AREA_CELL_HIGH

/area/prison/cellblock/highsec/north/north
	name = "\improper 北部高戒备监区北段"
	icon_state = "cells_high_nn"

/area/prison/cellblock/highsec/north/south
	name = "\improper 北部高戒备监区南段"
	icon_state = "cells_high_ns"

/area/prison/cellblock/highsec/south/north
	name = "\improper 南部高戒备监区北段"
	icon_state = "cells_high_sn"

/area/prison/cellblock/highsec/south/south
	name = "\improper 南部高戒备监区南段"
	icon_state = "cells_high_ss"

/area/prison/cellblock/maxsec
	minimap_color = MINIMAP_AREA_CELL_MAX

/area/prison/cellblock/maxsec/north
	name = "\improper 最高戒备全景敞视监区"
	icon_state = "cells_max_n"

/area/prison/cellblock/maxsec/south
	name = "\improper 最高戒备悬吊监区"
	icon_state = "cells_max_s"

/area/prison/cellblock/vip
	name = "\improper 贵宾牢房"
	icon_state = "cells_vip"
	minimap_color = MINIMAP_AREA_CELL_VIP

/area/prison/cellblock/protective
	name = "\improper 保护性羁押区"
	icon_state = "cells_protective"
	minimap_color = MINIMAP_AREA_CELL_VIP

/area/prison/disposal
	name = "\improper 废物处理区"
	icon_state = "disposal"

/area/prison/medbay
	name = "\improper 医务室"
	icon_state = "medbay"

/area/prison/medbay/foyer
	name = "\improper 医务室门厅"
	icon_state = "medbay2"

/area/prison/medbay/surgery
	name = "\improper 手术室"
	icon_state = "medbay3"

/area/prison/medbay/morgue
	name = "\improper 停尸房"
	icon_state = "morgue"

/area/prison/research
	name = "\improper 生物研究部"
	icon_state = "research"
	is_resin_allowed = FALSE

/area/prison/research/RD
	name = "\improper 研究主管办公室"
	icon_state = "disposal"
	is_resin_allowed = FALSE

/area/prison/research/secret
	name = "\improper 机密研究区"
	icon_state = "toxlab"
	is_resin_allowed = TRUE

/area/prison/research/secret/dissection
	name = "\improper 解剖室"
	icon_state = "toxmix"

/area/prison/research/secret/chemistry
	name = "\improper 化学区"
	icon_state = "chem"

/area/prison/research/secret/bioengineering
	name = "\improper 生物工程区"
	icon_state = "toxmisc"

/area/prison/research/secret/containment
	name = "\improper 实验对象收容区"
	icon_state = "xeno_f_store"

/area/prison/research/secret/testing
	name = "\improper 生物实验区"
	icon_state = "toxtest"

/area/prison/residential/central
	name = "\improper 平民居住区中央"
	icon_state = "blue-red2"

/area/prison/residential/north
	name = "\improper 平民居住区北部"
	icon_state = "blue2"

/area/prison/residential/south
	name = "\improper 平民居住区南部"
	icon_state = "red2"

/area/prison/monorail
	icon_state = "purple"

/area/prison/monorail/east
	name = "\improper 东部单轨车站"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/prison/monorail/west
	name = "\improper 西部单轨车站"

/area/prison/hanger
	is_resin_allowed = FALSE

/area/prison/hanger/main
	name = "\improper 主机库"
	icon_state = "hangar_alpha"
	is_landing_zone = TRUE

/area/prison/hanger/research
	name = "\improper 科研机库"
	icon_state = "hangar_beta"
	is_landing_zone = TRUE

/area/prison/hangar_storage/main
	name = "\improper 主机库储藏室"
	icon_state = "quartstorage"

/area/prison/hangar_storage/research
	name = "\improper 科研机库储藏室"
	icon_state = "toxstorage"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/prison/hangar_storage/research/shuttle
	name = "公司穿梭机"
	is_landing_zone = FALSE

/area/prison/telecomms
	name = "\improper 电信室"
	icon_state = "tcomsatcham"
	is_resin_allowed = FALSE

/area/prison/pirate
	name = "不定期货船“罗西南特号”"
	icon_state = "syndie-ship"
	requires_power = 0

/area/prison/secret
	name = "\improper 秘密房间"
	icon_state = "tcomsatcham"

/area/prison/landing/console
	name = "\improper 1号着陆区“行政部”"
	icon_state = "tcomsatcham"
	requires_power = 0

/area/prison/landing/console2
	name = "\improper 2号着陆区“科研”"
	icon_state = "tcomsatcham"
	requires_power = 0

/area/prison/landing/console3
	name = "\improper 1号着陆区“平民区”"
	icon_state = "tcomsatcham"
	requires_power = 0
