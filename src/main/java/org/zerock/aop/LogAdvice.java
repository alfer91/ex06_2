package org.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect   // 해당 클래스가 관심사(Aspect)를 구현한 Advice 임을 나타냄
@Log4j
@Component   // Bean 등록을 위해 사용
public class LogAdvice {
	
	@Before("execution(* org.zerock.service.SampleService*.*(..))")  /* AspectJ의 표현식 : 접근제한자 클래스.메서드 */
	public void logBefore() {
		
		log.info("======================");
	}
	
	/* 어떤 위치에 Advice를 적용할 것인지를 결정하는 Pointcut */
	@Before("execution(* org.zerock.service.SampleService*.doAdd(String, String)) && args(str1, str2)")   //메서드와 파라미터 타입 지정, 변수명 지정
	public void logBeforeWithParam(String str1, String str2) {  // Pointcut에 지정된 변수를 파라미터로 얻음
		log.info("str1: " + str1);
		log.info("str2: " + str2);
	}
	
	/* Target이 예외를 발생한 후 동작 */
	@AfterThrowing(pointcut = "execution(* org.zerock.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		
		log.info("exception....!!!!");
		log.info("exception: " + exception);
	}
	
	/* Arround는 직접 메서드를 실행할 수 있는 권한이 있어 실행 전, 후 처리 가능 (ProceedingJoinPoint로 구체적 처리 가능) */
	@Around("execution(* org.zerock.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		
		long start = System.currentTimeMillis();
		
		log.info("Target: " + pjp.getTarget());
		log.info("Param: " + Arrays.toString(pjp.getArgs()));
		
		log.info(pjp.getSignature().getDeclaringTypeName() + "-" + pjp.getSignature().getName() + Arrays.toString(pjp.getArgs()));
		
		//invoke method
		Object result = null;
		
		try {
			result = pjp.proceed();   // 메서드 실행
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("TIME: " + (end - start));   // 메서드 실행 시간
		
		return result;   // @Around가 적용 되는 메서드는 리턴타입이 메서드 실행 결과를 반환하는 형태여야 함 (void 안됨)
	}
}
