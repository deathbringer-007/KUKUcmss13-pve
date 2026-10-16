/*
 * Book
 */
/obj/item/book
	name = "书"
	icon = 'icons/obj/items/books.dmi'
	icon_state ="book_blue"
	throw_speed = SPEED_FAST
	throw_range = 5
	/// upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	w_class = SIZE_MEDIUM
	attack_verb = list("猛击", "敲打", "教育")
	pickup_sound = "sound/handling/book_pickup.ogg"
	drop_sound = "sound/handling/book_pickup.ogg"
	black_market_value = 15 //mendoza likes to read
	/// Actual page content
	var/dat
	/// Game time in 1/10th seconds
	var/due_date = 0
	/// Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/author
	/// 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/unique = 0
	/// The real name of the book.
	var/title
	/// Has the book been hollowed out for use as a secret storage item?
	var/carved = 0
	/// What's in the book?
	var/obj/item/store

/obj/item/book/attack_self(mob/user as mob)
	..()
	if(carved)
		if(store)
			to_chat(user, SPAN_NOTICE("[store]从《[title]》中掉了出来！"))
			store.forceMove(get_turf(src.loc))
			store = null
			return
		else
			to_chat(user, SPAN_NOTICE("《[title]》的书页被挖空了！"))
			return
	if(src.dat)
		show_browser(user, "<body class='paper'><TT><I>所有者：[author]。</I></TT> <BR>[dat]</body>", "window=book", width = 800, height = 600)
		user.visible_message("[user]打开了《[src.title]》。")
		onclose(user, "book")
	else
		to_chat(user, "这本书一片空白！")

/obj/item/book/attackby(obj/item/W as obj, mob/user as mob)
	if(carved)
		if(!store)
			if(W.w_class < SIZE_MEDIUM)
				user.drop_held_item()
				W.forceMove(src)
				store = W
				to_chat(user, SPAN_NOTICE("你把[W]放进《[title]》中。"))
				return
			else
				to_chat(user, SPAN_NOTICE("《[title]》里装不下[W]。"))
				return
		else
			to_chat(user, SPAN_NOTICE("《[title]》里已经放了东西！"))
			return
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		if(unique)
			to_chat(user, "这些书页似乎不吸墨，看来你无法修改它。")
			return
		var/choice = tgui_input_list(usr, "你想修改什么？", "修改书籍", list("书名", "内容", "作者", "取消"))
		switch(choice)
			if("书名")
				var/newtitle = reject_bad_text(stripped_input(usr, "请输入新书名："))
				if(!newtitle)
					to_chat(usr, "书名无效。")
					return
				else
					src.name = newtitle
					src.title = newtitle
					playsound(src, "paper_writing", 15, TRUE)
			if("内容")
				var/content = strip_html(input(usr, "请输入书籍内容（不允许使用 HTML）："),8192)
				if(!content)
					to_chat(usr, "内容无效。")
					return
				else
					src.dat += content
					playsound(src, "paper_writing", 15, TRUE)
			if("作者")
				var/newauthor = stripped_input(usr, "请输入作者姓名：")
				if(!newauthor)
					to_chat(usr, "姓名无效。")
					return
				else
					src.author = newauthor
					playsound(src, "paper_writing", 15, TRUE)
			else
				return

	else if(istype(W, /obj/item/tool/kitchen/knife) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(carved) return
		to_chat(user, SPAN_NOTICE("你开始挖空《[title]》的书页。"))
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_NOTICE("你把《[title]》的书页挖空了！反正你也没打算读。"))
			carved = 1
			return
	else
		..()

/obj/item/book/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_selected == "eyes")
		user.visible_message(SPAN_NOTICE("你打开书给[M]看。"), \
			SPAN_NOTICE("[user]打开书给[M]看。"))
		show_browser(M, "<body class='paper'><TT><I>作者：[author]。</I></TT> <BR>[dat]</body>", "window=book")


