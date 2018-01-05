/*
 * checks names of files in fileNameList and stores them in properFileNameList
 */
%macro checkfilename(filenamelist=, outputlist=);
	data &outputlist.;
		set &filenamelist.;
		nazwadata=input(substr(filename, 1, 8), ANYDTDTE8.);
		shop=substr(filename, 9, 1);
		numerSklepu=input(substr(filename, 10, 1), 5.);
		rozszerzenie=substr(filename, index(filename, '.'), 5);

		if missing(nazwadata) then
			do;
				putlog "[LOG] plik = " filename " ma zla date";
				delete;
			end;

		/* Czy znak 's' obecny */
		else if shop ^='s' then
			do;
				putlog "[LOG] plik = " filename " ma zla nazwe sklepu";
				delete;
			end;

		/* Czy numer sklepu jest cyfra */
		else if numerSklepu <=0 OR numerSklepu >=10 then
			do;
				putlog "[LOG] plik = " filename " ma zly numer sklepu";
				delete;
			end;

		/* Czy jest rozszerzeni .xlsx */
		else if rozszerzenie ^='.xlsx' then
			do;
				putlog "[LOG] plik = " filename " ma zle rozszerzenie";
				delete;
			end;

		/* Czy plik ma taka dlugosc jaka powinien */
		else if index(filename, '.') ^=11 then
			do;
				putlog "[LOG] plik = " filename " ma zly format wiec usuwam";
				delete;
			end;
	run;
%mend;
