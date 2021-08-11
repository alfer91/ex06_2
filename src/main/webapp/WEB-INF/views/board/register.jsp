<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%@include file="../includes/header.jsp" %>

			<div class="row">
				<div class="col-lg-12">
					<h1 class="page-header">Tables</h1>
				</div>
				<!-- /.col-lg-12 -->
			</div>
			<!-- /.row -->
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">Board Register</div>
						<!-- /.panel-heading -->
						<div class="panel-body">
							<form action="/board/register" method="post">
							<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">  <!-- CSRF 토큰 설정 -->
								<div class="form-group">
									<label>Title</label> <input class="form-control" name="title">
								</div>

								<div class="form-group">
									<label>Text-area</label> <textarea class="form-control" rows="3" name="content"></textarea>
								</div>

								<div class="form-group">
									<label>Writer</label> <input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly>
									<!-- 게시물 작성 시 로그인한 사용자의 아이디 출력, 스프링 시큐리티에서는 username 이 사용자의 아이디 -->
								</div>
								
								<button type="submit" class="btn btn-btn-default">Submit Button</button>
								<button type="reset" class="btn btn-btn-default">Reset Button</button>
							</form>
						</div>
						<!-- /.panel-body -->
					</div>
					<!-- /.panel -->
				</div>
				<!-- /.col-lg-12 -->
			</div>
			<!-- /.row -->
			
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<div class="panel-heading">File Attach</div>
						<!-- end panel-heading -->
						<div class="panel-body">
							<div class="form-group uploadDiv">
								<input type="file" name="uploadFile" multiple>
							</div>
							
							<div class="uploadResult">
								<ul>
								</ul>
							</div>
						</div>
						<!-- end panel-body -->
					</div>
					<!-- end panel -->
				</div>
				<!-- end col-lg-12 -->
			</div>
			<!-- end row -->
			
	<script>
		$(document).ready(function() {
			
			var formObj = $("form");
			
			$("button[type='submit']").on("click", function(e) {
				
				e.preventDefault();
				
				console.log("submit clicked");
				
				var str = "";
				
				$(".uploadResult ul li").each(function(i, obj) {
					
					var jobj = $(obj);
					
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				}) 
				
				formObj.append(str).submit();
			})
			
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 10485760;
			
			function checkExtension(fileName, fileSize) {
				
				if(fileSize >= maxSize) {
					alert("파일 사이즈 초과");
					return false;
				}
				
				if(regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				
				return true;
			}
			
			$("input[type='file']").change(function(e) {
				
				var formData = new FormData();
				
				var inputFile = $("input[name='uploadFile']");
				
				var files = inputFile[0].files;
				
				for(var i = 0; i < files.length; i++) {
					
					if(!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					url: '/uploadAjaxAction',
					processData: false,
					contentType: false,
					data: formData,
					type: 'POST',
					dataType: 'json',
					success: function(result) {
						console.log(result);
						showUploadResult(result); // 업로드 결과 처리 함수
					}
				})
			})
			
			function showUploadResult(uploadResultArr) {
                
                if(!uploadResultArr || uploadResultArr.length == 0) {
                    return;
                }
                
                var uploadUL = $(".uploadResult ul");
                
                var str = "";
                
                $(uploadResultArr).each(function(i, obj) {
                    
                    // image type
                    if(obj.image) {
                
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName); 
                        
                        str += "<li data-path='" + obj.uploadPath +"' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
                        str += "<span> " + obj.fileName + "</span>";
                        str += "<button type='button' data-file=\'" + fileCallPath +"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src='/display?fileName=" + fileCallPath +"'>";
                        str += "</div></li>";
                    } else {
                        //str += "<li>" + obj.fileName + "</li>";
                        
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);  
                        var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
                        
                        str += "<li data-path='" + obj.uploadPath +"' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
                        str += "<span> " + obj.fileName + "</span>";
                        str += "<button type='button' data-file=\'" + fileCallPath +"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<a><img src='/resources/img/attach-icon-png-18.jpg' style='width:70px; height:70px;'></a>";
                        str += "</div></li>"
                    }
                })
                
                uploadUL.append(str);
            }
			
			$(".uploadResult").on("click", "button", function(e) {
				
				console.log("delete file");
				
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				
				var targetLi = $(this).closest("li");
				
				$.ajax({
					url: '/deleteFile',
					data: {fileName: targetFile, type: type},
					dataType: 'text',
					type: 'POST',
					success: function(result){
						alert(result);
						targetLi.remove();
					}
				})
			})
		})
	</script>
<%@include file="../includes/footer.jsp" %>
