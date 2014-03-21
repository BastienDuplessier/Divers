#!/usr/bin/perl
use Unicode::String qw(utf8 latin1);

# spécifie le format par défaut des chaînes en entrée
Unicode::String->stringify_as('utf8');

@fichiers = `ls LCI/`;
$nbFichiers = @fichiers;
$i = 0;
print "$nbFichiers\n";
foreach $fichier (@fichiers){
    open(FILIN, "<LCI/$fichier") || die"ERREUR OUVERTURE FICHIER IN";
    open(FILOUT, ">LCI_OUTPUT/$fichier") || die"ERREUR OUVERTURE FICHIER OUT";
    while(<FILIN>){
	if(/IBL_ID=27303/){
	    do{
		# instancier la chaîne en objet au format "neutre"
		$ligne = Unicode::String->new($_);

		# rendre la chaîne sous un format iso8859-1
		print FILOUT $ligne->latin1;
		$_ = <FILIN>;
	    }until(/IBL_ID=27916 - Temps/);
	    # instancier la chaîne en objet au format "neutre"
	    $ligne = Unicode::String->new($_);

	    # rendre la chaîne sous un format iso8859-1
	    print FILOUT $ligne->latin1;
	}
    }
    close(FILIN);
    close(FILOUT);
}

