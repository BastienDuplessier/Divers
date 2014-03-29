#!/usr/bin/perl

#UNE = IBL_ID=27914
#LES_VOIRAUSI = IBL_ID=27914 + "A voir aussi :"
#FOCUS = IBL_ID=27913
#LES_GROSTITRES = IBL_ID=27915
#LES_RAPPELS = IBL_ID=27916

@fichiers = `ls LCI_OUTPUT/`;

foreach $fichier (@fichiers){

    open(FILIN, "<LCI_ONELINE/$fichier") || die"ERREUR OUVERTURE FICHIER IN";
    open(FILOUT, ">LCI_CONTENT/$fichier") || die"ERREUR OUVERTURE FICHIER OUT";

    while(<FILIN>){

	$missing = "";

	if(/A voir aussi/){
	    s/A voir aussi/$missing\nA voir aussi/;
	    $missing = "";
	} else {
	    $missing .= "\n";
	}
	if(/IBL_ID=27913/){
	    s/IBL_ID=27913/$missing\n/;
	    $missing = "";
	} else {
	    $missing .= "\n";
	}
	if(/IBL_ID=27915/){
	    s/IBL_ID=27915/$missing\n/;
	    $missing = "";
	} else {
	    $missing .= "\n";
	}
	if(/IBL_ID=27916/){
	    s/IBL_ID=27916/$missing\n/;
	    $missing = "";
	} else {
	    $missing .= "\n";
	}

	print FILOUT $_;
	print FILOUT "\n";
    }

    close(FILIN);
    close(FILOUT);
}
    

