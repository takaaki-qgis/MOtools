#pragma rtGlobals=3		// Use modern global access method and strict wave access.
proc Panel_SetDate()
	NewPanel /N=SetDate/W=(150,50,450,200)
	
	Button	Btn1,	pos={40,15},	size={100,30},	title="Acclination",	fsize=14,	proc=Button_AcclSetDate
	Button 	Btn2,	pos={40,55},	size={100,30},	title="Measure",		fsize=14,	proc=Button_MesSetDate
	Button 	Btn3,	pos={40,95},	size={100,30},	title="EPOC",		fsize=14,	proc=Button_EPOCSetDate
	Button	Btn4,	pos={160,40},	size={120,50}, 	title="Show Date", 	fsize=18,	fstyle=0,		proc=Button_ShowMO2


End
//////////////////////////////////
Function Button_AcclSetDate(ba)
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			execute "SetAcclimationStartDate()"
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End
///////////////////////////////////////
Proc SetAcclimationStartDate(Year, Month, Day, hh, mm, ss)
		variable	Year, Month, Day, hh, mm, ss
		Prompt	Year,		"Year?"
		Prompt	Month, 		"Month?"
		Prompt	Day, 		"Day?"
		Prompt	hh, 			"Hour?"
		Prompt	mm,		"Minute?"
		Prompt	ss, 			"Second?"
	
	variable/G	Accli_StDate = 	Date2secs(Year, Month, Day)
	variable/G	Accli_StTime = 	3600*hh + 60*mm + ss
	variable/G	Accli_StDaT =	Accli_StDate + Accli_StTime

EndMacro
//////////////////////////////////
Function Button_MesSetDate(ba)
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			execute "SetMeasureStartDate()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End
///////////////////////////////////////
Proc SetMeasureStartDate(Year, Month, Day, hh, mm, ss)
		variable	Year, Month, Day, hh, mm, ss
		Prompt	Year,		"Year?"
		Prompt	Month, 		"Month?"
		Prompt	Day, 		"Day?"
		Prompt	hh, 			"Hour?"
		Prompt	mm,		"Minute?"
		Prompt	ss, 			"Second?"
	
	variable/G	Mes_StDate = 	Date2secs(Year, Month, Day)
	variable/G	Mes_StTime = 	3600*hh + 60*mm + ss
	variable/G	Mes_StDaT =	StartDate + AccliStTime

EndMacro
//////////////////////////////////
Function Button_EPOCSetDate(ba)
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			execute "SetEPOCStartDate()"
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End
///////////////////////////////////////
proc SetEPOCStartDate(Year, Month, Day, hh, mm, ss)
	variable	Year, Month, Day, hh, mm, ss
		Prompt	Year,		"Year?"
		Prompt	Month, 		"Month?"
		Prompt	Day, 		"Day?"
		Prompt	hh, 			"Hour?"
		Prompt	mm,		"Minute?"
		Prompt	ss, 			"Second?"
	
	variable/G	EPOC_StDate = 	Date2secs(Year, Month, Day)
	variable/G	EPOC_StTime = 	3600*hh + 60*mm + ss
	variable/G	EPOC_StDaT =	EPOC_StDate + EPOC_StTime

EndMacro
/////////////////////////////////////////
proc Show_Date()
	
	NVAR Accli_stDaT, EPOC_stDaT
	
	make/O/N=2	DaT_Value
	DaT_Value[0]=	secs2date(Accli_StDaT)
	DaT_Value[1]=	secs2date(EPOC_StDaT)
	
	make/O/T 		DaT_Parameter
	DaT_Parameter[0]=	"Acclimation_Start_DaT" 
	DaT_Parameter[1]=	"EPOC_Start_DaT"
	
	Edit DaT_Parameter, DaT_Value
	ModifyTable size(DaT_Parameter)=16,	width(DaT_Parameter)=200
	ModifyTable size(DaT_Value)=16,			width(DaT_Value)=200, 		format(DaT_Value)=8
	
End
//////////////////////////////////////// 

