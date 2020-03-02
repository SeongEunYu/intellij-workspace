package kr.co.argonet.r2rims.erp.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.ErpMapperScan;
import kr.co.argonet.r2rims.core.vo.LicenseVo;

@ErpMapperScan
@Repository(value="erpLicenseMapper")
public interface ErpLicenseMapper {

	List<LicenseVo> findByModDate(@Param("lastHarvestDate")String lastHarvestDate);

	List<LicenseVo> findByUserId(@Param("userId")Date userId);

}
