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
     block=>sub{$schema=$_[1];$name=$_[2];},

   },
   table_column=>{
     prefix=>'',
     start=>'^\s*ALTER TABLE ONLY (\w+)\.(\w+) ALTER COLUMN',
     stop=> '',
     suffix=>'_db',
     block=>sub{$schema=$_[0];$name=$_[1];},
   },
   table_constraint=>{
     prefix=>'',
     start=>'^ALTER TABLE ONLY (\w+)\.(\w+)\s*$',
     stop=> '^\s*ADD CONSTRAINT ',
     suffix=>'_db',
     block=>sub{$schema=$_[0];$name=$_[1];},
   },

   table_index=>{
     prefix=>'',
     start=>'^CREATE INDEX (\w+) ON (\w+)\.(\w+) USING ',
     stop=> '',
     suffix=>'_db',
     block=>sub{$schema=$_[1];$name=$_[2];},
   },
   table_grant=>{
     prefix=>'',
     start=>'^(GRANT|REVOKE) (\w+,?\w*) ON TABLE (\w+)\.(\w+)',
     stop=> '',
     suffix=>'_db',
     block=>sub{$schema=$_[2];$name=$_[3];},
   },

   table_comment=>{
     prefix=>'',
     start=>'^COMMENT ON (TABLE|COLUMN) (\w+)\.(\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'_db',
     block=>sub{$schema=$_[1];$name=$_[2];},
   },
   function=>{
     prefix=>'',
     start=>'^\s*CREATE FUNCTION (\w+)\.(\w+)',
     stop=> '^\s*ALTER FUNCTION',
     stopprefix=>'--',
     suffix=>'',
     block=>sub{$schema=$_[0];$name=$_[1];},
     replace=>sub{$str=~s/^CREATE/CREATE OR REPLACE/;}
   },
   domain=>{
     prefix=>'',
     start=>'^CREATE DOMAIN (\w+)\.(\w+)',
     stop=> '^ALTER DOMAIN',
     stopprefix=>'--',
     suffix=>'',
     block=>sub{$schema=$_[0];$name=$_[1];},
    },
   extention=>{
     prefix=>'',
     start=>'^CREATE EXTENSION IF NOT EXISTS (\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'',
     block=>sub{$schema='public';$name=$_[1];},
    },
   type=>{
     prefix=>'',
     start=>'^CREATE TYPE (\w+)\.(\w+)',
     stop=> '^ALTER TYPE (\w+\.\w+) OWNER TO',
     stopprefix=>'--',
     suffix=>'_tp',
     block=>sub{$schema=$_[0];$name=$_[1];},
     skip=>'^\s*$',
    },
   view=>{
     prefix=>'',
     start=>'^CREATE VIEW (\w+)\.(\w+)',
     stop=> 'ALTER TABLE (\w+)\.(\w+) OWNER TO',
     stopprefix=>'--',
     suffix=>'_vw',
     block=>sub{$schema=$_[0];$name=$_[1];},
     skip=>'^\s*$',
    },
 
   trigger=>{
     prefix=>'',
     start=>'^CREATE TRIGGER .+ ON (\w+)\.(\w+) FOR ',
     stop=> '',
     stopprefix=>'',
     suffix=>'_trig',
     block=>sub{$schema=$_[0];$name=$_[1];},
    },

   language=>{
     prefix=>'',
     start=>'^CREATE OR REPLACE PROCEDURAL LANGUAGE (\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'_lang',
     block=>sub{$schema='public';$name=$_[0];},
    },

   extension=>{
     prefix=>'',
     start=>'^CREATE EXTENSION IF NOT EXISTS (\w+) WITH SCHEMA (\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'_ex',
     block=>sub{$schema=$_[1];$name=$_[0];},
    },

   server=>{
     prefix=>'',
     start=>'^CREATE SERVER (\w+) FOREIGN ',
     stop=> 'ALTER SERVER (\w+) OWNER TO ',
     stopprefix=>'--',
     suffix=>'',
     block=>sub{$schema='public';$name=$_[0];},
     skip=>'^\s*$',
    },
   server_mapuser=>{
     prefix=>'',
     start=>'^CREATE USER MAPPING FOR (\w+) SERVER (\w+) OPTIONS ',
     stop=> '\);',
     stopprefix=>'',
     suffix=>'',
     block=>sub{$schema='public';$name=$_[1];},
    },
   schema=>{
     prefix=>'',
     start=>'^CREATE SCHEMA (\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'_sc',
     block=>sub{$schema='public';$name=$_[0];},
    },


   sequence=>{
     prefix=>'',
     start=>'CREATE SEQUENCE (\w+)\.(\w+)',
     stop=> ';',
     stopprefix=>'',
     suffix=>'',
     block=>sub{$schema=$_[0];$name=$_[1];},
     skip=>'^\s*$',
    },

   sequence_grant=>{
     prefix=>'',
     start=>'^(GRANT|REVOKE) (\w+,?\w*) ON SEQUENCE (\w+)\.(\w+)',
     stop=> '',
     stopprefix=>'',
     suffix=>'',
     block=>sub{$schema=$_[2];$name=$_[3];},
     skip=>'^\s*$',
    },



#COMMENT ON TABLE public.memstat IS 'Данные CDR из MEM';

};
#CREATE FUNCTION audit.audit_table(target_table regclass) RETURNS void
#    LANGUAGE sql
#    AS $_$
#SELECT audit.audit_table($1, BOOLEAN 't', BOOLEAN 't');
#$_$;
#ALTER FUNCTION audit.audit_table(target_table regclass) OWNER TO cpn;


#print "dir=$dir filestru=$filestru key=$key\n";
#exit;
my $start=$lexem->{$key}->{start};
my $stop=$lexem->{$key}->{stop};
my $stopprefix=$lexem->{$key}->{stopprefix};
#print "start=$start\n";
#print "stop=$stop\n";
#print Dumper(\$lexem);
#print Dumper(\$lexem->{$key});


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
#        print $str,"\n";

#	print  $schema,"\n";
#	print  $name,"\n";
       $fl1=1;
     if ($schema=~/^public$/){
       $filename=$name.$lexem->{$key}->{'suffix'} .".sql";
     } else {
       $filename=$schema.".".$name.$lexem->{$key}->{'suffix'}.".sql";
#       print "$schema\n";
#       print "$name\n";
#       print "$lexem->{$key}->{'suffix'}\n";
#       exit;

     } 
#     print "$dir $filename \n"; 
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
   };
   if ($lexem->{$key}->{'skip'}){
     if ($str=~m/$lexem->{$key}->{'skip'}/){
        next;
     }
   }
   print $hfile $str;
}
exit;
