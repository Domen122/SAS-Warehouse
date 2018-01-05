%INCLUDE "/folders/myfolders/Hurtownia2/listxlsfiles.sas";
%macro getnewxls (targdir= , outlist= ,newcount=);

%listxlsfiles(dirName=&targdir, outputList=&outlist);
proc sql
	noprint;
	CREATE TABLE TEMPx (filename char(16));
quit;

proc sql
	noprint;
	INSERT INTO TEMPx SELECT * FROM &outlist. EXCEPT ALL SELECT * FROM ARCHIWUMPLIKOW;
quit;

data &outlist.;
	set TEMPx;
run;

data ARCHIWUMPLIKOW;
	set TEMPx ARCHIWUMPLIKOW;
run;

proc sql noprint;
		select count(*) into :&newcount. from TEMPx ;
quit;


proc datasets lib=work nodetails nolist;
	delete TEMPx;
run;

%mend;
*%getnewxls (targdir=/folders/myfolders/dane, outlist=work.NOWEPLIKI, archivelist=work.ARCHIWUMPLIKOW, newcount=c);

