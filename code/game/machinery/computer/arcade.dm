/obj/structure/machinery/computer/arcade
	name = "黑影多诺万Ⅱ：双重复仇"
	desc = "普通高中生乔希化身强大忍者“黑影多诺万”，击败兰琴科上校及其进步人民联盟实验军团，救出被俘的忍者女友蕾诺，两年后世界再次陷入混乱。乔希的加拿大表亲化身“狂怒元首”，创造了一个佛罗里达不复存在的世界。乔希再次化身黑影多诺万，迎战狂怒元首的爪牙大军，让这个地狱般的世界重现昔日荣光。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade
	unacidable = FALSE
	density = TRUE
	black_market_value = 35 //mendoza likes games
	var/enemy_name = "狂怒元首"
	var/temp = "由维兰德-汤谷与美国殖民地海军陆战队赞助" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 50 //Enemy health/attack points
	var/enemy_mp = 25
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	var/list/prizes = list( /obj/item/storage/box/mre = 3,
							/obj/item/spacecash/c10 = 4,
							/obj/item/ammo_magazine/flamer_tank = 1,
							/obj/item/tool/lighter/zippo = 2,
							/obj/item/tool/weldingtool = 1,
							/obj/item/storage/box/mre = 2,
							/obj/item/device/camera = 2,
							/obj/item/device/camera_film = 4,
							/obj/item/cell/crap/empty = 3,
							/obj/item/tool/hand_labeler = 1
							)

/obj/structure/machinery/computer/arcade
	var/turtle = 0

/obj/structure/machinery/computer/arcade/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/arcade/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat = "<a href='byond://?src=\ref[src];close=1'>关闭</a>"
	dat += "<center><h4>[src.enemy_name]</h4></center>"

	dat += "<br><center><h3>[src.temp]</h3></center>"
	dat += "<br><center>生命：[src.player_hp]|魔力：[src.player_mp]|敌方生命：[src.enemy_hp]</center>"

	if (src.gameover)
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>新游戏</a>"
	else
		dat += "<center><b><a href='byond://?src=\ref[src];attack=1'>攻击</a>|"
		dat += "<a href='byond://?src=\ref[src];heal=1'>治疗</a>|"
		dat += "<a href='byond://?src=\ref[src];charge=1'>恢复魔力</a>"

	dat += "</b></center>"

	show_browser(user, dat, name, "arcade")
	return

/obj/structure/machinery/computer/arcade/Topic(href, href_list)
	if(..())
		return

	if (!src.blocked && !src.gameover)
		if (href_list["attack"])
			src.blocked = 1
			var/attackamt = rand(2,6)
			src.temp = "你的剑造成了[attackamt]点伤害！"
			src.updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(10)
			src.enemy_hp -= attackamt
			src.arcade_action()

		else if (href_list["heal"])
			src.blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			src.temp = "你消耗[pointamt]点魔力，恢复了[healamt]点生命！"
			src.updateUsrDialog()
			turtle++

			sleep(10)
			src.player_mp -= pointamt
			src.player_hp += healamt
			src.blocked = 1
			src.updateUsrDialog()
			src.arcade_action()

		else if (href_list["charge"])
			src.blocked = 1
			var/chargeamt = rand(4,7)
			src.temp = "你恢复了[chargeamt]点魔力。"
			src.player_mp += chargeamt
			if(turtle > 0)
				turtle--

			src.updateUsrDialog()
			sleep(10)
			src.arcade_action()

	if (href_list["close"])
		usr.unset_interaction()
		close_browser(usr, "arcade")

	else if (href_list["newgame"]) //Reset everything
		temp = "新的一局"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/structure/machinery/computer/arcade/proc/arcade_action()
	if ((src.enemy_mp <= 0) || (src.enemy_hp <= 0))
		if(!gameover)
			src.gameover = 1
			src.temp = "[src.enemy_name]倒下了！欢呼吧！"

			if(!length(contents))
				var/prizeselect = pick_weight(prizes)
				new prizeselect(src.loc)

				if(istype(prizeselect, /obj/item/toy/gun)) //Ammo comes with the gun
					new /obj/item/toy/gun_ammo(src.loc)

				else if(istype(prizeselect, /obj/item/clothing/suit/syndicatefake)) //Helmet is part of the suit
					new /obj/item/clothing/head/syndicatefake(src.loc)

			else
				var/atom/movable/prize = pick(contents)
				prize.forceMove(loc)

	else if ((src.enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		src.temp = "[src.enemy_name]偷走了你的[stealamt]点魔力！"
		src.player_mp -= stealamt
		src.updateUsrDialog()

		if (src.player_mp <= 0)
			src.gameover = 1
			sleep(10)
			src.temp = "你的魔力被吸干了！游戏结束。"

	else if ((src.enemy_hp <= 10) && (src.enemy_mp > 4))
		src.temp = "[src.enemy_name]恢复了4点生命！"
		src.enemy_hp += 4
		src.enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		src.temp = "[src.enemy_name]的攻击造成[attackamt]点伤害！"
		src.player_hp -= attackamt

	if ((src.player_mp <= 0) || (src.player_hp <= 0))
		src.gameover = 1
		src.temp = "游戏结束"

	src.blocked = 0
	return

/obj/structure/machinery/computer/arcade/emp_act(severity)
	. = ..()
	if(inoperable())
		return
	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(0,2)
	for(num_of_prizes; num_of_prizes > 0; num_of_prizes--)
		empprize = pick_weight(prizes)
		new empprize(src.loc)
