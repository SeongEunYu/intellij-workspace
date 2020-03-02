package kr.co.argonet.r2rims.erp.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.ErpMapperScan;
import kr.co.argonet.r2rims.core.vo.DegreeVo;

@ErpMapperScan
@Repository(value="erpDegreeMapper")
public interface ErpDegreeMapper {

	List<DegreeVo> findByModDate(@Param("lastHarvestDate")String lastHarvestDate);

	List<DegreeVo> findByUserId(@Param("userId")Date userId);

}
