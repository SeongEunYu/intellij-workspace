package kr.co.argonet.r2rims.erp.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.ErpMapperScan;
import kr.co.argonet.r2rims.core.vo.AwardVo;

@ErpMapperScan
@Repository(value="erpAwardMapper")
public interface ErpAwardMapper {

	List<AwardVo> findByModDate(@Param("lastHarvestDate")String lastHarvestDate);

	List<AwardVo> findByUserId(@Param("userId")Date userId);

}
