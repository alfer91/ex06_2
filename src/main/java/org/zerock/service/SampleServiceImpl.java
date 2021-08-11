package org.zerock.service;

import org.springframework.stereotype.Service;

@Service
public class SampleServiceImpl implements SampleService {

	@Override
	public Integer doAdd(String str1, String str2) throws Exception {   // AOP target 메서드에 마크 생성됨

		return Integer.parseInt(str1)+ Integer.parseInt(str2);
	}
}
