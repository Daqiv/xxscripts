require "TSLib"
local ocr = require "cloudOcr"
local sz = require("sz")

local cjson = sz.json
local w,h = getScreenSize();
w,h = getScreenSize()
UINew("唱吧05.30.01","运行脚本","退出脚本","uiconfig.dat",0,120,w*0.9,h*0.9,"255,231,186","255,231,186") --方式一，宽高为屏幕的 90%
UILabel("作者qq:234154812")
--[[UILabel("选择脚本功能")
UICombo("step","关注,私信")
UILabel("输入刷新次数")
UIEdit("freshcts","输入刷新次数","",15,"left","255,0,0")
UILabel("选择聊天对象")
UICombo("chat","已聊,未聊")--]]
--UILabel("是否删除还原计数")
--UICombo("del","no,yes")
--[[UILabel("私聊内容")
UIEdit("contents","个性签名","",15,"left","255,0,0")
UILabel("微信号码")
UIEdit("wxid","微信号码","",15,"left","255,0,0")--]]

--[[UILabel("易码账号")
UIEdit("yimaAccount","易码账号","",15,"left","255,0,0")
UILabel("易码密码")
UIEdit("yimaPwd","易码密码","",15,"left","255,0,0")--]]
--[[UILabel("IP切换方式")
UICombo("ipchange","vpn,airplane")
UILabel("是否设置个人资料")
UICombo("userinfo","yes,no")
UILabel("个性签名")
UIEdit("sign","个性签名","",15,"left","255,0,0")
UILabel("评论内容")
UIEdit("com","评论内容","",15,"left","255,0,0")
UILabel("评论间隔(秒)")
UIEdit("interval","","",15,"left","255,0,0")
UILabel("单号在线时长(分钟)")
UIEdit("online","","",15,"left","255,0,0")--]]
UIShow()

if interval == "" or online =="" then
	dialog("请设置评论间隔以及单号在线时长")	
	lua_exit(); 
end

function myToast(param)
	if 1==1 then
	toast(param)	
	mSleep(1500)
	end
end

function runToast(param)
	toast(param)	
	mSleep(1500)
end



--[[if retTable[1] == 0 then
	runToast("取消运行")
	lua_exit(); 
else
	
end--]]

function notifyMessage(param)
	runToast(param)
end

function clickMove(x1,y1, x2,y2, n)
	local w = math.abs(x2-x1);
	local h = math.abs(y2-y1);
	touchDown(x1,y1); 
	mSleep(50);
	if x1 < x2 then
		w1 = n; 
	else
		w1 = -n;
	end
	if y1 < y2 then
		h1 = n; 
	else
		h1 = -n;
	end
	if w >= h then
		for i = 1 , w,n do 
			x1 = x1 + w1;
			if y1 == y2 then
			else
				y1 = y1 + math.ceil(h*h1/w);
			end
			touchMove(x1,y1);
			mSleep(10);
		end
	else
		for i = 1 ,h,n do 
			y1 = y1 + h1;
			if x1 ==x2 then
			else
				x1 = x1 + math.ceil(w*w1/h);
			end
			touchMove(x1,y1);
			mSleep(10);
		end
	end
	mSleep(50);
	touchUp(x2,y2);
end


function clickMoveQQ(x1,y1, x2,y2,n)
	local w = math.abs(x2-x1);
	local h = math.abs(y2-y1);
	touchDown(x1,y1); 
	mSleep(50);
	if x1 < x2 then
		w1 = n; 
	end
	if w >= h then
		for i = 1 , w*0.7,n do 
			x1 = x1 + w1;
			touchMove(x1,y1);
			mSleep(10);
		end
		
		for i=w*0.7,w,1 do
			x1=x1+1
			touchMove(x1,y1)
			mSleep(10)
		end
	end
	mSleep(1000);
	touchMove(x1,y1+20)
	mSleep(200)
	touchUp(x1,y1+20);
end


--local list = Split("abc,123,345", ",")
function Split(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do  
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
        if not nFindLastIndex then  
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            break  
        end  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end

function randomstring(n)
    local chars = 'abcdefghijklmnopqrstuvwxyz'
    local strs = ''
    math.randomseed(tostring(os.time()):reverse():sub(1,n))
    for i = 1,n do
        local index = math.random(string.len(chars))
        strs = strs..string.sub(chars,index,index)
    end
    return strs
end

--httpget
function myHttpGet(req)
	if req == nil then
		return nil, 400
	end

	--TODO:httpGet 返回值
	local ts = require("ts")	
	local status_resp, header_resp, body_resp = ts.httpGet(req)
	return body_resp, status_resp;
end

function MobileCode(server,uid, pwd, pid)
	local Tmp = {}
	Tmp.token = nil;
	Tmp.Mobile = nil;
	--私人云取号返回p_id
	Tmp.p_id = nil;
	--玉米:获取登录令牌
	function yumiGetToken()						
		local data,code = myHttpGet(string.format('http://api.jyzszp.com/Api/index/loginIn?uid=%s&pwd=%s', uid, pwd))			
		--15033|15033-ixp|eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1
		if data~=nil then
			local key = "|"
			local index = string.find(data, key);
			if index==nil then
				notifyMessage("玉米:登录错误"..data)
				return nil	
			end
			local ret= Split(data,key)
			if #ret<3 then
				notifyMessage("玉米:登录错误"..data)
				return nil
			end
			return ret[3]
		end
		return nil
	end
	--玉米:获取手机号
	function yumiGetMobileNum()				
		if Tmp.token == nil then
			Tmp.token = yumiGetToken();
		end
		if Tmp.token == nil then
			notifyMessage("玉米登录失败。。");
			return Tmp.Mobile;
		end
		if string.len(Tmp.token) < 3 then
			notifyMessage("玉米登录,长度错误:"..string.len(Tmp.token));
		end
		notifyMessage("玉米:发送请求...")		
		local data = nil;
		local code = nil;
		local req = nil;
		req = "http://api.jyzszp.com/Api/index/getMobilenum?"..					
		"&pid="..pid..
		"&uid="..uid..
		"&token="..Tmp.token
		data,code = myHttpGet(req);

		if data == nil then
			notifyMessage("玉米,获取手机应答错误")
			return nil
		end
		Tmp.Mobile = string.match(data, "%d+")
		if string.len(Tmp.Mobile)<8 then
			notifyMessage("玉米,获取手机号码错误:"..code)
			return nil
		end
		return Tmp.Mobile;
	end

	--玉米:获取短信验证码
	function yumiGetVcodeAndReleaseMobile()		
		if Tmp.Mobile == nil then
			notifyMessage("玉米:获取短信，手机号为空")
			return nil;
		end
		local req =nil
		req = "http://api.jyzszp.com/Api/index/getVcodeAndReleaseMobile?"..					
		"&pid="..pid..
		"&uid="..uid..
		"&token="..Tmp.token..
		"&mobile="..Tmp.Mobile..
		"&author_uid=18770"

		local data,code =myHttpGet(req)

		return data;
	end

	--玉米:加黑号码
	function yumiAddIgnoreList(remark)
		if Tmp.Mobile ~= nil then
			local req = nil
			local req = "http://api.jyzszp.com/Api/index/addIgnoreList?"..						
			"&pid="..pid..
			"&uid="..uid..
			"&token="..Tmp.token..
			"&mobile="..Tmp.Mobile				
			myHttpGet(req)			
		end
	end
	
	--私人云:获取登录令牌
	function sirenyunGetToken()
		local data,code = myHttpGet(string.format("http://sry.codesfrom.com:18000/yhapi.ashx?Action=userLogin&userName=%s&userPassword=%s",uid,pwd))
		if data ~= nil then
			local key = "|"
			local index = string.find(data,key)
			if index == nil then
				notifyMessage("私人云:登录错误"..data)
				return nil
			end
			local ret = Split(data,key)
			if #ret < 6 then
				notifyMessage("私人云:登录错误"..data)
				return nil
			end
			return ret[2]
		end
	end
	
	--私人云:获取手机号码
	function sirenyunGetMobileNum()
		if Tmp.token == nil then
			Tmp.token = sirenyunGetToken();
		end
		if Tmp.token == nil then
			notifyMessage("私人云登录失败。。");
			return Tmp.Mobile;
		end
		if string.len(Tmp.token) < 32 then
			notifyMessage("私人云登录,长度错误:"..string.len(Tmp.token));
		end
		notifyMessage("私人云:发送请求...")		
		local data = nil;
		local code = nil;
		local req = nil;
		req = "http://sry.codesfrom.com:18000/yhapi.ashx?Action=getPhone&token="..Tmp.token.."&i_id="..pid

		data,code = myHttpGet(req);

		if data == nil then
			notifyMessage("私人云,获取手机应答错误")
			return nil
		end
		--logDebug(data)
		local key = "|"
		local index = string.find(data,key)
		if index == nil then
			notifyMessage("私人云:获取手机错误")
		end
		local ret = Split(data,key)
		if #ret < 7 then
			notifyMessage("私人云:获取手机错误"..data)
			return nil
		end
		
		Tmp.Mobile = ret[5]
		Tmp.p_id = ret[2]
		return Tmp.Mobile,Tmp.p_id;
	end
	
	--私人云:获取短信验证码
	function sirenyunGetVcodeAndReleaseMobile()
		if Tmp.Mobile == nil then
			notifyMessage("私人云:获取短信，手机号为空")
			return nil;
		end
		local req =nil
		--logDebug(Tmp.token..Tmp.p_id)
		req = "http://sry.codesfrom.com:18000/yhapi.ashx?Action=getPhoneMessage&token="..Tmp.token.."&p_id="..Tmp.p_id
		local data,code =myHttpGet(req)

		return data;		
	end
	
	--私人云:加黑号码
	function sirenyunAddIgnoreList()
			if Tmp.Mobile ~= nil then
			local req = nil
			local req = "http://sry.codesfrom.com:18000/yhapi.ashx?Action=phoneToBlack&token="..Tmp.token.."&p_id="..Tmp.p_id.."&i_id="..pid.."&mobile="..Tmp.Mobile.."&reason=".."无法接受验证码"
			myHttpGet(req)			
		end
	end
	
	--易码:获取登录令牌
	function yimaGetToken()
		local data,code = myHttpGet(string.format('http://api.fxhyd.cn/UserInterface.aspx?action=login&username=%s&password=%s', uid, pwd))			
		--success|token
		if data~=nil then
			local key = "|"
			local index = string.find(data, key);
			if index==nil then
				notifyMessage("易码:登录错误"..data)
				return nil	
			end
			local ret= Split(data,key)
			if #ret<2 then
				notifyMessage("易码:登录错误"..data)
				return nil
			end
			
			return ret[2]
		end
		return nil
	end
	
	--易码:获取手机号码
	function yimaGetMobileNum()
		if Tmp.token == nil then
			Tmp.token = yimaGetToken()
		end
		if Tmp.token == nil then
			notifyMessage("易码登录失败...")
			return Tmp.Mobile;
		end
		notifyMessage("易码:发送请求...")
		local data = nil;
		local code = nil;
		local req = nil;
		req = "http://api.fxhyd.cn/UserInterface.aspx?action=getmobile"..			
		"&token="..Tmp.token..				
		"&itemid="..pid
		data,code = myHttpGet(req);

		if data == nil then
			notifyMessage("易码,获取手机应答错误")
			return nil
		end
		Tmp.Mobile = string.match(data, "%d+")
		if string.len(Tmp.Mobile)<8 then
			notifyMessage("易码,获取手机号码错误:"..code)
			return nil
		end
		return Tmp.Mobile;
	end
	
	--易码:获取短信验证码
	function yimaGetVcodeAndReleaseMobile()
		if Tmp.Mobile == nil then
			notifyMessage("易码:获取短信,手机号为空...")
			return nil;
		end
		local req = "http://api.fxhyd.cn/UserInterface.aspx?action=getsms&token="..Tmp.token..
		"&itemid="..pid..
		"&mobile="..Tmp.Mobile
		local data,code =myHttpGet(req)
		return data;				
	end
	
	--易码:加黑号码
	function yimaAddIgnoreList()
		
	end
	
	--获取手机号
	function Tmp.getMobileNum()				
		--notifyMessage(string.format("卡商:[%s]", sever));
		if Tmp.Mobile~= nil then
			if server =="yumi" then
				notifyMessage("玉米，加黑号码")
				yumiAddIgnoreList("get_next");
			elseif server == "sirenyun" then
				notifyMessage("私人云，加黑号码")
				--yumiAddIgnoreList("get_next");
			elseif server == "yima"	then
				notifyMessage("易码,加黑号码")
				--yimaAddIgnoreList()
			end
		end
		if server == "yumi" then
			notifyMessage("玉米:获取手机号码...")
			return yumiGetMobileNum();
		elseif server == "sirenyun" then
			notifyMessage("私人云:获取手机号码...")
			return sirenyunGetMobileNum();
		elseif server == "yima"	then
			return yimaGetMobileNum();
		end
		
		
	end
	
		--获取短信并释放号码
	function Tmp.getVcodeAndReleaseMobile()		
		if server == "yumi" then
			notifyMessage("玉米:接收验证码")
			return yumiGetVcodeAndReleaseMobile();
		elseif server == "sirenyun" then
			return sirenyunGetVcodeAndReleaseMobile();
		elseif server == "yima"	 then
			return yimaGetVcodeAndReleaseMobile();
		end
	end
	
	--[[function Tmp.getToken()
		return yimaGetToken();	
	end--]]
	--加黑手机号
	function Tmp.addIgnoreList(remark)
		if server == "yumi" then
			yumiAddIgnoreList();
		elseif server == "sirenyun" then
			sirenyunAddIgnoreList();
		elseif server == "yima"	 then
			yimaAddIgnoreList();
		end
		Tmp.Mobile = nil;
	end
	
		--复位登陆
	function Tmp.reLogin(remark)
		Tmp.Mobile = nil;			
		Tmp.token = nil;
	end
	
	return Tmp;
end


--验证码分割
function parasevCode(data)	
	if data ~= nil then
		--logDebug(data)
		local key = "验证码";	
		local _start = string.find(data, key);
		if _start ~= nil then
			--print(_start)
			_start = _start + string.len(key)
			local code = string.sub(data, _start, string.len(data));							
			return string.match(code,'%d+');
		end
	end
	return nil;	
end

function parasevCodeHuoshan(data)	
	if data ~= nil then
		--logDebug(data)
		local key = "验证码";	
		local _start = string.find(data, key);
		if _start ~= nil then
			--print(_start)
			_start = _start + string.len(key)
			local code = string.sub(data, 1, _start);							
			return string.match(code,'%d+');
		end
	end
	return nil;	
end

function click(x, y)--单击
    touchDown(x + math.random(-2, 2), y + math.random(-2, 2))
    mSleep(math.random(15,50))
    touchUp(x + math.random(-2, 2), y + math.random(-2, 2))
    mSleep(math.random(500,800))
end

function MulcolorNoOffset_xx_model(t)
    keepScreen(true)
    x,y = findMultiColorInRegionFuzzy(t[1],t[2],t[3],t[4],t[5],t[6],t[7])
    if x~= -1 and y ~=-1 then	
        --logDebug(string.format("0x".."%06x",t[1]))
        --tt = os.time()
        keepScreen(false)
        return true
    else
        keepScreen(false)
        return false
    end	
end



---结束在运行app
function appKillAndRun(bid,_time)
	if not _time then _time=2000 end
	closeApp(bid)
	mSleep(_time)
	runApp(bid)
end
--启动app
function appRun(bid,_time)
	if not _time then _time = 2000 end
	runApp(bid)
	mSleep(_time)
end

--关闭app
function appKill(bid,_time)
	if not _time then _time = 2000 end
	closeApp(bid)
	mSleep(_time)
end

--检测前台app
function myIsFrontApp(bid)
	if isFrontApp(bid) == 0 then
		appRun(bid)
		mSleep(5000)
	end
end

--切换飞行模式
function changeAirplaneMode()
    setAirplaneMode(true);  --打开飞行模式
	mSleep(2000)
    setAirplaneMode(false); --关闭飞行模式
	mSleep(2000)
end

function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

--重命名当前记录
function renameRecord(pama)
	recordId = encodeURI(pama);
	url = string.format("nzt://cmd/renamecurrentrecord?%s", pama);
	openURL(url);
end

--关闭打开vpn
function changeVpnEnable()
	runToast("关闭打开VPN...")
	setVPNEnable(false)
	for i=1,5 do
		toast(string.format("断开vpn,等待剩余时间%s秒",5-i))
		mSleep(1500)
	end
	setVPNEnable(true)
	for j=1,5 do
		toast(string.format("连接vpn,等待剩余时间%s秒",5-j))
		mSleep(1500)
	end
end

--获取NZT全息备份的记录总数
function getNZTRecordCount()
	openURL("nzt://cmd/getrecordcount")
	for i=1,5 do
		runToast("等待NZT处理")
	end
	local ts = require("ts")
	local plist = ts.plist
	local plfilename = "/var/mobile/NZTResult.plist" --设置plist路径
	local tmp2 = plist.read(plfilename)           --读取 PLIST 文件内容并返回一个 TABLE
	--dialog(tmp2.normal, 0)  	
	if tmp2.normal == nil then
		return nil
	else
		return tonumber(tmp2.normal)
	end
end

--NZT一键新机
function newPhoneByNZT()
	runToast("NZT一键新机...")
	local nztInterface = {0xffffff,"0|3|0xffffff,0|7|0xffffff,2|7|0x007aff,2|2|0x007aff,4|2|0x007aff,4|6|0x007aff,7|6|0xffffff,7|3|0xffffff", 90, 303, 1036, 325, 1062}
	--local exitNztButton = {}
	appKillAndRun("NZT")
	while 1 do
		if MulcolorNoOffset_xx_model(nztInterface) then
			--使用命令进行一件新机
			openURL("nzt://cmd/newrecord");mSleep(2000)
			while 1 do
				if MulcolorNoOffset_xx_model(nztInterface) and MulcolorNoOffset_xx_model({0xffffff,"0|4|0x333333,0|6|0x333333,0|10|0xffffff,6|10|0xffffff,10|10|0xffffff,10|6|0x333333,10|3|0x333333,10|0|0xffffff", 90, 250, 596, 281, 615}) then
					runToast("nzt清理中")
				elseif MulcolorNoOffset_xx_model(nztInterface) and MulcolorNoOffset_xx_model({0xffffff,"0|4|0x333333,0|6|0x333333,0|10|0xffffff,6|10|0xffffff,10|10|0xffffff,10|6|0x333333,10|3|0x333333,10|0|0xffffff", 90, 250, 596, 281, 615}) ==false then
					break
				end
			end
			for i=1,8 do
				toast(string.format("等待NZT一键新机结束还剩%s秒",8-i))
				mSleep(1000)
			end
			--appKill("NZT")
			pressHomeKey(0);    --按下 Home 键
			pressHomeKey(1);    --抬起 Home 键
			mSleep(2000)
			break
		else
			appRun("NZT")
		end
	end
end
--NZT全息备份下一条
function nextRecordNZT()
	runToast("NZT下一条记录...")
	local nztInterface = {0xffffff,"0|3|0xffffff,0|7|0xffffff,2|7|0x007aff,2|2|0x007aff,4|2|0x007aff,4|6|0x007aff,7|6|0xffffff,7|3|0xffffff", 90, 303, 1036, 325, 1062}
	local nextReord = {0x000000,"0|1|0x000000,-4|1|0xf9f9f9,-7|1|0xf9f9f9,-7|5|0xf9f9f9,-4|5|0xf9f9f9,0|5|0x000000,3|5|0xf9f9f9,7|5|0xf9f9f9", 90, 588, 79, 623, 93}
	appKillAndRun("NZT")	
	while 1 do
		if MulcolorNoOffset_xx_model(nztInterface) then
			--使用命令进行一件新机
			openURL("nzt://cmd/nextrecord");mSleep(2000)
			while 1 do
				if MulcolorNoOffset_xx_model(nextReord) and MulcolorNoOffset_xx_model({0xffffff,"0|2|0xffffff,6|2|0x333333,6|-1|0x333333,10|0|0xffffff,10|2|0xffffff,16|2|0x333333,16|0|0x333333,20|0|0xffffff,20|1|0xffffff", 90, 421, 611, 454, 624}) then
					runToast("nzt清理中")
				elseif MulcolorNoOffset_xx_model(nextReord) and MulcolorNoOffset_xx_model({0xffffff,"0|2|0xffffff,6|2|0x333333,6|-1|0x333333,10|0|0xffffff,10|2|0xffffff,16|2|0x333333,16|0|0x333333,20|0|0xffffff,20|1|0xffffff", 90, 421, 611, 454, 624}) ==false then
					break
				end
			end
			for i=1,8 do
				toast(string.format("等待NZT下一条记录结束还剩%s秒",8-i))
				mSleep(1000)
			end
			--appKill("NZT")
			pressHomeKey(0);    --按下 Home 键
			pressHomeKey(1);    --抬起 Home 键
			mSleep(2000)
			break
		else
			appRun("NZT")
		end
	end
end


--NZT全息备份下一条
function nextNZTForDouYin()
	runToast("NZT下一条记录...")
	local nztInterface = {0xffffff,"0|3|0xffffff,0|7|0xffffff,2|7|0x007aff,2|2|0x007aff,4|2|0x007aff,4|6|0x007aff,7|6|0xffffff,7|3|0xffffff", 90, 303, 1036, 325, 1062}
	local nextReord = {0x000000,"0|1|0x000000,-4|1|0xf9f9f9,-7|1|0xf9f9f9,-7|5|0xf9f9f9,-4|5|0xf9f9f9,0|5|0x000000,3|5|0xf9f9f9,7|5|0xf9f9f9", 90, 588, 79, 623, 93}
	appKillAndRun("NZT")	
	while 1 do
		if MulcolorNoOffset_xx_model(nztInterface) then
			--使用命令进行一件新机
			openURL("nzt://cmd/nextrecord");mSleep(2000)
			while 1 do
				if MulcolorNoOffset_xx_model(nextReord) and MulcolorNoOffset_xx_model({0xffffff,"0|2|0xffffff,6|2|0x333333,6|-1|0x333333,10|0|0xffffff,10|2|0xffffff,16|2|0x333333,16|0|0x333333,20|0|0xffffff,20|1|0xffffff", 90, 421, 611, 454, 624}) then
					runToast("nzt清理中")
				elseif MulcolorNoOffset_xx_model(nextReord) and MulcolorNoOffset_xx_model({0xffffff,"0|2|0xffffff,6|2|0x333333,6|-1|0x333333,10|0|0xffffff,10|2|0xffffff,16|2|0x333333,16|0|0x333333,20|0|0xffffff,20|1|0xffffff", 90, 421, 611, 454, 624}) ==false then
					break
				end
			end
			for i=1,8 do
				toast(string.format("等待NZT下一条记录结束还剩%s秒",8-i))
				mSleep(1000)
			end
			--
			if MulcolorNoOffset_xx_model({0x007aff,"1|1|0x007aff,3|4|0x007aff,6|4|0x007aff,9|2|0x007aff,11|0|0x007aff,13|-2|0x007aff,14|-3|0x007aff", 90, 573, 163, 613, 189}) and MulcolorNoOffset_xx_model({0x000000,"0|4|0x000000,0|7|0x000000,4|7|0xffffff,8|7|0xffffff,9|7|0xffffff,9|4|0xffffff,12|4|0x000000,12|7|0x000000,12|9|0x000000", 90, 74, 161, 96, 180}) then
				dialog("已经运行完最后一条",1)
				lua_exit();
			end
			--appKill("NZT")
			pressHomeKey(0);    --按下 Home 键
			pressHomeKey(1);    --抬起 Home 键
			mSleep(2000)
			break
		else
			appRun("NZT")
		end
	end
end
--将指定文件中的内容按行读取
function readFile(path)
    local file = io.open(path,"r");
    if file then
        local _list = {};
        for l in file:lines() do
            table.insert(_list,l)
        end
        file:close();
        return _list
    end
end

--好爱打码
function haoai()
	local op = {
	--必填参数
	["platform"]="haoi23", --平台类型，具体参数参照参数表
	["x1"]=28, --需要识别区域左上角坐标
	["y1"]=235,
	["x2"]=610, --需要识别区域右下角坐标
	["y2"]=572,
	["type"]="8006", --打码类型，可在对应平台官网查询
	["username"]="gaopanhao", --打码平台账号
	["password"]="gaopanhao|AA8C0B5892990D1F", --打码平台密码
	--选填参数
	["length"]=4, --打码长度
	["timeout"]=30, --超时时间
	["scale"]=100, --缩放比例，范围10 - 200，在某些待识别区域过大的时候可设置此参数
	};
	local ret = ocr.cloudOcrText(op);
	if ret.success then
		myToast(ret.text)
		return ret.text
	else
		return false
	end	
end

--获取文本账号
function getQQ()
	local _qq = readFile("/User/Media/TouchSprite/lua/qq.txt")		
	local relt = nil
	if _qq[1] == nil then
		while 1 do
			runToast("全部QQ登录完成")
		end
	end
	relt = string.match(_qq[1],"%s*(.-)%s*$")
	--myToast(relt)
	return relt
	
end

function removeAccount()
    -- body
    local ret = readFile("/User/Media/TouchSprite/lua/qq.txt")		
	os.execute("rm -rf /User/Media/TouchSprite/lua/qq.txt")	
	local _file = io.open("/User/Media/TouchSprite/lua/qq.txt","a+")
	if _file then
		for i=1,#ret-1 do
			_file:write(ret[i+1].."\n")
		end
		_file:close()
	end
end

function getRecord()
    -- body
    local _file
    local ret
    _file = io.open("/User/Media/TouchSprite/lua/a.txt","r")
    if _file ~= nil then
        ret = tonumber(_file:read())
        _file:close()
        return ret
    end	
end

--修改index的值
function modifyIndex()
	local _index = readFile("/User/Media/TouchSprite/lua/index.txt")
	local ret =string.match(_index[1],"%s*(.-)%s*$")
	ret = string.match(ret,"%d+")
	local file = nil
	file = io.open("/User/Media/TouchSprite/lua/index.txt","w")
	if file then
		file:write(ret+1)
		file:close()
	end
end

    --检测指定文件是否存在
function file_exists(file_name)
    local f = io.open(file_name, "r")
    return f ~= nil and f:close()
end

--生成还原记录
function record()
	local _file = nil
	--_file = io.open("/User/Media/TouchSprite/lua/a.txt","r")
	if file_exists("/User/Media/TouchSprite/lua/a.txt") then
		local _index = readFile("/User/Media/TouchSprite/lua/a.txt")
		local ret =string.match(_index[1],"%s*(.-)%s*$")
		ret = string.match(ret,"%d+")
		local file = nil
		file = io.open("/User/Media/TouchSprite/lua/a.txt","w")
		if file then
			file:write(ret+1)
			file:close()
		end		
	else
		_file = io.open("/User/Media/TouchSprite/lua/a.txt","w")
		if _file then
			_file:write(1)	
			_file:close()
		end
	end
	
end

--新用户按钮
qqNewUser = {0xffffff,"4|0|0xffffff,8|0|0xffffff,8|3|0x1ca0d5,5|3|0x1ca0d4,2|3|0x1ca0d4,2|5|0x1c9fd4,4|5|0x1da0d5", 85, 489, 968, 530, 991}
--qq登录按钮蓝色
qqLoadBtn = {0x2db1e4,"6|0|0x2eb2e6,9|0|0x2eb2e7,9|3|0xffffff,5|3|0xffffff,3|3|0xffffff,3|5|0x41b8e6,7|5|0x3db4e2", 85, 319, 552, 348, 571}
--点击账号栏之后按钮上浮
qqLoadBtnOne = {0xffffff,"5|0|0xffffff,5|4|0x34b2e2,1|4|0x2faede,1|6|0xffffff,5|6|0xffffff,5|9|0x25a9db,2|9|0x24a7da", 85, 319, 461, 347, 479}
--验证码
puzzleCode = {0x000000,"0|4|0x000000,0|7|0x000000,4|7|0xffffff,7|7|0xffffff,10|7|0xffffff,10|4|0xffffff", 85, 145, 165, 170, 183}
--滑块
sliderBtn = {0xefefef,"0|4|0xefefef,0|6|0xefefef,6|6|0x007aff,6|3|0x007aff,6|0|0x007aff,6|-2|0x007aff", 85, 111, 597, 135, 627}
--登录失败
loadFailed = {0x222222,"0|3|0x1c1c1c,0|8|0x222222,3|8|0xffffff,4|1|0xffffff,2|1|0xffffff,6|1|0x000000,6|7|0x000000", 85, 295, 664, 311, 686}
--开启消息推送
setNowBtn = {0x1eb9f2,"7|0|0x1eb9f2,15|0|0x1eb9f2,19|0|0xffffff,-3|0|0xffffff,-3|-1|0xffffff", 85, 351, 676, 386, 691}
--qq消息
qqMessage = {0x36b0fe,"4|0|0x36b0fe,7|0|0x36b1fe,7|3|0xffffff,1|3|0xffffff,1|6|0x36b1fe,5|6|0x36b0fe", 85, 293, 72, 316, 95}
--关闭qq绑定
closeBinding = {0x000000,"0|4|0xffffff,0|6|0xffffff,0|9|0x000000,-5|9|0x000000,-5|4|0xffffff,-5|0|0x000000", 85, 13, 71, 36, 89}
--确定关闭绑定
closeBindingSure = {0x000000,"5|0|0x000000,5|4|0xffffff,5|6|0xffffff,1|6|0xffffff,-2|6|0xffffff,-2|8|0x4a4a4a,1|8|0x4a4a4a", 85, 428, 707, 452, 724}
--账号暂时无法登陆
frozenQQ = {0x000000,"11|0|0x000000,11|2|0xffffff,3|2|0xffffff,3|4|0x858585,8|4|0x858585,8|5|0x000000,3|5|0x000000", 90, 240, 356, 274, 369}
frozen5s = {0x000000,"0|5|0x000000,0|13|0x000000,3|13|0xffffff,5|13|0xffffff,5|4|0xffffff,5|0|0xffffff,5|-2|0x0a0a0a", 90, 278, 336, 297, 374}
--登录QQ
function loginQQ()
	runToast("qq登录")
	--appKillAndRun("com.tencent.mqq")
	local _acc,_pwd = false ,false
	local acc,pwd = nil,nil
	local _input = false
	local count = 1
	while 1 do
		if MulcolorNoOffset_xx_model(qqNewUser) then
			click(168,979)
			--myToast("点击登录")
		elseif MulcolorNoOffset_xx_model(qqLoadBtn) then
			click(355,341)
			--myToast("点击账号栏")
		elseif _acc==false and _pwd==false and MulcolorNoOffset_xx_model(qqLoadBtnOne) then	
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b")mSleep(1000)
			local ret = getQQ()
			local _ret = Split(ret,"#")	
			inputText(_ret[1])mSleep(1000)
			_acc = true
			--myToast("输入账号")
		elseif _acc and _pwd==false and MulcolorNoOffset_xx_model(qqLoadBtnOne) then
			click(426,345)mSleep(1000)
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b")mSleep(1000)
			local ret = getQQ()
			local _ret = Split(ret,"#")	
			inputText(_ret[2])mSleep(1000)
			_pwd = true
			--myToast("输入密码")			
		elseif _acc and _pwd and MulcolorNoOffset_xx_model(qqLoadBtnOne) then
			click(x,y)mSleep(1000)
			--myToast("点击登录")
		elseif MulcolorNoOffset_xx_model(puzzleCode) and MulcolorNoOffset_xx_model(sliderBtn) then
			mSleep(3000)
			local ret = haoai()
			if ret ~= false then
				local x1 = Split(ret,",")
				clickMoveQQ(135,614,x1[1]+30,614,5)mSleep(5000)
				_input = true
			end
		elseif count >=3 and MulcolorNoOffset_xx_model(loadFailed) then
			runToast("账号密码连续错误三次换号...")
			appKill("com.tencent.mqq")
			_acc,_pwd = false ,false
			runToast("qq冻结")
		elseif MulcolorNoOffset_xx_model(loadFailed) then
			click(x,y)
			_acc,_pwd = false ,false
			mSleep(5000)
			count = count + 1
		elseif MulcolorNoOffset_xx_model(setNowBtn) then
			click(321,860)
		elseif MulcolorNoOffset_xx_model(closeBindingSure) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(closeBinding) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(qqMessage) then
			runToast("qq登录完成")
			if _input then
				--移除文本第一条
				removeAccount()
			end
			break
		elseif MulcolorNoOffset_xx_model(frozenQQ) or MulcolorNoOffset_xx_model(frozen5s) then
			appKill("com.tencent.mqq")
			_acc,_pwd = false ,false
			runToast("qq冻结")
			removeAccount()
		end
		appRun("com.tencent.mqq")
	end
end

--拒绝地理位置
rejectLaction = {0x007aff,"10|0|0x007aff,20|0|0x007aff,22|0|0x007aff,21|1|0x007aff,11|1|0x007aff,8|1|0x007aff", 90, 131, 653, 167, 662}
--拒绝通知
rejectNotify = {0x007aff,"9|0|0x007aff,15|0|0x007aff,18|0|0x007aff,18|1|0x007aff,10|1|0x007aff,4|1|0x007aff,2|1|0x007aff", 90, 130, 647, 166, 655}
--qq登录图标
loadByQQIcon = {0xffffff,"6|0|0xffffff,7|0|0xffffff,7|3|0xff5046,3|3|0xff5046,3|5|0xffffff,6|5|0xffffff,6|7|0xff5046,3|7|0xff5046", 90, 331, 614, 351, 633}
--唱吧想要打开qq
allowToQQ = {0x007aff,"0|5|0x007aff,0|8|0x007aff,0|11|0x007aff,6|11|0x007aff,9|11|0x007aff,12|11|0x007aff,12|5|0x007aff,12|2|0x007aff", 90, 457, 610, 484, 632}
--qq授权并登录
allowAndLoad = {0xffffff,"0|3|0xffffff,4|3|0x00aced,7|3|0x00aced,7|-1|0x00aced,5|-1|0x00aced,5|-3|0xfeffff,7|-3|0xfeffff", 85, 308, 1068, 326, 1087}
--重新授权
reAllow = {0x00aced,"0|-3|0x00aced,4|-3|0x00aced,5|-1|0x00aced,5|2|0x00aced", 85, 17, 887, 70, 921}
--登录失败
loadFailedSure = {0x000000,"2|5|0xffffff,2|10|0xffffff,5|10|0x000000,5|4|0x000000,10|4|0xffffff,13|4|0xffffff,13|8|0x101010", 85, 321, 662, 355, 691}
--名字完成
nameFinished = {0xff5046,"7|0|0xff5046,10|0|0xff5046,10|3|0xffffff,2|3|0xffffff,0|3|0xffffff,0|5|0xff5046,8|5|0xff5046", 90, 560, 76, 591, 89}
--底部红色话筒
redMic = {0xffebed,"8|0|0xffe4e7,12|0|0xffe2e5,12|1|0xff5046,6|1|0xff5046,2|1|0xff5046,2|2|0xff5046,8|2|0xff5046,10|2|0xff5046", 90, 303, 1073, 337, 1082}
--唱吧登录
function loadChangBa()
	runToast("唱吧登录")
	myIsFrontApp("com.changba.ktv")
	local user = false
	while 1 do
		if MulcolorNoOffset_xx_model(rejectLaction) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(rejectNotify) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(loadByQQIcon) then
			click(323,899)
		elseif MulcolorNoOffset_xx_model(allowToQQ) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(allowAndLoad) then
			click(x,y)mSleep(1000)	
		elseif MulcolorNoOffset_xx_model(reAllow) then
			click(x,y)
			mSleep(1000)			
		elseif MulcolorNoOffset_xx_model(loadFailedSure) then
			click(x,y)
			mSleep(1000)				
		elseif MulcolorNoOffset_xx_model(nameFinished) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(redMic) then
			runToast("唱吧登录完成")
			break
		end
	end
end
--红色动态
redDynamic = {0xff4d4a,"0|3|0xff4a4c,2|5|0xff4751,4|5|0xff4553,4|2|0xff4850,4|0|0xff4a4e,2|0|0xff4b4b", 90, 54, 1066, 70, 1083}
--灰色动态
greyDynamic = {0xcccccc,"0|3|0xcccccc,0|5|0xcccccc,3|5|0xcccccc,4|5|0xcccccc,4|2|0xcccccc,4|0|0xcccccc,2|0|0xcccccc", 90, 53, 1066, 73, 1083}
--关注
followRec = {0xff5046,"9|0|0xff5046,12|0|0xff5046,12|4|0xffffff,10|4|0xffffff,2|4|0xffffff,-1|4|0xffffff,-1|7|0xff645b", 90, 529, 596, 561, 612}
--底部关注
bottomFollow = {0xfa5046,"6|0|0xfa5046,13|0|0xfa5046,13|5|0xffffff,9|5|0xffffff,1|5|0xffffff,-2|5|0xffffff,-2|8|0xfa5046,13|8|0xfa5046", 90, 146, 1080, 179, 1097}
--左上角返回
leftBackBtn = {0xff5046,"4|4|0xff5046,7|6|0xff5248,9|8|0xff5046,10|9|0xff5046,11|10|0xff5046,12|11|0xff5046", 90, 18, 78, 46, 103}
--关注粉丝
followFuns = {0xff5046,"0|9|0xff5046,0|14|0xff5046,-4|6|0xff5046,-6|6|0xff5046,6|6|0xff5046,8|6|0xff5046", 90, 493, 183, 524, 1086}
--关闭通知
closeNotify = {0xffffff,"4|0|0xffffff,8|0|0xffffff,7|3|0xea5036,3|3|0xea5036,3|5|0xffffff,6|5|0xffffff,6|7|0xea5036,2|7|0xea5036", 90, 383, 779, 402, 798}
--唱吧关注
function followChangBa()
	runToast("唱吧关注")
	while 1 do
		if MulcolorNoOffset_xx_model(redMic) and MulcolorNoOffset_xx_model(greyDynamic) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(redDynamic) and MulcolorNoOffset_xx_model(redMic) and MulcolorNoOffset_xx_model(followRec) then
			click(257,600)
		elseif MulcolorNoOffset_xx_model(redDynamic) and MulcolorNoOffset_xx_model(redMic) and MulcolorNoOffset_xx_model(followRec)==false then
			click(167,86)
		elseif MulcolorNoOffset_xx_model(bottomFollow) then
			click(319,470)
		elseif MulcolorNoOffset_xx_model(leftBackBtn) and MulcolorNoOffset_xx_model(followFuns) then
			click(x,y)
		elseif MulcolorNoOffset_xx_model(closeNotify) then
			click(314,970)
		elseif MulcolorNoOffset_xx_model(leftBackBtn) and MulcolorNoOffset_xx_model(followFuns)==false then	
			runToast("唱吧关注完成")
			break
		end
		myIsFrontApp("com.changba.ktv")
	end
end

function allSteps()
	
end

init("0",0)
runToast("唱吧脚本开始运行...v05.30.01")

while 1 do
	loginQQ()
	loadChangBa()
	followChangBa()
	appKill("com.changba.ktv")
	newPhoneByNZT()
	changeAirplaneMode()
end	