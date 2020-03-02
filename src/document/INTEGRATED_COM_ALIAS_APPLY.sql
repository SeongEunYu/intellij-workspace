-- 1) create temporary table

   CREATE TABLE "TMP_COM_ALIAS"
   ( "SEQ_NO" NUMBER(6,0),
	 "ORG_NAME" VARCHAR2(1000 BYTE),
	 "INTEGRATED_NAME" VARCHAR2(1000 BYTE)
   ) TABLESPACE "TS_R2RIMS_YU" ;

-- 2) Import data to "TMP_COM_ALIAS" table using sqldeveloper program

-- 3) URP_ARTICLE_RAWDATA table add column

	alter table "URP_ARTICLE_RAWDATA" add("INTEGRATED_BLNG_ACG_NM" VARCHAR2(1000 BYTE)); /* 통합기관명 컬럼 */

-- 4) URP_ARTICLE_RAWDATA update

	merge into URP_ARTICLE_RAWDATA UA
	using (
			select TA.SEQ, TA.Blng_Acg_Nm
			      , (select MAX(Integrated_Name) from Tmp_Com_Alias where TRIM(ORG_NAME) = TRIM(TA.Blng_Acg_Nm) group by TRIM(ORG_NAME)) as Integrated_Name
			from Urp_Article_Rawdata TA
			where PERNO like 'GEN%'
		   ) TB on (UA.SEQ = TB.SEQ)
	 WHEN MATCHED THEN
	   UPDATE
	      SET UA.INTEGRATED_BLNG_ACG_NM = TB.Integrated_Name
	;

-- 5) Merge ER_ARTICLE_ADRES's RE_INST

	merge into ER_ARTICLE_ADRES AD
	using (
	          select TB.*
	          from (
	                    select TA.SOURC_IDNTFC_NO
	                          ,row_number()over(partition by TA.Sourc_Idntfc_No order by TA.seq) as ADRES_SEQ
	                          ,TA.AUTHR_NM as AUTHOR
	                          ,TA.BLNG_ACG_NM as ADDRESS
	                          ,DECODE(INSTR(TA.PERNO,'GEN'), 0, '영남대학교', TA.BLNG_ACG_NM) as RE_INST
	                          ,Ta.Integrated_Blng_Acg_Nm as NEW_RE_INST
	                          ,TB.ARTICLE_ID
	                          ,TA.PERNO
	                    from URP_ARTICLE_RAWDATA TA
	                        , ER_ARTICLE TB
	                    where TA.SOURC_IDNTFC_NO = TB.SOURC_IDNTFC_NO
	          ) TB where TB.PERNO like 'GEN%'
	) TC on (AD.SOURC_IDNTFC_NO = TC.SOURC_IDNTFC_NO and AD.ARTICLE_ID = TC.ARTICLE_ID and AD.ADRES_SEQ = TC.ADRES_SEQ)
	 WHEN MATCHED THEN
	   UPDATE
	      SET AD.RE_INST = TC.NEW_RE_INST
;

-- 6) Merge RI_ARTICLE_PARTI's BLNG_ACG_NM

	merge into RI_ARTICLE_PARTI TB
	using (
	          select RAP.ARTICLE_ID, RAP.SEQ_AUTHOR, TA.AUTHR_SEQ, RAP.BLNG_AGC_NM, TA.RE_INST
	           from RI_ARTICLE_PARTI RAP,
	                (
	                    select RA.ARTICLE_ID, AU.AUTHR_SEQ, AD.SOURC_IDNTFC_NO, AD.ADRES_SEQ, AD.RE_INST
	                     from RI_ARTICLE RA,
	                          (select RIMS_ID, EXRIMS_ID from INT_RESULT group by RIMS_ID, EXRIMS_ID) IR,
	                          ER_ARTICLE EA,
	                          ER_ARTICLE_AUTHR AU,
	                          ER_ARTICLE_ADRES AD,
	                          ER_ARTICLE_AUTHR_ADRES EAA
	                    where RA.ARTICLE_ID = IR.RIMS_ID
	                      and IR.EXRIMS_ID = EA.ARTICLE_ID
	                      and EA.ARTICLE_ID = AD.ARTICLE_ID
	                      and EA.SOURC_IDNTFC_NO = AD.SOURC_IDNTFC_NO
	                      and EA.ARTICLE_ID = AU.ARTICLE_ID
	                      and EA.SOURC_IDNTFC_NO = AU.SOURC_IDNTFC_NO
	                      and AU.SOURC_IDNTFC_NO = EAA.SOURC_IDNTFC_NO
	                      and AU.AUTHR_SEQ = EAA.AUTHR_SEQ
	                      and AD.SOURC_IDNTFC_NO = EAA.SOURC_IDNTFC_NO
	                      and AD.ADRES_SEQ = EAA.ADRES_SEQ
	                      and AU.RE_PERNO is null
	               ) TA
	          where RAP.ARTICLE_ID = TA.ARTICLE_ID
	            and RAP.SEQ_AUTHOR = TA.AUTHR_SEQ
	) TC on (TB.ARTICLE_ID = TC.ARTICLE_ID and TB.SEQ_AUTHOR = TC.SEQ_AUTHOR )
	 WHEN MATCHED THEN
	   UPDATE
	      SET TB.BLNG_AGC_NM = TC.RE_INST


-- 7) Addtional Rawdata Merge Inst_Name

merge into URP_ARTICLE_RAWDATA_160225 UA
using (
select TA.SEQ, TA.Blng_Acg_Nm
      , (select MAX(Integrated_Name) from Tmp_Com_Alias where TRIM(ORG_NAME) = TRIM(TA.Blng_Acg_Nm) group by TRIM(ORG_NAME)) as Integrated_Name
from URP_ARTICLE_RAWDATA_160225 TA
where PERNO like 'GEN%'
 and seq > 47252
 and RANGE_GUBUN = '교외'
) TB
on (UA.SEQ = TB.SEQ)
 WHEN MATCHED THEN
   UPDATE
      SET UA.INTEGRATED_BLNG_ACG_NM = TB.Integrated_Name
