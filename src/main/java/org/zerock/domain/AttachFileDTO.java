package org.zerock.domain;

import lombok.Data;

@Data
public class AttachFileDTO { /* 첨부파일의 정보 */
	
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean image; /* 이미지파일 여부 */
}
