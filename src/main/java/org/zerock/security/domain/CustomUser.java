package org.zerock.security.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.zerock.domain.MemberVO;

import lombok.Getter;

@Getter
public class CustomUser extends User {  // MemberVO를 UserDetails 타입으로 변환, org.springframework.security.core.userdetails.User 상속 받음

	private static final long serialVersionUID = 1L;
	
	private MemberVO member;  // 멤버변수로 MemberVO 를 가짐

	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	public CustomUser(MemberVO vo) {  // MemberVO 를 파라미터로 전달해서 User 클래스에 맞게 생성자 호출
		super(vo.getUserid(), vo.getUserpw(), vo.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));
		// AuthVO 인스턴스는 GrantedAuthority 객체로 변환해야 함
		
		this.member = vo;
	}
}
