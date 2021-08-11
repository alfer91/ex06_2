package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
	
		this.total = total;
		this.cri = cri;
		
		// 화면 상에서 보이는 시작, 마지막 페이지 번호
		this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;   // 10: 화면 상에 보이는 페이지 번호 갯수
		this.startPage = this.endPage - 9;
		
		// 전체 데이터를 기반으로 본 전체 페이지 갯수
		int realEnd = (int) (Math.ceil(total * 1.0) / cri.getAmount());
		
		if(realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		
		// 이전, 다음 페이지 생성 유, 무
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
	
	
}
