#! /usr/bin/perl

$file = "lci-monde-2005-12-08.html";
@fichiers = `ls LCI/`;
$nbFichiers = @fichiers;
$i = 0;

# Open output
open(FILOUT, ">final_output.xml") || die"ERREUR OUVERTURE FICHIER OUT";
print FILOUT "<CORPUS>\n";

foreach $file (@fichiers) {
    # File details
    open(FILIN, "<LCI_CONTENT/$file") || die"ERREUR OUVERTURE FICHIER IN";
    print FILOUT "<PAGE_LCI>\n<FICHIER>$file</FICHIER>\n";
    $file =~ /(\d{4})-(\d{2})-(\d{2})/s;
    $year = $1;
    $date = "$3/$2/$1";
    print FILOUT "<DATE_PAGE>$date</DATE_PAGE>\n";
    $i = 0;
    binmode FILIN;

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
	    $next_tag = "<LES_VOIRAUSSI></LES_VOIRAUSSI>\n";
	} elsif(/A voir aussi/) {
	    @a_voir_aussi = /<a href="([^<]+)<\/a>/gs;
	    print FILOUT "<LES_VOIRAUSSI>\n";
	    foreach $art (@a_voir_aussi) {
		print FILOUT "<VOIRAUSSI>\n";
		$art =~ /([^"]+).+S48.*>(.+)\((\d{2}\/\d{2}\/\d{4})/s;
		print FILOUT "<dateArticle>$3</dateArticle>\n";
		print FILOUT "<urlArticle>$1\</urlArticle>\n";
		print FILOUT "<titreArticle>$2</titreArticle>\n";
		print FILOUT "</VOIRAUSSI>\n";
	    }
	    print FILOUT "</LES_VOIRAUSSI>\n";
	} elsif (/<a href="([^"]+)" class="S401">([^<]+)<\/a>/) {
	    print FILOUT "<FOCUS>\n";
	    print FILOUT "<urlArticle>$1</urlArticle>\n";
	    print FILOUT "<titreArticle>$2</titreArticle>\n";
	    print FILOUT "<dateArticle>$date</dateArticle>\n";
	    /<tr.+td.+a.+img src="([^"]+)" width="80"/s;
	    print FILOUT "<urlImage>$1</urlImage>\n";
	    /<a.+ class="S48">([^<]+)/s;
	    print FILOUT "<resumeArticle>$1</resumeArticle>\n";
	    $temp = $1;
	    /<a (?=[^>]+class="S14)href="([^"]+)".*?>([^<]+)<\/a>/;
	    print FILOUT "<mailto>$1</mailto>\n";
	    print FILOUT "<auteur>$2</auteur>\n</FOCUS>\n";
	} elsif (/IBL_ID=27915/) {
	    print FILOUT "<LES_GROS_TITRES>\n";
	    while(/src="([^"]+?jpg)".+?class="S301">(.+?)<.+?<a.+?href="(.+?)".+?>(.+?)<.+?class="S48">(.+?)<(.+?)<\/table>/sg) {
		print FILOUT "<GROSTITRE>\n";
		print FILOUT "<urlArticle>$3</urlArticle>\n";
		print FILOUT "<themeArticle>$2</themeArticle>\n";
		print FILOUT "<titreArticle>$4</titreArticle>\n";
		print FILOUT "<dateArticle>$date</dateArticle>\n";
		print FILOUT "<urlImage>$1</urlImage>\n";
		print FILOUT "<resumeArticle>$5</resumeArticle>\n";
		if ($6 =~ /mailto:(.+?)".+?>(.+?)</) {
		    print FILOUT "<mailto>$1</mailto>\n";
		    print FILOUT "<auteur>$2</auteur>\n";
		} else { print FILOUT "<mailto></mailto>\n<auteur></auteur>\n"; }
		print FILOUT "</GROSTITRE>\n";
	    }
	    print FILOUT "</LES_GROS_TITRES>\n";
	} elsif (/IBL_ID=27916/) {
	    print FILOUT ("<LES_RAPPELS>\n");
	    while(/class="S48">(\d+)(.+?)<.+?class="S301">(.+?)<.+?href="(.+?)".+?class="S63".*?>(.+?)</sg) {
		print FILOUT "<RAPPEL>\n";
		print FILOUT "<themeArticle>$3</themeArticle>\n";
		print FILOUT "<urlArticle>$4</urlArticle>\n";
		print FILOUT "<titreArticle>$5</titreArticle>\n";

		$day = $1;

		if ($2 =~ m/jan/) { $month = "01"; }
		elsif ($2 =~ m/f.v/) { $month = "02"; }
		elsif ($2 =~ m/mar/) { $month = "03"; }
		elsif ($2 =~ m/avr/) { $month = "04"; }
		elsif ($2 =~ m/mai/) { $month = "05"; }
		elsif ($2 =~ m/juin/) { $month = "06"; }
		elsif ($2 =~ m/juil/) { $month = "07"; }
		elsif ($2 =~ m/ao.t/) { $month = "08"; }
		elsif ($2 =~ m/sep/) { $month = "09"; }
		elsif ($2 =~ m/oct/) { $month = "10"; }
		elsif ($2 =~ m/nov/) { $month = "11"; }
		elsif ($2 =~ m/d.c/) { $month = "12"; }

		print FILOUT "<dateArticle>$day/$month/$year</dateArticle>\n";
		print FILOUT "</RAPPEL>\n";
	    }
	} else {
	    if($i == 0) {
		print FILOUT "<UNE></UNE>\n";
	    } elsif($i == 1) {
		print FILOUT "<LES_VOIRAUSSI></LES_VOIRAUSSI>\n";
	    } elsif ($i == 2) {
		print FILOUT "<FOCUS></FOCUS>\n";
	    } elsif ($i == 3) {
		print FILOUT "<LES_GROS_TITRES></LES_GROS_TITRES>\n";
	    } else {
		print FILOUT "<LES_RAPPELS></LES_RAPPELS>\n";
	    }
	}
	$i++;
    }
    close(FILIN);
}
print FILOUT "</PAGE_LCI>\n</CORPUS>\n";
close(FILOUT);
