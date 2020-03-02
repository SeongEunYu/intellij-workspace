package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Test;
import org.springframework.beans.BeanUtils;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.mapper.ChangeHistoryMapper;
import kr.co.argonet.r2rims.core.mapper.SyncLogMapper;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.vo.ChangeHistoryVo;
import kr.co.argonet.r2rims.core.vo.SyncLogVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.erp.mapper.ErpUserMapper;

public class SyncUserFromErpUserTest extends AbstractApplicationContextTest {

	@Resource(name = "erpUserMapper")
	private ErpUserMapper erpUserMapper;
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	@Resource(name = "syncLogMapper")
	private SyncLogMapper syncLogMapper;
	@Resource(name = "changeHistoryMapper")
	private ChangeHistoryMapper changeHistoryMapper;

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

	@Test
	public void findErpUserTest() throws IllegalAccessException, InvocationTargetException, NoSuchMethodException, JSONException{

		//JSONArray changeCheckFields = new JSONArray("[{'field':'korNm', 'display':'성명(한글)'},{'field':'firstName','display':'First Name'}]");
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(new Date());
		cal2.add(Calendar.DATE, -1);
		//lastHarvestDate = cal2.getTime();
		List<UserVo> erpUserList = erpUserMapper.findUserByGubunAndModDate(sdf.format(cal2.getTime()), "M");
		if(erpUserList != null && erpUserList.size() > 0)  System.out.println("erpUserList.size() >>>> " + erpUserList.size());
		else System.out.println("empty List");

		int i = 0;
		for(UserVo erpUser : erpUserList)
		{
			System.out.println("erpUser >>>>> " + erpUser.getUserId() + " : " + erpUser.getGubun() + " : " + erpUser.getKorNm());
			UserVo rimsUser = userMapper.findByUserId(erpUser.getUserId());
			if(rimsUser != null)
			{
				System.out.println("rimsUser >>>>> " + rimsUser.getUserId() + " : " + rimsUser.getGubun() + " : " + rimsUser.getKorNm());
			}

			for(int j = 0 ; j < checkFields.length() ; j++)
			{
				JSONObject filed = checkFields.getJSONObject(j);
				System.out.println(filed.get("display") + " : " + org.apache.commons.beanutils.BeanUtils.getProperty(rimsUser, filed.get("field").toString()));
			}
			i++;
			if(i == 1) break;
		}
	}

	@Test
	public void syncErpUserTest() {

		Integer trgtCo = 0;
		Integer insertCo = 0;
		Integer updateCo = 0;

		// 1) init log data
		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_USER);
		logVo.setSyncType("TEST");
		logVo.setRegUserId("developer");
		syncLogMapper.add(logVo);

		try {
			// 4) find whole user_id from RI_USER table of rims system
			List<String> wholeUserId = userMapper.findWholeUserId();
			// 2) get last sync date from RI_SYNC_LOG
			String lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_USER);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
			// 3) find target data from PERSON_UID table of erp system
			List<UserVo> erpUserList = new ArrayList<UserVo>();
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
					afterData = userMapper.findByUserId(userId);
					insertCo++;
				}
				this.addChangeHistory(beforeData, afterData);
			}

			logVo.setTrgtCo(trgtCo);
			logVo.setInsertCo(insertCo);
			logVo.setUpdateCo(updateCo);
			logVo.setSyncEnd(new Date());
			logVo.setSyncRm("Success!");
			syncLogMapper.update(logVo);

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
				historyVo.setModUserAuthorCd("S");
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
		updateUser.setHomeTelno(erpUserData.getHomeTelno());
		updateUser.setFaxNo(erpUserData.getFaxNo());
		updateUser.setHomeZipCode(erpUserData.getHomeZipCode());
		updateUser.setHomeAddr1(erpUserData.getHomeAddr1());
		updateUser.setHomeAddr2(erpUserData.getHomeAddr2());
		updateUser.setModUserId("system");
		userMapper.update(updateUser);
		userMapper.updateBySelectOtherTable(erpUserData);
	}

}
