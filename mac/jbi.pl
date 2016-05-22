#! /usr/bin/perl
open  JBI, "./jbi-i.txt";
@lines = <JBI>;
close JBI;

for $line (@lines) {
  if ($line =~ /^NOTE\s\"(.*)\"\s\=\s\"(.*)\"$/) {
    $hush{$1} = $2;
  } 
  
}

@devices = split(/, /, $hush{"DEVICE"});
@idcodes = split(/, /, $hush{"IDCODE"});
@files = split(/, /, $hush{"FILE"});

$Devnum = scalar(@devices);


for ($i=0; $i <= scalar(@devices); $i++) {
$info[$i] = "$devices[$i] $idcodes[$i] $files[$i]";
}

#print join("\n", @info);

#print "\n";

#print join(" ", @devices); print "\n";
#print join(" ", @idcodes); print "\n";
#print join(" ", @files); print "\n"
