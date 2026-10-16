/obj/item/device/encryptionkey
	name = "标准加密密钥"
	desc = "无线电耳机使用的加密密钥。"
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = SIZE_TINY
	var/translate_apollo = FALSE
	var/translate_hive = FALSE
	var/list/channels = list()
	var/list/tracking_options
	var/abstract = FALSE

/obj/item/device/encryptionkey/Initialize(mapload, ...)
	. = ..()

	RegisterSignal(SSdcs, COMSIG_GLOB_PLATOON_NAME_CHANGE, PROC_REF(rename_platoon))

	if(!isnull(channels[SQUAD_MARINE_1]) && SQUAD_MARINE_1 != GLOB.main_platoon_name)
		rename_platoon(null, GLOB.main_platoon_name, SQUAD_MARINE_1)

/obj/item/device/encryptionkey/proc/rename_platoon(datum/source, new_name, old_name)
	SIGNAL_HANDLER

	var/toggled_channel = channels[old_name]

	if(isnull(toggled_channel))
		return

	channels -= old_name

	channels[new_name] = toggled_channel

	if(!istype(loc, /obj/item/device/radio/headset))
		return

	var/obj/item/device/radio/headset/current_headset = loc
	var/datum/radio_frequency/old_connections = current_headset.secure_radio_connections[old_name]
	if(!old_connections)
		return

	var/passed_freq = old_connections.frequency
	current_headset.secure_radio_connections -= old_name

	SSradio.remove_object(current_headset, passed_freq)

	current_headset.recalculateChannels()

/obj/item/device/encryptionkey/binary
	icon_state = "binary_key"
	translate_apollo = TRUE

/obj/item/device/encryptionkey/public
	name = "公共频道无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_ALMAYER = TRUE)
	abstract = TRUE

/obj/item/device/encryptionkey/colony
	name = "殖民地无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_COLONY= TRUE)

// MARINE ONE CHANNEL

/obj/item/device/encryptionkey/command
	name = "指挥频道加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE)

/obj/item/device/encryptionkey/jtac
	name = "\improper JTAC 无线电加密密钥"
	icon_state = "jtac_key"
	channels = list(RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_REQ = TRUE)

/obj/item/device/encryptionkey/intel
	name = "\improper 情报频道无线电加密密钥"
	icon_state = "jtac_key"
	channels = list(RADIO_CHANNEL_INTEL = TRUE)

//MARINE ENCRYPTION KEYS

/obj/item/device/encryptionkey/ai_integrated
	name = "AI 集成加密密钥"
	desc = "集成式加密密钥。"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_ALMAYER = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/sentry_laptop
	name = "哨戒炮网络状态加密密钥"
	desc = "自动广播哨戒炮状态更新的频道。"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_SENTRY = TRUE)

// MARINE COMMAND

/obj/item/device/encryptionkey/cmpcom/cdrcom
	name = "\improper 陆战队高级指挥无线电加密密钥"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/mcom
	name = "\improper 陆战队指挥无线电加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_SENTRY = TRUE)

/obj/item/device/encryptionkey/mcom/alt
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_SENTRY = TRUE)

// MARINE ENGINEERING

/obj/item/device/encryptionkey/ce
	name = "总工程师加密密钥"
	icon_state = "ce_key"
	channels = list(RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/engi
	name = "工程频道无线电加密密钥"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_ENGI = TRUE)

// MARINE MEDICAL

/obj/item/device/encryptionkey/cmo
	name = "首席医疗官加密密钥"
	icon_state = "cmo_key"
	channels = list(RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_INTEL = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE)

/obj/item/device/encryptionkey/med
	name = "医疗频道无线电加密密钥"
	icon_state = "med_key"
	channels = list(RADIO_CHANNEL_MEDSCI = TRUE)

/obj/item/device/encryptionkey/medres
	name = "科研频道无线电加密密钥"
	icon_state = "med_key"
	channels = list(RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_INTEL = TRUE)

// MARINE MILITARY POLICE

/obj/item/device/encryptionkey/cmpcom
	name = "\improper 陆战队宪兵长无线电加密密钥"
	icon_state = "cmp_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/mmpo
	name = "\improper 宪兵无线电加密密钥"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE,)

/obj/item/device/encryptionkey/sec
	name = "安保频道无线电加密密钥"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_MP = TRUE)

// MARINE REQUISTIONS

/obj/item/device/encryptionkey/qm
	name = "军需官加密密钥"
	icon_state = "ce_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = FALSE, RADIO_CHANNEL_MEDSCI = FALSE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/req/ct
	name = "补给频道无线电加密密钥"
	icon_state = "req_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_COMMAND = FALSE, RADIO_CHANNEL_ENGI = FALSE)

/obj/item/device/encryptionkey/req
	name = "补给频道无线电加密密钥"
	icon_state = "req_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE)

// MARINE SUPPORT

/obj/item/device/encryptionkey/cmpcom/synth
	name = "\improper 陆战队合成人无线电加密密钥"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/mcom/cl
	name = "\improper 公司代表无线电加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_WY = TRUE)

/obj/item/device/encryptionkey/mcom/rep
	name = "\improper 代表无线电加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ALMAYER = TRUE)

/obj/item/device/encryptionkey/po
	name = "\improper 陆战队飞行官无线电加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/io
	name = "\improper 陆战队情报官无线电加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_ALMAYER = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/vc
	name = "\improper 陆战队载具乘员无线电加密密钥"
	icon_state = "cap_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE)

/obj/item/device/encryptionkey/req/mst
	name = "补给频道无线电加密密钥"
	icon_state = "req_key"
	channels = list(RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_COMMAND = FALSE)

/obj/item/device/encryptionkey/mcom/ai //AI only.
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = TRUE, SQUAD_MARINE_2 = TRUE, SQUAD_MARINE_3 = TRUE, SQUAD_MARINE_4 = TRUE, SQUAD_MARINE_5 = TRUE, SQUAD_MARINE_CRYO = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE)

// MARINE SQUADS

/obj/item/device/encryptionkey/squadlead
	name = "\improper 小队长无线电加密密钥"
	icon_state = "sl_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_JTAC = TRUE)

/obj/item/device/encryptionkey/squadlead/acting
	abstract = TRUE

/obj/item/device/encryptionkey/alpha
	name = "\improper 阿尔法小队无线电加密密钥"
	icon_state = "alpha_key"
	channels = list(SQUAD_MARINE_1 = TRUE)

/obj/item/device/encryptionkey/bravo
	name = "\improper 布拉沃小队无线电加密密钥"
	icon_state = "bravo_key"
	channels = list(SQUAD_MARINE_2 = TRUE)

/obj/item/device/encryptionkey/charlie
	name = "\improper 查理小队无线电加密密钥"
	icon_state = "charlie_key"
	channels = list(SQUAD_MARINE_3 = TRUE)

/obj/item/device/encryptionkey/delta
	name = "\improper 德尔塔小队无线电加密密钥"
	icon_state = "delta_key"
	channels = list(SQUAD_MARINE_4 = TRUE)

/obj/item/device/encryptionkey/echo
	name = "\improper 埃科小队无线电加密密钥"
	icon_state = "echo_key"
	channels = list(SQUAD_MARINE_5 = TRUE)

/obj/item/device/encryptionkey/cryo
	name = "\improper 福克斯特罗特小队无线电加密密钥"
	icon_state = "cryo_key"
	channels = list(SQUAD_MARINE_CRYO = TRUE)

/obj/item/device/encryptionkey/soc
	name = "\improper 特种部队无线电加密密钥"
	icon_state = "binary_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_JTAC = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE)

/obj/item/device/encryptionkey/soc/forecon
	name = "\improper 特种部队无线电加密密钥"
	icon_state = "binary_key"
	channels = list(SQUAD_SOF = TRUE)

//ERT, PMC

/obj/item/device/encryptionkey/dutch
	name = "\improper 达奇十二人组无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_DUTCH_DOZEN = TRUE)

//---------------------------------------------------
//Weyland-Yutani Keys

///For CL and their Marine goons
/obj/item/device/encryptionkey/WY
	name = "\improper 维兰德-汤谷加密密钥"
	icon_state = "wy_key"
	channels = list(RADIO_CHANNEL_WY = TRUE)
	tracking_options = list("Corporate Liaison" = TRACKER_CL)

/obj/item/device/encryptionkey/pmc
	name = "\improper 维兰德-汤谷私人军事承包商无线电加密密钥"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE)

/obj/item/device/encryptionkey/pmc/engi
	name = "\improper 维兰德-汤谷承包商工程无线电加密密钥"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE, RADIO_CHANNEL_PMC_ENGI = TRUE, RADIO_CHANNEL_PMC_CCT = TRUE)

/obj/item/device/encryptionkey/pmc/medic
	name = "\improper 维兰德-汤谷承包商医疗无线电加密密钥"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE, RADIO_CHANNEL_PMC_MED = TRUE)

/obj/item/device/encryptionkey/pmc/command
	name = "\improper 维兰德-汤谷承包商指挥无线电加密密钥"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_PMC_CMD = TRUE, RADIO_CHANNEL_PMC_GEN = TRUE, RADIO_CHANNEL_WY = TRUE, RADIO_CHANNEL_PMC_ENGI = TRUE, RADIO_CHANNEL_PMC_CCT = TRUE, RADIO_CHANNEL_PMC_MED = TRUE)

/obj/item/device/encryptionkey/commando
	name = "\improper 维兰德-汤谷突击队无线电加密密钥"
	icon_state = "pmc_key"
	channels = list(RADIO_CHANNEL_WY_WO = TRUE, RADIO_CHANNEL_WY = TRUE)

//---------------------------------------------------
//UPP Keys
/obj/item/device/encryptionkey/upp
	name = "\improper UPP 海军步兵无线电加密密钥"
	icon_state = "upp_key"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE)

/obj/item/device/encryptionkey/upp/territorial
	name = "\improper UPP 地方卫队无线电加密密钥"
	channels = list(RADIO_CHANNEL_UPP_GRD = TRUE)

/obj/item/device/encryptionkey/upp/engi
	name = "\improper UPP 工程无线电加密密钥"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_ENGI = TRUE, RADIO_CHANNEL_UPP_CCT = TRUE)

/obj/item/device/encryptionkey/upp/medic
	name = "\improper UPP 医疗无线电加密密钥"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_MED = TRUE)

/obj/item/device/encryptionkey/upp/kdo
	name = "\improper UPP 突击队无线电加密密钥"
	channels = list(RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_KDO = TRUE, RADIO_CHANNEL_UPP_CCT = TRUE)

/obj/item/device/encryptionkey/upp/command
	name = "\improper UPP 指挥无线电加密密钥"
	channels = list(RADIO_CHANNEL_UPP_CMD = TRUE, RADIO_CHANNEL_UPP_GEN = TRUE, RADIO_CHANNEL_UPP_ENGI = TRUE, RADIO_CHANNEL_UPP_MED = TRUE, RADIO_CHANNEL_UPP_CCT = TRUE)
//---------------------------------------------------
//CLF Keys
/obj/item/device/encryptionkey/clf
	name = "\improper 殖民地解放阵线无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_CLF_GEN = TRUE)

/obj/item/device/encryptionkey/clf/engi
	name = "\improper CLF 工程无线电加密密钥"
	channels = list(RADIO_CHANNEL_CLF_GEN = TRUE, RADIO_CHANNEL_CLF_ENGI = TRUE)

/obj/item/device/encryptionkey/clf/medic
	name = "\improper CLF 医疗无线电加密密钥"
	channels = list(RADIO_CHANNEL_CLF_GEN = TRUE, RADIO_CHANNEL_CLF_MED = TRUE)

/obj/item/device/encryptionkey/clf/command
	name = "\improper CLF 指挥无线电加密密钥"
	channels = list(RADIO_CHANNEL_CLF_CMD = TRUE, RADIO_CHANNEL_CLF_GEN = TRUE, RADIO_CHANNEL_CLF_ENGI = TRUE, RADIO_CHANNEL_CLF_MED = TRUE)
//---------------------------------------------------
/obj/item/device/encryptionkey/highcom
	name = "\improper USCM 高级指挥部无线电加密密钥"
	icon_state = "binary_key"
	channels = list(RADIO_CHANNEL_HIGHCOM = TRUE, SQUAD_SOF = TRUE, RADIO_CHANNEL_PROVOST = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = FALSE, RADIO_CHANNEL_JTAC = FALSE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/provost
	name = "\improper USCM 军法监察无线电加密密钥"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_PROVOST = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = FALSE, RADIO_CHANNEL_JTAC = FALSE, RADIO_CHANNEL_INTEL = TRUE)


/obj/item/device/encryptionkey/contractor
	name = "\improper 先锋之箭公司无线电加密密钥"
	icon_state = "sl_key"
	channels = list("Command" = TRUE, "Engi" = TRUE, "MedSci" = TRUE, "Req" = TRUE, "JTAC" = TRUE, "Intel" = TRUE, "Almayer" = TRUE)

/obj/item/device/encryptionkey/royal_marine
	name = "\improper 皇家陆战突击队无线电加密密钥"
	icon_state = "sl_key"
	channels = list("Command" = TRUE, "Almayer" = TRUE,)

/obj/item/device/encryptionkey/cia
	icon_state = "sl_key"
	channels = list(RADIO_CHANNEL_CIA = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MP = TRUE, SQUAD_MARINE_1 = FALSE, SQUAD_MARINE_2 = FALSE, SQUAD_MARINE_3 = FALSE, SQUAD_MARINE_4 = FALSE, SQUAD_MARINE_5 = FALSE, SQUAD_MARINE_CRYO = FALSE, SQUAD_SOF = FALSE, RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_REQ = TRUE, RADIO_CHANNEL_JTAC = FALSE, RADIO_CHANNEL_INTEL = TRUE)

/obj/item/device/encryptionkey/cmb
	name = "\improper 殖民地执法局无线电加密密钥"
	icon_state = "cmb_key"
	channels = list(RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_MEDSCI = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_ALMAYER = TRUE, RADIO_CHANNEL_COLONY = TRUE)
/// Used by the Mortar Crew in WO game mode - intently has no squad radio access
/obj/item/device/encryptionkey/mortar
	name = "\improper 迫击炮组无线电加密密钥"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_ENGI = TRUE, RADIO_CHANNEL_JTAC = TRUE, RADIO_CHANNEL_INTEL = TRUE, RADIO_CHANNEL_REQ = TRUE)

/obj/item/device/encryptionkey/usasf
	name = "\improper 美国航空航天军无线电加密密钥"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_USASF = TRUE, RADIO_CHANNEL_COLONY = TRUE)

/obj/item/device/encryptionkey/usasf/attache
	name = "\improper 美国航空航天军无线电加密密钥"
	icon_state = "eng_key"
	channels = list(RADIO_CHANNEL_USASF = TRUE, RADIO_CHANNEL_COLONY = TRUE, SQUAD_MARINE_1 = TRUE)

/obj/item/device/encryptionkey/usasf/command
	name = "\improper 美国航空航天军指挥无线电加密密钥"
	icon_state = "binary_key"
	channels = list(RADIO_CHANNEL_USASF = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_COLONY = TRUE, RADIO_CHANNEL_JTAC = TRUE)

/obj/item/device/encryptionkey/usasf/command/attache
	name = "\improper 美国航空航天军指挥无线电加密密钥"
	icon_state = "binary_key"
	channels = list(RADIO_CHANNEL_USASF = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_COLONY = TRUE, RADIO_CHANNEL_JTAC = TRUE, SQUAD_MARINE_1 = TRUE)

/obj/item/device/encryptionkey/army
	name = "\improper 美国陆军无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_US_ARMY = TRUE, RADIO_CHANNEL_COLONY = TRUE)

/obj/item/device/encryptionkey/army/attache
	name = "\improper 美国陆军无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_US_ARMY = TRUE, RADIO_CHANNEL_COLONY = TRUE, SQUAD_MARINE_1 = TRUE)

/obj/item/device/encryptionkey/army/command
	name = "\improper 美国陆军指挥无线电加密密钥"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_US_ARMY = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_COLONY = TRUE, RADIO_CHANNEL_JTAC = TRUE)

/obj/item/device/encryptionkey/army/command/attache
	name = "\improper 美国陆军指挥无线电加密密钥"
	icon_state = "sec_key"
	channels = list(RADIO_CHANNEL_US_ARMY = TRUE, RADIO_CHANNEL_COMMAND = TRUE, RADIO_CHANNEL_COLONY = TRUE, RADIO_CHANNEL_JTAC = TRUE, SQUAD_MARINE_1 = TRUE)

/obj/item/device/encryptionkey/guard
	name = "\improper 美洲联盟殖民地卫队无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_UA_GUARD = TRUE, RADIO_CHANNEL_COLONY = TRUE)

/obj/item/device/encryptionkey/merc
	name = "\improper 雇佣兵无线电加密密钥"
	icon_state = "stripped_key"
	channels = list(RADIO_CHANNEL_MERC = TRUE, RADIO_CHANNEL_COLONY = TRUE)
