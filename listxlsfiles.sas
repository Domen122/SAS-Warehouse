/* List all .xlsx files in dirName to outputList */
%macro listxlsfiles (dirName=, outputList=);

	filename dirName "&dirName";
	
	data &outputList.;
		/* length is a statement which creates variable called directoryID with 8 bits long */
		length directoryID 8;
		
		*Jeśli jest ID = 0 to błąd;
		directoryID = dopen('dirName');
		if (directoryID = 0) then
			stop;
			
		/* Zwraca ilejest plików w folderze*/
		numOfMembers = dnum(directoryID);
		
		do i=1 to numOfMembers;
			/*dread(directory-id,nval) - Zwraca nazwę pliku o podanym ID */
			memberName = dread(directoryID, i);
			
			/*odwrócony string aby porównywanie było szybsze*/
 			if (reverse(lowcase(trim(memberName))) =: 'xslx.') then
        		output;
		end;

		 /* Nie można wywołać funkcji w SASie trzeba przypisać dclose do zmiennej*/
		tmp = dclose(directoryID);

		drop directoryID numOfMembers i tmp;
	run;
%mend;
