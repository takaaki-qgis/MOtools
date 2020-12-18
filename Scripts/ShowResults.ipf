#pragma rtGlobals=3		// Use modern global access method and strict wave access.
Macro Panel_MO2Analysis()
	NewPanel /N=MO2_Analysiser/W=(150,50,350,270)
	variable/G StartRMO2=	0
	variable/G StartUMO2=	0
	variable/G StartEPOC=	0
	checkbox 	checkR,	pos={30,15},	size={78,20},	fsize=14,	title="RMO2",	value=0,	mode=0, proc=CheckProcR
	checkbox 	checkU,	pos={30,40},	size={78,20},	fsize=14,	title="UMO2",	value=0,	mode=0, proc=CheckProcU
	checkbox 	checkE,	pos={30,65},	size={78,20},	fsize=14,	title="EPOC",	value=0,	mode=0, proc=CheckProcE
	Button		Btn1,	pos={30,90},	size={140,30},	fsize=16,	title="   Calculation\\JL", 		proc=Button_CalcMO2
	Button		Btn2,	pos={30,125},	size={140,30},	fsize=16,	title="   See Table\\JL", 	proc=Button_ShowTable
	Button		Btn3,	pos={30,160},	size={140,30},	fsize=16,	title="   See TimeSeries\\JL", 	proc=Button_ShowTS
end
///////////////////////////////////////////
Function CheckProcR(cba)
	STRUCT WMCheckboxAction &cba
	NVAR StartRMO2= root:StartRMO2
	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			break
		case -1: // control being killed
			break
	endswitch	
	StartRMO2= checked
	return 0
End
//////////////////////////
Function CheckProcU(cba)
	STRUCT WMCheckboxAction &cba
	NVAR StartUMO2= root:StartUMO2
	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			break
		case -1: // control being killed
			break
	endswitch	
	StartUMO2= checked
	return 0
End
/////////////////////////////
Function CheckProcE(cba)
	STRUCT WMCheckboxAction &cba
	NVAR StartEPOC= root:StartEPOC
	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			break
		case -1: // control being killed
			break
	endswitch	
	StartEPOC= checked
	return 0
End
//////////////////////////////////
Function Button_CalcMO2(ba)
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			execute "StartCalcMO2()"
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End
////
Function StartCalcMO2()
	NVAR StartRMO2= root:StartRMO2
	NVAR StartUMO2= root:StartUMO2
	NVAR StartEPOC= root:StartEPOC
	If (StartRMO2==1)
		Execute "RestMO2_AllCalc()"
	endif	
	If (StartUMO2==1)
		Execute "UMO2_AllCalc()"
	endif	
	If (StartEPOC==1)
		Execute "EPOC_Allcalc()"
	endif
end
//////////////////////////////////
Function Button_ShowTable(ba)
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			execute "StartShowMO2()"
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End
/////
Function StartShowMO2()
	NVAR StartRMO2= root:StartRMO2
	NVAR StartUMO2= root:StartUMO2
	NVAR StartEPOC= root:StartEPOC
	If (StartRMO2==1)
		Execute "Show_RMO2Results()"
	endif	
	If (StartUMO2==1)
		Execute "Show_UMO2Results()"
	endif	
	If (StartEPOC==1)
		Execute "Show_EPOCResults()"
	endif
end
/////
proc Show_RMO2Results()
	edit RestMO2_NoT, RestMO2_AccliDuration, RestMO2_Dif, RestMO2_Linefit, RestMO2_vR2, RestMO2_DaT
	ModifyTable size(RestMO2_NoT)=16,		width(RestMO2_NoT)=120
	ModifyTable size(RestMO2_Dif)=16,		width(RestMO2_Dif)=120
	ModifyTable size(RestMO2_Linefit)=16,	width(RestMO2_Linefit)=120
	ModifyTable size(RestMO2_vR2)=16,		width(RestMO2_vR2)=120
	ModifyTable size(RestMO2_AccliDuration)=16,		width(RestMO2_AccliDuration)=120
	ModifyTable size(RestMO2_DaT)=16,		width(RestMO2_DaT)=150, 	format(RestMO2_DaT)=7
End
/////
proc Show_UMO2Results()
	edit UMO2_NoT, UMO2_Dif, UMO2_Linefit, UMO2_vR2, UMO2_DaT as "UMO2Results"
	ModifyTable size(UMO2_NoT)=16,	width(UMO2_NoT)=120
	ModifyTable size(UMO2_Dif)=16,		width(UMO2_Dif)=120
	ModifyTable size(UMO2_Linefit)=16,	width(UMO2_Linefit)=120
	ModifyTable size(UMO2_vR2)=16,		width(UMO2_vR2)=120
	ModifyTable size(UMO2_DaT)=16,		width(UMO2_DaT)=150, 	format(UMO2_DaT)=7
End
/////
proc Show_EPOCResults()
	edit EPOC_NoT, EPOC_Duration, EPOC_Dif, EPOC_Linefit, EPOC_vR2, EPOC_DaT
	ModifyTable size(EPOC_NoT)=16,		width(EPOC_NoT)=120
	ModifyTable size(EPOC_Dif)=16,		width(EPOC_Dif)=120
	ModifyTable size(EPOC_Linefit)=16,	width(EPOC_Linefit)=120
	ModifyTable size(EPOC_vR2)=16,		width(EPOC_vR2)=120
	ModifyTable size(EPOC_DaT)=16,		width(EPOC_DaT)=150, 	format(EPOC_DaT)=7
	ModifyTable size(EPOC_Duration)=16,		width(EPOC_Duration)=120
End
////////////////////////////////////////
proc RestMO2_AllCalc(NoT, Wname)
	variable	NoT
	string	Wname
		Prompt NoT,		"How many trials?"
		Prompt Wname	"Template wave name for MO2 Analysis during Acclimation"
	string	snt1, snt2, snt3, snt4
	snt1= "make/O/D/N="+num2str(NoT)+" RestMO2_Linefit"
	snt2= "make/O/D/N="+num2str(NoT)+" RestMO2_vR2"
	snt3= "make/O/D/N="+num2str(NoT)+" RestMO2_DaT"
	snt4= "make/O/D/N="+num2str(NoT)+" RestMO2_Dif"
	execute	snt1
	execute	snt2
	execute	snt3
	execute snt4
	make/T/O RestMO2_NoT
	
	variable i=1
	do
			MO2_FitCalc_ver2(i, Wname, RestMO2_Linefit, RestMO2_vR2, RestMO2_DaT, RestMO2_NoT)
			MO2_DifCalc(i, Wname, RestMO2_Dif)
			i+=1
	while(i<=NoT)
	
	if(Accl_stDaT != nan)
		string snt5, snt6
		snt5= "make/O/D/N="+num2str(NoT)+" RestMO2_AccliDuration" 
		snt6= "RestMO2_AccliDuration = (RestMO2_DaT - Accl_stDaT)/60"
		execute snt5; execute snt6
	endif
EndMacro 
///


/////////////////このマクロを使うときは対象のウェーブの名前をU__とすること
Proc UMO2_AllCalc(StartU, Stepwise, EndU, W_tmp)
	variable	StartU, Stepwise, EndU
	string	W_tmp
		Prompt	StartU,		"Start speed?"
		Prompt	Stepwise,	"Stepwise?"
		Prompt	EndU,		"End Speed?"
		Prompt	W_tmp, 	"Wave name Template?"
	
	variable NumStep
	NumStep = (EndU-StartU)/Stepwise +1
	
	string	snt1, snt2, snt3, snt4, snt5
	snt1= "make/O/D/N="+num2istr(NumStep)+" UMO2_LineFit"
	snt2= "make/O/D/N="+num2istr(NumStep)+" UMO2_vR2"
	snt3= "make/O/D/N="+num2istr(NumStep)+" UMO2_Dif"	
	snt4= "make/O/D/N="+num2istr(NumStep)+" UMO2_DaT"
	snt5= "make/O/D/N="+num2istr(NumStep)+" UMO2_U"	
	make/T/O UMO2_NoT

	execute	snt1; execute snt2; execute	snt3; execute snt4; execute snt5
	
	variable i, Ui
	i=0
	Ui=StartU
	do
			UMO2_FitCalc(i, Ui, W_tmp, UMO2_Linefit, UMO2_vR2, UMO2_DaT, UMO2_U, UMO2_NoT)
			UMO2_DifCalc(i, Ui, W_tmp, UMO2_Dif)
			Ui+=Stepwise
			i+=1
	while(i+1<=NumStep)
	
EndMacro 
////////////////////////////////////////////////////////////
Function UMO2_FitCalc(i, Ui, W_tmp, UMO2_Linefit, UMO2_vR2,  UMO2_DaT, SwimSpeed, UMO2_NoT)
	wave UMO2_Linefit, UMO2_vR2, UMO2_DaT, SwimSpeed
	string W_tmp
	wave/T  UMO2_NoT
	variable i, Ui

	string W
	w= W_tmp+num2str(Ui)
	UMO2_NoT[i]=	W
	
	string snt1
	snt1 = "duplicate/o/d "+ "'"+ w+ "'" +", ChangeRateO2"
	execute snt1
	
	wave CRO 		= $("ChangeRateO2")	
	setScale/P x 0,0.016666666666, "", CRO
	
	CurveFit/M=2/W=0/Q line, CRO/D
	wave	fit_CRO		= $("fit_ChangeRateO2")
	wave	Coef 		= $("W_coef")
	variable	r2
	UMO2_Linefit[i]		= -Coef[1]
	UMO2_vR2[i]		= V_r2
	killwaves fit_CRO
	
	string snt2
	snt2=	"wavestats/Q " + "'" + W +"'"
	execute snt2
	
	NVAR V_minloc, V_maxloc
	UMO2_DaT[i]	=  (V_minloc + V_maxloc)/2
	SwimSpeed[i]	=Ui
	
	killwaves CRO, fit_CRO, Coef

End
///
Function UMO2_DifCalc(i, Ui, W_tmp, UMO2_Dif)	//////(Step数、速度、格納するwave)
	variable i, Ui
	string	W_tmp
	wave UMO2_Dif
	
	string W
	w= W_tmp+num2str(Ui)
	
	string snt1
	snt1 = "duplicate/o/d" +  "'" + w + "'" + ", ChangeRateO2"
	execute snt1
	wave CRO 		= $("ChangeRateO2")	
	
	variable FirstMO2, LastMO2, Secs
	FirstMO2=	(CRO[0]*CRO[1]*CRO[2])^(1/3)
	Secs=		numpnts(CRO)
	LastMO2=	(CRO[Secs-3]*CRO[Secs-2]*CRO[Secs-1])^(1/3)
	
	UMO2_Dif[i]=(FirstMO2-LastMO2)/Secs*60
	
end
/////////////////////////////////////////////
proc EPOC_AllCalc(NoT, Wname)
	variable	NoT
	string	Wname
		Prompt NoT,		"How many trials?"
		Prompt Wname	"Template name of wave for EPOC Analysis"
			
	string	snt1, snt2, snt3, snt4
	snt1= "make/O/D/N="+num2istr(NoT)+" EPOC_Linefit"
	snt2= "make/O/D/N="+num2istr(NoT)+" EPOC_vR2"
	snt3= "make/O/D/N="+num2istr(NoT)+" EPOC_DaT"
	snt4= "make/O/D/N="+num2istr(NoT)+" EPOC_Dif"
	execute	snt1; execute snt2; execute snt3; execute snt4
	
	make/T/O EPOC_NoT
	
	variable i
	i=1
	do
			MO2_FitCalc_ver2(i, Wname, EPOC_Linefit, EPOC_vR2, EPOC_DaT, EPOC_NoT)
			MO2_DifCalc(i, Wname, EPOC_Dif)
			i+=1
	while(i<=NoT)
	
		if(EPOC_stDaT != nan)
			string snt5, snt6
			snt5= "make/O/D/N="+num2str(NoT)+" EPOC_Duration" 
			snt6= "EPOC_Duration = (EPOC_DaT - EPOC_stDaT)/60"
			execute snt5; execute snt6
		endif

EndMacro 

////////////////////////////////////////
Function MO2_DifCalc(n, Wname, MO2_Dif)	//////(試行数、解析するウェーブの名前の鋳型、格納するwave)
	variable n
	string	Wname
	wave	MO2_Dif
	
	string snt1
	snt1 = "duplicate/o/d "+Wname+num2istr(n)+", ChangeRateO2"
	execute snt1
	wave CRO 		= $("ChangeRateO2")	
	
	variable FirstMO2, LastMO2, Secs
	FirstMO2=	(CRO[0]*CRO[1]*CRO[2])^(1/3)
	Secs=		numpnts(CRO)
	LastMO2=	(CRO[Secs-3]*CRO[Secs-2]*CRO[Secs-1])^(1/3)
	
	MO2_Dif[n-1]=(FirstMO2-LastMO2)/Secs*60
	killwaves CRO
end
////////////////////////////////////////
Function MO2_FitCalc_ver2(n, W_tmp, MO2, vR2, DaT, W_name)
	wave MO2, vR2, DaT
	variable n
	string W_tmp
	wave/T W_name

	string snt1
	snt1 = "duplicate/o/d "+ W_tmp+num2istr(n) +", ChangeRateO2"
	execute snt1
		
	wave CRO 		= $("ChangeRateO2")
	
	setScale/P x 0,0.016666666666, "", CRO
	
	CurveFit/M=2/W=0/Q line, CRO/D
	wave fit_CRO	= $("fit_ChangeRateO2")
	wave Coef 		= $("W_coef")
	MO2[n-1]	= -Coef[1]
	vR2[n-1]	= V_r2
	
	string snt2
	snt2=	"wavestats/Q "+ W_tmp +num2istr(n)
	execute snt2
	NVAR V_minloc, V_maxloc
	
	DaT[n-1]	=  (V_minloc + V_maxloc)/2
	killwaves CRO, fit_CRO
	
	string snt3
	snt3=	W_tmp+num2istr(n)
	W_Name[n-1]	= snt3

End
///////////////////////////////////////////////////
Macro EPOCwaveMaker(SourceName, Range, StartNum)
	String 	SourceName
	Variable	Range, StartNum
		prompt	SourceName		"Wave for Sampling"
		prompt	StartNum		"Number for first wave"
		prompt	Range			"Sampling Window(second)"
	variable StartP, EndP, NoT
		StartP	=	pcsr(A) 
		EndP	=	pcsr(B)
		NoT		=	trunc((EndP-StartP)/Range)
	variable	n, StP, r
	n=StartNum
	StP=StartP
	r=range
	do
		waveMaker_EPOC(StP, Range, n, SourceName)
		StP+= r
		n+=1
	while(StP<EndP-range+1)
EndMacro
///////
Function waveMaker_EPOC(StP, Range, N, SourceName)
	variable StP, Range, N
	string	SourceName
	variable EdP
	EdP= StP + Range
	string snt1
		snt1=	"Duplicate/O/R=["+ num2str(StP) + ","+ num2str(EdP) + "]"+" "+SourceName +", EPOC"+num2istr(N)
	execute snt1
End  