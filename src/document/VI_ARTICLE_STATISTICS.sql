CREATE VIEW VI_ARTICLE_STATISTICS AS
select RA.ARTICLE_ID
      ,RA.SCJNL_DVS_CD
      ,RA.OVRS_EXCLNC_SCJNL_PBLC_YN
      ,RA.DOC_TYPE
      ,RA.PBLC_YM
      ,DECODE(RA.PBLC_YM,'ACCEPT','A','P') as PUBLISH_GUBUN
      ,SUBSTR(RA.PBLC_YM,1,4) as PUBYEAR
      ,RA.DOI
      ,RA.APPR_DVS_CD
      ,RA.APPR_DATE
      ,RA.VRFC_DVS_CD
      ,RA.ID_SCI
      ,RA.ID_SCOPUS
      ,RA.ID_KCI
      ,RA.SCJNL_NM
      ,RA.ORG_LANG_PPR_NM
      ,RA.ISSN_NO
      ,RA.VOLUME
      ,RA.STT_PAGE
      ,RA.END_PAGE
      ,RA.IMPCT_FCTR
      ,RA.SJR
      ,RA.KCI_IF
      ,RA.TC
      ,RA.TC_DATE
      ,RA.SCP_TC
      ,RA.SCP_TC_DATE
      ,RA.KCI_TC
      ,RA.KCI_TC_DATE
      ,RA.ABST_CNTN
      ,RA.KEYWORD
      ,RA.PBLC_NTN_CD
      ,DECODE(RA.PBLC_NTN_CD,'KO','국내','국외') as NTNT_CD
      ,RAP.SEQ_AUTHOR
      ,RAP.PRTCPNT_ID
      ,RAP.PRTCPNT_NM
      ,RAP.TPI_DVS_CD
      ,RAP.IS_RECORD
      ,RU.KOR_NM
      ,RU.DEPT_KOR
      ,RU.APTM_DATE
      ,RU.HLDOF_YN
      ,NVL(RU.GRADE1, RU.POSI_NM) as GRADE1
      ,DECODE(NVL(RU.GRADE1, RU.POSI_NM),'교수', 1,'조교수',1,'부교수',1,'학생',3,2) as ENTER_GUBUN
      ,RU.SEX_DVS_CD
      ,RU.NTNT_CD as NTN_CD
      ,RU.GUBUN
      ,RU.USER_ID
      ,RU.EMP_ID
      ,CASE
        WHEN CONCAT(NVL(RA.SCJNL_DVS_CD,'9'),NVL(RA.OVRS_EXCLNC_SCJNL_PBLC_YN, '9')) <= '14'
        THEN '11'
        ELSE CONCAT(RA.SCJNL_DVS_CD,RA.OVRS_EXCLNC_SCJNL_PBLC_YN)
       END as JNL_GUBUN
from RI_ARTICLE RA
left join RI_ARTICLE_PARTI RAP on (RA.ARTICLE_ID = RAP.ARTICLE_ID)
left join RI_USER RU on (RAP.PRTCPNT_ID = RU.USER_ID)
where NVL(RA.DEL_DVS_CD,'N') <> 'Y'
 and NVL(RAP.DEL_DVS_CD,'N') <> 'Y'
;