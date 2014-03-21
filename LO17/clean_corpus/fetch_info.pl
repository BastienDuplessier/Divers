#! /usr/bin/perl

$file = "lci-monde-2005-03-01.html";


# Open output
open(FILOUT, ">final_output") || die"ERREUR OUVERTURE FICHIER OUT";
print FILOUT "<CORPUS>\n";

# File details
open(FILIN, "<LCI_ONELINE/$file") || die"ERREUR OUVERTURE FICHIER IN";  
print FILOUT "<PAGE_LCI>\n<FICHIER>$file</FICHIER>\n";
$file =~ /(\d{4})-(\d{2})-(\d{2})/s;
$date = "$3/$2/$1";
print FILOUT "<DATE_PAGE>$date</DATE_PAGE>\n";

while(<FILIN>) {
    # Une
    if(/<a href="([\/,A-Za-z0-9\-\._]+)" class="S431" style="line-height:normal;">([^<]+)<\/a>/){
	print FILOUT "<UNE>\n";
	print FILOUT "<urlArticle>$1</urlArticle>\n";
	print FILOUT "<titreArticle>$2</titreArticle>\n";
	print FILOUT "<dateArticle>$date</dateArticle>\n";
	$_ =~ /<img src="(http[^"]+?\.jpg)" border="0" alt=""><\/a>/s;
	print FILOUT "<urlImage>$1</urlImage>\n";
	$_ =~ /class="S48"><img src="\/img\/news\/puce_rouge\.gif" border="0" vspace="1" hspace="1">([^<]+?)<\/a>.*class="S48"><img src="\/img\/news\/puce_rouge\.gif" border="0" vspace="1" hspace="1">([^<]+?)<\/a>/s;
	print FILOUT "<resumeArticle>$1 $2</resumeArticle>\n";
	$_ =~ /<a href="mailto:([^"]+)" class="S14">([^<]+)<\/a>/s;
	print FILOUT "<mailto>$1</mailto>\n";
	print FILOUT "<auteur>$2</auteur>\n";
	print FILOUT "</UNE>\n";
	    
    } else {
	print FILOUT "<OTHER></OTHER>";
    }
}


close(FILIN);

print FILOUT "</PAGE_LCI>\n</CORPUS>\n";
close(FILOUT);




