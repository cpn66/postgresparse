#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
my ($str,$p0,$p1,$p2,$flstart,$hfile,$name,$filename,$schema,$dir);
#CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

$p1='^s*CREATE EXTENSION IF NOT EXISTS (\w+) WITH SCHEMA ';
$dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";

my ($fl0,$fl1,$fl2)=(0,0,0);
while ($str=<$hfilein>){
   if ($str=~m/$p1/){
     $name=$1;
     $fl1=1;
     $filename=$name."_ex.sql";
     open($hfile,">>$dir$filename")||die "Can not open file $filename";
   }
   next if $fl1!=1;
   $fl1=0 ;
   print $hfile $str;
}
