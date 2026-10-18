/obj/item/device/eftpos
	name = "电子转账扫描器"
	desc = "刷身份卡即可进行电子支付。"
	icon_state = "eftpos"
	var/machine_id = ""
	var/eftpos_name = "默认电子转账扫描器"
	var/transaction_locked = 0
	var/transaction_paid = 0
	var/transaction_amount = 0
	var/transaction_purpose = "默认收费"
	var/access_code = 0
	var/datum/money_account/linked_account

/obj/item/device/eftpos/Initialize()
	. = ..()
	machine_id = "[MAIN_SHIP_NAME] EFTPOS #[GLOB.num_financial_terminals++]"
	access_code = rand(1111,111111)
	spawn(0)
		print_reference()

		//create a short manual as well
		var/obj/item/paper/R = new(src.loc)
		R.name = "操作指南：正确使用电子转账终端"
		/*
		R.info += "<b>When first setting up your EFTPOS device:</b>"
		R.info += "1. Memorise your EFTPOS command code (provided with all EFTPOS devices).<br>"
		R.info += "2. Confirm that your EFTPOS device is connected to your local accounts database. For additional assistance with this step, contact Weyland-Yutani IT Support<br>"
		R.info += "3. Confirm that your EFTPOS device has been linked to the account that you wish to receive funds for all transactions processed on this device.<br>"
		R.info += "<b>When starting a new transaction with your EFTPOS device:</b>"
		R.info += "1. Ensure the device is UNLOCKED so that new data may be entered.<br>"
		R.info += "2. Enter a sum of money and reference message for the new transaction.<br>"
		R.info += "3. Lock the transaction, it is now ready for your customer.<br>"
		R.info += "4. If at this stage you wish to modify or cancel your transaction, you may simply reset (unlock) your EFTPOS device.<br>"
		R.info += "5. Give your EFTPOS device to the customer, they must authenticate the transaction by swiping their ID card and entering their PIN number.<br>"
		R.info += "6. If done correctly, the transaction will be logged to both accounts with the reference you have entered, the terminal ID of your EFTPOS device and the money transferred across accounts.<br>"
		*/
		//Temptative new manual:
		R.info += "<b>电子转账终端首次设置：</b><br>"
		R.info += "1. 记住电子转账终端的操作密码（随设备提供）。<br>"
		R.info += "2. 将电子转账终端关联到你希望接收款项的账户。<br><br>"
		R.info += "<b>发起新交易：</b><br>"
		R.info += "1. 输入应收金额以及新交易的事由。<br>"
		R.info += "2. 锁定新交易。若要修改或取消交易，只需重置电子转账终端。<br>"
		R.info += "3. 将电子转账终端交给顾客；顾客必须刷身份卡或余额充足的储值卡以完成交易。<br>"
		R.info += "4. 操作正确后，款项将完成转账。若要解锁设备，需重置电子转账终端。<br>"


		//stamp the paper
		var/image/stampoverlay = image('icons/obj/items/paper.dmi')
		stampoverlay.icon_state = "paper_stamp-rd"
		if(!R.stamped)
			R.stamped = new
		R.offset_x += 0
		R.offset_y += 0
		R.ico += "paper_stamp-rd"
		R.stamped += /obj/item/tool/stamp
		R.overlays += stampoverlay
		R.stamps += "<HR><i>本纸张已由电子转账终端盖章。</i>"

	//by default, connect to the station account
	//the user of the EFTPOS device can change the target account though, and no-one will be the wiser (except whoever's being charged)
	linked_account = GLOB.station_account

/obj/item/device/eftpos/proc/print_reference()
	var/obj/item/paper/R = new(src.loc)
	R.name = "设备资料：[eftpos_name]"
	R.info = "<b>[eftpos_name] 设备资料</b><br><br>"
	R.info += "访问密码：[access_code]<br><br>"
	R.info += "<b>请勿遗失此密码。</b><br>"

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/items/paper.dmi')
	stampoverlay.icon_state = "paper_stamp-rd"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/tool/stamp
	R.overlays += stampoverlay
	R.stamps += "<HR><i>本纸张已由电子转账终端盖章。</i>"
	var/obj/item/smallDelivery/D = new(R.loc)
	R.forceMove(D)
	D.wrapped = R
	D.name = "小包裹——“电子转账终端访问密码”"

/obj/item/device/eftpos/attack_self(mob/user)
	..()
	if(get_dist(src,user) <= 1)
		var/dat = "<i>本终端标识：</i>[machine_id]。<i>联系维兰德-汤谷技术支持时，请提供此编号。</i><br>"
		if(transaction_locked)
			dat += "<a href='byond://?src=\ref[src];choice=toggle_lock'>返回[transaction_paid ? "" : "（需要认证）"]</a><br><br>"

			dat += "交易事由：<b>[transaction_purpose]</b><br>"
			dat += "金额：<b>$[transaction_amount]</b><br>"
			dat += "关联账户：<b>[linked_account ? linked_account.owner_name : "无"]</b><hr>"
			if(transaction_paid)
				dat += "<i>此交易已成功处理。</i><hr>"
			else
				dat += "<i>在下方刷卡即可完成交易。</i><hr>"
				dat += "<a href='byond://?src=\ref[src];choice=scan_card'>\[------\]</a>"
		else
			dat += "<a href='byond://?src=\ref[src];choice=toggle_lock'>锁定新交易</a><br><br>"

			dat += "交易事由：<a href='byond://?src=\ref[src];choice=trans_purpose'>[transaction_purpose]</a><br>"
			dat += "金额：<a href='byond://?src=\ref[src];choice=trans_value'>$[transaction_amount]</a><br>"
			dat += "关联账户：<a href='byond://?src=\ref[src];choice=link_account'>[linked_account ? linked_account.owner_name : "无"]</a><hr>"
			dat += "<a href='byond://?src=\ref[src];choice=change_code'>更改访问密码</a><br>"
			dat += "<a href='byond://?src=\ref[src];choice=change_id'>更改电子转账终端标识</a><br>"
			dat += "刷卡以重置访问密码 <a href='byond://?src=\ref[src];choice=reset'>\[------\]</a>"
		show_browser(user, dat, eftpos_name, "eftpos")
	else
		close_browser(user,"eftpos")

/obj/item/device/eftpos/attackby(O as obj, user as mob)
	if(istype(O, /obj/item/card))
		if(linked_account)
			var/obj/item/card/I = O
			scan_card(I)
		else
			to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("无法连接关联账户。")]")
	else if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		if (linked_account)
			if(!linked_account.suspended)
				if(transaction_locked && !transaction_paid)
					if(transaction_amount <= E.worth)
						playsound(src, 'sound/machines/chime.ogg', 25, 1)
						src.visible_message("[icon2html(src, viewers(src))] [src]发出提示音。")
						transaction_paid = 1

						//transfer the money
						E.worth -= transaction_amount
						linked_account.money += transaction_amount

						//create entry in the EFTPOS linked account transaction log
						var/datum/transaction/T = new()
						T.target_name = E.owner_name //D.owner_name
						T.purpose = (transaction_purpose ? transaction_purpose : "未提供事由。")
						T.amount = transaction_amount
						T.source_terminal = machine_id
						T.date = GLOB.current_date_string
						T.time = worldtime2text()
						linked_account.transaction_log.Add(T)
					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("储值卡余额不足！")]")
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("关联账户已被冻结。")]")
		else
			to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("电子转账终端尚未关联账户。")]")

	else
		..()

/obj/item/device/eftpos/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["choice"])
		switch(href_list["choice"])
			if("change_code")
				var/attempt_code = tgui_input_number(usr, "再次输入当前电子转账终端访问密码", "确认旧访问密码", 1000, 999999, 1000)
				if(attempt_code == access_code)
					var/trycode = tgui_input_number(usr, "输入新的设备访问密码（4至6位，仅数字）", "输入新访问密码", 1000, 999999, 1000)
					if(trycode >= 1000 && trycode <= 999999)
						access_code = trycode
					else
						localized_native_alert(usr, "密码无效！")
					print_reference()
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("输入的密码错误。")]")
			if("change_id")
				var/attempt_code = tgui_input_number(usr, "再次输入当前电子转账终端访问密码", "确认访问密码", 1000, 999999, 1000)
				if(attempt_code == access_code)
					eftpos_name = input("为此设备输入新的终端标识", "输入新终端标识") + "电子转账扫描器"
					print_reference()
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("输入的密码错误。")]")
			if("link_account")
				var/attempt_account_num = tgui_input_number(usr, "输入接收电子转账款项的账号", "新账号", 111111, 999999, 111111)
				var/attempt_pin = tgui_input_number(usr, "输入个人识别码", "账户个人识别码", 1111, 111111, 1111)
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("账户已被冻结。")]")
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("未找到账户。")]")
			if("trans_purpose")
				var/choice = input("输入电子转账交易事由", "交易事由")
				if(choice) transaction_purpose = choice
			if("trans_value")
				var/try_num = tgui_input_number(usr, "输入电子转账金额", "交易金额")
				if(try_num < 0)
					localized_native_alert(usr, "金额无效！")
				else
					transaction_amount = try_num
			if("toggle_lock")
				if(transaction_locked)
					if (transaction_paid)
						transaction_locked = 0
						transaction_paid = 0
					else
						var/attempt_code = tgui_input_number(usr, "输入电子转账终端访问密码", "重置交易", 1000, 999999, 1000)
						if(attempt_code == access_code)
							transaction_locked = 0
							transaction_paid = 0
				else if(linked_account)
					transaction_locked = 1
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("未关联用于接收交易的账户。")]")
			if("scan_card")
				if(linked_account)
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card))
						scan_card(I)
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("无法关联账户。")]")
			if("reset")
				//reset the access code - requires HoP/captain access
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card))
					var/obj/item/card/id/C = I
					if(ACCESS_MARINE_DATABASE in C.access)
						access_code = 0
						to_chat(usr, "[icon2html(src, usr)]<span class='info'>访问密码已重置为0。</span>")

	src.attack_self(usr)

/obj/item/device/eftpos/proc/scan_card(obj/item/card/I)
	if (istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		visible_message(SPAN_INFO("[usr]在[src]上刷了一张卡。"))
		if(transaction_locked && !transaction_paid)
			if(linked_account)
				if(!linked_account.suspended)
					var/attempt_pin = ""
					var/datum/money_account/D = get_account(C.associated_account_number)
					if(D.security_level)
						attempt_pin = tgui_input_number(usr, "输入个人识别码", "电子转账交易", 1111, 111111, 1111)
						D = null
					D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
					if(D)
						if(!D.suspended)
							if(transaction_amount <= D.money)
								playsound(src, 'sound/machines/chime.ogg', 25, 1)
								src.visible_message("[icon2html(src, viewers(src))] [src]发出提示音。")
								transaction_paid = 1

								//transfer the money
								D.money -= transaction_amount
								linked_account.money += transaction_amount

								//create entries in the two account transaction logs
								var/datum/transaction/T = new()
								T.target_name = "[linked_account.owner_name]（经由[eftpos_name]）"
								T.purpose = transaction_purpose
								if(transaction_amount > 0)
									T.amount = "([transaction_amount])"
								else
									T.amount = "[transaction_amount]"
								T.source_terminal = machine_id
								T.date = GLOB.current_date_string
								T.time = worldtime2text()
								D.transaction_log.Add(T)
								//
								T = new()
								T.target_name = D.owner_name
								T.purpose = transaction_purpose
								T.amount = "[transaction_amount]"
								T.source_terminal = machine_id
								T.date = GLOB.current_date_string
								T.time = worldtime2text()
								linked_account.transaction_log.Add(T)
							else
								to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("你的余额不足！")]")
						else
							to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("你的账户已被冻结。")]")
					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("无法访问账户，请检查安全设置后重试。")]")
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("关联账户已被冻结。")]")
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("电子转账终端尚未关联账户。")]")
