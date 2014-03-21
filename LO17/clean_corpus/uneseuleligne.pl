#!/usr/bin/perl

@fichiers = `ls LCI_OUTPUT/`;
$nbFichiers = @fichiers;
$i = 0;
foreach $fichier (@fichiers){
    open(FILIN, "<LCI_OUTPUT/$fichier") || die"ERREUR OUVERTURE FICHIER IN";
    open(FILOUT, ">LCI_ONELINE/$fichier") || die"ERREUR OUVERTURE FICHIER OUT";
    while(<FILIN>){
	chomp($_);
	print FILOUT $_;
    }
    close(FILIN);
    close(FILOUT);
}

