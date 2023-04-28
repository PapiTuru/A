local encrypted = true

local shouldCancel = false
local fasttelephone = false
local fastbuydl = false

local wrenchmode = ""
local wrenchname = ""
local fastwrench = false

local fastdrop = false
local fasttrash = false
local fdftcount = 0

local phonex = 0
local phoney = 0

local chekergems = false
local sg = 0

local lastjoinedworld = "EXIT"

local lastjoinedname = ""
local lastjoinednetid = ""
local saveworld = ""

local autospam = false
local autospamtext = "`9Set Spam Text"
local autospamdelay = 3000

local telephonex = 0
local telephoney = 0

local lastfakespin = ""

local shownamespin = true

local blockfound = true
local blockemptyspam = true
local blocksdb = true

local btkmode = false
local skipautobtk = false
local btkwinner = 0
local btkcount = 0
local selectbtk = false
local btk1pos1x = 0
local btk1pos1y = 0
local btk1pos2x = 0
local btk1pos2y = 0
local btk1pos3x = 0
local btk1pos3y = 0
local btk2pos1x = 0
local btk2pos1y = 0
local btk2pos2x = 0
local btk2pos2y = 0
local btk2pos3x = 0
local btk2pos3y = 0

local gtax = 5
local currentgame = 0
local pos1_x = 0
local pos1_y = 0
local pos2_x = 0
local pos2_y = 0

function log(text)
    local packet = {}
    packet[0] = "OnConsoleMessage"
    packet[1] = "`0[`^Bang#2633`0]`o " .. text
    packet.netid = -1
    SendVarlist(packet)
end

function netidfromname(username)
    for _, item in pairs(GetPlayers()) do
        if string.sub(item.name, 3, string.len(item.name) - 2) == username then
            return math.floor(item.netid)
        end
    end
    return GetLocal().netid
end

function namefromnetid(netid)
    for _, item in pairs(GetPlayers()) do
        if item.netid == netid then
            return item.name
        end
    end
    return GetLocal().netid
end

function collectrange(range)
    for y = range, -range, -1 do
        for x = range, -range, -1 do
            collect(math.floor(GetLocal().pos_x // 32) + x, math.floor(GetLocal().pos_y // 32) + y)
        end
    end
end

function overlayText(text)
    local var = {}
    var[0] = "OnTextOverlay"
    var[1] = text
    var.netid = -1
    SendVarlist(var)
end

function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
       end
       last_end = e+1
       s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
       cap = pString:sub(last_end)
       table.insert(Table, cap)
    end
    return Table
end

local verify = [[{
    "content": "",
    "embeds": [{
        "title": "**Logs Online Bang Premium Proxy**",
        "description": "",
        "url": "https://ibb.co/zX1nYnw",
        "color": 5814783,
        "fields": [{
            "name": "Massage From **]]..GetLocal().name..[[**",
            "value": "New Logging Using Bang Proxy Whit UID ]]..GetLocal().userid..[["
        }],
        "author": {
            "name": "BangLogs",
            "url": "https://ibb.co/zX1nYnw",
            "icon_url": "https://ibb.co/zX1nYnw"
        },
        "footer": {
            "text": "Current World : ]]..GetLocal().world..[[",
            "icon_url": "https://ibb.co/C2sPhVF"
        },
        "timestamp": ""
    }]
}]]
local notverify = [[{
    "content": "",
    "embeds": [{
        "title": "**Logs Online Bang Premium Proxy**",
        "description": "",
        "url": "https://discord.gg/e4Mg7TfHbd",
        "color": 5814783,
        "fields": [{
            "name": "This Is Failed Use By **]]..GetLocal().name..[[**",
            "value": "Someone Want To Use Ur Premium Proxy Whit UID ]]..GetLocal().userid..[[. But I Can't Find His UID In The Database"
        }],
        "author": {
            "name": "BangLogs",
            "url": "https://ibb.co/zX1nYnw",
            "icon_url": "https://ibb.co/zX1nYnw"
        },
        "footer": {
            "text": "Current World : ]]..GetLocal().world..[[",
            "icon_url": "https://ibb.co/C2sPhVF"
        },
        "timestamp": ""
    }]
}]]
local webhook = "https://discord.com/api/webhooks/1100842089211760781/hRBMB6I67xyDs28XIh_aciEjEI4Y8aajIQHgjekLbgRb54xBJszsfdobdNtSIncAQrRC"


if encrypted then
    overlayText("`9Checking `2UserID")
    Sleep(1000)
    load(httprequest("https://rentry.co/db_bangproxy/raw", "get"))()
    local userchek = false
    for _,uids in pairs(uid) do
    nameee = GetLocal().userid
    if nameee == uids then
        overlayText("`9Your Account `2VERIFIED `9On Database")
        SendWebhook(webhook, verify)
        userchek = true
    end
end
    if userchek == false then
        overlayText("`9Your Account `4NOT VERIFIED `9On Database")
        SendWebhook(webhook, notverify)
        Sleep(1000)
        return false
    end
end

function use(id, x, y)
    local pkt = {}
    pkt.type = 3
    pkt.int_data = id
    pkt.pos_x = GetLocal().pos_x
    pkt.pos_y = GetLocal().pos_y 
    pkt.int_x = x
    pkt.int_y = y
    pkt.flags = 2560
    SendPacketRaw(pkt)
end

function shatter(id)
    local packet = {}
    packet.type = 10 
    packet.int_data = id
    SendPacketRaw(packet)
end

function chat(message)
    SendPacket(2, "action|input\n|text|" .. message)
end

function place(x, y, id)
    local pkt = {}
    pkt.type = 3
    pkt.flags = 2560
    pkt.int_data = id
    pkt.int_x = x
    pkt.int_y = y
    pkt.pos_x = GetLocal().pos_x
    pkt.pos_y = GetLocal().pos_y
    SendPacketRaw(pkt)
end

function pullnetid(netid)
    SendPacket(2, "action|wrench\n|netid|" .. netid)
    SendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|" .. netid .. "|\nnetID|" .. netid .. "|\nbuttonClicked|pull")
    return true
end

function getgemsbyblock(x, y)
    gems = 0
    for _,item in pairs(GetObjects()) do
        if item.pos_x // 32 == x and item.pos_y // 32 == y and item.id == 112 then
            gems = gems + item.count
        end
    end
    return math.floor(gems)
end

function checkgems()
    while chekergems do
        if GetLocal().world ~= "EXIT" then
        Local_Gems = GetLocal().gems
        Sleep(1000)
        if Local_Gems ~= GetLocal().gems then
        Sleep(150)
        speechbubble("`9Collected `2+"..math.floor(GetLocal().gems -Local_Gems).." `9Gems")
        sg = sg + math.floor(GetLocal().gems -Local_Gems)
        end
        end
    end
end

function blinks()
    local skin= {1685231359, 2022356223, 2190853119, 2527912447, 2864971775, 3033464831, 3370516479, 1348237567, 2749215231, 3317842431, 726390783, 713703935, 3578898943, 4042322175, 3531226367, 4023103999, 194314239, 1345519520}
    while blink do
        SendPacket(2,"action|setSkin\ncolor|".. skin[math.random(#skin)]); Sleep(600);
    end
end

function drop(itemID, count)
    SendPacket(2,"action|drop\n|itemID|" .. itemID)
    SendPacket(2,"action|dialog_return\ndialog_name|drop\nitem_drop|".. itemID .. "|\nitem_count|".. count)
end

function warp(world)
	SendPacket(3, "action|join_request\nname|" .. world .. "\ninvitedWorld|0")
end

function cdrop(count)
    shouldCancel = true
    tonumber(count)
    local wl = count % 100
    local dl = math.floor(count / 100) % 100
    local bgl = math.floor(count / 10000)

    local dlinventory = 0
    local wlinventory = 0
    local bglinventory = 0

    for _, item in pairs(GetInventory()) do
        if (item.id == 242) then
            wlinventory = item.count
        end
        if (item.id == 1796) then
            dlinventory = item.count
        end
        if (item.id == 7188) then
            bglinventory = item.count
        end
    end

    --drop
    if bgl ~= 0 then
        if bglinventory < bgl then
            drop(1796, 100 * bgl)
        else
            drop(7188, bgl)
        end
        log("`9Dropped `2" .. tostring(math.floor(bgl)) .. " `9Blue Gem Locks")
        Sleep(75)
    end
    if dl ~= 0 then
        if dlinventory < dl and bglinventory > bgl then
            shatter(7188)
        end
        if dlinventory < dl and wlinventory > wl + dl * 100 then
            shatter(242)
        end
        drop(1796, dl)
        log("`9Dropped `2" .. tostring(math.floor(dl)) .. " `9Diamond Locks")
        Sleep(75)
    end
    if wl ~= 0 then
        if wlinventory < wl and dlinventory > dl then
            shatter(1796)
        end
        drop(242, wl)
        log("`9Dropped `2" .. tostring(math.floor(wl)) .. " `9World Locks")
        Sleep(75)
    end
    Sleep(300)
    shouldCancel = false
end

local dialogpacket = ""

function addSpacer(type)
    if type == "big" then
        dialogpacket = dialogpacket .. "add_spacer|big|\n"
    else
        dialogpacket = dialogpacket .. "add_spacer|small|\n"
    end
end

function addLabelWithIcon(text, tileid, type)
    if type == "big" then
        dialogpacket = dialogpacket .. "add_label_with_icon|big|" .. text .. "|left|" .. tileid .. "|\n"
    else
        dialogpacket = dialogpacket .. "add_label_with_icon|small|" .. text .. "|left|" .. tileid .. "|\n"
    end 
end

function addButton(buttonname, buttontext)
    dialogpacket = dialogpacket .. "add_button|" .. buttonname .. "|" .. buttontext .. "|noflags|0|0|\n"
end

function addbuttonwhiticon(buttonname, textbutton, frame, itemid)
    dialogpacket = dialogpacket .. "\nadd_button_with_icon|" .. buttonname .. "|" .. textbutton .. "|" .. frame .. "|" .. itemid .. "||"
end

function textsc(text)
    dialogpacket = dialogpacket .. "\ntext_scaling_string|" .. text .. "|"
end

function addCheckbox(checkboxname, checkboxtext, checked)
    if checked then
        dialogpacket = dialogpacket .. "add_checkbox|" .. checkboxname .. "|" .. checkboxtext .. "|1|\n"
    else
        dialogpacket = dialogpacket .. "add_checkbox|" .. checkboxname .. "|" .. checkboxtext .. "|0|\n"
    end
end

function addTextBox(text)
    dialogpacket = dialogpacket .. "add_textbox|" .. text .. "|left|\n"
end

function addSmallText(text)
    dialogpacket = dialogpacket .. "add_smalltext|" .. text .. "|\n"
end

function addInputBox(name, text, cont, size)
    dialogpacket = dialogpacket .. "add_text_input|" .. name .. "|" .. text .. "|" .. cont .. "|" .. size .. "|\n"
end

function addQuickExit()
    dialogpacket = dialogpacket .. "add_quick_exit|\n"
end

function addEndDialog(name, accept, cancel)
    dialogpacket = dialogpacket .. "end_dialog|" .. name .. "|" .. cancel .. "|" .. accept .. "|\n"
end

function endlist()
    dialogpacket = dialogpacket .. "\nadd_button_with_icon||END_LIST|noflags|0|0|"
end

function addCustom(packet)
    dialogpacket = dialogpacket .. packet .. "\n"
end

function finishDialog()
    local var = {} --make table
    var[0] = "OnDialogRequest"
    var[1] = dialogpacket
    var.netid = -1 --need to put netid or it doesn't work
    SendVarlist(var)
    dialogpacket = ""
end

function proxy()
    addLabelWithIcon("`9Flauton Proxy Command", "7188", "big")
    addSpacer("small")
    addTextBox("`2Information:")
    addTextBox("`9/proxy (Show Commands)")
    addTextBox("`9/credit (Show Credit About This Script)")
    addTextBox("`9/update (Show Update About This Script)")
    addTextBox("`9/ping (Show Your Ping)")
    --addTextBox("`9/discord (Opens Flauton Proxy Discord Server)")
    addSpacer("small")
    addTextBox("`2Main Features:")
    addTextBox("`9/cdrop & /cd [Amount] (Drops Costum Amount Of WLS)")
    addTextBox("`9/ddrop & /dd [Amount] (Drops Costum Amount Of DLS)")
    addTextBox("`9/bdrop & /bd [Amount] (Drops Costum Amount Of BGLS)")
    addTextBox("`9/daw (Drops All Your WLS/DLS/BGLS)")
    addTextBox("`9/split [%] (Split And Drops A Portion Of Current World Lock Balance In %)")
    addTextBox("`9/wm (Fast Wrench Toggle)")
    addTextBox("`9/wrench (Fast Wrench Menu)")
    addTextBox("`9/cbgl (Fast Change BGL)")
    addTextBox("`9/cdl (Join To Preverius World)")
    addTextBox("`9/setphone (Set Position Telephone)")
    addTextBox("`9/autocbgl (Toggle Auto Change BGL)")
    addTextBox("`9/fd (Fast Drop Toggle)")
    addTextBox("`9/ft (Fast Trash Toggle)")
    addTextBox("`9/count [Amount] (Amount Fast Drop Or Trash)")
    addSpacer("small")
    addTextBox("`2Auto Hoster")
    addTextBox("`9/btkmode (Menu For BTK Mode)")
    addTextBox("`9/game [Amount] (Set Amount Game For Auto Hoster)")
    addTextBox("`9/tax (Set Your Costum Tax Amount)")
    addTextBox("`9/tp (Starts Auto Hoster `4[Don't Move]`9)")
    addTextBox("`9/pos1 (Set Pos 1 For Auto Hoster To Teleport)")
    addTextBox("`9/pos2 (Set Pos 2 For Auto Hoster To Teleport)")
    addTextBox("`9/win1 (Drops Prize To Pos 1 `4[Don't Move]`9)")
    addTextBox("`9/win2 (Drops Prize To Pos 2 `4[Don't Move]`9)")
    addTextBox("`9/gems (Show Gems Cheker)")
    addTextBox("`9/sg (Chat Gems Cheker When Collect Gems)")
    addTextBox("`9/gr (Reset Gems Cheker To 0)")
    addTextBox("`9/check (Check Gems Winner)")
    addTextBox("`9/gdrop & /gd (Drops Amount Game Whit Eat Tax)")
    addTextBox("`9/tdrop & /td (Drops Amount Tax Whit Eat Game)")
    addTextBox("`9/dp [Amount] (Deposit Your BGLS To Bank)")
    addTextBox("`9/wd [Amount] (Withdraw Your BGLS From Bank)")
    addSpacer("small")
    addTextBox("`2Other")
    addTextBox("`9/blink (Blink Your Player Color)")
    addTextBox("`9/res (Fast Respawn Command)")
    addTextBox("`9/warp [WORLD] (Fast Warp To Other World)")
    addTextBox("`9/back (Join Previous World)")
    addTextBox("`9/relog (Fast Relog World)")
    addTextBox("`9/save [World] (Join To Your Save World)")
    addTextBox("`9/spam (Toggle Set Auto Spam Text)")
    addTextBox("`9// (Start / Stop Spam)")
    addTextBox("`9/collect (Auto Collect 10 Far)")
    addTextBox("`9/block (Menu For Can't See SDB,DLL)]")
    addSpacer("small")
    addQuickExit()
    addEndDialog("command", "`wOkay", "`wCancel")
    finishDialog()
end

function credit()
    addLabelWithIcon("`9Credit", "9474", "big")
    addSpacer("small")
    addTextBox("`9Script Made by: `2Flauton#6796")
    addSpacer("small")
    addTextBox("`9Special `2Tanks `9To:")
    addSmallText("`1Hitoari#2327 `9For Some Function")
    addSmallText("`1! vaccat#7777 `9For Some Function")
    addSmallText("`1Growpai `9For Application")
    addSpacer("small")
    addQuickExit()
    addEndDialog("credit", "`wOkay", "`wCancel")
    finishDialog()
end

function update()
    addLabelWithIcon("`9Update Information", "9474", "big")
    addSpacer("small")
    addLabelWithIcon("`2Update V1", "2978", "small")
    addSmallText("`2[+] `9Proxy Release With Many Fiture")
    addSpacer("small")
    addLabelWithIcon("`2Update V1.2", "758", "small")
    addSmallText("`2[+] `9Added Many Fiture For Auto Hoster")
    addSmallText("`2[+] `9Added Function For Join World")
    addSpacer("small")
    addLabelWithIcon("`2Update V1.3", "32", "small")
    addSmallText("`2[+] `9Added Fast Roulete Wheel")
    addSmallText("`2[+] `9Added Command Check Gems Fiture")
    addSmallText("`2[+] `9Added Command Chat Collected When Take Gems")
    addSpacer("small")
    addLabelWithIcon("`2Update V1.4", "5956", "small")
    addSmallText("`2[+] `9Added Command /bdrop & /bd")
    addSmallText("`2[-] `9Deleted Visual Item/Clothes")
    addSmallText("`2[+] `9Added Command Chat Collected When Take Gems")
    addSpacer("small")
    addLabelWithIcon("`2Update V1.5", "2480", "small")
    addSmallText("`2[+] `9Last Wheel Spin")
    addSmallText("`2[+] `9Added Fast Drop And Trash")
    addSmallText("`2[+] `9Added Show Last Spin People")
    addSmallText("`2[+] `9Added Discord Link")
    addSmallText("`2[/] `9Change Logs For Wrench,Spam,Etc")
    addSmallText("`2[/] `9Last Version")
    addSmallText("`2[/] `9Fixed Bugs")
    addQuickExit()
    addEndDialog("update", "`wOkay", "`wCancel")
    finishDialog()
end

--function discord()
    --addLabelWithIcon("`9Flauton Proxy Discord Server", "7188", "big")
    --addSpacer("small")
    --addTextBox("`cThanks For Using `9Flauton Premium Proxy `cWe Welcome You To Join Official `9Flauton's Community!`c. Click The Button Below:")
    --addCustom("add_url_button|flauton|`9Flauton's Community|noflags|https://discord.gg/flauton|would you like to join Flauton's Community?|0|0|")
    --addSpacer("small")
    --addQuickExit()
    --addEndDialog("discord", "", "`wThanks for the info!")
    --finishDialog()
--end

function wrench()
    addLabelWithIcon("`9Wrench Mode", "32", "big")
    addSpacer("small")
    textsc("aaaaaaaa")
    addSpacer("small")
    if wrenchmode == "pull" or wrenchmode == "kick" or wrenchmode == "ban" then
        addTextBox("`cCurrently Wrench Mode Is `2Enabled `cAnd Is Set To: ".. wrenchname)
    end
    if wrenchmode == "" then
        addTextBox("`cCurrently Wrench Mode Is `4Disable `cAnd You Can't Fast Wrench.")
    end
    addSpacer("small")
    if wrenchmode == "ban" then
        addbuttonwhiticon("wmban", "`4Ban", "staticYellowFrame", "32")
    else
        addbuttonwhiticon("wmban", "`4Ban", "staticPurpleFrame", "32")
    end
    if wrenchmode == "kick" then
        addbuttonwhiticon("wmkick", "`4Kick", "staticYellowFrame", "32")
    else
        addbuttonwhiticon("wmkick", "`4Kick", "staticPurpleFrame", "32")
    end
    if wrenchmode == "pull" then
        addbuttonwhiticon("wmpull", "`pPull", "staticYellowFrame", "32")
    else
        addbuttonwhiticon("wmpull", "`pPull", "staticPurpleFrame", "32")
    end
    if wrenchmode == "" and fastwrench then
        fastwrench = false
        log("`9Fast Wrench `4OFF")
    end
    addbuttonwhiticon("wmoff", "`4Disable", "", "170")
    endlist()
    addSpacer("small")
    addCheckbox("togglefastwrench", "`2Enable `9Fast Wrench", fastwrench)
    addQuickExit()
    addEndDialog("wrench", "`wOkay", "`wCancel")
    finishDialog()
end

-------------------------

function tax(bet,taxp)
    taxpp = tonumber(taxp)
    betp = tonumber(bet)
    return math.floor(taxpp / 100 * betp)
end

function format(count)
    tonumber(count)
    local wl = count % 100
    local dl = math.floor(count / 100) % 100
    local bgl = math.floor(count / 10000)

    returnstring = ""

    if bgl == 0 and dl == 0 and wl == 0 then
        return "0 WL"
    end

    if bgl ~= 0 then
        if dl ~= 0 or wl ~= 0 then
            returnstring = returnstring .. math.floor(bgl) .. "BGL "
        else
            returnstring = returnstring .. math.floor(bgl) .. "BGL"
        end
    end
    if dl ~= 0 then
        if wl ~= 0 then
            returnstring = returnstring .. math.floor(dl) .. "DL "
        else
            returnstring = returnstring .. math.floor(dl) .. "DL"
        end
    end
    if wl ~= 0 then
        returnstring = returnstring .. math.floor(wl) .. "WL"
    end
    return returnstring
end

function btkcheck()
    RunThread(function()
        if btkmode == true then
            pos1gems = 0
            pos2gems = 0
            -- RETARDED SOLUTION PART 3, USE TABLES
            pos1gems = pos1gems + getgemsbyblock(btk1pos1x, btk1pos1y)
            pos1gems = pos1gems + getgemsbyblock(btk1pos2x, btk1pos2y)
            pos1gems = pos1gems + getgemsbyblock(btk1pos3x, btk1pos3y)
            pos2gems = pos2gems + getgemsbyblock(btk2pos1x, btk2pos1y)
            pos2gems = pos2gems + getgemsbyblock(btk2pos2x, btk2pos2y)
            pos2gems = pos2gems + getgemsbyblock(btk2pos3x, btk2pos3y)
            log("`9Checked Gems, Player 1 Has `2" .. pos1gems .. " `9Gems. Player 2 Has `2" .. pos2gems .. " `9Gems.")
            overlayText("`9Checked Gems, Player 1 Has `2" .. pos1gems .. " `9Gems. Player 2 Has `2" .. pos2gems .. " `9Gems.")
            if pos1gems > pos2gems then
                btkwinner = 1
            else
                btkwinner = 2
            end
        else
            log("`9Turn On BTK Mode Firts")
            autobtk = false
            return
        end
    end)
end

function win1()
    if pos1_x == 0 and pos2_x == 0 or currentgame == 0 then
        log("`9Set Pos1 and Pos2 And Game Amount First")
        return true
    end
    RunThread(function()
        curx = GetLocal().pos_x // 32
        cury = GetLocal().pos_y // 32

        FindPath(pos1_x, pos1_y)
        Sleep(500)
        cdrop(currentgame * 2 - tax(currentgame * 2, gtax))
        Sleep(50)
        FindPath(curx, cury)

        if btkmode then
            collect(btk1pos1x, btk1pos1y)
            Sleep(25)
            collect(btk1pos2x, btk1pos2y)
            Sleep(25)
            collect(btk1pos3x, btk1pos3y)
            Sleep(25)
            collect(btk2pos1x, btk2pos1y)
            Sleep(25)
            collect(btk2pos2x, btk2pos2y)
            Sleep(25)
            collect(btk2pos3x, btk2pos3y)
        end
    end)
    return true
end

function win2()
    if pos1_x == 0 and pos2_x == 0 or currentgame == 0 then
        log("`9Set Pos1 and Pos2 And Game Amount First")
        return true
    end
    RunThread(function()
        curx = GetLocal().pos_x // 32
        cury = GetLocal().pos_y // 32

        FindPath(pos2_x, pos2_y)
        Sleep(325)
        cdrop(currentgame * 2 - tax(currentgame * 2, gtax))
        Sleep(50)
        FindPath(curx, cury)

        if btkmode then
            collect(btk1pos1x, btk1pos1y)
            Sleep(25)
            collect(btk1pos2x, btk1pos2y)
            Sleep(25)
            collect(btk1pos3x, btk1pos3y)
            Sleep(25)
            collect(btk2pos1x, btk2pos1y)
            Sleep(25)
            collect(btk2pos2x, btk2pos2y)
            Sleep(25)
            collect(btk2pos3x, btk2pos3y)
        end
    end)
    return true
end

function speechbubble(text)
    local var = {} --make table
    var[0] = "OnTalkBubble"
    var[1] = math.floor(GetLocal().netid)
    var[2] = text
    var.netid = -1
    SendVarlist(var)
end

function collectoid(oid,x,y)
    local p = {
        type = 11,
        int_data = oid,
        pos_x = x,
        pos_y = y
    }
    SendPacketRaw(p)
end

function collect(x,y)
    for _,item in pairs(GetObjects()) do
        if item.pos_x // 32 == x and item.pos_y // 32 == y then
            collectoid(item.oid, item.pos_x, item.pos_y)
        end
    end
end

function startspam()
    RunThread(function()
        while autospam do
            chat(autospamtext)
            Sleep(autospamdelay)
        end
    end)
end

function gocbgl()
    if telephonex == 0 and telephoney == 0 then
        log("`9Set Position Telephone First")
        return
    end
    if telephoneworld ~= GetLocal().world then
        log("`9Not in world `2" .. telephoneworld .. ". `4Disabled `9Auto Change BGL")
        return
    end
    RunThread(function()
        curx = GetLocal().pos_x // 32
        cury = GetLocal().pos_y // 32
        FindPath(telephonex, telephoney)
        Sleep(100)
        use(32, telephonex, telephoney)
        Sleep(50)
        FindPath(curx, cury)
    end)
end
 
AddCallback("commandsss", "OnPacket", function (type, packet)
    if (type == 2 and packet:find("/proxy")) then
        RunThread(function()
            proxy()
        end)
        return true
    end

    if (type == 2 and packet:find("/credit")) then
        RunThread(function()
            credit()
        end)
        return true
    end

    if (type == 2 and packet:find("/update")) then
        RunThread(function()
            update()
        end)
        return true
    end

    if (type == 2 and packet:find("/ping")) then
        if GetPing() > 150 then
        color = "`9"
        end
        if GetPing() > 400 then
        color = "`4"
        end
        if GetPing() < 150 then
        color = "`2"
        end
        
        overlayText("`9Your ping : " .. color .. tostring(GetPing()):gsub(".0", ""))
        return true
    end

    if (type == 2 and packet:find("/cd ") or type == 2 and packet:find("/cdrop ")) then
        RunThread(function()
            local args = split(packet ," ")
            cdrop(args[2])
        end)
        return true
    end

    if (type == 2 and packet:find("/dd ") or type == 2 and packet:find("/ddrop ")) then
        RunThread(function()
            local args = split(packet ," ")
            cdrop(args[2] * 100)
        end)
        return true
    end

    if (type == 2 and packet:find("/bd ") or type == 2 and packet:find("/bdrop ")) then
        RunThread(function()
            local args = split(packet ," ")
            cdrop(args[2] * 10000)
        end)
        return true
    end

    if (type == 2 and packet:find("/daw")) then
        shouldCancel = true
        RunThread(function()
            for _, item in pairs(GetInventory()) do
                if (item.id == 242) then
                    drop(242, item.count)
                    log("`9Dropped `2" .. math.floor(item.count) .. " `9World Locks")
                    Sleep(80)
                end
                if (item.id == 1796) then
                    drop(1796, item.count)
                    log("`9Dropped `2" .. math.floor(item.count) .. " `9Diamond Locks")
                    Sleep(80)
                end
                if (item.id == 7188) then
                    drop(7188, item.count)
                    log("`9Dropped `2" .. math.floor(item.count) .. " `9Blue Gem Locks")
                    Sleep(125)
                end
            end
        end)
        shouldCancel = false
        return true
    end

    if (type == 2 and packet:find("/split ")) then
        local args = split(packet ," ")
        splitpercentage = args[2]
        RunThread(function()
            local inventorywls = 0
            for _, item in pairs(GetInventory()) do
                if (item.id == 242) then
                    inventorywls = inventorywls + item.count
                end
                if (item.id == 1796) then
                    inventorywls = inventorywls + item.count * 100
                end
                if (item.id == 7188) then
                    inventorywls = inventorywls + item.count * 10000
                end
            end
            cdrop(tax(inventorywls, splitpercentage))
        end)
        return true
    end

    if (type == 2 and packet:find("/wm")) then
        RunThread(function()
            if wrenchmode == "" then
                wrench()
                log("`9Set Wrench Mode First")
                return
            end
            if fastwrench then
                fastwrench = false
                log("`9Fast Wrench `4OFF")
            else
                fastwrench = true
                log("`9Fast Wrench `2ON")
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/wrench")) then
        RunThread(function()
            wrench()
        end)
        return true
    end

    if (type == 2 and packet:find("/cbgl")) then
        RunThread(function()
            if fasttelephone then
                fasttelephone = false
                log("`9Fast Change BGL `4OFF")
            else
                fasttelephone = true
                log("`9Fast Change BGL `2ON")
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/cdl")) then
        RunThread(function()
            if fastbuydl then
                fastbuydl = false
                log("`9Fast Change DL `4OFF")
            else
                fastbuydl = true
                log("`9Fast Change DL `2ON")
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/setphone")) then
        telephonex = GetLocal().pos_x // 32
        telephoney = GetLocal().pos_y // 32
        telephoneworld = GetLocal().world
        log("`9Phone Position Set To X: `2" .. telephonex .. " `9Y: `2" .. telephoney)
        return true
    end

    if (type == 2 and packet:find("/autocbgl")) then
        if autocbgl then
            autocbgl = false
            log("`9Auto Change BGL `4OFF")
        else
            autocbgl = true
            log("`9Auto Change BGL `2ON")
        end
        return true
    end

    if (type == 2 and packet:find("/fd")) then
        RunThread(function()
            if fastdrop then
                fastdrop = false
                log("`9Fast Drop `4OFF")
            else
                fastdrop = true
                log("`9Fast Drop `2ON")
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/ft")) then
        RunThread(function()
            if fasttrash then
                fasttrash = false
                log("`9Fast Trash `4OFF")
            else
                fasttrash = true
                log("`9Fast Trash `2ON")
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/count")) then
        local args = split(packet ," ")
        fdftcount = math.floor(args[2])
        if fdftcount == 0 then
            log("`9Fast Count Has Reset")
        else
            log("`9Fast Count Set To `2" .. fdftcount)
        end
        return true
    end

    if (type == 2 and packet:find("/btkmode")) then
        RunThread(function()
            addLabelWithIcon("`9BTK Mode", "340", "big")
            addSpacer("small")
            addCheckbox("ahbtk", "`9BTK Mode", btkmode)
            addCheckbox("ahautobtk", "`9Auto BTK Mode", autobtk)
            addButton("ahselectbtk", "`9Select Tile BTK")
            addQuickExit()
            addEndDialog("ahexit", "`wApply", "`wCancel")
            finishDialog()
        end)
        return true
    end

    if (type == 2 and packet:find("/game ")) then
        local args = split(packet ," ")
        currentgame = math.floor(args[2])
        log("`9Game: `2" .. format(currentgame) .. " `9VS `2" .. format(currentgame) .. " `9| Tax Is `2" .. gtax .. "% `9= `2" .. format(tax(args[2] * 2, gtax)) .. "`9!")
        overlayText("`9Game: `2" .. format(currentgame) .. " `9VS `2" .. format(currentgame) .. " `9| Tax Is `2" .. gtax .. "% `9= `2" .. format(tax(args[2] * 2, gtax)) .. "`9!")
        return true
    end

    if (type == 2 and packet:find("/tax")) then
        RunThread(function()
            addLabelWithIcon("`9Tax Amount Changer", "758", "big")
            addSpacer("small")
            addSmallText("`cTax amount `1will be calculated and auto eat `cTax `1amount of game")
            addInputBox("ahtax", "`cTax amount: %", gtax, "3")
            addQuickExit()
            addEndDialog("texit", "`wSave", "`wCancel")
            finishDialog()
        end)
        return true
    end

    if (type == 2 and packet:find("/tp")) then
        if pos1_x == 0 and pos2_x == 0 and not btkmode then
            log("`9Set Pos1 And Pos2 First")
            return true
        end

        RunThread(function()
            -- set variables
            pos1dropped = 0
            pos2dropped = 0

            -- check both pos
            for index,i in pairs(GetObjects()) do
                if i.pos_x < pos1_x * 32 + pos1_x * 1.5 and i.pos_x > pos1_x * 32 - pos1_x * 1.5 and i.pos_y < pos1_y * 32 + pos1_y * 2 and i.pos_y > pos1_y * 32 - pos1_y * 2 then
                    if i.id == 242.0 then
                        pos1dropped = pos1dropped + i.count
                    end
                    if i.id == 1796.0 then
                        pos1dropped = pos1dropped + i.count * 100
                    end
                    if i.id == 7188.0 then
                        pos1dropped = pos1dropped + i.count * 10000
                    end
                end
                if i.pos_x < pos2_x * 32 + pos2_x * 1.5 and i.pos_x > pos2_x * 32 - pos2_x * 1.5 and i.pos_y < pos2_y * 32 + pos2_y * 2 and i.pos_y > pos2_y * 32 - pos2_y * 2 then
                    if i.id == 242.0 then
                        pos2dropped = pos2dropped + i.count
                    end
                    if i.id == 1796.0 then
                        pos2dropped = pos2dropped + i.count * 100
                    end
                    if i.id == 7188.0 then
                        pos2dropped = pos2dropped + i.count * 10000
                    end
                end
            end
            pos1dropped = math.floor(pos1dropped)
            pos2dropped = math.floor(pos2dropped)

            if pos1dropped ~= pos2dropped then
                log("`9Bet Not Same `2" .. format(pos1dropped) .. " `9VS `1" .. format(pos2dropped))
                overlayText("`9Bet Not same `2" .. format(pos1dropped) .. " `9VS " .. format(pos2dropped))
                return true
            end
            log("`9Game: `2" .. format(pos1dropped) .. " `9VS `2" .. format(pos2dropped) .. " `9| Tax Is `2" .. gtax .. "% `9= `2 " .. format(tax(pos2dropped * 2, gtax)) .. "`9!")
            overlayText("`9Game: `2" .. format(pos1dropped) .. " `9VS `2" .. format(pos2dropped) .. " `9| Tax Is `2" .. gtax .. "% `9= `2 " .. format(tax(pos2dropped * 2, gtax)) .. "`9!")
            currentgame = pos1dropped
            curx = GetLocal().pos_x // 32
            cury = GetLocal().pos_y // 32
            collect(pos1_x, pos1_y)
            collect(pos1_x - 1, pos1_y)
            collect(pos1_x + 1, pos1_y)
            collect(pos2_x, pos2_y)
            collect(pos2_x - 1, pos2_y)
            collect(pos2_x + 1, pos2_y)
        end)
        return true
    end

    if (type == 2 and packet:find("/pos1")) then
        pos1_x = math.floor(GetLocal().pos_x // 32)
        pos1_y = math.floor(GetLocal().pos_y // 32)
        log("`9Set Pos 1 To X: `2" .. pos1_x .. " `9Y: `2" .. pos1_y)
        return true
    end

    if (type == 2 and packet:find("/pos2")) then
        pos2_x = math.floor(GetLocal().pos_x // 32)
        pos2_y = math.floor(GetLocal().pos_y // 32)
        log("`9Set Pos 2 To X: `2" .. pos2_x .. " `9Y: `2" .. pos2_y)
        return true
    end

    if (type == 2 and packet:find("/win1")) then
        win1()
        return true
    end

    if (type == 2 and packet:find("/win2")) then
        win2()
        return true
    end

    if (type == 2 and packet:find("/gems")) then
        RunThread(function()
            if chekergems then
                chekergems = false
                log("`9Checker Gems (gems) `4OFF")
            else
                chekergems = true
                log("`9Checker Gems (gems) `2ON")
                checkgems()
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/sg")) then
        if not chekergems then
            speechbubble("`2ON `9Gems Cheker First(gems)")
            return true
        end
        if sg == 0 then
            chat("`9Nothing Collected, Gems Still `20 (gems)")
            return true
        end
        if sg <= -1 then
            chat("`9Nothing Collected, Gems Still `20 (gems)")
            sg = 0
            return true
        end
        if sg >= 0 then
            chat("`9Collected `2+"..sg.." (gems)")
            sg = 0
            return true
        end
    end

    if (type == 2 and packet:find("/gr")) then
        if not chekergems then
            speechbubble("`2ON `9Gems Cheker First(gems)")
            return true
        end
        if sg >= 1 or sg <= -1 then
            speechbubble("`9Detector Gems Reset To `20 (gems)`9.Last Detect is `2"..sg.." (gems)")
            Sleep(100)
            sg = 0
            return true
        end
        if sg == 0 then
            speechbubble("`9Gems Still `20 (gems)`9, No Reset")
            return true
        end
    end

    if (type == 2 and packet:find("/check")) then
        btkcheck()
        return true
    end

    if (type == 2 and packet:find("/gd") or packet:find("/gdrop")) then
        if currentgame == 0 then
            log("`9Not Detect Bet Amount")
            return true
        end
        RunThread(function()
            cdrop(currentgame * 2 - tax(currentgame * 2, gtax))
        end)
        return true
    end

    if (type == 2 and packet:find("/td") or packet:find("/tdrop")) then
        if currentgame == 0 then
            log("`9Not Detect Bet Amount")
            return true
        end
        RunThread(function()
            cdrop(tax(currentgame * 2, gtax))
        end)
        return true
    end

    if (type == 2 and packet:find("/dp")) then
        local args = split(packet ," ")
        depo = math.floor(args[2])
        if depo == 0 then
            log("`9You Can't Deposit 0 BGLS")
        else
            SendPacket(2, "action|dialog_return\ndialog_name|bank_deposit\nbgl_count|"..depo)
        end
        return true
    end

    if (type == 2 and packet:find("/wd")) then
        local args = split(packet ," ")
        depo = math.floor(args[2])
        if depo == 0 then
            log("`9You Can't Withdraw 0 BGLS")
        else
            SendPacket(2, "action|dialog_return\ndialog_name|bank_withdraw\nbgl_count|"..depo)
        end
        return true
    end

    if (type ==2 and packet:find("/blink")) then
        if blink then
            blink = false
        else
            blink = true
        end
        RunThread(function()
        blinks()
        end)
        return true
    end

    if (type == 2 and packet:find("/res")) then
        SendPacket(2, "action|respawn|")
        return true
    end

    if (type == 2 and packet:find("/back")) then
        RunThread(function()
            warp(lastjoinedworld)
        end)
        return true
    end

    if (type == 2 and packet:find("/relog")) then
        curworld = GetLocal().world
        RunThread(function()
            warp("EXIT")
            Sleep(350)
            warp(curworld)
        end)
        return true
    end

    if (type == 2 and packet:find("/save")) then
        siviworld = packet:sub(packet:find("/save") + 6)
        if (siviworld == nil) or (siviworld == "") or (siviworld == " ") then
         if saveworld ~= nil or saveworld ~= " " or saveworld ~= "" then
                 RunThread(function()
          log("`9Warping To Save World : `2" .. saveworld)
          Sleep(200)
          warp("saveworld")
          Sleep(300)
                end)
         end
        else
                saveworld = siviworld:upper()
                log("`9Save World Set To : `2" .. saveworld)
        end
        return true
    end

    if (type == 2 and packet:find("/spam")) then
        addLabelWithIcon("`9Spam Page", "242", "big")
        addSpacer("small")
        addCheckbox("sptoggle", "`2Enable `cAuto Spam", autospam)
        addSmallText("`cCurrent HotKeys: `2//")
        addSmallText("`2None`c: `2Enable`9/`4Disable `cAuto Spam")
        addSmallText("`2None`c: Spam Text Once")
        addInputBox("sptext", "`cSpam Text", autospamtext, "120")
        addSmallText("`cMinimum Interval is 1000ms. (1000ms is 1second)")
        addInputBox("spdelay", "`c Interval: ms", autospamdelay, "5")
        addSmallText("`cSpamming For A Long Time Can Cause `4Perma Ban`c.")
        addQuickExit()
        addEndDialog("spexit", "`wOkey", "`wCancel")
        finishDialog()
        return true
    end

    if (type == 2 and packet:find("//")) then
        RunThread(function()
            if autospam then
                autospam = false
                log("`9Auto Spam `4OFF")
            else
                autospam = true
                log("`9Auto Spam `2ON")
                startspam()
            end
        end)
        return true
    end

    if (type == 2 and packet:find("/collect")) then
        RunThread(function()
            collectrange(5)
        end)
        return true
    end

    if (type == 2 and packet:find("/block")) then
        RunThread(function()
            addLabelWithIcon("`4Block", "12908", "big")
            addSpacer("small")
            addCheckbox("bfound", "`pBlock Oh, look what you've found", blockfound)
            addCheckbox("bspam", "`pBlock No Spam Text", blockemptyspam)
            addCheckbox("bsdb", "`pBlock Super Duper Broadcast", blocksdb)
            addQuickExit()
            addEndDialog("bexit", "`wApply", "`wCancel")
            finishDialog()
        end)
        return true
    end

    -- FAST WRENCH
    if (packet:find("action|wrench")) then
        netid2 = tonumber(string.sub(packet,22,30))
        name = namefromnetid(netid2)
        if fastwrench and netid2 ~= GetLocal().netid then
            if (wrenchmode:find("pull")) then
                SendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|" .. netid2 .. "|\nnetID|" .. netid2 .. "|\nbuttonClicked|pull")
                overlayText("`wSuccesfully `pPull `0"..name)
            elseif (wrenchmode:find("kick")) then
                SendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|" .. netid2 .. "|\nnetID|" .. netid2 .. "|\nbuttonClicked|kick")
                overlayText("`wSuccesfully `4Kick `0"..name)
            elseif (wrenchmode:find("ban")) then
                SendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|" .. netid2 .. "|\nnetID|" .. netid2 .. "|\nbuttonClicked|world_ban")
                overlayText("`wSuccesfully `4Ban `0"..name)
            end
            return true
        end
    end

    -- FAST WRENCH MENU
    if (packet:find("togglefastwrench|1")) then
        fastwrench = true
        log("`9Fast Wrench `2ON")
    end
    if (packet:find("togglefastwrench|0")) then
        fastwrench = false
        log("`9Fast Wrench `4OFF")
    end
    if (packet:find("buttonClicked|wmpull")) then
        wrenchmode = "pull"
        wrenchname = "`pPull"
        wrench()
    end
    if (packet:find("buttonClicked|wmkick")) then
        wrenchmode = "kick"
        wrenchname = "`4Kick"
        wrench()
    end
    if (packet:find("buttonClicked|wmban")) then
        wrenchmode = "ban"
        wrenchname = "`4Ban"
        wrench()
    end
    if (packet:find("buttonClicked|wmoff")) then
        wrenchmode = ""
        wrenchname = ""
        wrench()
    end

    -- AUTOHOSTER
    if (packet:find("ahbtk|1")) then
        btkmode = true
    end
    if (packet:find("ahbtk|0")) then
        btkmode = false
    end
    if (packet:find("ahautobtk|1")) then
        autobtk = true
    end
    if (packet:find("ahautobtk|0")) then
        autobtk = false
    end
    if (packet:find("buttonClicked|ahselectbtk")) then
        selectbtk = true
        overlayText("`pPunch the block you want to select for BTK mode")
    end

    if (packet:find("ahtax|") and not packet:find("`p")) then
        gtax = string.sub(string.sub(packet, 0, string.len(packet) - 1), packet:find("ahtax|") + 6)
    end

    -- BLOCK MENU
    if (packet:find("bfound|1")) then
        blockfound = true
    end
    if (packet:find("bfound|0")) then
        blockfound = false
    end
    if (packet:find("bspam|1")) then
        blockemptyspam = true
    end
    if (packet:find("bspam|0")) then
        blockemptyspam = false
    end
    if (packet:find("bsdb|1")) then
        blocksdb = true
    end
    if (packet:find("bsdb|0")) then
        blocksdb = false
    end

    -- SPAM MENU
    if (packet:find("sptoggle|1")) then
        startspam()
        autospam = true
    end
    if (packet:find("sptoggle|0")) then
        autospam = false
    end
    if (packet:find("sptext|") and not packet:find("`p")) then
        autospamtext = string.sub(packet, packet:find("sptext|") + 7, packet:find("spdelay|") - 2)
    end
    if (packet:find("spdelay|") and not packet:find("`p")) then
        autospamdelay = string.sub(string.sub(packet, 0, string.len(packet) - 1), packet:find("spdelay|") + 8, packet:find("spdelay|") + 13)
    end

    if (packet:find("action|join_request")) then
        lastjoinedworld = GetLocal().world
    end
end)

AddCallback("onvariantlist", "OnVarlist", function(vlist)
    if vlist[3] == 0 and vlist[2]:find("spun the wheel") then
        RunThread(function()
            Sleep(20)
            spinname = string.sub(vlist[2], 6, vlist[2]:find("spun the wheel") - 3)
            --log(spinname)
            if lastfakespin ~= spinname then
                if shownamespin then
                    dog = string.sub(vlist[2], vlist[2]:find("got") + 6, vlist[2]:find("!]") - 3)
                    --log(dog)
                    ananisikeyim = namefromnetid(math.floor(vlist[1]))
                    if ananisikeyim:find('`c') then
                        ananisikeyim = string.sub(ananisikeyim, 0, ananisikeyim:find("`c") - 5)
                    end
                    local var = {} --make table
                    var[0] = "OnNameChanged"
                    var[1] = ananisikeyim .. " `w[`c" .. dog .. "`w]"
                    var.netid = vlist[1]
                    SendVarlist(var)
                end
                local var = {} --make table
                var[0] = "OnTalkBubble"
                var[1] = math.floor(vlist[1])
                var[2] = "`w[`^REAL`w] " .. vlist[2]
                var[3] = 394
                var[4] = 0
                var.netid = -1
                SendVarlist(var)
            end
        end)
        return true
    end
end)

AddCallback("onvarlist", "OnVarlist", function(vlist)
    if vlist[0]:find("OnDialogRequest") then
        if vlist[1]:find("Drop World Lock") or vlist[1]:find("Drop Diamond Lock") or vlist[1]:find("Drop Blue Gem Lock") or vlist[1]:find("Drop Infinity Gem Lock") and shouldCancel then
            return true
        end

        if fasttelephone then
            if vlist[1]:find("a number to call somebody") then
                splitted = split(vlist[1],"\n")
                phonex = string.sub(tostring(splitted[3]), 14, 15)
                phoney = string.sub(tostring(splitted[4]), 14, 15)
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nx|".. phonex .. "|\ny|".. phoney .."|\nnum|53785")
                return true
            end
            if vlist[1]:find("savior of the wealthy!") then
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. phonex .. "|\ny|".. phoney .."|\nbuttonClicked|bglitem")
                return true
            end
            if vlist[1]:find("sell you a Blue Gem Lock") then
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|".. phonex .. "|\ny|".. phoney .."|\nbuttonClicked|bglconvert")
                return true
            end
            if vlist[1]:find("sell you another Blue Gem Lock") then
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|".. phonex .. "|\ny|".. phoney .."|\nbuttonClicked|bglconvert")
            end
            if vlist[1]:find("end_dialog|telephone|Hang Up") then
                local x,y = vlist[1]:match("embed_data|x|(%d+).-embed_data|y|(%d+)")
                return true
            end
        end

        if fastdrop then
            if vlist[1]:find("How many to drop?") then
                local itemid = string.sub(vlist[1], vlist[1]:find("embed_data|item_drop|") + 21, vlist[1]:find("end_dialog") - 2)
                if fdftcount == 0 then
                    local count = string.sub(vlist[1], vlist[1]:find("item_count||") + 12, vlist[1]:find("|5|\n") - 1)
                    SendPacket(2,"action|dialog_return\ndialog_name|drop\nitem_drop|" .. itemid .. "|\nitem_count|" .. count)
                else
                    SendPacket(2,"action|dialog_return\ndialog_name|drop\nitem_drop|" .. itemid .. "|\nitem_count|" .. fdftcount)
                end
                return true
            end
        end

        if fasttrash then
            if vlist[1]:find("How many to `4destroy") then
                local itemid = string.sub(vlist[1], vlist[1]:find("embed_data|item_trash|") + 22, vlist[1]:find("end_dialog") - 2)
                if fdftcount == 0 then
                    local count = string.sub(vlist[1], vlist[1]:find("you have ") + 9, vlist[1]:find("add_text_input|item_count||") - 9)
                    SendPacket(2, "action|dialog_return\ndialog_name|trash\nitem_trash|" .. itemid .. "|\nitem_count|" .. count)
                else
                    SendPacket(2, "action|dialog_return\ndialog_name|trash\nitem_trash|" .. itemid .. "|\nitem_count|" .. fdftcount)
                end
                
                return true
            end
        end

        if fastbuydl then
            if vlist[1]:find("a number to call somebody") then
                splitted = split(vlist[1],"\n")
                phonex = string.sub(tostring(splitted[3]), 14, 16)
                phoney = string.sub(tostring(splitted[4]), 14, 16)
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nx|".. phonex .. "|\ny|".. phoney .."|\nnum|53785")
                return true
            end
            if vlist[1]:find("savior of the wealthy!") then
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|".. phonex .. "|\ny|".. phoney .."|\nbuttonClicked|diamondlock")
                return true
            end
            if vlist[1]:find("sell you a Diamond Lock") then
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|".. phonex .. "|\ny|".. phoney .."|\nbuttonClicked|dlconvert")
                return true
            end
            if vlist[1]:find("sell you another Diamond Lock") then
                Sleep(50)
                SendPacket(2,"action|dialog_return\ndialog_name|telephone\nnum|53785\nx|".. phonex .. "|\ny|".. phoney .."|\nbuttonClicked|dlconvert")
                return true
            end
        end

        if vlist[1]:find("House Entrance") then
            splitted = split(vlist[1],"\n")
            phonex = string.sub(tostring(splitted[4]), 14, 16)
            phoney = string.sub(tostring(splitted[5]), 14, 16)
            --log("Made public")
            --SendPacket(2, "action|dialog_return\ndialog_name|gateway_edit\nx|" .. phonex .. "|\ny|" .. phoney .. "|\npublic|1")
            --return true
        end
    
        if vlist[0]:find("OnSDBroadcast") then
            if blocksdb then
                return true
            end
        end
    
        --if vlist[0]:find("OnDialogRequest") then
            --if vlist[1]:find("The Creative Discord server") then
                --discord()
                --return true
            --end
        --end

        if blockemptyspam then
            if vlist[2]:find("No spam text set! Use /setspam <text>.") then
                return true
            end
        end

        if blockfound then
            if vlist[2]:find("`1O`2h`3, `4l`5o`6o`7k `8w`9h`ba`!t `$y`3o`2u`4'`ev`pe `#f`6o`8u`1n`7d`w!") then
                return true
            end
        end
    end

    if vlist[0]:find("OnConsoleMessage") then
        if vlist[1]:find("spun the wheel") and vlist[1]:find("CP:_PL") then
            RunThread(function()
                -- CP:_PL:0_OID:_CT:[W]_ `6<`1Turkinpippuri``>`` `$`w[`1Turkinpippuri`` spun the wheel and got `b16``!]``````
                --log(vlist[1]:find("``>`` `"))
                lastfakespin = string.sub(vlist[1], vlist[1]:find("6<`1") + 4, vlist[1]:find("``>"))
                --log(lastfakespin)
                local var = {} --make table
                var[0] = "OnTalkBubble"
                var[1] = math.floor(netidfromname(lastfakespin))
                var[2] = "`w[`4FAKE`w] " .. string.sub(vlist[1], vlist[1]:find(lastfakespin) - 3, string.len(vlist[1]))
                var[3] = 394
                var[4] = 0
                var.netid = -1
                SendVarlist(var)
                Sleep(200)
                lastfakespin = "NONE"
            end)
            return true
        end

        if blockemptyspam then
            if vlist[1]:find("No spam text set! Use /setspam <text>.") then
                return true
            end
        end

        if blockfound then
            if vlist[1]:find("`1O`2h`3, `4l`5o`6o`7k `8w`9h`ba`!t `$y`3o`2u`4'`ev`pe `#f`6o`8u`1n`7d`w!") then
                return true
            end
        end
    end
end)
    
            

AddCallback("onrawpackethook", "OnRawPacket", function(pkt)
    if selectbtk then
        if pkt.type == 0 and pkt.int_x ~= 4294967295 and pkt.int_y ~= 4294967295 then
            RunThread(function()
                EditToggle("ModFly", false)
                EditToggle("AntiBounce", false)
                x = pkt.int_x
                y = pkt.int_y
                -- EVEN MORE RETARDED SOLUTION THAN THE VARIABLES /fp
                if btk1pos1x == 0 and btk1pos1y == 0 then
                    btk1pos1x = x
                    btk1pos1y = y
                    log("`9Tile 1 Pos 1 BTK Mode Set To X: `2" .. btk1pos1x .. " `9Y: `2" .. btk1pos1y)
                    return true
                end
                if btk1pos2x == 0 and btk1pos2y == 0 then
                    btk1pos2x = x
                    btk1pos2y = y
                    log("`9Tile 2 Pos 1 BTK Mode Set To X: `2" .. btk1pos2x .. " `9Y: `2" .. btk1pos2y)
                    return true
                end
                if btk1pos3x == 0 and btk1pos3y == 0 then
                    btk1pos3x = x
                    btk1pos3y = y
                    log("`9Tile 3 Pos 1 BTK Mode Set To X: `2" .. btk1pos3x .. " `9Y: `2" .. btk1pos3y)
                    return true
                end
                if btk2pos1x == 0 and btk2pos1y == 0 then
                    btk2pos1x = x
                    btk2pos1y = y
                    log("`9Tile 1 Pos 2 BTK Mode Set To X: `2" .. btk2pos1x .. " `9Y: `2" .. btk2pos1y)
                    return true
                end
                if btk2pos2x == 0 and btk2pos2y == 0 then
                    btk2pos2x = x
                    btk2pos2y = y
                    log("`9Tile 2 Pos 2 BTK Mode Set To X: `2" .. btk2pos2x .. " `9Y: `2" .. btk2pos2y)
                    return true
                end
                if btk2pos3x == 0 and btk2pos3y == 0 then
                    btk2pos3x = x
                    btk2pos3y = y
                    log("`9Tile 3 Pos 2 BTK Mode Set To X: `2" .. btk2pos3x .. " `9Y: `2" .. btk2pos3y)
                    overlayText("`9BTK Position Has Ben Set!")
                    selectbtk = false
                end
                return true
            end)
        end
    end
    return
end)

timer.Create("shattertimer", 1, 0, function() 
    for _, item in pairs(GetInventory()) do
        if (item.id == 242) then
            if item.count >= 100 then
                shatter(242)
            end
        end
    end
end)

timer.Create("autocbgl", 1, 0, function()
    if not autocbgl then
        return
    end
    for _, item in pairs(GetInventory()) do
        if (item.id == 1796) then
            if item.count >= 100 then
                gocbgl()
            end
        end
    end
end)

timer.Create("autobtk", 1, 0, function()
    if not autobtk then
        return
    end
    if skipautobtk then
        return
    end
    RunThread(function()
        emptyblocks = 0
        for _, item in pairs(GetTiles()) do
            -- this might be the most retarded thing i have in the whole entire 1400 lines of code
            if item.pos_x == btk1pos1x and item.pos_y == btk1pos1y and item.fg == 0 then
                emptyblocks = emptyblocks + 1
            end
            if item.pos_x == btk1pos2x and item.pos_y == btk1pos2y and item.fg == 0 then
                emptyblocks = emptyblocks + 1
            end
            if item.pos_x == btk1pos3x and item.pos_y == btk1pos3y and item.fg == 0 then
                emptyblocks = emptyblocks + 1
            end
            if item.pos_x == btk2pos1x and item.pos_y == btk2pos1y and item.fg == 0 then
                emptyblocks = emptyblocks + 1
            end
            if item.pos_x == btk2pos2x and item.pos_y == btk2pos2y and item.fg == 0 then
                emptyblocks = emptyblocks + 1
            end
            if item.pos_x == btk2pos3x and item.pos_y == btk2pos3y and item.fg == 0 then
                emptyblocks = emptyblocks + 1
            end
        end
        if emptyblocks == 6 then
            curx = GetLocal().pos_x // 32
            cury = GetLocal().pos_y // 32
            skipautobtk = true
            btkcheck()
            Sleep(350)
            if btkwinner == 1 then
                Sleep(200)
                GetLocal().facing_left = true
                win1()
            end
            if btkwinner == 2 then
                Sleep(200)
                GetLocal().facing_left = false
                win2()
            end
            Sleep(1500)
            EditToggle("ModFly", true)
            Sleep(250)
            FindPath(btk1pos2x, btk1pos2y)
            Sleep(500)
            place(btk1pos1x, btk1pos1y, 340)
            Sleep(160)
            place(btk1pos2x, btk1pos2y, 340)
            Sleep(160)
            place(btk1pos3x, btk1pos3y, 340)
            Sleep(250)
            FindPath(btk2pos2x, btk2pos2y)
            Sleep(500)
            place(btk2pos1x, btk2pos1y, 340)
            Sleep(160)
            place(btk2pos2x, btk2pos2y, 340)
            Sleep(160)
            place(btk2pos3x, btk2pos3y, 340)
            Sleep(250)
            FindPath(curx, cury)
            EditToggle("ModFly", false)
            EditToggle("AntiBounce", false)
            Sleep(1000)
            skipautobtk = false
        end
        emptyblocks = 0
    end)
end)

RunThread(function() 
    while true do
        timer.Update(1)
        Sleep(1000)
    end
end)
