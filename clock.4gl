IMPORT os
MAIN
	DEFINE l_titl STRING
	DEFINE l_wc   STRING
	LET l_wc = fgl_getenv("FGLIMAGEPATH")
	DISPLAY SFMT("FGLIMAGEPATH: %1", l_wc)
	RUN "env | sort > /tmp/wc_clock.env"
	OPEN FORM c FROM "clock"
	DISPLAY FORM c
	LET l_titl = ui.Window.getCurrent().getText()

	IF fgl_getenv("GAS") = "true" THEN
		DISPLAY ui.Interface.filenameToURI("clock/clock.html") TO cl
		DISPLAY ui.Interface.filenameToURI("dclock/dclock.html") TO dcl
	ELSE
		DISPLAY os.Path.join(l_wc, "clock/clock.html") TO cl
		DISPLAY os.Path.join(l_wc, "dclock/dclock.html") TO dcl
	END IF

	CALL updateTime("formonly.cur_time", l_titl)

	MENU
		COMMAND "Exit"
			EXIT MENU
		ON ACTION close
			EXIT MENU
		ON TIMER 5
			CALL updateTime("formonly.cur_time", l_titl)
	END MENU
END MAIN
--------------------------------------------------------------------------------
FUNCTION updateTime(l_ff STRING, l_titl STRING) RETURNS()
	DEFINE l_tim DATETIME HOUR TO MINUTE
	DEFINE l_win ui.Window
	LET l_win = ui.Window.getCurrent()
	IF l_win IS NULL THEN
		RETURN
	END IF
	IF l_win.findNode("FormField", l_ff) IS NOT NULL THEN
		LET l_tim = CURRENT
		DISPLAY l_tim TO cur_time
	END IF
	CALL l_win.setText(SFMT("%1 - %2 %3", l_titl, TODAY, l_tim))
END FUNCTION
