## Script to translate the transcripts.txt Rockhopper output into gff3 format
## Will create putative_sRNA and putative_UTR entries in the gff3 to conform
## to baerhunter's output
use strict;

die "Usage: perl get_gff3_from_Rockhopper.pl transcripts.txt\n" unless (1== scalar(@ARGV) );
my $infile = $ARGV[0];
open(INFILE, $infile) or die "Could not open file $infile\n";

my $line;

my $num_5pUTRs=0;
my $num_3pUTRs=0;
my $num_sRNAs=0;

print "#Rockhopper transcripts\n";
$line=<INFILE>;  #the header
while ($line =<INFILE>) {
  chomp($line);
  my @fields=split(/\t/, $line);
  next if (2 > scalar(@fields)); #Rockhopper prints an empty line at the end...
  my ($start, $end, $type);
  my $newlineUTR="";
  my ($add5pUTR, $add3pUTR);
  my ($start5pUTR, $end5pUTR, $start3pUTR, $end3pUTR);
  my $strand_positive=0;

  #
  # Rockhopper prints output in a weird format in the first 4 fields
  # It is not clear at all when it uses two fields, three or four ...
  # Have to check each case to ensure UTRs are found (as difference between transcription
  # and translation start/stops
 
  # set the add5pUTR and add3pUTR flags  (default=do not print UTRs)
  $add5pUTR=0;
  $add3pUTR=0;

  # if there are 4 fields, then use the outer two numbers (which may or may not overlap
  # with the inner two 
  if ((length($fields[0])) && (length($fields[1])) && (length($fields[2])) && (length($fields[3]))) { 
     # count only for checking purposes
     if (($fields[0] != $fields[1])) {
        $num_5pUTRs++;
        $add5pUTR=1;
     }
     if (($fields[2] != $fields[3]))  {
        $num_3pUTRs++;
        $add3pUTR=1;
     }
     if ($fields[0] > $fields[3]) {
        $start = $fields[2];
        $end = $fields[1];
        $start5pUTR= $fields[1]+1;  #these may not be used if the add5p/3pUTR is not set
        $end5pUTR= $fields[0];
        $start3pUTR= $fields[3];
        $end3pUTR=$fields[2]-1;
      
     } else {
        $strand_positive=1;
        $start = $fields[1];
        $end = $fields[2];
        $start5pUTR= $fields[0];
        $end5pUTR= $fields[1] -1;
        $start3pUTR= $fields[2]+1;
        $end3pUTR= $fields[3];   
     }

  }  
  # if there are only two non-empty fields, there are no UTRs 
  elsif (!length($fields[0])  && (!length($fields[3]))) { 
     if ($fields[1] > $fields[2]) {
        $start = $fields[2];
        $end = $fields[1];
     } else {
        $strand_positive=1;
        $start = $fields[1];
        $end = $fields[2];
     }

  }
  elsif (!length($fields[1])  && (!length($fields[2]))) {
     if ($fields[0] > $fields[3]) {
        $start = $fields[3];
        $end = $fields[0];
     } else {
        $strand_positive=1;
        $start = $fields[0];
        $end = $fields[3];
     }
  }
  # if the first field is missing (no 5prime UTR), check the third and fourth
  elsif (!length($fields[0])) {  
    if ($fields[2] != $fields[3]) {
        $num_3pUTRs++;
        $add3pUTR=1;;
     }

     if ($fields[1] > $fields[3]) {
        $start = $fields[2]; 
        $end = $fields[1];
        $start3pUTR = $fields[3];
        $end3pUTR = $fields[2] -1;
     } else {
        $strand_positive=1;
        $start = $fields[1];
        $end = $fields[2];
        $start3pUTR = $fields[2]+1;
        $end3pUTR = $fields[3];
     }

  }
  # if the fourth field is missing, check the first against the second
  elsif (!length($fields[3])) {  

     if ($fields[0] != $fields[1]) {
         $num_5pUTRs++ ;   #the way Rockhopper prints out, 5p is always at the start
         $add5pUTR=1;
     }

     if ($fields[0] > $fields[2]) {
        $start = $fields[2];
        $end = $fields[1];
        $start5pUTR= $fields[1]+1;
        $end5pUTR= $fields[0];
     } else {
        $strand_positive=1;
        $start = $fields[1];
        $end = $fields[2];
        $start5pUTR= $fields[0];
        $end5pUTR= $fields[1] -1 ;
     }
  }
  else {
     print("Field 0=", $fields[0],"stop\n");
     print("Field 1=", $fields[1],"stop\n");
     print("Field 2=", $fields[2],"stop\n");
     print("Field 3=", $fields[3],"stop\n");
     exit("WARNING - unexpected condition\n");
  }
 
  if ($fields[6] =~ /predicted RNA/) {
     $type = "putative_sRNA";
     $num_sRNAs++;
  } else {
     $type = "CDS"; 
  }

  
  # we use the translation start and stop as Rockhopper's output is inconsistent in including the transcription start and stop
  my $newline = "Chromosome\trockhopper\t$type\t$start\t$end\t\.\t$fields[4]\t\.\t$fields[6]\.$fields[7]\n";
  my($newline5p, $newline3p); 
  if ($add5pUTR) {
     $type="putative_UTR";
     $newline5p = "Chromosome\trockhopper\t$type\t$start5pUTR\t$end5pUTR\t\.\t$fields[4]\t\.\t$fields[6]\.$fields[7]\n";
  }
  else {$newline5p="";}

  if ($add3pUTR) {
     $type="putative_UTR";
     $newline3p = "Chromosome\trockhopper\t$type\t$start3pUTR\t$end3pUTR\t\.\t$fields[4]\t\.\t$fields[6]\.$fields[7]\n";
  }
  else { $newline3p ="";}

  # note that we take care of the coordinates being sorted for 5prime/CDS/3prime but 
  # the original transcripts file has short RNAs that are not in sorted order! 
  print($newline5p, $newline, $newline3p);

}

# For checking only against Rockhopper's summary
# print("Number of 5pUTRs= ", $num_5pUTRs, "\n");
# print("Number of 3pUTRs= ", $num_3pUTRs, "\n");
# print("Number of sRNAs= ", $num_sRNAs, "\n");
