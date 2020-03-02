package kr.co.argonet.r2rims.erp.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.ErpMapperScan;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;

@ErpMapperScan
@Repository(value="erpUserMapper")
public interface ErpUserMapper {

	List<UserVo> findUserByGubunAndModDate(@Param("lastHarvestDate")String lastHarvestDate, @Param("gubun")String gubun);

	Integer countByKeyword(@Param("keyword")String keyword);

	Integer countByKeyword(RimsSearchVo searchVo);

	List<UserVo> findUserListByKeyword(@Param("keyword")String keyword);

	List<UserVo> findRetireUser(@Param("lastHarvestDate")String lastHarvestDate, @Param("gubun")String gubun);

	List<UserVo> findUserListByKeyword(RimsSearchVo searchVo);

	UserVo findByUserId(@Param("userId")String userId);


}
