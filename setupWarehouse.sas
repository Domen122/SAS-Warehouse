%macro setupWarehouse;
	proc sql
		noprint;
		create table WORK.DANE (Data date, Sklep_id num, produkt_id num, Ilosc num);
	quit;
	
	proc sql
		noprint;
		CREATE TABLE ARCHIWUMPLIKOW (filename char(16));
	quit;
	
	proc sql
		noprint;
		CREATE TABLE PRODUKTY (product_id num, nazwa char(20));
	quit;
%mend;

%setup;