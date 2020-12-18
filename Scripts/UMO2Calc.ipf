#pragma rtGlobals=3		// Use modern global access method and strict wave access.
/////////////////このマクロを使うときは対象のウェーブの名前をU__とすること
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
	snt5= "make/O/D/N="+num2istr(NumStep)+" SwimSpeed"
	execute	snt5
	
	variable i, Ui
	i=0
	Ui=StartU
	do
			UMO2_FitCalc(i, Ui, UMO2_Linefit, UMO2_vR2, UMO2_DaT, SwimSpeed)
			UMO2_DifCalc(i, Ui, UMO2_Dif)
			Ui+=Stepwise
			i+=1
	while(i+1<=NumStep)
	
EndMacro 
////////////////////////////////////////////////////////////
Function UMO2_FitCalc(i, Ui, UMO2_Linefit, UMO2_vR2,  UMO2_DaT, SwimSpeed)
	wave UMO2_Linefit, UMO2_vR2, UMO2_DaT, SwimSpeed
	variable i, Ui
		
	string snt1
	snt1 = "duplicate/o/d U"+num2istr(Ui)+", ChangeRateO2"
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
	snt2=	"wavestats/Q	U"+num2istr(Ui)
	execute snt2
	NVAR V_minloc, V_maxloc
	
	UMO2_DaT[i]	=  (V_minloc + V_maxloc)/2
	SwimSpeed[i]	=Ui
	
	killwaves CRO, fit_CRO, Coef

End
/////////////////////////////////////////////
Function UMO2_DifCalc(i, Ui, UMO2_Dif)	//////(Step数、速度、格納するwave)
	variable i, Ui
	wave UMO2_Dif
	
	string snt1
	snt1 = "duplicate/o/d U"+num2istr(Ui)+", ChangeRateO2"
	execute snt1
	wave CRO 		= $("ChangeRateO2")	
	
	variable FirstMO2, LastMO2, Secs
	FirstMO2=	(CRO[0]*CRO[1]*CRO[2])^(1/3)
	Secs=		numpnts(CRO)
	LastMO2=	(CRO[Secs-3]*CRO[Secs-2]*CRO[Secs-1])^(1/3)
	
	UMO2_Dif[i]=(FirstMO2-LastMO2)/Secs*60
	
end
/////////////////////////////////////////////
Function AutoWnameMaker(i, Name)
	variable i
	String	Name
	

end