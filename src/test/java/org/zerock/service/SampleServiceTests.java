package org.zerock.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class SampleServiceTests {

	@Autowired
	private SampleService service;
	
	@Test
	public void testClass() {
		
		log.info(service);   // org.zerock.service.SampleServiceImpl@573906eb
		log.info(service.getClass().getName());   // com.sun.proxy.$Proxy20   - AOP target에 대한 Proxy 객체 생성
	}
	
	@Test
	public void testAdd() throws Exception {
		
		log.info(service.doAdd("123", "456"));
	}
}
