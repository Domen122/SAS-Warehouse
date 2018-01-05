%macro loadData(namefile, outfilelist, filenamedatalist, productlist);
	%put 'loadData' &namefile;
	PROC IMPORT OUT= &outfilelist (WHERE = (data NE .)) DATAFILE= "/folders/myfolders/Hurtownia2/dane/&namefile"  
        	DBMS=xlsx REPLACE;
    	GETNAMES=YES;
	RUN;
	
	data daneExcel;
		set &outfilelist;
		if missing(Godzina) OR missing (Data) OR missing (Sklep_id) OR missing (produkt_id) OR missing (Ilosc) then 
		do;
			putlog "[LOG] plik =  &namefile  niekompletny wiersz";
			delete;
		end;
	run;
	
	data &outfilelist;
		set &outfilelist;
		DATE2 = INPUT(PUT(Data,8.),YYMMDD8.);
		Data=DATE2;
		DROP DATE2;
		FORMAT Data YYMMDDd8.;
	RUN;
		
	data &filenamedatalist;
			set &filenamedatalist;
			call symput('nazwadata', nazwadata);
			call symput('numerSklepu', numerSklepu);
			
	run;
	
    proc sql;
		create table TMP as select * from &outfilelist  as l left join &productlist as r  on l.produkt_id = r.product_id;
    quit;
 
	data &outfilelist;
		set TMP;
		
    	if Data ^= &nazwadata then
		do;
			putlog "[LOG] plik =  &namefile  zla data [ " Data " ]";
			delete;
		end;
		
		if Sklep_id ^= &numerSklepu then
		do;
			putlog "[LOG] plik =  &namefile  zly nr sklepu [ " Sklep_id "] ";
			delete;
		end;
		if product_id = '.' then
		do;
			putlog "[LOG] plik =  &namefile zly nr produktu [" product_id"]";
			delete;
		end;	
		if Ilosc < 0 then
		do;
			putlog "[LOG] plik =  &namefile ujemna liczba sprzedanych [nr produktu " produkt_id "]";
			delete;
		end;				
	RUN;
	
	PROC Delete data = TMP;
	
%mend;