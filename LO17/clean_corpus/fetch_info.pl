#! /usr/bin/perl

$file = "lci-monde-2005-03-01.html";


# Open output
open(FILOUT, ">final_output") || die"ERREUR OUVERTURE FICHIER OUT";
print FILOUT "<CORPUS>\n";

# File details
open(FILIN, "<LCI_ONELINE/$file") || die"ERREUR OUVERTURE FICHIER IN";  
print FILOUT "<PAGE_LCI>\n<FICHIER>$file</FICHIER>\n";
$file =~ /(\d{4})-(\d{2})-(\d{2})/s;
print FILOUT "<DATE_PAGE>$3/$2/$1</DATE_PAGE>\n";

close(FILIN);

print FILOUT "</PAGE_LCI>\n</CORPUS>\n";
close(FILOUT);




