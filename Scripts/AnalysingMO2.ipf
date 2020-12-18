#pragma rtGlobals=3		// Use modern global access method and strict wave access.
//////////////////////////////////
Macro DefineExperimentalCondition(Oxygen, lBW, lVc)
	string 	Oxygen
	variable lBW,	 lVc
		Prompt	Oxygen, "wave for Analysis?"
		Prompt lBW,	"Body weight (g)?"
		Prompt lVc,	"Chamber size (l)?" 
	variable/G	BW=lBW		///////BWはGlobal変数で格納
	variable/G	Vc=lVc		///////VcもGlobal変数で格納

	ChamberO2($Oxygen)	///////Chamber内の溶存酸素量を計算させておく
	
EndMacro
///////////////////////////////////////
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
////////////////////////////////////////
Macro RestMO2_AllCalc(NoT, Wname)
	variable	NoT
	string	Wname
		Prompt NoT,		"How many trials?"
		Prompt Wname	"Template wave name for MO2 Analysis during Acclimation"
			
	string	snt1
	snt1= "make/O/D/N="+num2istr(NoT)+" RestMO2_Linefit"
	execute	snt1
	
	string	snt2
	snt2= "make/O/D/N="+num2istr(NoT)+" RestMO2_vR2"
	execute	snt2
	
	string	snt3
	snt3= "make/O/D/N="+num2istr(NoT)+" RestMO2_DaT"
	execute	snt3
	
	string	snt4
	snt4= "make/O/D/N="+num2istr(NoT)+" RestMO2_Dif"
	execute	snt4
	
	variable i
	i=1
	do
			RestMO2_FitCalc(i, Wname, RestMO2_Linefit, RestMO2_vR2, RestMO2_DaT)
			RestMO2_DifCalc(i, Wname, RestMO2_Dif)
			i+=1
	while(i<=NoT)

EndMacro 
//////////////////////////////////////// 
Function RestMO2_DifCalc(i, Wname, RestMO2_Dif)	//////(試行数、解析するウェーブの名前の鋳型、格納するwave)
	variable i
	string	Wname
	wave	RestMO2_Dif
	
	string snt1
	snt1 = "duplicate/o/d "+Wname+num2istr(i)+", ChangeRateO2"
	execute snt1
	
	wave CRO 		= $("ChangeRateO2")	
	
	variable FirstMO2, LastMO2, Secs
	FirstMO2=	(CRO[0]*CRO[1]*CRO[2])^(1/3)
	Secs=		numpnts(CRO)
	LastMO2=	(CRO[Secs-3]*CRO[Secs-2]*CRO[Secs-1])^(1/3)
	
	RestMO2_Dif[i-1]=(FirstMO2-LastMO2)/Secs*60
	killwaves CRO
end
////////////////////////////////////////
Function RestMO2_FitCalc(n, Wname, MO2, vR2, DaT)
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
	
	variable i
	i=1
	do
			EPOC_FitCalc(i, Wname, EPOC_Linefit, EPOC_vR2, EPOC_DaT)
			EPOC_DifCalc(i, Wname, EPOC_Dif)
			i+=1
	while(i<=NoT)

EndMacro 
//////////////////////////////////////// 
Function EPOC_DifCalc(n, Wname, MO2_Dif)	//////(試行数、解析するウェーブの名前の鋳型、格納するwave)
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
Function EPOC_FitCalc(n, Wname, MO2, vR2, DaT)
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
