package kr.co.argonet.r2rims.scholar.lecture;

import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.RowBounds;
import org.junit.Test;
import org.mybatis.spring.SqlSessionTemplate;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.scholar.mapper.LectureMapper;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;

public class FindLectureTest extends AbstractApplicationContextTest {

	@Resource(name = "lectureMapper")
	private LectureMapper lectureMapper;
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	@Resource(name = "scholarSqlSession")
	private SqlSessionTemplate scholarSqlSession;

	@Test
	public void findLectureTest(){
		RimsSearchVo searchVo = new RimsSearchVo();
		searchVo.setSrchUserId("757");
		List<LectureVo> lectureList = lectureMapper.findBySearchVo(searchVo);
		if(lectureList != null && lectureList.size() > 0)
			System.out.println(lectureList.size());

	}

	@Test
	public void findLecturePaingTest(){
		RimsSearchVo searchVo = new RimsSearchVo();
		searchVo.setSrchUserId("757");

		Integer totalCount = lectureMapper.countBySearchVo(searchVo);
		System.out.println("totalCount >>>>>>>>>>>>>>>>> " + totalCount);

		searchVo.setCt(50);
		searchVo.setPs(50);

		//int ps = 0;
		//int count = 100; // 페이지당 ROW수
		//int p = Math.max(0, ps/count);
		//System.out.println("p >>>>>>>>>>>>>>>>>>>> " + p);

		RowBounds rowBounds = new RowBounds(searchVo.getPs(), searchVo.getCt());
		List<LectureVo> lectureList = scholarSqlSession.selectList("kr.co.argonet.r2rims.scholar.mapper.LectureMapper.findBySearchVo", searchVo, rowBounds);
		if(lectureList != null && lectureList.size() > 0)
		{
			System.out.println(lectureList.size());
			System.out.println(lectureList.get(0).getSbjectCode());
		}

		/*
		 * totalCount >>>>>>>>>>>>>>>>> 140874
		   p >>>>>>>>>>>>>>>>>>>> 0
		   100
			ME960
		 *
		 *
		 */

	}


}
