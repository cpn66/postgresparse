#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
#use utf8;
# Пропускать коментарии с начала строки
#Добавляет имя схемы перед функцией если схема не public
my ($str,$p0,$p1,$p2,$flstart,$hfile,$name,$filename,$schema,$dir,$skip);
$dir="out/";
$p0='^\s*SET\s+search_path\s*=\s*(\w+)';
#CREATE VIEW tarplan_ivr AS
#    SELECT tarplan_068.code_e164, tarplan_068.codename, '068'::text AS client_type FROM tarplan_068 UNION SELECT tarplan_ckc.code_e164, tarplan_ckc.codename, 'ckc'::text AS client_type FROM tarplan_ckc;
#ALTER TABLE public.tarplan_ivr OWNER TO litosh;






$p1='^\s*CREATE\s+VIEW\s+(\w+)';
$p2='^\s*ALTER TABLE\s+(\w+\.\w+)|(\w+)\s+OWNER TO';
$skip='^$';
$dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";

my ($fl0,$fl1,$fl2)=(0,0,0);
while ($str=<$hfilein>){
   next if $str=~/$skip/;
   if ($str=~m/$p0/){
     $fl0=1;
     $schema=$1;
   }
   next if !$fl0;
#   next if $str=~m/$skip/;
   if ($str=~m/$p1/){
     $name=$1;
     $fl1=1;
     if ($schema=~/^public$/){
       $filename=$name."_vw.sql";
     } else {
       $filename=$schema.".".$name."_vw.sql";
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
   if ($str=~m/$p2/){
     $str="--".$str;
     $fl1=0 ;
   };
   print $hfile $str;
}
