package kr.co.argonet.r2rims.scholar.mapper;

import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;

@Repository(value="lectureMapper")
public interface LectureMapper {

	Integer countBySearchVo(RimsSearchVo searchVo);

	List<LectureVo> findBySearchVo(RimsSearchVo searchVo);

}
