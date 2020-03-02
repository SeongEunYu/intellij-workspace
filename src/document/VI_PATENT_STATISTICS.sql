  CREATE OR REPLACE FORCE VIEW "VI_PATENT_STATISTICS" ("PATENT_ID", "PATYEAR", "ACQS_NTN_DVS_CD", "APPL_REG_NO", "ITL_PPR_RGT_REG_NO", "ITL_PPR_RGT_NM", "APPL_REGT_NM", "ACQS_DVS_CD", "ACQS_DTL_DVS_CD", "SMMR_CNTN", "CLAIMTEXT", "PAT_CLS_CD", "STATUS", "APPL_STATUS", "APPL_REG_NTN_CD", "APPL_REG_NTN_NM", "VRFC_DVS_CD", "APPR_DVS_CD", "APPR_DATE", "SEQ_AUTHOR", "PRTCPNT_ID", "PRTCPNT_NM", "USER_ID", "GUBUN", "KOR_NM", "DEPT_KOR", "HLDOF_YN", "APTM_DATE", "GRADE1", "POSI_NM", "SEX_DVS_CD", "NTNT_CD", "EMP_ID", "GRADE_GUBUN") AS
  SELECT
            TA.PATENT_ID,
            NVL(SUBSTR(TA.APPL_REG_DATE,1,4),to_char(TA.MOD_DATE, 'YYYY')) as PATYEAR,
            TA.ACQS_NTN_DVS_CD,
			TA.APPL_REG_NO,
			TA.ITL_PPR_RGT_REG_NO,
			TA.ITL_PPR_RGT_NM,
			TA.APPL_REGT_NM,
			TA.ACQS_DVS_CD,
			TA.ACQS_DTL_DVS_CD,
			TA.SMMR_CNTN,
			TA.CLAIMTEXT,
			TA.PAT_CLS_CD,
			TA.STATUS,
			TA.APPL_STATUS,
			TA.APPL_REG_NTN_CD,
			TA.APPL_REG_NTN_NM,
			TA.VRFC_DVS_CD,
            TA.APPR_DVS_CD,
            TA.APPR_DATE,
            TB.SEQ_AUTHOR,
            TB.PRTCPNT_ID,
            TB.PRTCPNT_NM,
            TC.USER_ID,
            TC.GUBUN,
            TC.KOR_NM,
            TC.DEPT_KOR,
            TC.HLDOF_YN,
            TC.APTM_DATE,
            TC.GRADE1,
            TC.POSI_NM,
            TC.SEX_DVS_CD,
            TC.NTNT_CD,
	        TC.EMP_ID,
	        DECODE (TC.POSI_NM,
                    '교수', 1,
                    '조교수', 1,
                    '부교수', 1,
                    '학생', 3,
                    2)
               grade_gubun
       FROM RI_PATENT TA, RI_PATENT_PARTI TB, RI_USER TC
      WHERE     TA.PATENT_ID = TB.PATENT_ID
            AND TB.PRTCPNT_ID = TC.USER_ID
            AND NVL (TA.DEL_DVS_CD, 'N') != 'Y'
            AND NVL (TB.DEL_DVS_CD, 'N') != 'Y';