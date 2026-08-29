--!nonstrict
--!native
--!nolint RedundantNativeAttribute
local metatable = debug.getmetatable(game) :: {[string]: any};
local instance_tostring: (...any) -> string = metatable.__tostring;
local rawtostring: (any) -> string = newcclosure(@native function(obj: any): string
	local metatable: {[string]: any} = (debug.getmetatable(obj) or {});
	local _tostring: (...any) -> (...any)? = rawget(metatable, "__tostring");
	if (_tostring and type(_tostring) == "function" and _tostring ~= instance_tostring) then
		return typeof(obj);
	else
		return tostring(obj);
	end;
end, "");
local syn_secure_call: (...any) -> any;
local listeners: {[any]: any} = {};
local listener_metatable: {[string]: any};
for _,v in getgc(true) do
	if (type(v) == "table" and isreadonly(v) and not debug.getmetatable(v)) then
		local __index = rawget(v, "__index") :: (...any) -> (...any);
		local __tostring = rawget(v, "__tostring") :: (...any) -> (...any);
		if (not __index or type(__index) ~= "function" or not __tostring or type(__tostring) ~= "function" or iscclosure(__index) or iscclosure(__tostring)) then
			continue;
		end;
		local constants = debug.getconstants(__index);
		if (table.find(constants, "ID") and table.find(constants, "SendServer") and table.find(constants, "ClientLoaded")) then
			listener_metatable = v;
			listeners = debug.getupvalue(__index, 2);
			break;
		end;
	end;
end;
local getlistener: (string) -> any = @native function(name: string): any 
	local __index = rawget(listener_metatable, "__index") :: (...any) -> (...any);
	local enviorment: { [string]: any } = getfenv(__index);
	for i: any, _: unknown in next, (listeners) do
		if (type(i) ~= "table") then
			continue;
		end;
		local metatable: {[number]: any} = debug.getmetatable(i);
		local __tostring: (...any) -> (...any)? = rawget(metatable, "__tostring");
		if (__tostring and type(__tostring)  == "function" and not isfunctionhooked(__tostring)) then
			local setfenv: <T..., R...>(((T...) -> (R...)) | number, { [string]: any }) -> ((T...) -> (R...))? = setfenv;
			local setthreadidentity: (number) -> () = setthreadidentity;
			local getthreadidentity: () -> number = getthreadidentity;
			local enviorment: { [string]: any } = getfenv(__tostring);
			local hook: (...any) -> never; hook = hookmetamethod(i, "__tostring", function(...): (never | string)
				if (getthreadidentity() == 2) then
					setfenv(1, enviorment);
					setfenv(0, enviorment);
					setthreadidentity(2);
					return hook(...);
				end;
				return "";
			end);
		end;
		local id: string = syn_secure_call(__index, enviorment, i, "ID");
		if (rawequal(id, name)) then -- nuh uh
			return i;
		end;
	end;
	return nil :: never;
end;
local get_listener_name: (any) -> string = @native function(operand: any): string 
	local __index = rawget(listener_metatable, "__index") :: (...any) -> (...any);
	local enviorment: { [string]: any } = getfenv(__index);
	local id: string = syn_secure_call(__index, enviorment, operand, "ID");
	return id;
end;
do -- namecall hook
	--[[local decode: (buffer) -> () = function(bfr: buffer)
		local xor: (...number) -> number = bit32.bxor;
		local writefloat64: (buffer, number, number) -> () = buffer.writef64;
	end;
	local isreferenced: (any) -> boolean = function(arg: any): boolean
		return (table.find(getgc(true), arg) ~= nil)
	end;]]
	local namecall: (...any) -> (...any); namecall = oth.hook(metatable.__namecall, @native function(...: any): ...any 
		if (getthreadidentity() ~= 2) then return namecall(...); end;
		local self: Instance, arugments: {[number]: any} = select(1, ...), {select(3, ...)}; 
		local method: string = string.lower(getnamecallmethod());
		if (self and type(self) == "userdata" and typeof(self) == "Instance" and self.ClassName == "RemoteEvent" and method == "fireserver" and typeof(arugments[1]) ~= "buffer") then
			print("Blocked detection", rawtostring(arugments[1]));
			return;
		end;
		return namecall(...);
	end);
end;
local hide_stack: () -> () = @native function(): ()
     for i: number = 1, 100 do
     local closure: (...any) -> (...any)? = debug.info(i, "f");
     if (not closure) then break; end;
     if (isexecutorclosure(closure) or isnewcclosure(closure)) then
          setstackhidden(closure, true); -- bleh
       end;
    end;
 end;
do -- hooks
	--local network_handler_func: (...any) -> (...any);  
	local setfenv: <T..., R...>(((T...) -> (R...)) | number, { [string]: any }) -> ((T...) -> (R...))? = setfenv;
	local warn: <T...>(T...) -> () = warn;
	local print: <T...>(T...) -> () = print;
    local setstackhidden: (((...any) -> (...any)) | number, boolean) -> () = setstackhidden;
    local isexecutorclosure: ((...any) -> (...any)) -> boolean = isexecutorclosure;
    local type: <T>(T) -> string = type;
    local hookfunction: <A1..., R1...>((A1...) -> (R1...), (...any) -> (...any)) -> (A1...) -> (R1...) = hookfunction;
    local getfunctionhash: ((...any) -> (...any)) -> string = getfunctionhash;
    local isfunctionhooked: ((...any) -> (...any)) -> boolean = isfunctionhooked;
    local islclosure: ((...any) -> (...any)) -> boolean = islclosure;
	local debug: typeof(debug) = debug;
	local setthreadidentity: (number) -> () = setthreadidentity;
	local disable: ((...any) -> (...any)) -> () = @native function(func: (...any) -> (...any)): ()
		local upvalues: {[number]: any} = debug.getupvalues(func);
		for _: unknown, v: (...any) -> (...any) in upvalues do
			if (type(v) == "function" and islclosure(v) and not isfunctionhooked(v) and getfunctionhash(v) == "598cc67dbd40c2d857c0b109390f9ffa8aadfb243cd8d27163e83f1f8f37f918d5b1570af23a814faf620319537824ca") then
				hookfunction(v, function(...): ...any  
					hide_stack();
					return false;
				end);
			end;
		end;
		return;
	end;
	do
		local unpack: <V>({V}, number?, number?) -> (...V) = unpack;
		syn_secure_call = newcclosure(@native function(closure: (...any) -> (...any), enviorment: {[string]: any}, ...: any): any
			hide_stack();
			local arugments: {[number]: any} = {...};
			local result: any = {};
			coroutine.wrap(@native function()
				hide_stack();
				setthreadidentity(2);
				disable(closure);
				setfenv(1, enviorment);
				setfenv(0, enviorment);
				result = {closure(unpack(arugments))};
				return;
			end)();
			return unpack(result);
		end, "secure_call");
	end;
	local network_heartbeat: (...any) -> (...any);
	for _: unknown, v: (...any) -> (...any) in (getgc(false)) do
		if (type(v) == "function" and islclosure(v) and not isexecutorclosure(v) and not isfunctionhooked(v) and getfunctionhash(v) == "aeb28bee32c573b2f94681d903c3bf19b969faa96690c2c51c4a7dbae18a60558c5e6e1ab98f7bb4bdad101532cc6ece") then
			network_heartbeat = v;
			break;
		end;
	end;
	print("hi", network_heartbeat)
	coroutine.wrap(@native function(...: never): ()
		while (true) do
			disable(network_heartbeat);
			task.wait();
		end;
		return;
	end)();
	--[[for _: unknown, v: any in getgc(false) do
		if (type(v) == "function" and islclosure(v) and not isexecutorclosure(v) and debug.info(v, "n") == "SendServer") then -- TODO: getfunctionhash if i even bother
            local enviorment: { [string]: any } = getfenv(v);
			local upvalues: {[number]: any} = debug.getupvalues(v);
			disable(v);
			local hook: (...any) -> (...any); hook = hookfunction(v, @native function(...: any): any
                hide_stack();
				disable(hook);
				warn("------");
				for i: number, v: any in ({...}) do
					print(i, rawtostring(v));
				end;
				warn("------");
				setfenv(1, enviorment);
				setfenv(0, enviorment);
				setthreadidentity(2);
				return hook(...);
			end);
		end;
	end;]]
end;

--print("i work wow so cool");
--print("disconnect listener", getlistener("Disconnect"));


do
	local listener: any = getlistener("Disconnect");
	local __index: (...any) -> (...any) = rawget(debug.getmetatable(listener), "__index") :: (...any) -> (...any);
	local enviorment: { [string]: any } = getfenv(__index);
	local SendServer = syn_secure_call(__index, enviorment, listener, "SendServer") :: (...any) -> (...any);
	local setfenv: <T..., R...>(((T...) -> (R...)) | number, { [string]: any }) -> ((T...) -> (R...))? = setfenv;
	local setthreadidentity: (number) -> () = setthreadidentity;
	local debug: typeof(debug) = debug;
	local rawequal: <T1, T2>(T1, T2) -> boolean = rawequal;
	local log: (any, { [any]: any }) -> () = @native function(listener: any, arugments: {[any]: any})
		print("------");
		print("Remote fired: ", rawtostring(get_listener_name(listener)));
		for i: number, v: any in (arugments) do
			print(i, rawtostring(v));
		end;
		print("------");
		return;
	end;
	local wrap:<A..., R...>((A...) -> (R...)) -> (A...) -> (R...) = coroutine.wrap;
	local hook: (...any) -> (...any); hook = hookfunction(SendServer, @native function(...: any): ...any  
		hide_stack();
		setfenv(1, enviorment);
		setfenv(0, enviorment);
		setthreadidentity(2);
		local arugments: {[number]: any} = {...}; 
		local self: any = arugments[1];
		if (not self or not debug.getmetatable(self) or not rawequal(debug.getmetatable(self), listener_metatable)) then
			return hook(...);
		end;
		table.remove(arugments, 1);
		wrap(log)(self, arugments);
		return hook(...);
	end);
	print("finished");
end;
