select
     TA.PRODYEAR
    ,TA.PRODEDITION
    ,TA.issn
    ,TA.CATEG
    ,(select COUNT(*)
       from JCR_CAT_RANK TB
       where TB.PRODYEAR = TA.PRODYEAR
        AND TB.CATEG=TA.CATEG
        AND TB.PRODEDITION=TA.PRODEDITION
        AND TO_NUMBER(NVL(TB.IMPACT,0))>TO_NUMBER(NVL(TA.IMPACT,0))
     ) as RANK
    ,TA.IMPACT
from JCR_CAT_RANK TA
 where TA.CATEG = 'CQ'
 and TA.PRODYEAR = '2014'
--ORDER BY TA.CATEG, RANK

;
UPDATE JCR_CAT_RANK TA
       SET TA.RANK=
       (SELECT COUNT(*)+1
         FROM JCR_CAT_RANK TB
        WHERE TA.PRODYEAR=TB.PRODYEAR
              AND TB.CATEG=TA.CATEG
              AND TA.PRODEDITION=TB.PRODEDITION
              AND TO_NUMBER(NVL(TB.IMPACT,0))>TO_NUMBER(NVL(TA.IMPACT,0))
       )
 WHERE TA.PRODYEAR = '2004';

UPDATE JCR_CAT_RANK
       SET RATIO= TO_NUMBER(((RANK-1)/CNT)*100)
 WHERE PRODYEAR = '2004';

commit;




-- Update SJR from RI_ARTICLE

 update RI_ARTICLE TA
   set
      TA.SJR = (select MAX(SJR) from SJR_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2010')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2010','2011');

 update RI_ARTICLE TA
   set
      TA.SJR = (select MAX(SJR) from SJR_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2011')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2011','2012');

 update RI_ARTICLE TA
   set
      TA.SJR = (select MAX(SJR) from SJR_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2012')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2012','2013');

 update RI_ARTICLE TA
   set
      TA.SJR = (select MAX(SJR) from SJR_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2013')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2013','2014');

 update RI_ARTICLE TA
   set
      TA.SJR = (select MAX(SJR) from SJR_TIT where ISSN = TA.ISSN_NO and PRODYEAR = '2014')
where SUBSTR(TA.PBLC_YM, 0, 4) IN ('2014','2015');