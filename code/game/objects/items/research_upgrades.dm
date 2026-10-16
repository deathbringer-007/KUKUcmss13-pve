//prop items
/obj/item/oldresearch
	name = "异形器官"
	desc = "看着就让人想吐。"
	icon = 'icons/obj/items/Marine_Research.dmi'
	icon_state = "biomass"
	black_market_value = 50
	//For all of them for now, until we have specific organs/more techs

/obj/item/oldresearch/Resin
	name = "异形树脂"
	desc = "一块异形树脂。"
	icon_state = "biomass"


/obj/item/oldresearch/Chitin
	name = "几丁质块"
	desc = "一块异形几丁质。"
	icon_state = "chitin-chunk"


/obj/item/oldresearch/Blood
	name = "血液样本瓶"
	desc = "一份异形血液样本。"
	icon_state = "blood-vial"

//prop items end

//previously file holding left over stuff that never got finished from 8 years ago, it was boring though, so we change that.
/obj/item/research_upgrades
	name = "研究升级模块"
	desc = "不知道你是怎么拿到的，按理说你不该拥有这个。算你走运吧。"
	icon = 'icons/obj/items/disk.dmi'
	w_class = SIZE_TINY
	icon_state = "datadisk1" // doesnt HAVE to be a disk!
	///technology stored on this disk, goes through one to whatever levels of upgrades there are.
	var/value

// Upgrade for autodoc T1: Internal bleeding
/obj/item/research_upgrades/autodoc
	name = "研究升级模块（自动手术舱）"
	desc = "自动手术舱的研究升级模块。磁盘中的技术可用于缝合内出血部位。插入自动手术舱即可使用。"
	value = RESEARCH_UPGRADE_TIER_1

// Upgrade for autodoc T2: Broken bones
/obj/item/research_upgrades/autodoc/tier2
	desc = "自动手术舱的研究升级模块。磁盘中的技术可用于修复骨折。插入自动手术舱即可使用。"
	value = RESEARCH_UPGRADE_TIER_2

// Upgrade for autodoc T3: Internal organ damage
/obj/item/research_upgrades/autodoc/tier3
	desc = "自动手术舱的研究升级模块。磁盘中的技术可用于治疗内脏损伤。插入自动手术舱即可使用。"
	value = RESEARCH_UPGRADE_TIER_3

// Upgrade for autodoc T4: Larva removal
/obj/item/research_upgrades/autodoc/tier4
	desc = "自动手术舱的研究升级模块。磁盘中的技术可用于取出未知寄生虫。插入自动手术舱即可使用。"
	value = RESEARCH_UPGRADE_TIER_4

/obj/item/research_upgrades/sleeper
	name = "研究升级模块（医疗休眠舱）"
	desc = "医疗休眠舱系统的研究升级模块。磁盘中的技术可让医疗休眠舱使用更多种类的药物。"


/obj/item/research_upgrades/credits
	name =	"研究市场（科研点数）"
	var/credit_value = 8

/obj/item/research_upgrades/credits/Initialize(mapload, ...)
	. = ..()
	credit_value = rand(8, 9)
	desc = "研究磁盘，存有分析仪能够回收的全部数据。将其插入研究计算机，出售数据即可获得[credit_value]点科研点数。"
