package kr.co.argonet.r2rims;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={
		"classpath:config/context-test-common.xml",
		"classpath:config/context-test-datasource.xml",
		"classpath:config/context-test-mapper.xml",
		"classpath:config/mybatis-test-config-base.xml"
		})
public class AbstractApplicationContextTest {
	@Autowired ApplicationContext ctx;
}
