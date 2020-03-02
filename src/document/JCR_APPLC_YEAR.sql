/*
JCR_적용_년도 JCR_APPLC_YEAR

일련번호        SN
JCR 적용 연도	JCR_YEAR
시작년월일	 	BEGIN_DE
끝년월일	 	END_DE
등록일자	 	RGS_DE
등록자ID		REGISTER_ID
*/


create table JCR_APPLC_YEAR (
	SN			NUMBER(11) not null,
	JCR_YEAR		varchar2(10),
	BEGIN_DE		varchar2(8),
	END_DE		varchar2(8),
	RGS_DE		DATE,
	REGISTER_ID			varchar2(20)
);

insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(1, '2010', '20100101','20120911',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(2, '2011', '20120912','20130631',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(3, '2012', '20130701','20140731',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(4, '2013', '20140801','20150631',sysdate,'system');
insert into JCR_APPLC_YEAR (SN, JCR_YEAR, BEGIN_DE, END_DE, RGS_DE, REGISTER_ID) values(5, '2014', '20150701', null,sysdate,'system');
commit;