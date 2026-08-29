--!nocheck
--!native

local game = cloneref(game) :: DataModel;
local workspace = cloneref(workspace) :: Workspace;

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua"))();
local states: {[string]: boolean} = {
	inf_ammo = false;
	mouse_is_unlocked = true;
	enable_3rd_person = true;
};

local service; service = setmetatable({}, table.freeze({
	__index = newcclosure(@native function(self: {}, index: string): Instance
		if (type(index) ~= "string") then
			return nil :: never;
		end;
		local ref: Instance = cloneref(game:GetService(index));

		rawset(service, index, ref);
		return ref;
	end);
	__metatable = "";
}));

local collection_service = service.CollectionService :: CollectionService;
local players = service.Players :: Players;

local player = players.LocalPlayer :: Player;
local lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/XSX-UI-Library/refs/heads/main/xsx%20lib.lua'))();

lib.headerColor = Color3.fromRGB(51, 158, 190);
lib.companyColor = Color3.fromRGB(163, 151, 255);

lib.acientColor = Color3.fromRGB(159, 115, 255)
lib:Init({
	verison = "V0";
	title = "Retrobreach SEX hub";
	company = "WATDAHECKLOL Softworks";
	BlurEffect = false;
});

lib:Watermark("WATDAHECKLOL Softworks");
lib:BeginIntroduction();

lib:AddIntroductionMessage("Loading, this can take a bit.")
task.wait(1);

lib:AddIntroductionMessage(`Welcome {player}.`);
lib:AddIntroductionMessage("Be free, be proud.");

lib:AddIntroductionMessage("Thank you for choosing");
lib:AddIntroductionMessage("WATDAHECKLOL Softworks");

lib:AddIntroductionMessage("Press RIGHTSHIFT, to toggle the UI.");
task.wait(3);

lib:EndIntroduction();
local tabs = table.freeze({
	ac = lib:NewTab("Anti-Cheat");
	items = lib:NewTab("Items & Objects");
	config = lib:NewTab("Config");
	weapons = lib:NewTab("Weapons");
	locations = lib:NewTab("Locations");
	misc = lib:NewTab("MISC");
});


local weapon_events = {};
local weapon_fire_func;

for _: unknown, v: ({[any]: any} | thread | (...any) -> (...any)) in (getgc(true)) do
	if (type(v) == "table" and rawget(v, "repReload")) then
		--ReloadEvent = rawget(v, "repReload");
		--FireWeapon = rawget(v, "fireWeapon");

		--weapon_events.Fire = rawget(v, "repReload");
		weapon_events.Reload = rawget(v, "repReload");

		weapon_events.tbl = v;
		table.freeze(weapon_events)

		break;
	end;
end;

for _,v in (getgc(false)) do
	if (type(v) == "function" and islclosure(v)) then
		local upvalues = debug.getupvalues(v);
		if (table.find(upvalues, weapon_events.tbl) and debug.info(v, "n") == "call_fire") then
			weapon_fire_func = v;
			break;
		end;
	end;
end;
local locations = table.freeze({
	outside_warhead = CFrame.new(1559.05945, 567.781372, 327.585907);
	lcz_armory = CFrame.new(852.441956, 51.8333931, 588.815369);
	warheads_inside = CFrame.new(1010.59198, -98.0892181, 1000.07159);
	scp_173_cell = CFrame.new(1139.92542, 72.8695374, 475.448181);
	scp_012 = CFrame.new(994.8573, 35.7203636, 414.546478);
	scp_914 = CFrame.new(916.246643, 52.5091782, 582.270569);
	cafe = CFrame.new(1315.00391, 40.7572899, 458.66983);
	ez_armory = CFrame.new(1253.73059, 40.9821243, 300.267242);
	scp_008 = CFrame.new(1281.60803, 51.7784958, 702.195923);
	gate_a = CFrame.new(1464.29736, 588.639343, 427.886841);
	gate_b = CFrame.new(1316.83459, 588.539917, 216.652054);
	gate_b_armory = CFrame.new(1398.62866, 578.992615, 204.397781);
	lobby = CFrame.new(1437.25952, 390.986633, 945.315552)
});

local config_settings: {[string]: boolean} = {show_alets = true};
local network_client = service.NetworkClient :: NetworkClient;

local notify: (...any) -> () = @native function(...: any): ()
	if (not config_settings.show_alets) then
		return;
	end;
	return lib:Notify(...);
end;
tabs.ac:NewButton("Bypass", @native function()
	local namecall: (...any) -> (...any); namecall = hookmetamethod(game, "__namecall", newcclosure(function(...: any): any
		if (getthreadidentity() ~= 2 or string.lower(getnamecallmethod()) ~= "destroy") then
			return namecall(...);
		end;

		local self: Instance = ...;
		if (self and type(self) == "userdata" and typeof(self) == "Instance" and self == player) then
			return;
		end;

		return namecall(...);
	end));

	notify("Anti cheat has been bypassed!", 2, "success");
	return;
end);

local get_cur_items: () -> {[number]: string} = @native function()
	local items: {[number]: Instance} = workspace.ItemSpawns:GetChildren();
	local output: {[number]: string} = {};
	for _: unknown, v: Instance in (items) do
		if (not v:IsA("Model")) then
			continue;
		end;
		table.insert(output, tostring(v));
	end;
	return output;
end;

local item_buttons: {[number]: {[string]: (self: any) -> ()}} = {};
local item_callback: (operand: string) -> () = @native function(operand: string): ()
    local obj = workspace.ItemSpawns:FindFirstChild(operand);
    if (not obj) then
        notify(`Can not pick up object {obj}, (item is already picked up or is missing).`, 3, "error");
        return;
    end;

    local clicker = obj:FindFirstChildWhichIsA("ClickDetector");
    if (not clicker) then
        notify(`Could not pick up {obj}, (Can not find click detector).`)
        return;
    end;

    fireclickdetector(clicker);
    return;
end;

local update_items: () -> () = @native function(): ()
    for _,v in (item_buttons) do
        v:Remove();
    end;
    table.clear(item_buttons);

    for _: unknown, v: string in (get_cur_items()) do
        local res: {[string]: any} = tabs.items:NewButton(v, @native function(_: unknown): ()
            return item_callback(v);
        end);

        table.insert(item_buttons, res);
    end;
    return;
end;

update_items();
tabs.config:NewToggle("Show alerts", true, @native function(value: boolean): ()
	config_settings.show_alets = value;
	return;
end);


tabs.weapons:NewToggle("Infinite Ammo", false, @native function(value: boolean): ()
	states.inf_ammo = value;
	return;
end);
tabs.config:NewToggle("Unlock mouse", true, @native function(value: boolean): ()
	states.mouse_is_unlocked = value;
	return;
end);

tabs.config:NewToggle("Enable 3rd person", true, @native function(value: boolean): ()
	states.enable_3rd_person = value;
	return;
end);

tabs.weapons:NewToggle("Instant Kill", false, @native function(value: boolean): ()
	notify("Make sure you have infinite ammo turnt on!", 5, "alert");
	if (value) then
		local env: {[string]: any} = getfenv(weapon_fire_func);
		local our_enviorment: {[string]: any} = getfenv();

		local FireGun: (...any) -> (); FireGun = hookfunction(weapon_fire_func, newcclosure(function(...: any): ()
			local current_tbl;
			for _: unknown, v: {[string]: any} in (our_enviorment.getgc(true)) do
				if (our_enviorment.type(v) == "table" and our_enviorment.rawget(v, "BulletsFired")) then
					current_tbl = v :: {[string]: any};
					break;
				end;
			end;

			our_enviorment.setthreadidentity(2);
			our_enviorment.setfenv(1, env);

			our_enviorment.setfenv(0, env);
			for i: number = 1, 70 do
				--our_enviorment.rawset(current_tbl, "Spread", 0);
				--our_enviorment.rawset(current_tbl, "BulletsFired", 71);

				FireGun(...);
			end;

			return FireGun(...);
		end));

	else
		if (isfunctionhooked(weapon_fire_func)) then
			restorefunction(weapon_fire_func);
		end;
	end;
	return;
end);


local user_input_service = service.UserInputService :: UserInputService;
do
	local new_index: (...any) -> (); new_index = hookmetamethod(game, "__newindex", newcclosure(@native function(...: any): ()
		if (getthreadidentity() ~= 2) then
			return new_index(...);
		end;

		local self: Instance, index: string, value: any = ...;
		--local caller_str: string = debug.info(3, "s");

		if (self and type(self) == "userdata" and typeof(self) == "Instance" and type(index) == "string" and value) then
			if (self.ClassName == "UserInputService" and index == "MouseBehavior" and typeof(value) == "EnumItem" and value ~= Enum.MouseBehavior.Default and states.mouse_is_unlocked) then
				return;
			elseif(self.ClassName == "Player" and index == "CameraMode" and typeof(value) == "EnumItem" and value ~= Enum.CameraMode.Classic and states.enable_3rd_person) then
				return;
			end;
		end;
		return new_index(...);
	end));
end;

workspace.ItemSpawns.ChildAdded:Connect(@native function(obj: Instance): ()
	update_items();

	notify(`You can now pick up item {obj}`, 2, "alert")
	return;
end);
workspace.ItemSpawns.ChildRemoved:Connect(@native function(obj: Instance): ()
	update_items();
	return;
end);

for i: string, v: CFrame in (locations) do
	tabs.locations:NewButton(i, @native function(_: unknown): ()
		if (not player.Character) then
			notify(`Failed to teleport to {i}, you are not spawned.`, 2, "error");
			return;
		end;

		player.character:PivotTo(v);
		return;
	end);
end;

tabs.misc:NewButton("Load IY", @native function(): ()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
end);
coroutine.wrap(@native function(): ()
	while (true) do
		network_client:SetOutgoingKBPSLimit(math.huge);
		--user_input_service.MouseBehavior = Enum.MouseBehavior.Default;

		local ui = player.PlayerGui:WaitForChild("ScreenGui");
		if (ui and ui:FindFirstChild("MouseLockFrame")) then
			ui.MouseLockFrame:Destroy();
		end;

	--	player.CameraMode = (states.enable_3rd_person and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson);
	--	user_input_service.MouseBehavior = (states.mouse_is_unlocked and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter);

       --[[if (player.Character) then
            local character = player.Character;
            if (not character:FindFirstChild("Camera")) then
                return;
            end;
            for _,v in (character.Camera:GetChildren()) do
                v.Disabled = true;
                v:Destroy();
            end;
       end;]]

		if (states.inf_ammo) then      
			weapon_events.Reload:Fire();  

			for _: unknown, v: Instance in (player.Backpack:GetDescendants()) do
				if (tostring(v) == "Reserve" or tostring(v) == "Mag" and v:IsA("IntConstrainedValue")) then
					v.MinValue = 0;
					v.MaxValue = 99999;
					v.Value = 99999;
				end;
			end;
			for _: unknown, v: Instance in (player.Character:GetDescendants()) do
				if (tostring(v) == "Reserve" or tostring(v) == "Mag" and v:IsA("IntConstrainedValue")) then
					v.MinValue = 0;
					v.MaxValue = 99999;
					v.Value = 99999;
				end;
			end;

			for _: unknown, v: Instance in (workspace.ItemSpawns:GetChildren()) do
				if (not v:IsA("MeshPart") or not string.find(string.lower(tostring(v)), "ammo")) then
					continue;
				end;

				local detector = v:FindFirstChildWhichIsA("ClickDetector", true);
				if (not detector) then
					continue;
				end;
				fireclickdetector(detector);
			end;
		end;

		task.wait(0.1);
	end;
	return;
end)();
