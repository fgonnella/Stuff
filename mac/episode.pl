#! /usr/bin/perl
opendir DIR, ".";
@files = readdir(DIR);
closedir DIR;



for $file (@files) {
$format = "not";

  if ($file =~ /^(.*)(\.avi|\.mkv|\.mp4)$/){
    ($name, $ext) = ($1, $2);
print "\n *** Episode file: $file\n";
    if($name =~ /^(.*?)([\W\s]*)(\d+)(x|X)(\d+)(.*)$/){
      $format = "x"; 
      $title = $1;
      $season = $3;
      $episode = $5;
    } elsif($name =~ /^(.*?)([\W\s]*)(s|S)(\d+)(e|E)(\d+)(.*)$/){
      $format = "e";
      $title = $1;
      $season = $4;
      $episode = $6;
    } else {
      $format = "not"
    }

 # print $format;

  }

$title_srt = " ";
$season_srt = " ";
$episode_srt = " ";  

  
  if ($format ne "not") {

     for $sub (@files) { 
       if ($sub =~  /^(.*)(\.sub|\.txt|\.srt)$/)	{
	 ($name_sub, $ext_sub) = ($1, $2);
	 if($name_sub =~ /^(.*?)([\W\s]*)(\d+)(x|X)(\d+)(.*)$/){
	   $title_srt = $1;
	   $season_srt = $3;
	   $episiode_srt = $5;
	 } elsif($name_sub =~ /^(.*?)([\W\s]*)(s|S)(\d+)(e|E)(\d+)(.*)$/){
	   $title_srt = $1;
	   $season_srt = $4;
	   $episode_srt = $6;
	 } else {
	   $title_srt = " ";
	   $season_srt = " ";
	   $episode_srt = " ";
	 }	 

	   print "$season eq $season_srt and $episode eq $episode_srt\n";
	 
	 if ($season == $season_srt and $episode == $episode_srt) {
	   print "For file $file, I would rename $sub into: $name$ext_sub\n"; 
	   print "$season eq $season_srt and $episode eq $episode_srt\n";
	   $title_srt = " ";
	   $season_srt = " ";
	   $episode_srt = " ";
       	 }

       }

#    print "\n";
    
     }
   }
}
