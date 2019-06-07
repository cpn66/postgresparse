#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
#use utf8;
# Пропускать коментарии с начала строки
#Добавляет имя схемы перед функцией если схема не public
my ($str,$p1,$p2,$hfile,$name,$filename,$schema,$dir);
$p1='^s*CREATE\s+SCHEMA\s+(\w+)';
$dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";

my ($fl1,$fl2)=(0,0);
while ($str=<$hfilein>){
#   next if $str=~m/$skip/;
   if ($str=~m/$p1/){
     $name=$1;
     $fl1=1;
     $filename=$name."_sc.sql";
     open($hfile,">>$dir$filename")||die "Can not open file $filename";
   }
   next if $fl1!=1;
    $fl1=0 ;
   print $hfile $str;
}
