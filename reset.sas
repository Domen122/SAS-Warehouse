%macro reset;	
	proc sql noprint;
		DELETE FROM ARCHIWUMPLIKOW;
	quit;
	
	proc sql noprint;
		DELETE FROM DANE;
	quit;
	
	proc sql noprint;
		DELETE FROM PRODUKTY;
	quit;
%mend;

%reset;