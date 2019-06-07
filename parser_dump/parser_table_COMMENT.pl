#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
my ($str,$p0,$p1,$p2,$flstart,$hfile,$name,$filename,$schema,$dir);
$dir="out/";
$p0='^\s*SET\s+search_path\s*=\s*(\w+)';
$p1='^s*COMMENT\s+ON\s+(TABLE|COLUMN)\s+(\w+)(\s|\.)+.*;.*$';
$dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";

my ($fl0,$fl1,$fl2)=(0,0,0);
while ($str=<$hfilein>){
   if ($str=~m/$p0/){
     $fl0=1;
     $schema=$1;
   }
   next if !$fl0;
#   next if $str=~m/$skip/;
   if ($str=~m/$p1/){
     $name=$2;
     $fl1=1;
     if ($schema=~/^public$/){
       $filename=$name."_db.sql";
     } else {
       $filename=$schema.".".$name."_db.sql";
     } 
#     print "filename=$filename\n"; 
     if (-e $dir.$filename){     
       open($hfile,">>$dir$filename")||die "Can not open file $filename";
       
     } else {
       open($hfile,">>$dir$filename")||die "Can not open file $filename";
       print $hfile "SET search_path = $schema, pg_catalog;\n";
     }
   }
   next if $fl1!=1;
    $fl1=0 ;
   print $hfile $str;
}
