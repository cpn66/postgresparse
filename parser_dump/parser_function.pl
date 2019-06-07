#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
#use utf8;
# Пропускать коментарии с начала строки
#Добавляет имя схемы перед функцией если схема не public
my ($str,$p0,$p1,$p2,$fl0,$flstart,$hfile,$name,$filename,$dir,$schema);
$p0='^\s*SET\s+search_path\s*=\s*(\w+)';
$p1='^\s*CREATE\s+FUNCTION\s+(\w+)';
$p2='^\s*ALTER FUNCTION\s+(\w+)\.(\w+)';
my $skip='^$';
$flstart=0;
my @str=();
$flstart=0;
$dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";
while ($str=<$hfilein>){
#   next if $str=~m/$skip/;
   if ($str=~m/$p0/){
     $fl0=1;
     $schema=$1;
   }
   next if !$fl0;
   if ($str=~m/$p1/){
     $name=$1;
     $flstart=1;
     if ($schema=~/^public$/){
       $filename=$name.".sql";
     } else {
       $filename=$schema.".".$name.".sql";
     } 
#     print "filename=$filename\n"; 
#     if (-e $dir.$filename){     
       open($hfile,">>$dir$filename")||die "Can not open file $filename";
#       
#     } else {
#       open($hfile,">>$dir$filename")||die "Can not open file $filename";
#       print $hfile "SET search_path = $schema, pg_catalog;\n";
#     }
   }
   next if $flstart!=1;
#Собираем строки в массив @str
   push @str,$str if $flstart==1;
#   print $hfile $str if $flstart==1;
   if ($str=~m/$p2/){
     my $schema=$1;
     $str[$#str]="--".$str;
     $str[0]=~s/CREATE\s+FUNCTION\s+/CREATE OR REPLACE FUNCTION /;
     if ($schema!~"public"){
       $str[0]=~s/CREATE OR REPLACE FUNCTION $name\(/CREATE OR REPLACE FUNCTION $schema\.$name\(/;
#       unshift @str,"SET search_path = $schema, pg_catalog;\n";
#       push    @str,"SET search_path = public,  pg_catalog;\n";
     }
     $flstart=0 ;
     print $hfile join("",@str);
     @str=();
   };
}
