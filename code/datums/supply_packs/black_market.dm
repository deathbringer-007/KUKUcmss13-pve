//*******************************************************************************
//BLACK MARKET
//*******************************************************************************/

//------------------------crates----------------

/*

----

IMPORTANT NOTE!!!!!

black market prices are NOT based on real or in-universe costs. they are based on how much the insane cargo-technician inside the elevator gives a damn about the crate.

----

*/

/datum/supply_packs/contraband //base
	name = "contraband crate"
	localized_name = "违禁品箱"
	contains = null
	containertype = null
	containername = "大型货箱"
	group = "Black Market"
	contraband = TRUE
	cost = 0
	dollar_cost = 50
	crate_heat = 5

/obj/structure/largecrate/black_market
	fill_from_loc = FALSE
	/// Wipes points from objects inside to avoid infinite farming.
	var/points_wipe = TRUE
	//no special name so it can be hidden

/obj/structure/largecrate/black_market/unpack()
	if(!points_wipe)
		return ..()

	for(var/atom/movable/content_atom in contents)
		content_atom.black_market_value = 0 //no free points
		recursive_points_wipe(content_atom, 1)

	return ..()

#define RECURSION_LIMIT 3

/obj/structure/largecrate/black_market/proc/recursive_points_wipe(atom/movable/content_atom, recursion)
	if(!points_wipe || recursion > RECURSION_LIMIT) // sanity
		return
	for(var/atom/movable/nested_atom in content_atom.contents)
		nested_atom.black_market_value = 0
		recursive_points_wipe(nested_atom, recursion++)

#undef RECURSION_LIMIT

/* --- SEIZED ITEMS --- */

/*

Non-USCM items, from CLF, UPP, colonies, etc. Mostly combat-related.

*/

/datum/supply_packs/contraband/seized
	group = "Seized Items"

/datum/supply_packs/contraband/seized/black_market_scanner
	name = "black market scanner crate"
	localized_name = "黑市扫描仪箱"
	contains = list(/obj/item/device/black_market_scanner)
	containername = "垃圾推车"
	dollar_cost = 5
	crate_heat = 0
	containertype = /obj/structure/closet/crate/trashcart

/datum/supply_packs/contraband/seized/confiscated_equipment
	name = "seized foreign equipment crate"
	localized_name = "查扣外来装备箱"
	dollar_cost = 70
	crate_heat = 10
	containertype = /obj/structure/largecrate/black_market/confiscated_equipment

/obj/structure/largecrate/black_market/confiscated_equipment/Initialize()
	. = ..()
	switch(rand(1,6))
		if(1) //pmc
			new /obj/item/clothing/under/marine/veteran/pmc(src)
			new /obj/item/clothing/head/helmet/marine/veteran/pmc(src)
			new /obj/item/clothing/suit/storage/marine/veteran/pmc(src)
			new /obj/item/clothing/gloves/marine/veteran/pmc(src)
			new /obj/item/clothing/mask/gas/pmc(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(2) //pizza
			new /obj/item/clothing/under/pizza(src)
			new /obj/item/clothing/head/soft/red(src)
		if(3) //clf
			new /obj/item/clothing/under/colonist/clf(src)
			new /obj/item/clothing/suit/storage/militia(src)
			new /obj/item/clothing/head/militia(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(4) //upp
			new /obj/item/clothing/head/helmet/marine/veteran/UPP(src)
			new /obj/item/clothing/under/marine/veteran/UPP(src)
			new /obj/item/clothing/suit/marine/faction/UPP(src)
			new /obj/item/clothing/shoes/marine/upp(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(5) //freelancer
			new /obj/item/clothing/under/marine/veteran/freelancer(src)
			new /obj/item/clothing/suit/storage/marine/faction/freelancer(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/storage/backpack/lightpack/five_slot(src)
		if(6) //VAIPO
			new /obj/item/clothing/glasses/sunglasses/big(src)
			new /obj/item/clothing/suit/storage/marine/light/vest(src)
			new /obj/item/clothing/under/tshirt/gray_blu(src)

/datum/supply_packs/contraband/seized/confiscated_weaponry
	name = "seized foreign weaponry crate"
	localized_name = "查扣外来武器箱"
	contains = list()
	dollar_cost = 45
	crate_heat = 15
	containertype = /obj/structure/largecrate/black_market/confiscated_weaponry

/obj/structure/largecrate/black_market/confiscated_weaponry/Initialize()
	. = ..()
	spawn_guns()
	spawn_guns() //the crate gives 2 guns

/obj/structure/largecrate/black_market/confiscated_weaponry/proc/spawn_guns()
	switch(rand(1, 5))
		if(1) //pmc
			new /obj/item/weapon/gun/smg/fp9000(src)
			new /obj/item/ammo_magazine/smg/fp9000(src)
			new /obj/item/ammo_magazine/smg/fp9000(src)
			new /obj/item/ammo_magazine/smg/fp9000(src)
			new /obj/item/ammo_magazine/smg/fp9000(src)
		if(2) //pizza
			new /obj/item/weapon/gun/pistol/holdout(src)
			new /obj/item/ammo_magazine/pistol/holdout(src)
		if(3) //clf
			switch(rand(1, 2))
				if(1)
					new /obj/item/weapon/gun/smg/uzi(src)
					new /obj/item/ammo_magazine/smg/uzi/extended(src)
					new /obj/item/ammo_magazine/smg/uzi(src)
					new /obj/item/ammo_magazine/smg/uzi(src)
				if(2)
					new /obj/item/weapon/gun/smg/mac15(src)
					new /obj/item/ammo_magazine/smg/mac15/extended(src)
					new /obj/item/ammo_magazine/smg/mac15(src)
					new /obj/item/ammo_magazine/smg/mac15(src)
		if(4) //upp
			new /obj/item/weapon/gun/shotgun/pump/type23(src)
			new /obj/item/ammo_magazine/handful/shotgun/heavy/beanbag(src)
			new /obj/item/ammo_magazine/handful/shotgun/heavy/beanbag(src)
			new /obj/item/ammo_magazine/handful/shotgun/heavy/flechette(src)
			new /obj/item/ammo_magazine/handful/shotgun/heavy/flechette(src)
			new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src)
			new /obj/item/ammo_magazine/handful/shotgun/heavy/slug(src) //NO buckshot!
		if(5) //freelancer
			new /obj/item/weapon/gun/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40/extended(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)


/* Misc. Individual Guns */

/* Prices are based on two things.

- 1. How strong the weapon is.
- 2. How underutilized it is by players.

Magazine count is also similarly based on this.

This way, underused-but-good weapons are incentivized to be bought for cheap like the PK-9.

Additionally, weapons that are way too good to put in the basically-flavor black market get weakened versions of themselves.

*/

// Rifles

/datum/supply_packs/contraband/seized/m16
	name = "M16 rifle crate (x4 magazines included)"
	localized_name = "M16步枪箱（附弹匣4个）"
	contains = list(
		/obj/item/weapon/gun/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16,
	)
	dollar_cost = 35
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/ar10
	name = "AR10 rifle crate (x5 magazines included)"
	localized_name = "AR10步枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
		/obj/item/ammo_magazine/rifle/ar10,
	)
	dollar_cost = 40 // rarer
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mar30
	name = "MAR-30 battle carbine crate (x5 magazines included)"
	localized_name = "MAR-30战斗卡宾枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/rifle/mar40/carbine,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
		/obj/item/ammo_magazine/rifle/mar40,
	)
	dollar_cost = 30
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/hunting
	name = "Basira-Armstrong bolt-action hunting rifle crate (x5 magazines included)"
	localized_name = "巴西拉-阿姆斯特朗栓动猎枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/ammo_magazine/rifle/boltaction,
	)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

// Shotguns
/datum/supply_packs/contraband/seized/custom
	name = "custom-built shotgun crate (x1 ammo box included)"
	localized_name = "自制霰弹枪箱（附弹药盒1个）"
	contains = list(
		/obj/item/weapon/gun/shotgun/merc/damaged,
		/obj/item/ammo_magazine/shotgun,
	)
	dollar_cost = 50
	containertype = /obj/structure/largecrate/black_market

// SMGs

/datum/supply_packs/contraband/seized/fp9000
	name = "FN FP9000 submachinegun crate (x5 magazines included)"
	localized_name = "FN FP9000冲锋枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
		/obj/item/ammo_magazine/smg/fp9000,
	)
	dollar_cost = 25
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mp27
	name = "MP-27 submachinegun crate (x5 magazines included)"
	localized_name = "MP-27冲锋枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
		/obj/item/ammo_magazine/smg/mp27,
	)
	dollar_cost = 20
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mp5
	name = "MP5 submachinegun crate (x5 magazines included)"
	localized_name = "MP5冲锋枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/smg/mp5,
	)
	dollar_cost = 25
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/uzi
	name = "UZI submachinegun crate (x5 magazines included)"
	localized_name = "乌兹冲锋枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
		/obj/item/ammo_magazine/smg/uzi,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/mac15
	name = "MAC-15 submachinegun crate (x5 magazines included)"
	localized_name = "MAC-15冲锋枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
		/obj/item/ammo_magazine/smg/mac15,
	)
	dollar_cost = 5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/pps43
	name = "Type-19 submachinegun crate (x5 magazines included)"
	localized_name = "19式冲锋枪箱（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/smg/pps43,
		/obj/item/ammo_magazine/smg/pps43/extended,
		/obj/item/ammo_magazine/smg/pps43/extended,
		/obj/item/ammo_magazine/smg/pps43,
		/obj/item/ammo_magazine/smg/pps43,
		/obj/item/ammo_magazine/smg/pps43,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

//Pistols

/datum/supply_packs/contraband/seized/b92fs
	name = "Beretta pistol crate (x6 magazines included)"
	localized_name = "伯莱塔手枪箱（附弹匣6个）"
	contains = list(
		/obj/item/weapon/gun/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/pistol/b92fs,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/heavy
	name = "Desert Eagle crate (x4 magazines included)"
	localized_name = "沙漠之鹰手枪箱（附弹匣4个）"
	contains = list(
		/obj/item/weapon/gun/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
		/obj/item/ammo_magazine/pistol/heavy,
	)
	dollar_cost = 45
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/t73
	name = "Type 73 pistol crate (x6 magazines included)"
	localized_name = "73式手枪箱（附弹匣6个）"
	contains = list(
		/obj/item/weapon/gun/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/kt42
	name = "KT-42 Automag pistol (x5 magazines included)"
	localized_name = "KT-42 Automag手枪（附弹匣5个）"
	contains = list(
		/obj/item/weapon/gun/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
		/obj/item/ammo_magazine/pistol/kt42,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/holdout
	name = "holdout pistol (x7 magazines included)"
	localized_name = "袖珍手枪（附弹匣7个）"
	contains = list(
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
		/obj/item/ammo_magazine/pistol/holdout,
	)
	dollar_cost = 5
	crate_heat = 2
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/bizon
	name = "Type 64 Submachinegun (x4 magazines included)"
	localized_name = "64式冲锋枪（附弹匣4个）"
	contains = list(
		/obj/item/weapon/gun/smg/bizon,
		/obj/item/ammo_magazine/smg/bizon,
		/obj/item/ammo_magazine/smg/bizon,
		/obj/item/ammo_magazine/smg/bizon,
		/obj/item/ammo_magazine/smg/bizon,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

//Revolvers

/datum/supply_packs/contraband/seized/cmb
	name = "CMB Spearhead revolver (x5 magazines included)"
	localized_name = "殖民地执法局“矛头”左轮手枪（附装弹器5个）"
	contains = list(
		/obj/item/weapon/gun/revolver/spearhead,
		/obj/item/ammo_magazine/revolver/spearhead,
		/obj/item/ammo_magazine/revolver/spearhead,
		/obj/item/ammo_magazine/revolver/spearhead,
		/obj/item/ammo_magazine/revolver/spearhead,
		/obj/item/ammo_magazine/revolver/spearhead,
	)
	dollar_cost = 20
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/small
	name = "Smith and Wesson revolver (x6 magazines included)"
	localized_name = "史密斯-韦森左轮手枪（附装弹器6个）"
	contains = list(
		/obj/item/weapon/gun/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
		/obj/item/ammo_magazine/revolver/small,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/upprevolver
	name = "ZHNK-72 revolver (x6 magazines included)"
	localized_name = "ZHNK-72左轮手枪（附装弹器6个）"
	contains = list(
		/obj/item/weapon/gun/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
		/obj/item/ammo_magazine/revolver/upp,
	)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/seized/r4t
	name = "R4T hunting rifle case (x3 ammo boxes included)"
	localized_name = "R4T猎枪盒（附弹药盒3个）"
	contains = list(
		/obj/item/weapon/gun/lever_action/r4t,
		/obj/item/attachable/stock/r4t,
		/obj/item/ammo_magazine/lever_action,
		/obj/item/ammo_magazine/lever_action,
		/obj/item/ammo_magazine/lever_action/training,
	)
	dollar_cost = 75
	containertype = /obj/structure/largecrate/black_market

/* --- SHIPSIDE CONTRABAND --- */

/*

Primarily made up of things that would be best utilized, well, shipside. Recreational drugs, alcohol, toys...

*/

/datum/supply_packs/contraband/shipside
	group = "Shipside Contraband"

/datum/supply_packs/contraband/shipside/confiscated_alcohol
	name = "confiscated alcohol crate"
	localized_name = "查扣酒类箱"
	randomised_num_contained = 5
	contains = list(
		/obj/item/reagent_container/food/drinks/bottle/gin,
		/obj/item/reagent_container/food/drinks/bottle/whiskey,
		/obj/item/reagent_container/food/drinks/bottle/sake,
		/obj/item/reagent_container/food/drinks/bottle/vodka,
		/obj/item/reagent_container/food/drinks/bottle/vodka/chess/random,
		/obj/item/reagent_container/food/drinks/bottle/tequila,
		/obj/item/reagent_container/food/drinks/bottle/davenport,
		/obj/item/reagent_container/food/drinks/bottle/bottleofnothing,
		/obj/item/reagent_container/food/drinks/bottle/patron,
		/obj/item/reagent_container/food/drinks/bottle/rum,
		/obj/item/reagent_container/food/drinks/bottle/vermouth,
		/obj/item/reagent_container/food/drinks/bottle/kahlua,
		/obj/item/reagent_container/food/drinks/bottle/goldschlager,
		/obj/item/reagent_container/food/drinks/bottle/cognac,
		/obj/item/reagent_container/food/drinks/bottle/wine,
		/obj/item/reagent_container/food/drinks/bottle/absinthe,
		/obj/item/reagent_container/food/drinks/bottle/melonliquor,
		/obj/item/reagent_container/food/drinks/bottle/bluecuracao,
		/obj/item/reagent_container/food/drinks/bottle/grenadine,
		/obj/item/reagent_container/food/drinks/bottle/pwine,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/tuxedo,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/ganucci,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/bluemalt,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/partypopper,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/tazhushka,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/reaper,
		/obj/item/reagent_container/food/drinks/bottle/beer/craft/mono,
	)
	dollar_cost = 35
	crate_heat = -5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/shipside/confiscated_medicine
	name = "confiscated medicinal supplies crate"
	localized_name = "查扣医疗用品箱"
	randomised_num_contained = 5
	contains = list(
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/mystery,
		/obj/item/storage/pill_bottle/russianRed/skillless,
		/obj/item/reagent_container/food/drinks/flask/weylandyutani/poison,
		/obj/item/reagent_container/food/drinks/bottle/holywater/bong,
		/obj/item/storage/pill_bottle/paracetamol,
	)
	dollar_cost = 25
	crate_heat = 3
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/shipside/confiscated_cuisine
	name = "confiscated cuisine supplies crate"
	localized_name = "查扣烹饪用品箱"
	randomised_num_contained = 7
	contains = list(
		/obj/item/reagent_container/food/drinks/bottle/absinthe,
		/obj/item/reagent_container/food/drinks/bottle/pwine,
		/obj/item/reagent_container/food/snacks/stew,
		/obj/item/reagent_container/food/snacks/donut/chaos,
		/obj/item/reagent_container/food/snacks/egg/random,
		/obj/item/reagent_container/food/snacks/egg/random, //not a dupe
		/obj/item/reagent_container/food/snacks/xemeatpie,
		/obj/item/storage/box/mre/upp,
		/obj/item/reagent_container/food/snacks/mre_pack/xmas1,
		/obj/item/reagent_container/food/snacks/mre_pack/xmas2,
		/obj/item/reagent_container/food/snacks/mre_pack/xmas3,
		/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk,
		/obj/item/reagent_container/food/snacks/meat/human,
		/obj/item/reagent_container/food/snacks/meat/corgi,
		/obj/item/reagent_container/food/snacks/meat/xenomeat,
		/obj/item/reagent_container/food/snacks/grown/apple/poisoned,
		/obj/item/reagent_container/food/snacks/grown/poisonberries,
		/obj/item/reagent_container/food/snacks/grown/deathberries,
		/obj/item/reagent_container/food/snacks/carpmeat,
		/obj/item/reagent_container/food/snacks/candy_corn,
		/obj/item/reagent_container/food/snacks/monkeyburger,
		/obj/item/reagent_container/food/snacks/human/burger,
		/obj/item/reagent_container/food/snacks/xenoburger,
		/obj/item/reagent_container/food/snacks/amanitajelly,
		/obj/item/reagent_container/food/snacks/spacylibertyduff,
		/obj/item/reagent_container/food/snacks/monkeysdelight,
		/obj/item/reagent_container/food/snacks/sliceable/braincake,
		/obj/item/reagent_container/food/snacks/resin_fruit,
		/obj/item/reagent_container/food/condiment/hotsauce/franks/macho,
	)
	dollar_cost = 15
	crate_heat = -5
	containertype = /obj/structure/largecrate/black_market


/datum/supply_packs/contraband/shipside/confiscated_nicotine
	name = "confiscated nicotine items crate"
	localized_name = "查扣尼古丁制品箱"
	randomised_num_contained = 2
	contains = list(
		/obj/item/storage/fancy/cigarettes/blackpack,
		/obj/item/storage/fancy/cigarettes/wypacket,
		/obj/item/storage/fancy/cigarettes/kpack,
		/obj/item/storage/fancy/cigarettes/arcturian_ace,
		/obj/item/storage/fancy/cigarettes/lady_finger,
		/obj/item/storage/fancy/cigar/tarbacks,
		/obj/item/storage/fancy/cigar/tarbacktube,
	)
	dollar_cost = 45
	crate_heat = -5
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/shipside/confiscated_miscellaneous
	name = "confiscated miscellaneous items crate"
	localized_name = "查扣杂物箱"
	randomised_num_contained = 6
	contains = list(
		/obj/item/toy/bikehorn,
		/obj/item/storage/box/packet/hefa/toy,
		/obj/item/toy/inflatable_duck,
		/obj/item/toy/beach_ball,
		/obj/item/toy/plush/farwa,
		/obj/item/toy/waterflower,
		/obj/item/toy/spinningtoy,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/toy/balloon,
		/obj/item/storage/wallet,
		/obj/item/storage/belt/champion,
		/obj/item/clothing/mask/luchador,
		/obj/item/tool/soap/deluxe,
		/obj/item/maintenance_jack,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/poster,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/deathripley,
		/obj/item/reagent_container/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_container/food/snacks/grown/ambrosiavulgaris,
		/obj/item/clothing/accessory/horrible,
		/obj/item/storage/belt/marine/quackers,
		/obj/item/storage/belt/shotgun/full/quackers,
		/obj/item/pamphlet/skill/powerloader,
		/obj/item/pamphlet/language/russian,
		/obj/item/pamphlet/language/japanese,
		/obj/item/pamphlet/language/chinese,
		/obj/item/pamphlet/language/german,
		/obj/item/pamphlet/language/spanish,
	)
	dollar_cost = 30
	crate_heat = -2
	containertype = /obj/structure/largecrate/black_market


/* --- SURPLUS EQUIPMENT --- */

/*

USCM spare items, miscellaneous gear that's too niche and distant (or restricted) to put in normal req but juuuust USCM-related enough to fit here.

*/

/datum/supply_packs/contraband/surplus
	group = "Surplus Equipment"

/* - Misc. USCM equipment - */

/datum/supply_packs/contraband/surplus/uscm_poncho
	name = "surplus USCM poncho crate (x2)"
	localized_name = "剩余库存殖民地陆战队雨披箱（2件）"
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market/poncho
	crate_heat = -2

/obj/structure/largecrate/black_market/poncho/Initialize()
	. = ..()
	var/obj/item/paper/nope = new(src)
	nope.name = "自动仓储检索系统通知"
	nope.info = "抱歉！你订购的<b>USCM雨披（2件）</b>未能成功送达，原因是：“仓库中没有找到该类物品。”"
	nope.color = "green"
	nope.update_icon()

/datum/supply_packs/contraband/surplus/uscm_heap
	name = "surplus high-explosive armor-piercing M41A magazine crate (x3)"
	localized_name = "剩余库存M41A高爆穿甲弹匣箱（3个）"
	dollar_cost = 40
	crate_heat = -2
	containertype = /obj/structure/largecrate/black_market/uscm_heap

/obj/structure/largecrate/black_market/uscm_heap/Initialize()
	. = ..()
	var/obj/item/paper/nope = new(src)
	nope.name = "自动仓储检索系统通知"
	nope.info = "抱歉！你订购的<b>M41A高爆穿甲弹匣（3个）</b>未能成功送达，原因是：“错误：无法进入舱室，退出代码2342：爆炸危险。”"
	nope.color = "green"
	nope.update_icon()

/datum/supply_packs/contraband/surplus/surplus_police_equipment
	name = "surplus riot control equipment"
	localized_name = "剩余库存防暴装备"
	randomised_num_contained = 3
	contains = list(
		/obj/item/weapon/baton/damaged,
		/obj/item/reagent_container/spray/pepper,
		/obj/item/weapon/baton/cattleprod,
		/obj/item/ammo_magazine/shotgun/beanbag,
		/obj/item/storage/box/packet/m15/rubber,
		/obj/item/storage/box/guncase/m79,
		/obj/item/clothing/head/helmet/marine/MP,
		/obj/item/prop/helmetgarb/riot_shield,
	)
	dollar_cost = 55
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/surplus_non_lethal_ammunition
	name = "surplus non-lethal ammunition"
	localized_name = "剩余库存非致命弹药"
	randomised_num_contained = 2
	contains = list(
		/obj/item/ammo_magazine/smg/m39/rubber,
		/obj/item/ammo_magazine/pistol/rubber,
		/obj/item/ammo_magazine/pistol/vp70/rubber,
		/obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/m49a/rubber,
		/obj/item/ammo_magazine/shotgun/beanbag,
	)
	dollar_cost = 50
	containertype = /obj/structure/largecrate/black_market

/* - Misc. USCM weaponry - */

/datum/supply_packs/contraband/surplus/mk45_automag
	name = "surplus HG 45 case"
	localized_name = "剩余库存HG 45武器盒"
	dollar_cost = 35
	contains = list(/obj/item/storage/box/guncase/hg45)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/nsg23_marine
	name = "surplus NSG-23 assault rifle case"
	localized_name = "剩余库存NSG-23突击步枪盒"
	dollar_cost = 45
	contains = list(/obj/item/storage/box/guncase/nsg23_marine)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/m3717
	name = "surplus M37-17 pump shotgun case"
	localized_name = "剩余库存M37-17泵动霰弹枪盒"
	dollar_cost = 80
	contains = list(/obj/item/storage/box/guncase/m3717)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/m1911
	name = "surplus M1911 service pistol case"
	localized_name = "剩余库存M1911制式手枪盒"
	dollar_cost = 10
	contains = list(/obj/item/storage/box/guncase/m1911)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/surplus/m1911/socom
	name = "surplus SOCOM M1911 service pistol case"
	localized_name = "剩余库存SOCOM M1911制式手枪盒"
	dollar_cost = 25
	contains = list(/obj/item/storage/box/guncase/m1911/socom)
	containertype = /obj/structure/largecrate/black_market

/* --- AMMO --- */

/datum/supply_packs/contraband/ammo
	group = "Contraband Ammo"

/datum/supply_packs/contraband/ammo/r4t
	name = "45-70 bullet box crate (x300 rounds)"
	localized_name = "45-70子弹补给箱（300发）"
	dollar_cost = 135
	contains = list(/obj/item/ammo_box/magazine/lever_action)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/r4t/training
	name = "45-70 bullet box crate (x300 training rounds)"
	localized_name = "45-70子弹补给箱（训练弹300发）"
	dollar_cost = 35
	contains = list(/obj/item/ammo_box/magazine/lever_action/training)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/m16
	name = "Magazine box (M16, 12x regular mags)"
	localized_name = "弹匣箱（M16，普通弹匣12个）"
	dollar_cost = 100
	contains = list(/obj/item/ammo_box/magazine/M16)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/ar10
	name = "Magazine box (AR10, 12x regular mags)"
	localized_name = "弹匣箱（AR10，普通弹匣12个）"
	dollar_cost = 115
	contains = list(/obj/item/ammo_box/magazine/ar10)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/deagle
	name = "Magazine box (Desert Eagle, 16x regular mags)"
	localized_name = "弹匣箱（沙漠之鹰，普通弹匣16个）"
	dollar_cost = 180
	contains = list(/obj/item/ammo_box/magazine/deagle)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/deagle/hiap
	name = "Magazine box (Desert Eagle, 16x HIAP mags)"
	localized_name = "弹匣箱（沙漠之鹰，高冲击穿甲弹匣16个）"
	dollar_cost = 260
	contains = list(/obj/item/ammo_box/magazine/deagle/super/highimpact/ap/empty)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/type73
	name = "Magazine box (Type 73, 16x regular mags)"
	localized_name = "弹匣箱（73式，普通弹匣16个）"
	dollar_cost = 60
	contains = list(/obj/item/ammo_box/magazine/type73)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/nsg
	name = "Magazine box (NSG-23, 16x regular mags)"
	localized_name = "弹匣箱（NSG-23，普通弹匣16个）"
	dollar_cost = 140
	contains = list(/obj/item/ammo_box/magazine/nsg23)
	containertype = /obj/structure/largecrate/black_market
/datum/supply_packs/contraband/ammo/mar30
	name = "Magazines box (MAR30, 10x regular mags)"
	localized_name = "弹匣箱（MAR30，普通弹匣10个）"
	dollar_cost = 60
	contains = list(/obj/item/ammo_box/magazine/mar30)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/fp9000
	name = "Magazines box (FN FP9000, 10x mags)"
	localized_name = "弹匣箱（FN FP9000，弹匣10个）"
	dollar_cost = 35
	contains = list(/obj/item/ammo_box/magazine/fp9000)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/mp27
	name = "Magazines box (MP-27, 12x mags)"
	localized_name = "弹匣箱（MP-27，弹匣12个）"
	dollar_cost = 45
	contains = list(/obj/item/ammo_box/magazine/mp27)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/uzi
	name = "Magazines box (UZI, 12x mags)"
	localized_name = "弹匣箱（乌兹，弹匣12个）"
	dollar_cost = 25
	contains = list(/obj/item/ammo_box/magazine/uzi)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/mac15
	name = "Magazines box (MAC-15, 12x mags)"
	localized_name = "弹匣箱（MAC-15，弹匣12个）"
	dollar_cost = 15
	contains = list(/obj/item/ammo_box/magazine/mac15)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/pps43
	name = "Magazines box (Type-19, 10x regular mags)"
	localized_name = "弹匣箱（19式，普通弹匣10个）"
	dollar_cost = 40
	contains = list(/obj/item/ammo_box/magazine/type19)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/b92fs
	name = "Magazines box (Beretta 92FS, 16x mags)"
	localized_name = "弹匣箱（伯莱塔92FS，弹匣16个）"
	dollar_cost = 30
	contains = list(/obj/item/ammo_box/magazine/b92fs)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/kt42
	name = "Magazines box (KT-42, 16x mags)"
	localized_name = "弹匣箱（KT-42，弹匣16个）"
	dollar_cost = 45
	contains = list(/obj/item/ammo_box/magazine/kt42)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/bizon
	name = "Magazines box (Type 64, 10x mags)"
	localized_name = "弹匣箱（64式，弹匣10个）"
	dollar_cost = 40
	contains = list(/obj/item/ammo_box/magazine/type64)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/m1911
	name = "Magazines box (M1911, 16x mags)"
	localized_name = "弹匣箱（M1911，弹匣16个）"
	dollar_cost = 40
	contains = list(/obj/item/ammo_box/magazine/m1911)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/mk45
	name = "Magazines box (MK-45 Automagnum, 16x mags)"
	localized_name = "弹匣箱（MK-45 Automagnum，弹匣16个）"
	dollar_cost = 80
	contains = list(/obj/item/ammo_box/magazine/mk45)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/cmb
	name = "Speed loaders box (CMB Spearhead, 16x HP loaders)"
	localized_name = "快速装弹器箱（殖民地执法局“矛头”，空尖弹装弹器16个）"
	dollar_cost = 70
	contains = list(/obj/item/ammo_box/magazine/spearhead)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/smw
	name = "Speed loaders box (Smith and Wesson revolver, 12x loaders)"
	localized_name = "快速装弹器箱（史密斯-韦森左轮手枪，装弹器12个）"
	dollar_cost = 30
	contains = list(/obj/item/ammo_box/magazine/snw)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/ammo/zhnk
	name = "Speed loaders box (ZHNK-72, 12x loaders)"
	localized_name = "快速装弹器箱（ZHNK-72，装弹器12个）"
	dollar_cost = 30
	contains = list(/obj/item/ammo_box/magazine/zhnk)
	containertype = /obj/structure/largecrate/black_market


/* --- DEEP STORAGE --- */

/*

Some of the least-obtainable loadout items, now purchasable from the contraband menu. If you think this is filler, uh........ yeah.

This is where the RO can reclaim their lost honor and purchase the M44 custom, though.

*/

/datum/supply_packs/contraband/deep_storage
	group = "Deep Storage"
	crate_heat = -5

/datum/supply_packs/contraband/deep_storage/spacejam
	name = "Tickets to Space Jam"
	localized_name = "《空中大灌篮》门票"
	contains = list(/obj/item/prop/helmetgarb/spacejam_tickets)
	dollar_cost = 5
	crate_heat = -2
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/broken_nvgs
	name = "Broken Night Vision Goggles"
	localized_name = "损坏的夜视镜"
	contains = list(/obj/item/prop/helmetgarb/helmet_nvg/cosmetic)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/xm43e1_pipe
	name = "10x99mm XM43E1 casing"
	localized_name = "10x99毫米XM43E1弹壳"
	contains = list(/obj/item/prop/helmetgarb/bullet_pipe)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/trimmed_wire
	name = "Trimmed Barbed Wire"
	localized_name = "修剪过的铁丝网"
	contains = list(/obj/item/prop/helmetgarb/trimmed_wire)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/lucky_feather_random
	name = "Lucky Feather"
	localized_name = "幸运羽毛"
	randomised_num_contained = 1
	contains = list(
		/obj/item/prop/helmetgarb/lucky_feather,
		/obj/item/prop/helmetgarb/lucky_feather/blue,
		/obj/item/prop/helmetgarb/lucky_feather/purple,
		/obj/item/prop/helmetgarb/lucky_feather/yellow,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/rosary
	name = "Rosary"
	localized_name = "玫瑰念珠"
	contains = list(/obj/item/prop/helmetgarb/rosary)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/rabbitsfoot
	name = "Rabbit's Foot"
	localized_name = "幸运兔脚"
	contains = list(/obj/item/prop/helmetgarb/rabbitsfoot)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

// Masks

/datum/supply_packs/contraband/deep_storage/tacticalmask_random
	name = "Tactical Mask"
	localized_name = "战术面罩"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask,
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask/red,
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask/green,
		/obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/skull_balaclava_random
	name = "Skull Balaclava"
	localized_name = "骷髅头套"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/mask/rebreather/skull/black,
		/obj/item/clothing/mask/rebreather/skull,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market


/datum/supply_packs/contraband/deep_storage/skull_facepaint
	name = "Skull Facepaint"
	localized_name = "骷髅脸彩"
	contains = list(/obj/item/facepaint/skull)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

//Glasses

/datum/supply_packs/contraband/deep_storage/aviator_shades
	name = "Aviator Shades"
	localized_name = "飞行员墨镜"
	contains = list(/obj/item/clothing/glasses/sunglasses/aviator)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/ballistic_goggles_random
	name = "Ballistic Goggles"
	localized_name = "防弹护目镜"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/glasses/mgoggles,
		/obj/item/clothing/glasses/mgoggles/orange,
		/obj/item/clothing/glasses/mgoggles/black,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/bimex_shades
	name = "BiMex Personal Shades"
	localized_name = "比迈克斯个人墨镜"
	contains = list(/obj/item/clothing/glasses/sunglasses/big)
	dollar_cost = 15
	containertype = /obj/structure/largecrate/black_market

// Headgear

/datum/supply_packs/contraband/deep_storage/bandana_random
	name = "USCM Bandana"
	localized_name = "殖民地陆战队方巾"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/head/cmbandana,
		/obj/item/clothing/head/cmbandana/tan,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uscm_earpiece
	name = "USCM Earpiece"
	localized_name = "殖民地陆战队耳机"
	randomised_num_contained = 1
	contains = list(/obj/item/clothing/head/headset)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uscm_headband
	name = "USCM Headband"
	localized_name = "殖民地陆战队头带"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/head/headband,
		/obj/item/clothing/head/headband/brown,
		/obj/item/clothing/head/headband/gray,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/tan,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uscm_boonie_hat
	name = "USCM Boonie Hat"
	localized_name = "殖民地陆战队丛林帽"
	randomised_num_contained = 1
	contains = list(
		/obj/item/clothing/head/cmcap/boonie/tan,
		/obj/item/clothing/head/cmcap/boonie,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

//Misc

/datum/supply_packs/contraband/deep_storage/pdtl_kit
	name = "PDT/L Kit"
	localized_name = "PDT/L套件"
	contains = list(/obj/item/storage/box/pdt_kit)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/lucky_lime
	name = "Frozen Lime"
	localized_name = "冰冻青柠"
	contains = list(/obj/item/reagent_container/food/snacks/grown/lime)
	dollar_cost = 5
	crate_heat = -2
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/uno_reverse_random
	name = "Uno Reverse Card"
	localized_name = "UNO反转牌"
	randomised_num_contained = 1
	contains = list(
		/obj/item/toy/handcard/uno_reverse_red,
		/obj/item/toy/handcard/uno_reverse_blue,
		/obj/item/toy/handcard/uno_reverse_purple,
		/obj/item/toy/handcard/uno_reverse_yellow,
	)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/jungle_boots
	name = "Jungle Pattern Combat Boots"
	localized_name = "丛林迷彩作战靴"
	contains = list(/obj/item/clothing/shoes/marine/jungle)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

//Weapons

/datum/supply_packs/contraband/deep_storage/type_replica
	name = "Type 80 Bayonet Replica"
	localized_name = "80式刺刀复制品"
	contains = list(/obj/item/attachable/bayonet/upp/surplus)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/cartridge_bayonet
	name = "M8 Cartridge Bayonet Kit"
	localized_name = "M8弹射刺刀套件"
	contains = list(/obj/item/storage/box/loadout/co2_knife)
	dollar_cost = 10
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/clf_holdout
	name = "D18 Holdout Pistol"
	localized_name = "D18袖珍手枪"
	contains = list(/obj/item/storage/box/loadout/CLF_loadout)
	dollar_cost = 10
	crate_heat = 2
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/m4a3_c
	name = "M4A3 Custom Pistol"
	localized_name = "M4A3定制手枪"
	contains = list(/obj/item/weapon/gun/pistol/m4a3/custom)
	dollar_cost = 35
	crate_heat = 4
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/deep_storage/m44_c
	name = "M44 Custom Revolver"
	localized_name = "M44定制左轮手枪"
	contains = list(/obj/item/weapon/gun/revolver/m44/custom)
	dollar_cost = 70
	crate_heat = 4
	containertype = /obj/structure/largecrate/black_market

/* --- MISCELLANEOUS --- */

/*

Things that don't fit anywhere else. If they're meant for shipside use, they probably fit in shipside contraband.

*/

/datum/supply_packs/contraband/miscellaneous
	group = "Miscellaneous"

/datum/supply_packs/contraband/miscellaneous/secured_wildlife
	name = "secured wildlife container"
	localized_name = "加固野生动物集装箱"
	dollar_cost = 45
	crate_heat = 7
	containertype = /obj/structure/largecrate/black_market/secured_wildlife

/obj/structure/largecrate/black_market/secured_wildlife
	name = "加固野生动物集装箱"
	icon_state = "lisacrate"

/obj/structure/largecrate/black_market/secured_wildlife/unpack()
	//We need to pick a 'secured wildlife' mob that actually makes sense.
	var/unfit_simplemobs = list(/mob/living/simple_animal/drone, /mob/living/simple_animal/hostile/retaliate/malf_drone)
	var/fit_hostiles = list(/mob/living/simple_animal/hostile/giant_spider, /mob/living/simple_animal/hostile/bear,, /mob/living/simple_animal/hostile/retaliate/goat)
	var/monkey_mobs = list(/mob/living/carbon/human/monkey, /mob/living/carbon/human/farwa, /mob/living/carbon/human/stok, /mob/living/carbon/human/yiren, /mob/living/carbon/human/neaera)
	var/mob/contained_mob_type = pick( ( subtypesof(/mob/living/simple_animal) - typesof(/mob/living/simple_animal/hostile) ) + fit_hostiles + monkey_mobs - unfit_simplemobs)
	new contained_mob_type(loc)
	. = ..()

/datum/supply_packs/contraband/miscellaneous/potted_plant
	name = "potted plant crate"
	localized_name = "盆栽箱"
	dollar_cost = 50
	crate_heat = -10
	contains = list(/obj/structure/flora/pottedplant/random/unanchored)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/miscellaneous/cargo_tug
	name = "cargo tug crate"
	localized_name = "货运牵引车箱"
	dollar_cost = 50
	contains = list(/obj/vehicle/train/cargo/engine)
	containertype = /obj/structure/largecrate/black_market

/datum/supply_packs/contraband/miscellaneous/clf_supplies
	name = "unmarked CLF supply crate"
	localized_name = "无标识的殖民地解放阵线补给箱"
	dollar_cost = 40
	crate_heat = 25
	contains = list()
	containertype = /obj/structure/largecrate/black_market/clf_supplies

/obj/structure/largecrate/black_market/clf_supplies
	name = "无标识的CLF补给箱"
	desc = "箱子里装着什么？只有打开才知道！"
	icon_state = "chest"
	/// If you want to use this in mapping, you can force-set the contents via this.
	var/forced_rng

#define UNLUCKY_GRENADE_AMOUNT 3

/obj/structure/largecrate/black_market/clf_supplies/unpack()
	var/loot_luck = rand(1, 100)
	if(forced_rng)
		loot_luck = forced_rng
	var/loot_message
	switch(loot_luck)
		if(1 to 5)
		// Random sheets! Could be iron, could be diamonds.
			for(var/i in 1 to 5)
				var/sheet_type = pick(subtypesof(/obj/item/stack/sheet))
				var/obj/item/stack/sheet/sheet_stack = new sheet_type(loc)
				if(sheet_stack.amount == 1)
					sheet_stack.amount = rand(1, 5)
			loot_message = SPAN_NOTICE("板上钉钉，是一堆板材！")
		if(6 to 10)
		// Elite recovered gear.
			var/list/armor_to_pick = list(
				// Y8 Miner (default)
				/obj/item/clothing/under/marine/veteran/mercenary/miner,
				/obj/item/clothing/suit/storage/marine/veteran/mercenary/miner,
				/obj/item/clothing/head/helmet/marine/veteran/mercenary/miner,
				// K12 Ceramic (Heavy-ish)
				/obj/item/clothing/under/marine/veteran/mercenary,
				/obj/item/clothing/suit/storage/marine/veteran/mercenary,
				/obj/item/clothing/head/helmet/marine/veteran/mercenary,
				// Z7 Support (Support)
				/obj/item/clothing/under/marine/veteran/mercenary,
				/obj/item/clothing/suit/storage/marine/veteran/mercenary/support,
				/obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer
				// You get three random pieces. If you want to complete the set you need to keep rolling the dice!
			)
			for(var/i in 1 to 3)
				var/picked_type = pick(armor_to_pick)
				new picked_type(loc)
			loot_message = SPAN_NOTICE("这里面是些奇怪的精锐装备……？")
		if(11 to 15)
			//Type 64
			new /obj/item/weapon/gun/smg/bizon(loc)
			new /obj/item/ammo_magazine/smg/bizon(loc)
			new /obj/item/ammo_magazine/smg/bizon(loc)
			new /obj/item/ammo_magazine/smg/bizon(loc)
			// Somehow they found a Webley.
			new /obj/item/weapon/gun/revolver/m44/custom/webley(loc)
			new /obj/item/ammo_magazine/revolver/webley(loc)
			new /obj/item/ammo_magazine/revolver/webley(loc)
			new /obj/item/ammo_magazine/revolver/webley(loc)
			loot_message = SPAN_NOTICE("这里面是殖民地解放阵线的手枪装备！")
		if(16 to 20)
			// Type 19
			new /obj/item/weapon/gun/smg/pps43/extended_mag(loc)
			new /obj/item/ammo_magazine/smg/pps43/extended(loc)
			new /obj/item/ammo_magazine/smg/pps43/extended(loc)
			new /obj/item/ammo_magazine/smg/pps43/extended(loc)
			// MAC-15
			new /obj/item/weapon/gun/smg/mac15/extended(loc)
			new /obj/item/ammo_magazine/smg/mac15/extended(loc)
			new /obj/item/ammo_magazine/smg/mac15/extended(loc)
			new /obj/item/ammo_magazine/smg/mac15/extended(loc)
			loot_message = SPAN_NOTICE("这里面是殖民地解放阵线的冲锋枪装备。")
		if(21 to 25)
			// Discovered Yautja ruins.. (None of these will trigger any alarms. They are far too old, degraded, and useless for any Yautja to care.)
			new /obj/item/clothing/mask/yautja_flavor(loc)
			new /obj/item/clothing/suit/armor/yautja_flavor(loc)
			new /obj/item/clothing/shoes/yautja_flavor(loc)
			new /obj/item/weapon/twohanded/yautja/glaive/damaged(loc)
			new /obj/item/stack/yautja_rope(loc)
			loot_message = SPAN_NOTICE("这里面是些奇怪的古老装备……？")
		if(26 to 29)
			// stevemre1989's secret stash
			new /obj/item/storage/box/mre/fsr(loc)
			new /obj/item/storage/box/mre/twe(loc)
			new /obj/item/storage/box/mre/wy(loc)
			new /obj/item/storage/box/mre/pmc(loc)
			new /obj/item/storage/box/mre/upp(loc)
			loot_message = SPAN_NOTICE("这里面是些口粮……？")
		if(30 to 35)
		// CLF nades!
			loot_message = SPAN_NOTICE("这里面是一包各式殖民地解放阵线手榴弹！")
			var/list/nades_to_pick = list(
				/obj/item/explosive/grenade/empgrenade,
				/obj/item/explosive/grenade/custom/ied,
				/obj/item/explosive/grenade/incendiary/molotov,
				/obj/item/explosive/grenade/custom/ied_incendiary,
				/obj/item/explosive/grenade/phosphorus/clf,
				/obj/item/explosive/grenade/smokebomb,
				/obj/item/explosive/grenade/smokebomb/airburst,
				/obj/item/explosive/grenade/custom/antiweed
			)
			for(var/i in 1 to 4)
				var/picked_type = pick(nades_to_pick)
				var/obj/item/explosive/grenade/new_nade = new picked_type(loc)
				if(new_nade.hand_throwable && prob(7))
					loot_message = SPAN_HIGHDANGER("有诡雷！快跑！")
					new_nade.prime()
		if(36 to 40)
		// Molotovs and supplies to make more...
			new /obj/item/explosive/grenade/incendiary/molotov(loc)
			new /obj/item/explosive/grenade/incendiary/molotov(loc)
			new /obj/item/paper_bin(loc)
			new /obj/item/reagent_container/food/drinks/bottle/whiskey(loc)
			new /obj/item/reagent_container/food/drinks/bottle/kahlua(loc)
			new /obj/item/reagent_container/food/drinks/bottle/rum(loc)
			loot_message = SPAN_NOTICE("这里面是一堆制成和未制成的燃烧瓶。")
		if(41 to 45)
		// Spare CLF gear!
			new /obj/effect/essentials_set/random/clf_shoes(loc)
			new /obj/item/clothing/under/colonist/clf(loc)
			new /obj/effect/essentials_set/random/clf_armor(loc)
			new /obj/effect/essentials_set/random/clf_gloves(loc)
			new /obj/effect/essentials_set/random/clf_head(loc)
			new /obj/effect/essentials_set/random/clf_belt(loc)
			loot_message = SPAN_NOTICE("这里面是一套备用的殖民地解放阵线装备。你大概不该穿上它……")
		// That was the good 50%. Now it's time for the bad.
		if(46 to 50)
		// Random junk
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			new /obj/effect/essentials_set/random/clf_bonus_item(loc)
			loot_message = SPAN_NOTICE("这里面是一堆乱七八糟的废物……")
		if(51 to 70)
			new /obj/effect/spawner/random/bomb_supply(loc)
			new /obj/effect/spawner/random/bomb_supply(loc)
			new /obj/effect/spawner/random/toolbox(loc)
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/attachment(loc)
			if(prob(33))
				new /obj/effect/spawner/random/supply_kit/market(loc)
			else
				new /obj/effect/spawner/random/attachment(loc)
			loot_message = SPAN_NOTICE("只是一些旧装备和零件。")
		if(71 to 75)
		// CLF corpse!! Why is this here? Don't ask.
			var/mob/living/carbon/human/corpse = new (loc)
			corpse.create_hud() //Need to generate hud before we can equip anything apparently...

			var/corpse_type = pick(/datum/equipment_preset/corpse/bluecollar, /datum/equipment_preset/corpse/whitecollar)
			arm_equipment(corpse, corpse_type, TRUE, FALSE) // I didn't choose the shitcode life, the shitcode life chose me

			loot_message = SPAN_HIGHDANGER("是一具尸体！！")
		if(76 to 90)
		// Random supply garbage.
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/tool(loc)
			new /obj/effect/spawner/random/tech_supply(loc)
			new /obj/effect/spawner/random/tech_supply(loc)
			new /obj/effect/spawner/random/tech_supply(loc)
			new /obj/effect/spawner/random/toy(loc)
			new /obj/effect/spawner/random/toy(loc)
			new /obj/effect/spawner/random/toy(loc)
			loot_message = SPAN_NOTICE("只是一堆垃圾！")
		if(91 to 95)
		// We don't really have any other kind of booby trap so this will do
			var/obj/item/explosive/grenade/spawnergrenade/claymore_launcher/spawner = new(loc)
			spawner.prime()
			loot_message = SPAN_HIGHDANGER("有诡雷！快跑！")
		if(96 to 99)
		// Oh boy. Big booby trap!
			var/obj/item/mortar_shell/frag/fragshell = new(loc)
			var/obj/item/explosive/grenade/incendiary/molotov/molotov = new(loc)
			molotov.prime()
			fragshell.balloon_alert_to_viewers("迫击炮弹发出骇人的嘶嘶声！")
			addtimer(CALLBACK(fragshell, TYPE_PROC_REF(/obj/item/mortar_shell/frag, detonate), loc), 5 SECONDS)
			QDEL_IN(fragshell, 5.5 SECONDS)
			loot_message = SPAN_HIGHDANGER("快跑！！！")
		if(100)
		// You got real fuckin' unlucky kid :joker:
			for(var/i = 1 to UNLUCKY_GRENADE_AMOUNT)
				var/obj/item/explosive/grenade/spawnergrenade/claymore_launcher/spawner = new(loc)
				spawner.prime()
			loot_message = SPAN_HIGHDANGER("里面全是诡雷！快跑！")

	visible_message(loot_message, max_distance = 4)
	return ..()

#undef UNLUCKY_GRENADE_AMOUNT
