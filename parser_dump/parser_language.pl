#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
#use utf8;
# Пропускать коментарии с начала строки
#Добавляет имя схемы перед функцией если схема не public
my ($str,$p0,$p1,$p2,$flstart,$hfile,$name,$filename,$schema,$dir,$skip);
$dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";
$p1='CREATE OR REPLACE PROCEDURAL LANGUAGE (\w+);';
$p2='ALTER PROCEDURAL LANGUAGE (\w+) OWNER TO (\w+);';
$skip='^$';
my ($fl0,$fl1,$fl2)=(0,0,0);
while ($str=<$hfilein>){
   next if $str=~/$skip/;
   if ($str=~m/$p1/){
     $name=$1;
     $fl1=1;
     $filename=$name."_lang.sql";
     open($hfile,">>$dir$filename")||die "Can not open file $filename";
   }
   next if $fl1!=1;
   if ($str=~m/$p2/){
     $str="--".$str;
     $fl1=0 ;
   };
   print $hfile $str;
}
