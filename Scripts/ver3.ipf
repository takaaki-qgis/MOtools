#pragma rtGlobals=3		// Use modern global access method and strict wave access.
///////////////////////////////////////
Macro SamplingWave_NameSet(W_tmp)
	string W_tmp
		prompt W_tmp,	"Wave for Sampling"
	String/G SamplingWv = W_tmp
End
//////////
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
//////////////////////////////////////////////////////////ˆÈ‰ºAÌ‚ÌlX
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