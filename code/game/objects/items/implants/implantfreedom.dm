//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implant/freedom
	name = "脱困植入物"
	desc = "用它逃出那些邪恶红衫卫兵的魔爪。"
	implant_color= "r"
	var/activation_emote = "chuckle"
	var/uses = 1


/obj/item/implant/freedom/New()
	src.activation_emote = pick("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	src.uses = rand(1, 5)
	..()
	return


/obj/item/implant/freedom/trigger(emote, mob/living/carbon/source as mob)
	if (src.uses < 1) return 0
	if (emote == src.activation_emote)
		src.uses--
		to_chat(source, "你感觉到一声轻微的咔嗒声。")
		if (source.handcuffed)
			var/obj/item/W = source.handcuffed
			source.handcuffed = null
			source.handcuff_update()
			source.drop_inv_item_on_ground(W)
		if (source.legcuffed)
			var/obj/item/W = source.legcuffed
			source.legcuffed = null
			source.update_inv_legcuffed()
			source.drop_inv_item_on_ground(W)
	return


/obj/item/implant/freedom/implanted(mob/living/carbon/source)
	source.mind.store_memory("脱困植入物可通过[src.activation_emote]表情动作激活，输入<B>say *[src.activation_emote]</B>即可尝试激活。", 0, 0)
	to_chat(source, "体内的脱困植入物可通过[src.activation_emote]表情动作激活，输入<B>say *[src.activation_emote]</B>即可尝试激活。")
	return 1


/obj/item/implant/freedom/get_data()
	var/dat = {"
<b>植入物规格：</b><BR>
<b>名称：</b> 脱困信标<BR>
<b>寿命：</b> 理想情况下可使用5次<BR>
<b>重要提示：</b> <font color='red'>违禁品</font><BR>
<HR>
<b>植入物详情：</b> <BR>
<b>功能：</b> 发射一组特殊信号，强制解除手铐的锁定
机构<BR>
<b>特殊功能：</b><BR>
<i>神经扫描</i>- 分析神经系统中的特定潜在信号<BR>
<b>可靠性：</b> 电池电量极低，植入后通常会
衰减到只能使用1次。<HR>
无其他植入物专属信息"}
	return dat


