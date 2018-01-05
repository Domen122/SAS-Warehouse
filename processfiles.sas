%INCLUDE "/folders/myfolders/Hurtownia2/reset.sas";
%INCLUDE "/folders/myfolders/Hurtownia2/loadData.sas";
%INCLUDE "/folders/myfolders/Hurtownia2/getnewxls.sas";
%INCLUDE "/folders/myfolders/Hurtownia2/checkFileName.sas";
%INCLUDE "/folders/myfolders/Hurtownia2/getProductList.sas";


%macro processfiles;
	proc sql
		noprint;
		create table WORK.NOWEPLIKI (filename char(16));
	quit;
	
	proc sql
		noprint;
		create table WORK.TMPDANE (Data date, Sklep_id num, produkt_id num, Ilosc num);
	quit;

	%local numOfNewFiles;
	%let numOfNewFiles = 0;	
	
	%getnewxls(targdir=/folders/myfolders/Hurtownia2/dane, outlist=NOWEPLIKI, newcount=numOfNewFiles);
	%getproductlist(ListaProduktow.xlsx , PRODUKTY);
	
	%put 'ILOSC NOWYCH PLIKOW' &numOfNewFiles;
	%put "petla";
	
		%do i = 1 %to &numOfNewFiles;
		
			data iterator;
				set NOWEPLIKI (obs=&i);
			run;
		
		
			%checkfilename(filenamelist=iterator, outputlist=FILENAME_DATA);	
		
			data FILENAME_DATA;
				set FILENAME_DATA;
				call symput('filename', filename);
			run;
				
			%if (&filename ^= '') %then
				%do;			
					%loadshopdata(&filename,TMPDANE,FILENAME_DATA, PRODUKTY); 
			
				data DANE;
					set DANE TMPDANE;
				run;
			
				data DANE;
					set DANE;
					if sklep_id = '.' then delete;
				run;
			%end;
	%end;
	
	data DANE;
		set DANE;
		format Data YYMMDDD10.;
		drop produkt_id;
	run;

Proc delete data = ITERATOR;
Proc DElete data = DANEEXCEL;
PROC Delete data = TMPDANE;
PROC Delete data = NOWEPLIKI;
PROC Delete data = FILENAME_DATA;
%mend;
option nonotes;
%processfiles;