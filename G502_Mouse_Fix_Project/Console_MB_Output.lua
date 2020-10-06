
function OnEvent(event, arg)
	
	if event == "MOUSE_BUTTON_PRESSED"  then
        		OutputLogMessage("Event: "..event.." Button: "..arg.."\n");
	end	
end
