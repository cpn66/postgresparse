# postgresparse
Набор perl script-ов для парсинга структуры база на postgresql для удобства фиксации изменений в разработке используя git для контроля версий.
зависимости:
  make
  pg_dump
  perl
  git
начало работы:
 добиться выполнения 
 # cd  parser_dump 
 # make stru
 после настройки в parser_dump/Makefile переменных DATABASE и HOST
 #cp -R db ../db
 # cd ..
 работать с db/