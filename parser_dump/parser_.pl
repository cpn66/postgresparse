#!/usr/bin/perl -w 
use strict;
use Data::Dumper;
#use utf8;
# Пропускать коментарии с начала строки
#Добавляет имя схемы перед функцией если схема не public
my $dir=$ARGV[0]."/";
my $filestru=$ARGV[1];
my $key=$ARGV[2];
#$dir="db/function/";
#$filestru="stbs2.stru"; 
#$key="function";
print "dir=$dir filestru=$filestru key=$key\n";
#exit;

my ($str,$p0,$p2,$flstart,$hfile,$name,$filename,$schema,$skip);
my $lexem={
   table=>{
     prefix=>'',
     start=>'^\s*CREATE( FOREIGN)? TABLE (\w+)\.(\w+)',
     stop=> '^\s*ALTER( FOREIGN)? TABLE (\w+)\.(\w+) OWNER TO',
     stopprefix=>'--',
     suffix=>'_db',
     schema=>2,
     name=>3,
     block=>sub{$schema=$_[1];$name=$_[2];},

   },
   table_foreing=>{
     prefix=>'',
     start=>'^\s*CREATE\s+FOREIGN\s+TABLE\s+(\w+)\.(\w+)',
     stop=> '^\s*ALTER\s+FOREIGN\s+TABLE\s+(\w+)\.(\w+)\s+OWNER TO',
     stopprefix=>'--',
     suffix=>'_db',
   },
   table_column=>{
     prefix=>'',
     start=>'^\s*ALTER TABLE ONLY (\w+)\.(\w+) ALTER COLUMN',
     stop=> '',
     suffix=>'_db',
     block=>sub{$schema=$_[0];$name=$_[1];},
   },
   table_comment=>{
     prefix=>'',
     start=>'^COMMENT ON (TABLE|COLUMN) (\w+)\.(\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'',
     block=>sub{$schema=$_[1];$name=$_[2];},
   },
   function=>{
     prefix=>'',
     start=>'^\s*CREATE FUNCTION (\w+)\.(\w+)',
     stop=> '^\s*ALTER FUNCTION',
     stopprefix=>'--',
     suffix=>'',
     block=>sub{$schema=$_[0];$name=$_[1];},
     replace=>sub{$str=~s/^CREATE/CREATE OR REPLACE/;},
#COMMENT ON TABLE public.memstat IS 'Данные CDR из MEM';

   }
};
#CREATE FUNCTION audit.audit_table(target_table regclass) RETURNS void
#    LANGUAGE sql
#    AS $_$
#SELECT audit.audit_table($1, BOOLEAN 't', BOOLEAN 't');
#$_$;
#ALTER FUNCTION audit.audit_table(target_table regclass) OWNER TO cpn;


print "dir=$dir filestru=$filestru key=$key\n";
#exit;
my $start=$lexem->{$key}->{start};
my $stop=$lexem->{$key}->{stop};
my $stopprefix=$lexem->{$key}->{stopprefix};
print "start=$start\n";
print "stop=$stop\n";
#exit;
#my $str=
#'CREATE FUNCTION audit.audit_table(target_table regclass) RETURNS void';
#if ($str=~m/$start/){
#  $lexem->{$key}->{block}->($1,$2,$3,$4,$5);
#  my $schema=$1;
#  my $name=$2;
#  print  $schema,"\n";
#  print  $name,"\n";
#}

#exit;
open(my $hfilein, "<", $filestru) or  die "cannot open < ".$filestru."\n";

#$start='^\s*SET\s+search_path\s*=\s*(\w+)';
#$stop='^\s*CREATE\s+(FOREIGN\s+)*TABLE\s+(\w+)';
#ALTER TABLE ats OWNER TO cpn;
#$stop='^\s*ALTER TABLE\s+(\w+)\.(\w+)\s+OWNER TO';
#$stop='^\s*ALTER\s+(FOREIGN\s+)*TABLE\s+(\w+)|(\w+\.\w+)\s+OWNER TO';

#пустые строки пропускаю
$skip='^$';
my ($fl0,$fl1,$fl2)=(0,0,0);
my @keys;
while ($str=<$hfilein>){
#   next if $str=~/$skip/;
   if ($str=~m/$start/){
	$lexem->{$key}->{'block'}->($1,$2,$3,$4,$5);
	$lexem->{$key}->{'replace'}->() if defined $lexem->{$key}->{'replace'};
#        print $str,"\n";
#	$str=~s/^CREATE/CREATE OR REPLACE/;
        print $str,"\n";

	print  $schema,"\n";
	print  $name,"\n";
       $fl1=1;
     if ($schema=~/^public$/){
       $filename=$name.$lexem->{$key}->{'suffix'} .".sql";
     } else {
       $filename=$schema.".".$name.$lexem->{$key}->{'suffix'} .".sql";
     } 
     print "$dir $filename \n"; 
     if (-e $dir.$filename){     
       open($hfile,">>$dir$filename")||die "Can not open file $filename";
       
     } else {
       open($hfile,">$dir$filename")||die "Can not open file $filename";
#       print $hfile "SET search_path = $schema, pg_catalog;\n";
     }

   }
   next if $fl1!=1;
   if ($str=~m/$stop/){
     if ($stopprefix){     
        $str=$stopprefix.$str;
     }
     $fl1=0 ;
     print $str,'NEXT',"\n";
   };
   print $hfile $str;
}
exit;
