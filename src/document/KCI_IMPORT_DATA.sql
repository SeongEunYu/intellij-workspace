-- 1) Temporary table create  - KCI_TIT_RAW, KCI_CAT_RANK_RAW table

-- 2) Import data to KCI_TIT_RAW table using sqldeveloper program

-- 3) Update CATEG column of KCI_TIT_RAW table

update KCI_TIT_RAW TA 
   set CATEG = (
                    select CATCODE 
                    from RD_SUBJECT 
                    where PRODCODE = 'KCI' 
                    and DESCRIPTION = TA.CATNAME 
                    and CATCODE like DECODE( TA.UP_CATNAME, 
                                               '인문학','A%',
                                               '사회과학','B%',
                                               '자연과학','C%',
                                               '공학','D%',
                                               '의약학','E%',
                                               '농수해양','F%',
                                               '예술체육','G%', 
                                               '복합학','H%', 
                                               'ZZZZ'          )
                    group by CATCODE
                )
;

-- 4) insert into KCI_CAT_RANK_RAW select from KCI_TIT_RAW

insert into KCI_CAT_RANK_RAW (  ID, PRODYEAR, CATEG, CATNAME, KCI_IF, ISSN, TITLE ) select ROWNUM, PRODYEAR, CATEG, CATNAME, KCI_IF, ISSN, TITLE from KCI_TIT_RAW where PRODYEAR = '2008'
;





