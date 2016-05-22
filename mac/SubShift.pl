#!/usr/bin/perl
if ($#ARGV != 1) {
    print "\nUsage: SubShift.pl <file.srt> <offset in seconds>\n\n";
    exit;
}

open MINC, $ARGV[0] or die "Couldn't open $ARGV[0]: $!\n";
$offset = $ARGV[1];

while (<MINC>) {
    if (/(\d\d)\:(\d\d)\:(\d\d)\,(\d\d\d) \-\-\> (\d\d)\:(\d\d)\:(\d\d)\,(\d\d\d)/) {
	($h1,$m1,$s1,$f1,$h2,$m2,$s2,$f2) = ($1,$2,$3,$4,$5,$6,$7,$8);
	$s1 += $offset;
	$s2 += $offset;
	
	if ($s1 > 59) {
	    $m1++;
	    $s1-=60;
	}

	if ($s2 > 59) {
	    $m2++;
	    $s2-=60;
	}

	if ($m1 > 59) {
	    $h1++;
	    $m1-=60;
	}

	if ($m2 > 59) {
	    $h2++;
	    $m2-=60;
	}

	if ($s1 < 0) {
	    $m1--;
	    $s1+=60;
	}

	if ($s2 < 0) {
	    $m2--;
	    $s2+=60;
	}

	if ($m1 < 0) {
	    $h1--;
	    $m1+=60;
	}

	if ($m2 < 0) {
	    $h2--;
	    $m2+=60;
	}

	print "$h1:$m1:$s1,$f1 --> $h2:$m2:$s2,$f2\n";

    } else {
	print;
    }
}
