package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.*;

import kr.co.argonet.r2rims.core.mapper.MemberAuthorMapper;
import kr.co.argonet.r2rims.core.util.EncryptionUtil;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.util.ServerIpUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.BeanUtils;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.erp.mapper.ErpUserMapper;

public class SyncUserService extends SyncUser {

	private SqlSession erpSqlSession;
	private ErpUserMapper erpUserMapper;
	private MemberAuthorMapper memberAuthorMapper;
	private Map<String, String> authInfo;

	private JSONArray checkFields = new JSONArray("[{'field':'korNm', 'display':'성명(한글)'},"
												 + "{'field':'firstName','display':'First Name'},"
												 + "{'field':'lastName','display':'Last Name'},"
												 + "{'field':'emalAddr','display':'e-mail주소'},"
												 + "{'field':'hldofYn','display':'상태'},"
												 + "{'field':'retrDate','display':'퇴직일'},"
												 + "{'field':'deptKor','display':'학과(한글)'},"
												 + "{'field':'deptEng','display':'학과(영문)'},"
												 + "{'field':'deptCode','display':'학과코드'},"
												 + "{'field':'grade1','display':'직급1'},"
												 + "{'field':'grade2','display':'직급2'},"
												 + "{'field':'userId','display':'연구자등록번호'},"
												 + "{'field':'gubun','display':'구분'},"
												 + "{'field':'ftfFirstAptmDate','display':'임용일(최초)'},"
												 + "{'field':'sexDvsCd','display':'성별'},"
												 + "{'field':'ofcTelno','display':'전화(Office)'},"
												 + "{'field':'hpTelno','display':'핸드폰'},"
												 + "{'field':'faxNo','display':'팩스번호'},"
												 + "{'field':'posiNm','display':'신분'},"
												 + "{'field':'sbjtCd','display':'연구재단학과코드'},"
												 + "{'field':'clgCd','display':'단과대학코드'},"
												 + "{'field':'ntntCd','display':'국적'},"
												 + "{'field':'birthDt','display':'생년월일'}]");

	private JSONArray authCheckFields = new JSONArray("[{'field':'userId', 'display':'대상자사번'},"
															+ "{'field':'korNm','display':'대상자성명(한글)'},"
															+ "{'field':'adminDvsCd','display':'대상자권한코드'},"
															+ "{'field':'authorStatus','display':'권한상태'},"
															+ "{'field':'workTrget','display':'업무대상KEY'},"
															+ "{'field':'workTrgetNm','display':'업무대상명'},"
															+ "{'field':'mngrResnCn','display':'비고'}]");

	public void sync() {

		authInfo = new HashMap<>();
		authInfo.put("userId","system");
		authInfo.put("adminDvsCd","M");
		authInfo.put("conectIp", ServerIpUtil.makeServerIp());
//		authInfo.put("conectIp","server.ip");

		//get mapper
		SqlSession sqlSession =  (SqlSession) context.getBean("sqlSession");
		memberAuthorMapper = sqlSession.getMapper(MemberAuthorMapper.class);
		erpSqlSession = (SqlSession)context.getBean("erpSqlSession");
		erpUserMapper = erpSqlSession.getMapper(ErpUserMapper.class);
		//count
		Integer trgtCo = 0;
		Integer insertCo = 0;
		Integer updateCo = 0;

		String lastSyncDate = null;
		if(stdrDate != null && !"".equals(stdrDate))
		{
			lastSyncDate = stdrDate.replace("-", "");
		}
		else
		{
			// 3) get last sync date from RI_SYNC_LOG
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_USER);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		// 1) init log data
		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_USER);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		syncLogMapper.add(logVo);

		try {
			// 2) find whole user_id from RI_USER table of rims system
			List<String> wholeUserId = userMapper.findWholeUserId();

			// 4) find target data from PERSON_UID table of erp system
			if(lastSyncDate != null)
			{
				EncryptionUtil encryption = new EncryptionUtil();
				List<UserVo> erpUserList = new ArrayList<UserVo>();
				UserIdntfrVo idntfrVo = null;
				List<UserVo> erpStaffList = erpUserMapper.findUserByGubunAndModDate(lastSyncDate, "M"); // 전임,비전임 교원
				List<UserVo> erpStudentList = erpUserMapper.findUserByGubunAndModDate(lastSyncDate, "S"); // 전임,비전임 교원
				if(erpStaffList != null) erpUserList.addAll(erpStaffList);
				if(erpStudentList != null) erpUserList.addAll(erpStudentList);
				trgtCo = erpUserList.size();

				for (UserVo erpUser : erpUserList) {
					String userId = erpUser.getUserId();
					UserVo beforeData = null;
					UserVo afterData = null;
					if (wholeUserId.contains(userId))
					{
						beforeData = userMapper.findByUserId(userId);
						UserVo updateVo = new UserVo();
						BeanUtils.copyProperties(beforeData, updateVo);
						this.updateFromErpUserData(erpUser, updateVo);
						afterData = userMapper.findByUserId(userId);
						updateCo++;
					}
					else
					{
						userMapper.add(erpUser);
						userMapper.updateBySelectOtherTable(erpUser);
						erpUser.setEncptUserId(encryption.encryptSha256WithPrefix(userId, instNm).substring(0,20));
						userMapper.updateEncptUserId(erpUser);

						//add userIdntfr (UID)
						idntfrVo = new UserIdntfrVo();
						idntfrVo.setUserId(erpUser.getUserId());
						idntfrVo.setIdntfrSe("UID");
						idntfrVo.setIdntfr(erpUser.getuId());
						idntfrVo.setStatus("009");
						idntfrVo.setDelDvsCd("N");
						idntfrVo.setRegUserId("system");
						idntfrVo.setModUserId("system");
						userIdntfrMapper.add(idntfrVo);

						afterData = userMapper.findByUserId(userId);
						insertCo++;
					}

					if (StringUtils.isNotBlank(erpUser.getEmalAddr())) {
						List<UserIdntfrVo>  userIdntfrList = userIdntfrMapper.findByUserIdAndIdntfrSe(erpUser.getUserId(), "EMAIL");
						boolean chkEmail = false;
						if (userIdntfrList != null && userIdntfrList.size() > 0) {
							for (UserIdntfrVo userIdntfrVo : userIdntfrList) {
								if (erpUser.getEmalAddr().equals(userIdntfrVo.getIdntfr())) {
									chkEmail = true;
									break;
								}
							}
						}
						if (chkEmail == false) {
							idntfrVo = new UserIdntfrVo();
							idntfrVo.setUserId(erpUser.getUserId());
							idntfrVo.setIdntfrSe("EMAIL");
							idntfrVo.setIdntfr(erpUser.getEmalAddr());
							idntfrVo.setStatus("009");
							idntfrVo.setDelDvsCd("N");
							idntfrVo.setRegUserId("system");
							idntfrVo.setModUserId("system");
							userIdntfrMapper.add(idntfrVo);													// 식별자(EMAIL) 데이터 저장
						}
					}

					this.addChangeHistory(beforeData, afterData);
				}

				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncEnd(new Date());
				logVo.setSyncRm("Success!");
				syncLogMapper.update(logVo);

				/* 퇴직자 처리  */
				List<UserVo> retireUserList = erpUserMapper.findRetireUser(lastSyncDate, "M");
				for(UserVo retireUser : retireUserList)
				{
					String retUserId = retireUser.getUserId();
					UserVo beforeData = null;
					UserVo afterData = null;
					if (wholeUserId.contains(retUserId))
					{
						beforeData = userMapper.findByUserId(retUserId);
						userMapper.updateHldofYn(retireUser);
						afterData = userMapper.findByUserId(retUserId);
						this.addChangeHistory(beforeData, afterData);
					}
					procAuthorFrftrByUserId(retUserId);
				}

				List<UserVo> retireStudentList = erpUserMapper.findRetireUser(lastSyncDate, "S");
				for(UserVo retireStudent : retireStudentList)
				{
					String retUserId = retireStudent.getUserId();
					UserVo beforeData = null;
					UserVo afterData = null;
					if (wholeUserId.contains(retUserId))
					{
						beforeData = userMapper.findByUserId(retUserId);
						userMapper.updateHldofYn(retireStudent);
						afterData = userMapper.findByUserId(retUserId);
						this.addChangeHistory(beforeData, afterData);
					}
					procAuthorFrftrByUserId(retUserId);
				}
			}
			else
			{
				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncRm("Error >>> search date : " + stdrDate);
				syncLogMapper.update(logVo);
			}

		} catch (Exception e) {
			// update ri_sync_log error
			logVo.setTrgtCo(trgtCo);
			logVo.setInsertCo(insertCo);
			logVo.setUpdateCo(updateCo);
			if(e != null && e.getMessage() != null && e.getMessage().length() > 900)
				logVo.setSyncRm("Error >>> " + e.getMessage().substring(0, 900));
			else if(e != null)
				logVo.setSyncRm("Error >>> " + e.getMessage());
			syncLogMapper.update(logVo);
		}
	}

	private void addChangeHistory(UserVo before, UserVo after){
		StringBuffer sb = new StringBuffer();
		ChangeHistoryVo historyVo = new ChangeHistoryVo();
		try {
			if(before != null && after != null) // update인 경우
			{
				for(int i = 0; i < checkFields.length(); i++)
				{
					JSONObject field = checkFields.getJSONObject(i);
					String fieldName = field.getString("field");
					String display = field.getString("display") + ": ";
					String beforeValue = org.apache.commons.beanutils.BeanUtils.getProperty(before, fieldName);
					String afterValue = org.apache.commons.beanutils.BeanUtils.getProperty(after, fieldName);
					if(beforeValue != null && afterValue != null && !beforeValue.equals(afterValue))
						sb.append(display).append(beforeValue).append(" -> ").append(afterValue).append("\n");
				}
				historyVo.setChangeSe("U");
			}
			else if(after != null) //insert인 경우
			{
				sb.append("[신규입력]").append("\n");
				for(int j = 0; j < checkFields.length(); j++)
				{
					JSONObject field = checkFields.getJSONObject(j);
					String fieldName = field.getString("field");
					String display = field.getString("display") + ": ";
					String value = org.apache.commons.beanutils.BeanUtils.getProperty(after, fieldName);
					sb.append(display).append(value).append("\n");
				}
				historyVo.setChangeSe("I");
			}
			if(sb.length() > 0)
			{
				//RI_CHANGE_POINT 테이블에 ADD하는 로직 추가
				historyVo.setTrgterId(after.getUserId());
				historyVo.setTrgterAuthorCd("U");
				historyVo.setWorkSe(R2Constant.CHANGE_HISTORY_WORKSE_USER);
				historyVo.setChangeFrmat("TEXT");
				historyVo.setChangeContents(sb.toString());
				historyVo.setModUserId("SYSTEM");
				historyVo.setModUserAuthorCd("Y");
				changeHistoryMapper.add(historyVo);
			}
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}

	private void updateFromErpUserData(UserVo erpUserData, UserVo updateUser) {
		updateUser.setKorNm(erpUserData.getKorNm());
		if (updateUser.getFirstName() == null || "".equals(updateUser.getFirstName()))
			updateUser.setFirstName(erpUserData.getFirstName());
		if (updateUser.getLastName() == null || "".equals(updateUser.getLastName()))
			updateUser.setLastName(erpUserData.getLastName());
		if (updateUser.getAptmDate() == null || "".equals(updateUser.getAptmDate()))
			updateUser.setAptmDate(erpUserData.getAptmDate());
		if (updateUser.getRetrDate() == null || "".equals(updateUser.getRetrDate()))
			updateUser.setRetrDate(erpUserData.getRetrDate());
		updateUser.setEmalAddr(erpUserData.getEmalAddr());
		updateUser.setBirthDt(erpUserData.getBirthDt());
		updateUser.setHldofYn(erpUserData.getHldofYn());
		updateUser.setDeptKor(erpUserData.getDeptKor());
		updateUser.setDeptEng(erpUserData.getDeptEng());
		updateUser.setDeptCode(erpUserData.getDeptCode());
		updateUser.setGrade1(erpUserData.getGrade1());
		updateUser.setGrade2(erpUserData.getGrade2());
		updateUser.setPosiNm(erpUserData.getPosiNm());
		updateUser.setPosiCd(erpUserData.getPosiCd());
		updateUser.setOfcTelno(erpUserData.getOfcTelno());
		updateUser.setHpTelno(erpUserData.getHpTelno());
//		updateUser.setHomeTelno(erpUserData.getHomeTelno());
		updateUser.setFaxNo(erpUserData.getFaxNo());
//		updateUser.setHomeZipCode(erpUserData.getHomeZipCode());
//		updateUser.setHomeAddr1(erpUserData.getHomeAddr1());
//		updateUser.setHomeAddr2(erpUserData.getHomeAddr2());
		updateUser.setuId(erpUserData.getuId());
		updateUser.setModUserId("system");
		userMapper.updateSync(updateUser);
		userMapper.updateBySelectOtherTable(erpUserData);
	}

	//권한회수처리
	private void procAuthorFrftrByUserId(String userId){
		List<MemberAuthorVo> hasAuthorList = memberAuthorMapper.findByUserId(userId);

		if(hasAuthorList != null && hasAuthorList.size() > 0)
		{
			for(MemberAuthorVo hasAuthor : hasAuthorList)
			{
				if("Y".equals(hasAuthor.getAuthorStatus()))
				{
					hasAuthor.setModUserId(authInfo.get("userId"));
					memberAuthorMapper.delete(hasAuthor);
					MemberAuthorVo afterAuthor = memberAuthorMapper.findByAuthorId(hasAuthor.getAuthorId());
					this.addAuthChangHistory(hasAuthor, afterAuthor, authInfo);
				}
			}
		}
	}
	//권한수정에 따른 이력저장
	public void addAuthChangHistory(MemberAuthorVo beforeAuthor, MemberAuthorVo afterAuthor, Map<String, String> authInfo){
		ChangeHistoryVo historyVo = new ChangeHistoryVo();
		historyVo.setTrgterId(afterAuthor.getUserId());
		historyVo.setTrgterKorNm(afterAuthor.getKorNm());
		historyVo.setTrgterAuthorCd(afterAuthor.getAdminDvsCd());
		historyVo.setTrgterAuthorId(afterAuthor.getAuthorId());
		historyVo.setTrgterAuthorWork(afterAuthor.getWorkTrget());
		historyVo.setTrgterAuthorWorkNm(afterAuthor.getWorkTrgetNm());
		historyVo.setModUserId(authInfo.get("userId"));
		historyVo.setModUserAuthorCd(authInfo.get("adminDvsCd"));
		historyVo.setConectIp(authInfo.get("conectIp"));
		historyVo.setWorkSe(R2Constant.CHANGE_HISTORY_WORKSE_AUTH);
		historyVo.setChangeFrmat("TEXT");
		StringBuffer contents = new StringBuffer();
		boolean isChanged = false;
		try {
			if(beforeAuthor != null) // 수정 또는 삭제
			{
				if("F".equals(afterAuthor.getAuthorStatus()))
				{
					historyVo.setChangeSe("D");
					contents.append(afterAuthor.getAdminDvsCdNm()).append(" 삭제(유저동기화:퇴직 및 졸업)").append("\n");
					isChanged = true;
				}
				else
				{
					historyVo.setChangeSe("U");
					contents.append(afterAuthor.getAdminDvsCdNm()).append(" 수정").append("\n");
				}
				for(int i = 0; i < authCheckFields.length(); i++)
				{
					JSONObject field = authCheckFields.getJSONObject(i);
					String fieldName = field.getString("field");
					String display = field.getString("display") + ": ";
					String beforeValue =  org.apache.commons.beanutils.BeanUtils.getProperty(beforeAuthor, fieldName);
					String afterValue = org.apache.commons.beanutils.BeanUtils.getProperty(afterAuthor, fieldName);
					if(beforeValue != null && afterValue != null && !beforeValue.equals(afterValue))
					{
						contents.append(display).append(beforeValue).append(" -> ").append(afterValue).append("\n");
						isChanged = true;
					}
				}
			}
			else
			{
				historyVo.setChangeSe("I");
				contents.append(afterAuthor.getAdminDvsCdNm()).append(" 추가").append("\n");
				isChanged = true;
				for(int j = 0; j < authCheckFields.length(); j++)
				{
					JSONObject field = authCheckFields.getJSONObject(j);
					String fieldName = field.getString("field");
					String display = field.getString("display") + ": ";
					String value = org.apache.commons.beanutils.BeanUtils.getProperty(afterAuthor, fieldName);
					contents.append(display).append(value).append("\n");
				}
			}
			historyVo.setChangeContents(contents.toString());
			if(isChanged) changeHistoryMapper.add(historyVo);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}

}
