%macro getproductlist(filename, productlist);
	PROC IMPORT OUT= &productlist (WHERE = (product_id NE .)) DATAFILE= "/folders/myfolders/Hurtownia2/produkty/&filename"  
        	DBMS=xlsx REPLACE;
    	GETNAMES=YES;
	RUN;
%mend;
