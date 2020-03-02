package kr.co.argonet.r2rims.erp.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.ErpMapperScan;
import kr.co.argonet.r2rims.core.vo.ActivityVo;

@ErpMapperScan
@Repository(value="erpActivityMapper")
public interface ErpActivityMapper {

	List<ActivityVo> findByModDate(@Param("lastHarvestDate")String lastHarvestDate);


}
