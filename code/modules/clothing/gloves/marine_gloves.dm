
/obj/item/clothing/gloves/marine
	name = "作战手套"
	desc = "一副黑色作战手套，既能绝缘，也能抵挡弹片。唯一的缺点就是一直戴着会让双手汗流不止。"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_HANDS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/gloves/marine/fingerless
	name = "露指作战手套"
	desc = "一副剪掉了指套的黑色作战手套。它不再绝缘，也无法完全抵挡弹片，但至少双手不会再一直汗津津的了。"
	icon_state = "black_fingerless"
	item_state = "black_fingerless"
	siemens_coefficient = 1
	permeability_coefficient = 1

/obj/item/clothing/gloves/marine/brown
	name = "作战手套"
	desc = "一副棕色作战手套，既能绝缘，也能抵挡弹片。唯一的缺点就是一直戴着会让双手汗流不止。"
	icon_state = "brown"
	item_state = "brown"

/obj/item/clothing/gloves/marine/brown/fingerless
	name = "露指作战手套"
	desc = "一副剪掉了指套的棕色作战手套。它不再绝缘，也无法完全抵挡弹片，但至少双手不会再一直汗津津的了。"
	icon_state = "brown_fingerless"
	item_state = "brown_fingerless"
	siemens_coefficient = 1
	permeability_coefficient = 1

/obj/item/clothing/gloves/marine/specialist
	name = "\improper B18 防护护手"
	desc = "一副重装甲手套。"
	icon_state = "black"
	item_state = "bgloves"
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/M3G
	name = "\improper M3-G4 掷弹兵手套"
	desc = "一副带有护甲板却依然灵活的手套。"
	icon_state = "grenadier"
	item_state = "grenadier"
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGH
	unacidable = TRUE
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE

/obj/item/clothing/gloves/marine/pve_mopp
	name = "\improper M2 MOPP 防护手套"
	desc = "M2 MOPP 防护手套，保护你免受神经毒气与致命化学物质的侵害。要是在接口上缠些胶带，你大概会更放心。"
	icon_state = "cbrn"
	item_state = "cbrn"

/obj/item/clothing/gloves/marine/veteran/pmc/commando
	name = "\improper M5X 护手"
	desc = "一副为 M5X 外骨骼装甲配套制作的重装甲手套。"
	icon_state = "gauntlets"
	item_state = "bgloves"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_rad = CLOTHING_ARMOR_ULTRAHIGH
	armor_internaldamage = CLOTHING_ARMOR_ULTRAHIGH
	unacidable = TRUE

/obj/item/clothing/gloves/marine/dress
	name = "礼服手套"
	desc = "一副时尚的白色手套，由穿礼服的陆战队员佩戴。"
	icon_state = "white"
	item_state = "marine_white"

/obj/item/clothing/gloves/marine/veteran/souto
	name = "\improper 索托侠手套"
	desc = "索托侠佩戴的手套，抓握力比樱桃味索托的味道还强劲！"
	icon_state = "souto_man"
	item_state = "souto_man"
	flags_inventory = CANTSTRIP
	armor_melee = CLOTHING_ARMOR_HARDCORE
	armor_bullet = CLOTHING_ARMOR_HARDCORE
	armor_laser = CLOTHING_ARMOR_HARDCORE
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_bomb = CLOTHING_ARMOR_HARDCORE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	unacidable = TRUE

/obj/item/clothing/gloves/marine/veteran/insulated/van_bandolier
	name = "定制射击手套"
	desc = "能有效防护损伤、高低温和电击。冬暖夏凉，在任何表面都能稳稳抓牢。买它的钱能买不少东西，但它绝对物有所值。"

/obj/item/clothing/gloves/marine/joe
	name = "西格森危险品防护手套"
	desc = "为接触和操作极度危险的物质而制造的合成人专用手套，可抵御生物危害液体、腐蚀性材料等。手背醒目地印着西格森标识与生物危害符号。携手共创明天。"
	icon_state = "working_joe"
	item_state = "working_joe"
	siemens_coefficient = 0
	armor_melee = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_VERYHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	unacidable = TRUE

/obj/item/clothing/gloves/marine/veteran/cbrn
	name = "\improper M3 MOPP 防护手套"
	desc = "M3 MOPP 防护手套采用经过处理的文拉尔纤维制成，旨在保护核生化环境中作业者的双手免遭污染。设计特别注重手部灵活性，使佩戴者能够完整保养步枪或使用大多数手持工具，指部的环形防滑纹则可增强抓握力。标准核生化规程规定，手套接触中等程度污染后，最佳防护效力约可维持二十四小时，之后建议丢弃并更换。"
	icon_state = "cbrn"
	item_state = "cbrn"
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
