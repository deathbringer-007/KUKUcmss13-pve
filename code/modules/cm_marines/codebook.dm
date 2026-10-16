GLOBAL_LIST_EMPTY(codebook_data)

/obj/item/book/codebook/proc/create_codebook(faction = FACTION_MARINE)
	if(!GLOB.codebook_data[faction])
		GLOB.codebook_data[faction] = generate_code()

	dat = GLOB.codebook_data[faction]

/obj/item/book/codebook/proc/generate_code()
	var/number
	var/letter
	var/code_data = "<table><tr><th>问令</th><th>答令<th></tr>"
	for(var/i in 1 to 10)
		letter = pick(GLOB.greek_letters)
		number = rand(100,999)
		code_data += "<tr><td>[letter]-[number]</td>"
		letter = pick(GLOB.greek_letters)
		number = rand(100,999)
		code_data += "<td>[letter]-[number]</td></tr>"
	code_data += "</table>"
	return code_data

/obj/item/book/codebook
	name = "阿尔迈耶号口令簿"
	author = "美国殖民地海军陆战队"
	unique = 1
	dat = ""
	var/faction = FACTION_MARINE

/obj/item/book/codebook/Initialize()
	. = ..()
	title = name
	create_codebook(faction)

/obj/item/book/codebook/clf
	name = "解放阵线身份验证口令簿"
	faction = FACTION_CLF
	author = "【墨迹模糊】"

/obj/item/book/codebook/twe
	name = "帝国身份验证口令簿"
	faction = FACTION_TWE
	author = "皇家海军陆战队"

/obj/item/book/codebook/upp
	name = "联盟身份验证口令簿"
	faction = FACTION_UPP
	author = "人民军"

/obj/item/book/codebook/wey_yu
	name = "公司身份验证口令簿"
	faction = FACTION_WY
	author = "维兰德-汤谷通信部门"

/obj/item/book/codebook/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/tool/kitchen/knife) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		return
	..()
