/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/item/card/id/var/money = 2000

/obj/structure/machinery/atm
	name = "维兰德-汤谷自动取款机"
	desc = "满足你所有的金融需求！"
	icon = 'icons/obj/structures/machinery/terminals.dmi'
	icon_state = "atm"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN
	var/datum/effect_system/spark_spread/spark_system
	var/withdrawal_timer = 0

/obj/structure/machinery/atm/New()
	..()
	machine_id = "[MAIN_SHIP_NAME] RT #[GLOB.num_financial_terminals++]"
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/structure/machinery/atm/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/structure/machinery/atm/attackby(obj/item/I as obj, mob/user as mob)
	if(inoperable())
		to_chat(user, SPAN_NOTICE("你试图使用它，但它似乎没有通电！"))
		return //so it doesnt brazil IDs when unpowered
	if(istype(I, /obj/item/card))
		var/obj/item/card/id/idcard = I
		if(!held_card)
			usr.drop_held_item()
			idcard.forceMove(src)
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
	else if(authenticated_account)
		if(istype(I,/obj/item/spacecash))
			var/obj/item/spacecash/spacecash = I
			//consume the money
			if(spacecash.counterfeit)
				authenticated_account.money += floor(spacecash.worth * 0.25)
				visible_message(SPAN_DANGER("你将[I]装入[src]时，它开始冒火花并发出错误提示音！"))
				spark_system.start()
			else
				authenticated_account.money += spacecash.worth
			if(prob(50))
				playsound(loc, 'sound/items/polaroid1.ogg', 15, 1)
			else
				playsound(loc, 'sound/items/polaroid2.ogg', 15, 1)

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = GLOB.current_date_string
			T.time = worldtime2text()
			authenticated_account.transaction_log.Add(T)

			to_chat(user, SPAN_INFO("你将[I]插入[src]。"))
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/structure/machinery/atm/proc/drop_money(turf)
		playsound(turf, "sound/machines/ping.ogg", 15)
		new /obj/item/spacecash/c100(turf)

/obj/structure/machinery/atm/attack_hand(mob/user as mob)
	if(isRemoteControlling(user))
		to_chat(user, SPAN_DANGER("[icon2html(src, usr)] 已识别人工单位。根据维兰德-汤谷第1005号规定，人工单位目前不领取货币报酬。"))
		return
	if(get_dist(src,user) <= 1)

		//js replicated from obj/structure/machinery/computer/card
		var/dat = "<h1>维兰德-汤谷自动取款机</h1>"
		dat += "满足你所有的金融需求！<br>"
		dat += "<i>本终端标识：</i>[machine_id]。<i>联系维兰德-汤谷技术支持时，请提供此编号。</i><br/>"

		dat += "身份卡：<a href='byond://?src=\ref[src];choice=insert_card'>[held_card ? held_card.name : "------"]</a><br><br>"

		if(ticks_left_locked_down > 0)
			dat += SPAN_ALERT("密码尝试次数已达上限！此自动取款机的访问权限暂时被禁用。")
		else if(authenticated_account)
			if(authenticated_account.suspended)
				dat += SPAN_WARNING("<b>此账户已被停用，账户内资金已被冻结。</b>")
			else
				switch(view_screen)
					if(CHANGE_SECURITY_LEVEL)
						dat += "为此账户选择新的安全等级：<br><hr>"
						var/text = "零级——提供账号或身份卡即可访问此账户。电子转账时需要刷卡并输入个人识别码，但不会验证识别码是否正确。"
						if(authenticated_account.security_level != 0)
							text = "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=0'>[text]</a>"
						dat += "[text]<hr>"
						text = "一级——访问此账户或处理交易时，必须手动输入账号及个人识别码。"
						if(authenticated_account.security_level != 1)
							text = "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=1'>[text]</a>"
						dat += "[text]<hr>"
						text = "二级——访问此账户或处理交易时，除账号及个人识别码外，还必须提供身份卡。"
						if(authenticated_account.security_level != 2)
							text = "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=2'>[text]</a>"
						dat += "[text]<hr><br>"
						dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>返回</a>"
					if(VIEW_TRANSACTION_LOGS)
						dat += "<b>交易记录</b><br>"
						dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>返回</a>"
						dat += "<table border=1 style='width:100%'>"
						dat += "<tr>"
						dat += "<td><b>日期</b></td>"
						dat += "<td><b>时间</b></td>"
						dat += "<td><b>交易对象</b></td>"
						dat += "<td><b>事由</b></td>"
						dat += "<td><b>金额</b></td>"
						dat += "<td><b>来源终端标识</b></td>"
						dat += "</tr>"
						for(var/datum/transaction/T in authenticated_account.transaction_log)
							dat += "<tr>"
							dat += "<td>[T.date]</td>"
							dat += "<td>[T.time]</td>"
							dat += "<td>[T.target_name]</td>"
							dat += "<td>[T.purpose]</td>"
							dat += "<td>$[T.amount]</td>"
							dat += "<td>[T.source_terminal]</td>"
							dat += "</tr>"
						dat += "</table>"
						dat += "<A href='byond://?src=\ref[src];choice=print_transaction'>打印</a><br>"
					if(TRANSFER_FUNDS)
						dat += "<b>账户余额：</b>$[authenticated_account.money]<br>"
						dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>返回</a><br><br>"
						dat += "<form name='transfer' action='?src=\ref[src]' method='get'>"
						dat += "<input type='hidden' name='src' value='\ref[src]'>"
						dat += "<input type='hidden' name='choice' value='transfer'>"
						dat += "收款账号：<input type='text' name='target_acc_number' value='' style='width:200px; background-color:white;'><br>"
						dat += "转账金额：<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><br>"
						dat += "交易事由：<input type='text' name='purpose' value='资金转账' style='width:200px; background-color:white;'><br>"
						dat += "<input type='submit' class='button' value='转账'><br>"
						dat += "</form>"
					else
						dat += "欢迎，<b>[authenticated_account.owner_name]。</b><br/>"
						dat += "<b>账户余额：</b>$[authenticated_account.money]"
						dat += "<form name='withdrawal' action='?src=\ref[src]' method='get'>"
						dat += "<input type='hidden' name='src' value='\ref[src]'>"
						dat += "<input type='radio' name='choice' value='withdrawal' checked> 现金 <input type='radio' name='choice' value='e_withdrawal'> 储值卡<br>"
						dat += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' class='button' value='取款'>"
						dat += "</form>"
						dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=1'>更改账户安全等级</a><br>"
						dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=2'>转账</a><br>"
						dat += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=3'>查看交易记录</a><br>"
						dat += "<A href='byond://?src=\ref[src];choice=balance_statement'>打印余额对账单</a><br>"
						dat += "<A href='byond://?src=\ref[src];choice=logout'>退出账户</a><br>"
		else
			dat += "<form name='atm_auth' action='?src=\ref[src]' method='get'>"
			dat += "<input type='hidden' name='src' value='\ref[src]'>"
			dat += "<input type='hidden' name='choice' value='attempt_auth'>"
			dat += "<b>账号：</b><input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'><br>"
			dat += "<b>个人识别码：</b><input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><br>"
			dat += "<input type='submit' class='button' value='提交'><br>"
			dat += "</form>"

		show_browser(user, dat, "维兰德-汤谷自动取款机", "atm", width = 550, height = 650)
	else
		close_browser(user,"atm")

/obj/structure/machinery/atm/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["choice"])
		switch(href_list["choice"])
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list["funds_amount"])
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("金额无效。")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = text2num(href_list["target_acc_number"])
						var/transfer_purpose = href_list["purpose"]
						if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
							to_chat(usr, "[icon2html(src, usr)]<span class='info'>资金转账成功。</span>")
							authenticated_account.money -= transfer_amount

							//create an entry in the account transaction log
							var/datum/transaction/T = new()
							T.target_name = "Account #[target_account_number]"
							T.purpose = transfer_purpose
							T.source_terminal = machine_id
							T.date = GLOB.current_date_string
							T.time = worldtime2text()
							T.amount = "([transfer_amount])"
							authenticated_account.transaction_log.Add(T)
						else
							to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("资金转账失败。")]")

					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("你的资金不足，无法执行此操作！")]")
			if("view_screen")
				view_screen = text2num(href_list["view_screen"])
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level = max( min(text2num(href_list["new_security_level"]), 2), 0)
					authenticated_account.security_level = new_sec_level
			if("attempt_auth")

				// check if they have low security enabled
				scan_user(usr)

				if(!ticks_left_locked_down)
					var/tried_account_num = text2num(href_list["account_num"])
					if(!tried_account_num && held_card)
						tried_account_num = held_card.associated_account_number
					var/tried_pin = text2num(href_list["account_pin"])

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
					if(!authenticated_account)
						number_incorrect_tries++
						if(previous_account_number == tried_account_num)
							if(number_incorrect_tries > max_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 25, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									var/datum/transaction/T = new()
									T.target_name = failed_account.owner_name
									T.purpose = "Unauthorised login attempt"
									T.source_terminal = machine_id
									T.date = GLOB.current_date_string
									T.time = worldtime2text()
									failed_account.transaction_log.Add(T)
							else
								to_chat(usr, SPAN_DANGER("[icon2html(src, usr)] 输入的密码与账号不匹配，还剩[max_pin_attempts - number_incorrect_tries]次尝试机会。"))
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 25, 1)
						else
							to_chat(usr, SPAN_DANGER("[icon2html(src, usr)] 输入的密码与账号不匹配。"))
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 25, 1)
						ticks_left_timeout = 120
						view_screen = NO_SCREEN
						number_incorrect_tries = 0

						//create a transaction log entry
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Remote terminal access"
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = worldtime2text()
						authenticated_account.transaction_log.Add(T)

						to_chat(usr, SPAN_NOTICE(" [icon2html(src, usr)] 访问已授权。欢迎，[authenticated_account.owner_name]。"))

					previous_account_number = tried_account_num
			if("e_withdrawal")
				if(withdrawal_timer > world.time)
					alert("请等待 [floor((withdrawal_timer-world.time)/10)] 秒后再尝试取款。")
					return
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("金额无效。")
					withdrawal_timer = world.time + 20
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 25, 1)

						//remove the money
						authenticated_account.money -= amount

						// spawn_money(amount,src.loc)
						spawn_ewallet(amount,src.loc,usr)

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = worldtime2text()
						authenticated_account.transaction_log.Add(T)
						withdrawal_timer = world.time + 20
					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("你的资金不足，无法执行此操作！")]")
						withdrawal_timer = world.time + 20
			if("withdrawal")
				if(withdrawal_timer > world.time)
					alert("请等待 [floor((withdrawal_timer-world.time)/10)] 秒后再尝试取款。")
					return
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("金额无效。")
					withdrawal_timer = world.time + 20
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 25, 1)

						//remove the money
						authenticated_account.money -= amount

						spawn_money(amount,src.loc,usr)

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = worldtime2text()
						authenticated_account.transaction_log.Add(T)
						withdrawal_timer = world.time + 20
					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("你的资金不足，无法执行此操作！")]")
						withdrawal_timer = world.time + 20
			if("balance_statement")
				if(authenticated_account)
					var/obj/item/paper/R = new(src.loc)
					R.name = "账户余额：[authenticated_account.owner_name]"
					R.info = "<b>维兰德-汤谷自动取款机账户对账单</b><br><br>"
					R.info += "<i>账户持有人：</i>[authenticated_account.owner_name]<br>"
					R.info += "<i>账号：</i>[authenticated_account.account_number]<br>"
					R.info += "<i>余额：</i>$[authenticated_account.money]<br>"
					R.info += "<i>日期与时间：</i>[worldtime2text()]，[GLOB.current_date_string]<br><br>"
					R.info += "<i>服务终端标识：</i>[machine_id]<br>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/items/paper.dmi')
					stampoverlay.icon_state = "paper_stamp-weyyu"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/tool/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>本纸张已由维兰德-汤谷自动取款机盖章。</i>"

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 15, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 15, 1)
			if ("print_transaction")
				if(authenticated_account)
					var/obj/item/paper/R = new(src.loc)
					R.name = "交易记录：[authenticated_account.owner_name]"
					R.info = "<b>交易记录</b><br>"
					R.info += "<i>账户持有人：</i>[authenticated_account.owner_name]<br>"
					R.info += "<i>账号：</i>[authenticated_account.account_number]<br>"
					R.info += "<i>日期与时间：</i>[worldtime2text()]，[GLOB.current_date_string]<br><br>"
					R.info += "<i>服务终端标识：</i>[machine_id]<br>"
					R.info += "<table border=1 style='width:100%'>"
					R.info += "<tr>"
					R.info += "<td><b>日期</b></td>"
					R.info += "<td><b>时间</b></td>"
					R.info += "<td><b>交易对象</b></td>"
					R.info += "<td><b>事由</b></td>"
					R.info += "<td><b>金额</b></td>"
					R.info += "<td><b>来源终端标识</b></td>"
					R.info += "</tr>"
					for(var/datum/transaction/T in authenticated_account.transaction_log)
						R.info += "<tr>"
						R.info += "<td>[T.date]</td>"
						R.info += "<td>[T.time]</td>"
						R.info += "<td>[T.target_name]</td>"
						R.info += "<td>[T.purpose]</td>"
						R.info += "<td>$[T.amount]</td>"
						R.info += "<td>[T.source_terminal]</td>"
						R.info += "</tr>"
					R.info += "</table>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/items/paper.dmi')
					stampoverlay.icon_state = "paper_stamp-weyyu"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/tool/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>本纸张已由维兰德-汤谷自动取款机盖章。</i>"

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 15, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 15, 1)

			if("insert_card")
				if(!held_card)
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id))
						usr.drop_held_item()
						I.forceMove(src)
						held_card = I
				else
					release_held_id(usr)
			if("logout")
				authenticated_account = null

	src.attack_hand(usr)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/structure/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(authenticated_account)
		return
	var/obj/item/card/id/card = human_user.get_idcard()
	if(!card)
		return

	authenticated_account = attempt_account_access(card.associated_account_number)
	if(!authenticated_account)
		return

	to_chat(human_user, SPAN_NOTICE("[icon2html(src, human_user)] 访问已授权。欢迎，[authenticated_account.owner_name]。"))

	//create a transaction log entry
	var/datum/transaction/log = new()
	log.target_name = authenticated_account.owner_name
	log.purpose = "Remote terminal access"
	log.source_terminal = machine_id
	log.date = GLOB.current_date_string
	log.time = worldtime2text()
	authenticated_account.transaction_log.Add(log)

	view_screen = NO_SCREEN

// put the currently held id on the ground or in the hand of the user
/obj/structure/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as mob)
	if(!held_card)
		return

	held_card.forceMove(src.loc)
	authenticated_account = null

	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null
/obj/structure/machinery/atm/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in view(1)

	if(!usr || usr.is_mob_incapacitated()) return

	if(ishuman(usr) && held_card)
		to_chat(usr, "你从[src]中取出了[held_card]。")
		held_card.forceMove(get_turf(src))
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(held_card)
		held_card = null
		authenticated_account = null
	else
		to_chat(usr, "[src]里没有可取出的东西。")
	return

/obj/structure/machinery/atm/proc/spawn_ewallet(sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/spacecash/ewallet/E = new /obj/item/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
