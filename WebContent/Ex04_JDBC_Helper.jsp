<%@page import="kr.or.bit.utils.SingletonHelper"%>
<%@page import="kr.or.bit.utils.ConnectionHelper"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Connection conn = null;
	conn = ConnectionHelper.getConnection("oracle");
	System.out.println(conn);
	conn.close();
    
    conn = ConnectionHelper.getConnection("oracle","hr","1004");
    
 	// 만약, 5개의 페이지에 위의 코드가 똑같이 있고, 각각 DB에연결한다면
 	// ConnectionHelper.getConnection("oracle");
 	// 새로운 객체가 5번 만들어지는 것이다.
 	// 그럴 필요가 없당
 	// 하나의 연결 객체를 만들어서 사용하면 되지 않을까? (공유) 
 			// -> Singleton 패턴 (학습용으로 좋다 but, 현업에서는 DB작업에 Singleton 사용하지 x -> POOL 사용한다)

 	
 	Connection conn2 = null;
 	conn2 = SingletonHelper.getConnection("oracle");
 	
 	Connection conn3 = null;
 	conn3 = SingletonHelper.getConnection("oracle");
 	
 	System.out.println(conn2==conn3);
 	System.out.println(conn2);
 	System.out.println(conn3);
 	
 	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	연결이 끊겼나용? : <%= conn.isClosed() %> <br>
   	재정의 : <%= conn.toString() %><br>
   	ProductName : <%= conn.getMetaData().getDatabaseProductName() %><br>
   	ProductVersion : <%= conn.getMetaData().getDatabaseProductVersion() %><br>
	
</body>
</html>