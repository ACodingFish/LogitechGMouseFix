--Author Notes
-- I assume no responsibility for any damages to your devices or any bugs. 
-- That being said, I've tried to write this code in a way that it should avoid issues and could be applied to other mice with some effort
-- A delay between 10-20 ms is recommended, but a delay in a range of 2-50 ms could potentially fix the issue and should be unnoticeable to most users.
-- If this does not work, increase the delay for the specified button.
-- I recommend using macros for the primary mouse buttons (LMB,RMB,MMB) as seen below:
-- https://www.reddit.com/r/G502MasterRace/comments/j47bxb/logitech_gaming_g502_mouse_double_clickdrag_issue/

-- This is my personal mouse setup for the Logitech G502


-- Helpful Resources
--https://github.com/ACodingFish/LogitechGMouseFix/
--https://www.reddit.com/r/LogitechG/comments/j5uecz/software_fix_for_double_clicking_logitech_mice/
--https://www.logitech.com/assets/65550/ghub.pdf
--https://douile.github.io/logitech-toggle-keys/APIDocs.pdf

--Setup DPI Table -- not implemented in GHUB yet, using macro for workaround
--dpi_table_sz = 2 -- size of the DPI_Table
--dpi_index = 2
-- SetMouseDPITable({300, 1200},dpi_index) -- 1 based indexing

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
button_state_pressed = {false,false,false,false,false,false,false,false,false,false,false} -- Button States

-- Press function table
local button_press_tbl = 
{
--	[BTN] = action
-- 	actions like, PlayMacro("MacroName") or PressKey(30) or PressKey("a") or PressMouseButton(1)
	[1] = nil, -- Assigned in G HUB (using macro method)
	[2] = nil, -- Assigned in G HUB (using macro method)
	[3] = nil, -- Assigned in G HUB (using macro method)
	[4] = PressKey, -- Assigns to Keyboard Key z, don't forget to release key
	[5] = PressKey, -- Assigns to Keyboard Key y
	[6] = PressMouseButton, -- Press Right Click, NOTE: reads as software "Click" not as hardware button press
	[7] = PlayMacro, -- Lowers DPI Setting using "DPI_Down" Macro in G HUB
	[8] = PlayMacro, -- Increases DPI Setting using "DPI_Up" Macro
	[9] = PlayMacro, -- Cycles DPI Setting using "Cycle_DPI" Macro
	[10] = PlayMacro, -- Scrolls Right using "scroll_R" Macro
	[11] = PlayMacro, -- Scrolls Left using "scroll_L" Macro
}

-- Press function arguments
local button_press_args = 
{
-- Store arguments like "MacroName" or 30 or "a" or 1 (if going by the examples in the above table.
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = "z",
	[5] = "y",
	[6] = 3, -- 3 is RMB
	[7] = "DPI_Down",
	[8] = "DPI_Up",
	[9] = "Cycle_DPI",
	[10] = "scroll_R",
	[11] = "scroll_L",
}

-- Release function table
local button_release_tbl = 
{
--	[BTN] = action
-- 	actions like, AbortMacro("MacroName") or ReleaseKey(30) or ReleaseKey("a") or ReleaseMouseButton(1)
	[1] = nil, -- Assigned in G HUB (using macro method)
	[2] = nil, -- Assigned in G HUB (using macro method)
	[3] = nil, -- Assigned in G HUB (using macro method)
	[4] = ReleaseKey,
	[5] = ReleaseKey,
	[6] = ReleaseMouseButton,
	[7] = nil, -- No Action
	[8] = nil,
	[9] = nil,
	[10] = nil,
	[11] = nil,
}

-- Release function arguments
local button_release_args = 
{
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = "z",
	[5] = "y",
	[6] = 3, -- 3 is RMB
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