-- Mouse buttons list for G502
mouse_buttons = {"1 - Left MB", "2 - Right MB", "3 - Middle MB", "4 - G4", "5 - G5", "6 - Thumb Target MB", "7 - G7 ", "8 - G8",  "9 - G9", "10 - Scroll Wheel Right", "11 - Scroll Wheel Left"}

EnablePrimaryMouseButtonEvents(true);

function OnEvent(event, arg)
	
	if event == "MOUSE_BUTTON_PRESSED"  then
        		OutputLogMessage("Event: "..event.." Button: "..mouse_buttons[arg].."\n");
	end	
end