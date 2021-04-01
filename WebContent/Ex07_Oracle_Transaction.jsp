<%@page import="kr.or.bit.utils.SingletonHelper"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
/*
create table trans_A(
  num number,
  name varchar2(20)
);

create table trans_B(
   num number constraint pk_trans_B_num primary key,
   name varchar2(20)
);

JDBC >> default(dml) >> autocommit

trans_A , trans_B 하나의 논리적인 단위 (transaction 처리)

JDBC >> autocommit >> false >> 개발자는 반드시 >> commit , rollback
*/
 -->
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	
	conn = SingletonHelper.getConnection("oracle");
	
	String sql = "insert into trans_A(num,name) values(100,'A')";
	String sql2= "insert into trans_B(num,name) values(100,'B')";
	
	try{
		conn.setAutoCommit(false); // autocommit을 false처리하면 개발자가 명시적으로 commit과 rollback을 강제해야한다.
		//begin
			pstmt = conn.prepareStatement(sql);
			pstmt.executeQuery();
			
			pstmt2 = conn.prepareStatement(sql2);
			pstmt2.executeQuery();
		//end
			//개발자
			conn.commit(); // 실반영
		
	}catch(Exception e){
		// 둘중에 하나라도 실패했을 때 rollback시켜야 하니까 catch(예외)블럭에서 처리해야한다!!!
		conn.rollback(); // 롤백시 두개의 쿼리가 취소된다.
		System.out.println(e.getMessage());
		
		// 두번 실행시?
		// ORA-00001: unique constraint (BITUSER.PK_TRANS_B_NUM) violated
		// A, B 테이블 둘 다 데이터가 들어가지 않았을 것~~~~
		
	}finally {
		SingletonHelper.close(pstmt);
		SingletonHelper.close(pstmt2);
	}
%>
</body>
</html>