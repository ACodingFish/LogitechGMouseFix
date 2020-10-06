--Author Notes
-- I assume no responsibility for any damages to your devices or any bugs. 
-- That being said, I've tried to write this code in a way that it should avoid issues and could be applied to other mice with some effort
-- A delay between 10-20 ms is recommended, but a delay in a range of 2-50 ms could potentially fix the issue and should be unnoticeable to most users.
-- If this does not work, increase the delay for the specified button.
-- I recommend using macros for the primary mouse buttons (LMB,RMB,MMB) as seen below:
-- https://www.reddit.com/r/G502MasterRace/comments/j47bxb/logitech_gaming_g502_mouse_double_clickdrag_issue/


-- Helpful Resources
--https://github.com/ACodingFish/LogitechGMouseFix/
--https://www.reddit.com/r/LogitechG/comments/j5uecz/software_fix_for_double_clicking_logitech_mice/
--https://www.logitech.com/assets/65550/ghub.pdf
--https://douile.github.io/logitech-toggle-keys/APIDocs.pdf

-- READ THIS BEFORE CONTINUING --
-- Enabling Primary Mouse Button Events Causes Performance Issues, Do at your own risk.

--EnablePrimaryMouseButtonEvents(true);         -- Enable this if you need to edit left mouse button

-- Mouse buttons list (array) for G502 - Arrays in LUA are 1-based, rather than 0-based
--mouse_buttons = {"1 - Left MB", "2 - Right MB", "3 - Middle MB", "4 - G4", "5 - G5", "6 - Thumb Target MB", "7 - G7 ", "8 - G8",  "9 - G9", "10 - Scroll Wheel Right", "11 - Scroll Wheel Left"}
-- Button delay organized by buttons
num_mouse_buttons = 11									-- Number of Buttons on mouse
press_delay_ms = {10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10}			-- Length that should be delayed for each button in ms after a button press
release_delay_ms =  {10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10}			-- Length that should be delayed for each button in ms after a button release
last_press_timestamp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}		-- TImestamp of last button press
last_release_timestamp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}		-- Timestamp of last button release

function unbound(arg)
	OutputLogMessage("Action Unbound"..arg.."\n");
end

function empty()
	OutputLogMessage("Empty\n");
end

-- Press function table
local button_press_tbl = 
{
--	[BTN] = action
-- 	actions like, PlayMacro("MacroName") or PressKey(30) or PressKey("a") or PressMouseButton(1)
	[1] = unbound,
	[2] = unbound,
	[3] = unbound,
	[4] = unbound,
	[5] = unbound,
	[6] = unbound,
	[7] = unbound,
	[8] = unbound,
	[9] = unbound,
	[10] = unbound,
	[11] = unbound,
}

-- Press function arguments
local button_press_args = 
{
-- Store arguments like "MacroName" or 30 or "a" or 1 (if going by the examples in the above table.
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,
	[9] = 9,
	[10] = 10,
	[11] = 11,
}

-- Release function table
local button_release_tbl = 
{
--	[BTN] = action
-- 	actions like, AbortMacro("MacroName") or ReleaseKey(30) or ReleaseKey("a") or ReleaseMouseButton(1)
	[1] = empty,
	[2] = empty,
	[3] = empty,
	[4] = empty,
	[5] = empty,
	[6] = empty,
	[7] = empty,
	[8] = empty,
	[9] = empty,
	[10] = empty,
	[11] = empty,
}

-- Release function arguments
local button_release_args = 
{
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = nil,
	[5] = nil,
	[6] = nil,
	[7] = nil,
	[8] = nil,
	[9] = nil,
	[10] = nil,
	[11] = nil,
}


function OnEvent(event, arg)
	
	if (event == "MOUSE_BUTTON_PRESSED")  and (arg <= num_mouse_buttons) then
        button_state_pressed[arg] = true;
		if (GetRunningTime() -	last_press_timestamp[arg]) >= press_delay_ms[arg] then
        			--OutputLogMessage("Event: "..event.." Button: "..mouse_buttons[arg].."\n");
            if delay_press_check(arg) then
                local press_func = button_press_tbl[arg]
                local press_arg = button_press_args[arg]
                if (press_func)  then
                    if (press_arg) then
                        press_func(press_arg)
                    else
                        press_func()
                    end
                end
                last_press_timestamp[arg] = GetRunningTime();
                
            end
		end
	elseif (event == "MOUSE_BUTTON_RELEASED")  and (arg <= num_mouse_buttons) then
        button_state_pressed[arg] = false;
		if delay_release_check(arg) then			-- Holding the button and releasing it should fix any locking issues.
        			--OutputLogMessage("Event: "..event.." Button: "..mouse_buttons[arg].."\n");
			local release_func = button_release_tbl[arg]
			local release_arg = button_release_args[arg]
			if (release_func)  then
				if (release_arg) then
					release_func(release_arg)
				else
					release_func()
				end
			end
			last_release_timestamp[arg] = GetRunningTime();
		end
	end
end

function delay_press_check(arg)
    last_release = (GetRunningTime() -	last_release_timestamp[arg])
    if (last_release < release_delay_ms[arg]) then
        return false
    else
        return true
    end
end

function delay_release_check(arg)
    last_press = (GetRunningTime() - last_press_timestamp[arg])
    last_press_remaining = 0
    if (last_press < press_delay_ms[arg]) then
        last_press_remaining = press_delay_ms[arg] - last_press
    end
    
    last_release = (GetRunningTime() -	last_release_timestamp[arg])
    last_release_remaining = 0
    if (last_release < release_delay_ms[arg]) then
        last_release_remaining = release_delay_ms[arg] - last_press
    end
    
    delay_remaining = math.max(last_press_remaining, last_release_remaining);
    if (delay_remaining > 0) then
        Sleep(delay_remaining);
    end
    
    if (button_state_pressed[arg] == false) then
        return true
    else
        return false
    end

end