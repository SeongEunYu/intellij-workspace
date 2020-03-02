/* Database Driven Message Resource Management */

/**
 * RI_i18n
 *   코드			code 		 varchar2(100)
 *   설명			description  varchar2(500)
 *   기본메시지	default_msg	 varchar2(500)
 *   사용여부
 * RI_i18n_detail
 *    코드		code 		 varchar2(100)
 *    언어		lang		 varchar2(5)
 *    메시지		msg	 		 varchar2(500)
 * RI_i18n_lang
 *    언어		lang		 varchar2(5)
 *    이름		name		 varchar2(100)
 */

create table RI_I18N (
	code			varchar2(100) not null,
	description		varchar2(500),
	default_msg		varchar2(500) not null,
	is_used			varchar2(1)
);

alter table RI_I18N add constraint ri_i18n_pk primary key (code);

create table RI_I18N_LANG (
	lang 			varchar2(5) not null,
	name 			varchar2(100) not null
);

alter table RI_I18N_LANG add constraint ri_i18n_lang_pk primary key (lang);

create table RI_I18N_DETAIL (
	code	varchar2(100) not null,
	lang	varchar2(5) not null,
	msg		varchar2(500) not null
);
alter table RI_I18N_DETAIL add constraint ri_i18n_dtl_pk primary key (code, lang);
alter table RI_I18N_DETAIL add constraint rel_ri_i18n_detail foreign key (code) references RI_I18N (code);
alter table RI_I18N_DETAIL add constraint rel_ri_i18n_lang_detail foreign key (lang) references RI_I18N_LANG (lang);

/* abut SCI menu */

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview','메뉴명 - About Overview','Overview','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.latest','메뉴명 - About Latest SCI Articles','Latest SCI Articles','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.latest', 'ko', '최근게재논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.trend','메뉴명 - About SCI Trends by year','SCI Trends by year','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.trend', 'ko', '연도별 논문건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.sbuject','메뉴명 - About Subject Trends by year','Subject Trends by year','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.sbuject', 'ko', '연도별 최다 논문 게재<br/> 연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.ranking','메뉴명 - About IF Ranking by Cat.','IF Ranking by Cat.','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.ranking', 'ko', '학술지 분야별 IF');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.journal','메뉴명 - About Journal by Dept.','Journal by Dept.','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.journal', 'ko', '연도별 최다 논문 게재<br/> 학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.coauthor','메뉴명 - About 공동연구 네트워크','공동연구 네트워크','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.coauthor', 'ko', '공동연구 네트워크');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.sbuject.page','메뉴명 - About Subject Trends by year','Subject Trends by year','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.sbuject.page', 'ko', '연도별 최다 논문 게재 연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.journal.page','메뉴명 - About Journal by Dept.','Journal by Dept.','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.journal.page', 'ko', '연도별 최다 논문 게재 학술지 현황');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.scilatest','메뉴명 - About 최근SCI논문','최근SCI논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.scilatest', 'ko', '최근SCI논문');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.kcilatest','메뉴명 - About 최근KCI논문','최근KCI논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.kcilatest', 'ko', '최근KCI논문');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.scitrend','메뉴명 - About 연도별 SCI 논문수','연도별 SCI 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.scitrend', 'ko', '연도별 SCI 논문수');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about.overview.kcitrend','메뉴명 - About 연도별 KCI 논문수','연도별 KCI 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about.overview.kcitrend', 'ko', '연도별 KCI 논문수');



/* researcher menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.artco','메뉴명 - Researcher 논문건수 분석','연도별 논문건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.artco', 'ko', '연도별 논문건수');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.overview','메뉴명 - Researcher Overview','Overview','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.profile','메뉴명 - Researcher Overview','Profile','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.profile', 'ko', '프로파일');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.hindex','메뉴명 - Researcher H-index','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.cited','메뉴명 - Researcher Cited vs Uncited','Cited vs Uncited','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.cited', 'ko', '논문 피인용 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.coauthor','메뉴명 - Researcher Co-Author Networks','Co-Author Networks','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.coauthor', 'ko', '공동연구자 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.similar','메뉴명 - Researcher Similar Experts','Similar Experts','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.similar', 'ko', '유사 연구자 조회');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.journal','메뉴명 - Researcher Published Journal','Published Journal','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.journal', 'ko', '연도별 최다 논문 게재<br/>학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.patent','메뉴명 - Researcher Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.techtrans','메뉴명 - Researcher Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.techtrans', 'ko', '기술이전');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch.journal.page','메뉴명 - Researcher Published Journal','Published Journal','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch.journal.page', 'ko', '연도별 최다 논문 게재 학술지 현황');

/* department menu */

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.overview','메뉴명 - Department Overview','요약','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.latest','메뉴명 - Department Latest Articles','최근게재논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.latest', 'ko', '최근게재논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.artco','메뉴명 - Department 논문건수 분석','연도별 논문건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.artco', 'ko', '연도별 논문건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.avgif','메뉴명 - Department 평균IF 분석','평균 IF 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.avgif', 'ko', '평균 IF 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.cited','메뉴명 - Department Citation 분석','논문 피인용 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.cited', 'ko', '논문 피인용 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.hindex','메뉴명 - Department H-index','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.sbuject','메뉴명 - Department 저널 주제별 연구동향','연도별 최다 논문 게재<br/>연구분야 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.sbuject', 'ko', '연도별 최다 논문 게재<br/>연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.journal','메뉴명 - Department 학과별 투고 저널','연도별 최다 논문 게재<br/>학술지 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.journal', 'ko', '연도별 최다 논문 게재<br/>학술지 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.patent','메뉴명 - Researcher Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.techtrans','메뉴명 - Researcher Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.techtrans', 'ko', '기술이전');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.sbuject.page','메뉴명 - Department 저널 주제별 연구동향','연도별 최다 논문 게재 연구분야 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.sbuject.page', 'ko', '연도별 최다 논문 게재 연구분야 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept.journal.page','메뉴명 - Department 학과별 투고 저널','연도별 최다 논문 게재 학술지 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept.journal.page', 'ko', '연도별 최다 논문 게재 학술지 현황');

/* college menu */

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.overview','메뉴명 - College Overview','요약','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.overview', 'ko', '요약');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.latest','메뉴명 - College Latest Articles','최근게재논문','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.latest', 'ko', '최근게재논문');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.artco','메뉴명 - College 학과별 논문 건수','학과별 논문 건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.artco', 'ko', '학과별 논문 건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.avgif','메뉴명 - College 평균IF','학과별 평균 IF 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.avgif', 'ko', '학과별 평균 IF 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.cited','메뉴명 - College 학과별 평균 피인용횟수','학과별 평균 논문 피인용현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.cited', 'ko', '학과별 평균 논문 피인용현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.coauthor','메뉴명 - College 학과별 공동연구','학과별 공동연구 네트워크','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.coauthor', 'ko', '학과별 공동연구 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.patent','메뉴명 - College Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.techtrans','메뉴명 - College Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.techtrans', 'ko', '기술이전');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.hindex','메뉴명 - College H-index','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.hindex', 'ko', 'H-index');
                 
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg.cited.page','메뉴명 - College 학과별 평균 피인용현황 페이지','학과별 평균 논문 피인용현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg.cited.page', 'ko', '학과별 평균 논문 피인용현황');                 
                 
/* Institution menu */

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.hindex','메뉴명 - Institution H-index by Researcher','H-index','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.hindex', 'ko', 'H-index');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.pub','메뉴명 - Institution Researcher by Pub.','연구자별 논문수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.pub', 'ko', '연구자별 논문수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.artCited','메뉴명 - Institution Article by Citation','논문별 피인용수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.artCited', 'ko', '논문별 피인용수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.artco','메뉴명 - Institution 학과별 논문 건수','논문 건수','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.artco', 'ko', '논문 건수');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.avgif','메뉴명 - Institution 평균IF','평균 IF 현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.avgif', 'ko', '평균 IF 현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.cited','메뉴명 - Institution 학과별 평균 피인용횟수','평균 논문 피인용현황','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.cited', 'ko', '평균 논문 피인용현황');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.coauthor','메뉴명 - Institution 학과별 공동연구','공동연구 네트워크','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.coauthor', 'ko', '공동연구 네트워크');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.patent','메뉴명 - Researcher Trend Patent','특허건수 분석','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.patent', 'ko', '특허건수 분석');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.techtrans','메뉴명 - Researcher Tech-Trans','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.techtrans', 'ko', '기술이전');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.logByMenu','메뉴명 - Institution 로그분석 by menu','로그분석 by menu','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.logByMenu', 'ko', '로그분석 by menu');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.logByDate','메뉴명 - Institution 로그분석 by date','로그분석 by date','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.logByDate', 'ko', '기술이전');


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst.connUser','메뉴명 - Institution 시스템 접속자','시스템 접속자','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst.connUser', 'ko', '시스템 접속자');



insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.inst','메뉴명 - Institution','Institution','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.inst', 'ko', 'Institution');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.clg','메뉴명 - College','College','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.clg', 'ko', 'College');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.dept','메뉴명 - Department','Department','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.dept', 'ko', 'Department');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.rsch','메뉴명 - Researcher','Researcher','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.rsch', 'ko', 'Researcher');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED)
                 values('menu.asrms.about','메뉴명 - About SCI','About YU SCI/KCI','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG)
                 values('menu.asrms.about', 'ko', 'About YU SCI/KCI');


-- jcr import, sjr import, kci_if import
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.jcr.import','메뉴명 - JCR Import','JCR Import','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.jcr.import', 'ko', 'JCR 반입');

insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.jcr.import', 'ko', 'JCR import');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.sjr.import','메뉴명 - SJR Import','SJR Import','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.sjr.import', 'ko', 'SJR 반입');

insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.sjr.import', 'ko', 'SJR import');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.kci_if.import','메뉴명 - KCI Import','KCI IF Import','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.kci_if.import', 'ko', 'KCI IF 반입');

insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.kci_if.import', 'ko', 'KCI IF import');

-- statistics patent, techtrans
-- menu.statistics.patent, menu.statistics.techtrans


insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.statistics.patent','메뉴명 - 통계 지식재산(특허)','지식재산(특허)','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.statistics.patent', 'ko', '지식재산(특허)');

insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.statistics.techtrans','메뉴명 - 통계 기술이전','기술이전','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.statistics.techtrans', 'ko', '기술이전');

/* kci import menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG,IS_USED) values ('menu.kci','메뉴명 - KCI','KCI','Y');
insert into RI_I18N_DETAIL (CODE,LANG,MSG) values ('menu.kci','ko','KCI');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG,IS_USED) values ('menu.kci.import','메뉴명 - KCI 데이터 반입','Import Data','Y');
insert into RI_I18N_DETAIL (CODE,LANG,MSG) values ('menu.kci.import','KO','데이터 반입');
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG,IS_USED) values ('menu.kci.identify','메뉴명 - KCI 저자식별','Researcher Identify','Y');
insert into RI_I18N_DETAIL (CODE,LANG,MSG) values ('menu.kci.identify','KO','저자식별');

/* track menu 2016.02.05 */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.track','메뉴명 - Track관리','Track Manage','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.track', 'ko', 'Track 관리');

/* org-alias menu */
insert into RI_I18N (CODE,DESCRIPTION,DEFAULT_MSG, IS_USED) values('menu.orgalias','메뉴명 - 기관전거관리','ORG-Alias Manage','Y');
insert into RI_I18N_DETAIL(CODE, LANG, MSG) values('menu.orgalias', 'ko', '기관명전거관리');


