#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

////////////////////////////////////////////////////////////////////////////////
/// @file			MO2Analyser.ipf
/// @brief			
/// @author			  
/// @date			
/// Version:		1
/// Revision:		$
/// @note			ファイルに備考などを明記する場合はここへ書き込む
/// @attention		ファイルに注意書きなどを明記する場合はここへ書き込む
///
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Macro DefineExperimentalCondition(Oxygen, ID, Temp, lFL, lBW, lVc)
	string 	Oxygen, ID
	variable Temp, lFL, lBW, lVc
		Prompt	Oxygen, 	"wave for Analysis?"
		Prompt	ID,  			"FishID?"
		Prompt	Temp, 		"Temperature(Degree)?"
		Prompt	lFL, 			"Fork Length (cm)?"
		Prompt	lBW,		"Body weight (g)?"
		Prompt	lVc,			"Chamber size (l)?" 
	
	variable/G	FL=		lFL
	variable/G	BW=	lBW		///////BWはGlobal変数で格納
	variable/G	Vc=		lVc		///////VcもGlobal変数で格納
	
	make/T/O Parameter
	Parameter[0]=	"FishID"
	Parameter[1]=	"Temperature(Deg.)"
	Parameter[2]=	"ForkLength(cm)"
	Parameter[3]=	"BodyWeight(g)"
	
	make/T/O Value
	Value[0]=	ID
	Value[1]=	num2str(Temp)
	Value[2]=	num2str(FL)
	Value[3]=	num2str(BW)
	
	ChamberO2($Oxygen)	///////Chamber内の溶存酸素量を計算させておく
	
	Edit Parameter, Value
	ModifyTable size(Parameter)=16,	width(Parameter)=200
	ModifyTable size(Value)=16,		width(Value)=200

EndMacro
///////////////////////////////////////
Macro DefineExperimentalDate(Year, Month, Day)
	string 	Oxygen, ID
	variable Temp, lFL, lBW, lVc
		Prompt	Oxygen, 	"wave for Analysis?"
		Prompt	ID,  		"FishID?"
		Prompt	Temp, 		"Temperature(Degree)?"
		Prompt	lFL, 		"Fork Length (cm)?"
		Prompt	lBW,		"Body weight (g)?"
		Prompt	lVc,		"Chamber size (l)?" 
	
	variable/G	FL=		lFL
	variable/G	BW=		lBW		///////BWはGlobal変数で格納
	variable/G	Vc=		lVc		///////VcもGlobal変数で格納
	
	make/T/O Parameter
	Parameter[0]=	"FishID"
	Parameter[1]=	"Temperature(Deg.)"
	Parameter[2]=	"ForkLength(cm)"
	Parameter[3]=	"BodyWeight(g)"
	
	make/T/O Value
	Value[0]=	ID
	Value[1]=	num2str(Temp)
	Value[2]=	num2str(FL)
	Value[3]=	num2str(BW)
	
	ChamberO2($Oxygen)	///////Chamber内の溶存酸素量を計算させておく
	
	Edit Parameter, Value
	ModifyTable size(Parameter)=16,	width(Parameter)=200
	ModifyTable size(Value)=16,		width(Value)=200

EndMacro
////////////////////////////////////////
Function ChamberO2(Oxygen)
	wave 	Oxygen
	variable	p = 0
	NVAR BW = root:BW, Vc = root:Vc		/////Global変数からの引用
	
	Duplicate/O Oxygen, mgO2
		do
		mgO2[p] = Oxygen[p]*(Vc - BW/1000)
		p+=1
		while (p<numpnts(Oxygen))
	
	Duplicate/O Oxygen, ugO2
		ugO2= mgO2*1000
	
End

///////////////////////////////////////
Macro SamplingWave(Source, Newname)
	string Source, Newname
		Prompt	Source,		"wave for Sampling?"
		Prompt	Newname,	"New wave Name?"
		
		Sampling($Source, NewName)

End
////////////////////////////////////////
Function Sampling(Source, NewName)
	wave Source
	string Newname
	string s
	
	Duplicate/O Source, wt
	
	s= "Duplicate/O/R=[pcsr(A), pcsr(B)] wt," + "'"+ Newname + "'"
	execute s
	killwaves wt
	
	print "Created Wave " + Newname
End

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Macro RestMO2_AllCalc(NoT, Wname)
	variable	NoT
	string	Wname
		Prompt NoT,		"How many trials?"
		Prompt Wname	"Template wave name for MO2 Analysis during Acclimation"
			
	string	snt1
	snt1= "make/O/D/N="+num2str(NoT)+" RestMO2_Linefit"
	execute	snt1
	
	string	snt2
	snt2= "make/O/D/N="+num2str(NoT)+" RestMO2_vR2"
	execute	snt2
	
	string	snt3
	snt3= "make/O/D/N="+num2str(NoT)+" RestMO2_DaT"
	execute	snt3
	
	string	snt4
	snt4= "make/O/D/N="+num2str(NoT)+" RestMO2_Dif"
	execute	snt4
	
	make/T/O RestMO2_NoT
	
	variable i
	i=1
	do
			MO2_FitCalc_ver2(i, Wname, RestMO2_Linefit, RestMO2_vR2, RestMO2_DaT, RestMO2_NoT)
			MO2_DifCalc(i, Wname, RestMO2_Dif)
			i+=1
	while(i<=NoT)

EndMacro 
////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
/////////////////このマクロを使うときは対象のウェーブの名前をU__とすること
///
////////////////////////////////////////////////////////////////////////////////
Macro UMO2_AllCalc(StartU, Stepwise, NumStep)
	variable	StartU, Stepwise, NumStep
		Prompt StartU,		"Start speed?"
		Prompt Stepwise	,	"Stepwise?"
		Prompt	NumStep,	"How many Step?"
	
	string	snt1
	snt1= "make/O/D/N="+num2istr(NumStep)+" UMO2_LineFit"
	execute	snt1
	
	string	snt2
	snt2= "make/O/D/N="+num2istr(NumStep)+" UMO2_vR2"
	execute	snt2
	
	string	snt3
	snt3= "make/O/D/N="+num2istr(NumStep)+" UMO2_Dif"
	execute	snt3
	
	string	snt4
	snt4= "make/O/D/N="+num2istr(NumStep)+" UMO2_DaT"
	execute	snt4
	
	string	snt5
	snt5= "make/O/D/N="+num2istr(NumStep)+" UMO2_U"
	execute	snt5
	
	make/T/O UMO2_NoT
	
	variable i, Ui
	i=0
	Ui=StartU
	do
			UMO2_FitCalc(i, Ui, UMO2_Linefit, UMO2_vR2, UMO2_DaT, UMO2_U, UMO2_NoT)
			UMO2_DifCalc(i, Ui, UMO2_Dif)
			Ui+=Stepwise
			i+=1
	while(i+1<=NumStep)
	
EndMacro 

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Function UMO2_FitCalc(i, Ui, UMO2_Linefit, UMO2_vR2,  UMO2_DaT, SwimSpeed, UMO2_NoT)
	wave UMO2_Linefit, UMO2_vR2, UMO2_DaT, SwimSpeed
	wave/T  UMO2_NoT
	variable i, Ui
	

	string W
	w= "U"+num2str(Ui)
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
	UMO2_Linefit[i]	= -Coef[1]
	UMO2_vR2[i]		= V_r2
	killwaves fit_CRO
	
	string snt2
	snt2=	"wavestats/Q " + "'" + W +"'"
	execute snt2
	NVAR V_minloc, V_maxloc
	
	UMO2_DaT[i]	=  (V_minloc + V_maxloc)/2
	SwimSpeed[i]	=Ui
	
	killwaves CRO, fit_CRO, Coef

End Function

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Function UMO2_DifCalc(i, Ui, UMO2_Dif)	//////(Step数、速度、格納するwave)
	variable i, Ui
	wave UMO2_Dif
	
	string W
	w= "U"+num2str(Ui)
	
	string snt1
	snt1 = "duplicate/o/d" +  "'" + w + "'" + ", ChangeRateO2"
	execute snt1
	wave CRO 		= $("ChangeRateO2")	
	
	variable FirstMO2, LastMO2, Secs
	FirstMO2=	(CRO[0]*CRO[1]*CRO[2])^(1/3)
	Secs=		numpnts(CRO)
	LastMO2=	(CRO[Secs-3]*CRO[Secs-2]*CRO[Secs-1])^(1/3)
	
	UMO2_Dif[i]=(FirstMO2-LastMO2)/Secs*60
	
End Function

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Macro EPOC_AllCalc(NoT, Wname)
	variable	NoT
	string	Wname
		Prompt NoT,		"How many trials?"
		Prompt Wname	"Template name of wave for EPOC Analysis"
			
	string	snt1
	snt1= "make/O/D/N="+num2istr(NoT)+" EPOC_Linefit"
	execute	snt1
	
	string	snt2
	snt2= "make/O/D/N="+num2istr(NoT)+" EPOC_vR2"
	execute	snt2
	
	string	snt3
	snt3= "make/O/D/N="+num2istr(NoT)+" EPOC_DaT"
	execute	snt3
	
	string	snt4
	snt4= "make/O/D/N="+num2istr(NoT)+" EPOC_Dif"
	execute	snt4
	
	make/T/O EPOC_NoT
	
	variable i
	i=1
	do
			MO2_FitCalc_ver2(i, Wname, EPOC_Linefit, EPOC_vR2, EPOC_DaT, EPOC_NoT)
			MO2_DifCalc(i, Wname, EPOC_Dif)
			i+=1
	while(i<=NoT)
	
	string snt5
	snt5= "edit EPOC_NoT, EPOC_Dif, EPOC_Linefit, EPOC_vR2, EPOC_DaT"
	execute snt5
	

	
EndMacro 

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
proc AfterTime(Year, Month, Day, Hh, Mm, Ss)
	prompt 

end

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
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

End Function

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
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


End Function

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Macro EPOCwaveMaker(SourceName, Range, StartNum)
	String 	SourceName
	Variable	Range, StartNum
		prompt	SourceName		"Wave for Sampling"
		prompt	StartNum		"Number for first wave"
		prompt	Range			"Window(second)"
	
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
///////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// @brief		
/// @param		
/// @return	
///
////////////////////////////////////////////////////////////////////////////////
Function waveMaker_EPOC(StP, Range, N, SourceName)
	variable StP, Range, N
	string	SourceName
	
	variable EdP
	EdP= StP + Range
	
	string snt1
		snt1=	"Duplicate/O/R=["+ num2str(StP) + ","+ num2str(EdP) + "]"+" "+SourceName +", EPOC"+num2istr(N)
	execute snt1
	
End Function

////////////////////////////////////////////
Macro KillwaveFromWaveName(EndNum, targetWaveTempStr)

	variable		EndNum
	String		targetWaveTempStr

		prompt	EndNum	"消すウェーブの個数"
		prompt	targetWaveTempStr	"消すウェーブの名前"
	
	
	//! 削除するwaveの名前
	string targetWaveStr
	variable	n = 1
	do
		sprintf targetWaveStr "%s%n" targetWaveTempStr, num2istr(n)
		killwaves $(targetWaveStr)
		n+=1
	while(n<=EndNum)

EndMacro








//////////////////////////////////////////////////////////以下、昔の人々
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
Function MO2_FitCalc(n, Wname, MO2, vR2, DaT)
	wave MO2, vR2, DaT
	variable n
	string Wname
		
	string snt1
	snt1 = "duplicate/o/d "+ Wname+num2istr(n) +", ChangeRateO2"
	execute snt1
		
	wave CRO 		= $("ChangeRateO2")
	
	setScale/P x 0,0.016666666666, "", CRO
	
	CurveFit/M=2/W=0/Q line, CRO/D
	wave fit_CRO	= $("fit_ChangeRateO2")
	wave Coef 		= $("W_coef")
	MO2[n-1]	= -Coef[1]
	vR2[n-1]	= V_r2
	
	string snt2
	snt2=	"wavestats/Q "+ Wname +num2istr(n)
	execute snt2
	NVAR V_minloc, V_maxloc
	
	DaT[n-1]	=  (V_minloc + V_maxloc)/2
	killwaves CRO, fit_CRO

End
//////////////////////////////////