function parasevCodeHuoshan(data)	
	if data ~= nil then
		--logDebug(data)
		local key = "��֤��";	
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


print(parasevCodeHuoshan("����ɽС��Ƶ��0188����ɽС��Ƶ��֤�룩��30��������Ч������й¶"))

