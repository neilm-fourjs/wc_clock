IMPORT os
IMPORT util
MAIN
	DEFINE l_titl STRING
	DEFINE l_wc   STRING
	LET l_wc = fgl_getenv("FGLIMAGEPATH")
	DISPLAY SFMT("FGLIMAGEPATH: %1", l_wc)
	RUN "env | sort > /tmp/wc_clock.env"
	OPEN FORM c FROM "clock"
	DISPLAY FORM c

	DISPLAY ui.Interface.filenameToURI("clock/clock.html") TO cl
	DISPLAY ui.Interface.filenameToURI("dclock/dclock.html") TO dcl

	CALL ui.Interface.frontCall("standard", "feInfo", ["osversion"], [l_titl])
	DISPLAY l_titl TO osver
	IF ui.Interface.getFrontEndName() = "GDC" THEN
		DISPLAY SFMT("%1: %2 GBC: %3",
						ui.Interface.getFrontEndName(), ui.Interface.getFrontEndVersion(), ui.Interface.getUniversalClientVersion())
				TO cli
	ELSE
		DISPLAY SFMT("%1: %2", ui.Interface.getFrontEndName(), ui.Interface.getFrontEndVersion()) TO cli
	END IF
	LET l_titl = ui.Window.getCurrent().getText()
	CALL updateTime(l_titl)

	MENU
		COMMAND "Exit"
			EXIT MENU
		ON ACTION close
			EXIT MENU
		ON TIMER 5
			CALL updateTime(l_titl)
	END MENU
END MAIN
--------------------------------------------------------------------------------
FUNCTION updateTime(l_titl STRING) RETURNS()
	DEFINE l_tim DATETIME HOUR TO MINUTE
	DEFINE l_win ui.Window
	LET l_win = ui.Window.getCurrent()
	IF l_win IS NULL THEN
		RETURN
	END IF
	IF l_win.findNode("FormField", "formonly.cur_time") IS NOT NULL THEN
		LET l_tim = CURRENT
		DISPLAY l_tim TO cur_time
	END IF
	IF l_win.findNode("FormField", "formonly.cur_date") IS NOT NULL THEN
		DISPLAY util.Datetime.format(CURRENT, "(%a.) %b. %d, %Y") TO cur_date
	END IF
	CALL l_win.setText(SFMT("%1 - %2 %3", l_titl, TODAY, l_tim))
END FUNCTION
