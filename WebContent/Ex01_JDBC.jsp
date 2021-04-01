<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <!--

JDBC

1. Java 를 통해서 Oracle 연결 하고 CRUD 작업

2. 어떤한 DB 소프트웨어 사용 결정 (Oracle , mysql , ms-sql) 
2.1 제품에 맞는 드라이버필요 (각 벤더 사이트에서 다운로드 받아서 사용)
2.2 오라클 (로컬 PC 오라클 DB 서버 설치) >> ojdbc6.jar (드라이버 파일)

C:\oraclexe\app\oracle\product\11.2.0\server\jdbc\lib
드라이버: ojdbc6.jar

만약, MYSQL을 사용중이라면 >> https://www.mysql.com/products/connector

3. Cmd 기반의 Java Project 에서는 드라이버 사용하기 위해서 참조 
3.1 java Build Path (jar 추가) 하는 작업
3.2 드라이버 사용준비 완료 >> 드라이버 사용할 수 있도록 메모리 (new ..)
3.3 class.forName("class 이름") >> new 동일한 효과 

(WEB)
1. Webproject >> WebContent > WEB-INF lib >> jar파일 붙여넣기!
2. 드라이버 로딩: class.forName("드라이버 클래스명"): 자동화되었다
3. DB연결 (연결 문자열: 서버 IP, PORT, 계정, 비번)

4.JAVA ( JDBC API)
4.1 import java.sql.*; 제공하는 자원 (대부분의 자원은 : interface , class)
4.2 개발자는 interface 를 통해서 작업 
  > why interface 일까? hint)java 뿐만 아니라 다양한 언어 사용
  > 사용하는 DB가 변경되어도 코드의 변화가 없도록 하기 위해서!!
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

5. DB연결 -> 명령 -> 실행 -> 처리 -> 자원해제
5.1 명령 (CRUD) : insert, select , update , delete
5.2 처리 : select 화면 출력할꺼야 아니야 난 확인만 .. : DML(insert, update, delete) -> 성공 실패 여부 확인!
5.3 자원해제 (성능)

*연결 문자열 (ConnectionString) 설정
채팅 (client -> server 연결하기 위해서)
네트워크 DB (서버 IP , PORT , SID(전역 데이터베이스 이름) , 접속계정 , 접속 비번) 
 
 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<table border="1">
	<tr>
		<th>부서번호</th><th>부서명</th><th>부서위치</th>
	</tr>



<%
	//Class.forName("oracle.jdbc.OracleDriver");
	Connection conn = null;
	
	conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.54:1521:xe","bituser","1004");
	//접속 성공시 new 연결 객체가 객체의 주소를 conn에 리턴할 것
	//out.print(conn.isClosed()); //연결 여부 확인 : false가 나와야댄다
	
	//getConnection을 통해서 생성되는 연결객체는 무엇을 구현하고 있을까 ?
	//(HINT: JDBC API는 대부분 다형성!)
	//Myconn implements Connection
	//Oracleconn implements Connection
	
	//아래와 같이 쓰면 확장성 힘들어용...
	//CoracleConnection conn = null;
	//conn = DriverManager.getConnection
			
	out.print("연결이 끊겼니? : "+conn.isClosed()); // false가 정상 연결된 상태!
	//conn.close(); // 연결 해제
	//out.print(conn.isClosed()); // 닫았으니까 true가 나올것!
	
	//명령(CRUD)
	Statement stmt = conn.createStatement(); // 명령 객체 얻어오기
	
	//명령
	String sql = "select deptno, dname, loc from dept";
	
	//실행
	ResultSet rs = stmt.executeQuery(sql); //DB 서버에서 실행되고, 결과를 반환받을 때 사용하는 함수 (파라미터에 sql문)
	//ResultSet : 연결된 DB 서버의 데이터를 조회할 수 있다.
	
	//처리(화면 출력)
	while(rs.next()){ //생성된 row가 있니? (데이터가 있니)
		//System.out.println("deptno: "+rs.getInt("deptno") + "/ dname: "+ rs.getString("dname") + "/ loc: "+ rs.getString("loc"));
	%>
		<tr>
			<td><%= rs.getInt("deptno") %></td>
			<td><%= rs.getString("dname") %></td>
			<td><%= rs.getString("loc") %></td>
		</tr>
	<%
	}
	
	stmt.close(); //명령객체 닫기
	rs.close(); //데이터 집합 객체 닫기
	conn.close(); //연결 해제
	
	out.print(" / DB 연결 해제: " + conn.isClosed()); // 닫았으니까 true가 나올것!
	
%>

</table>
</body>
</html>













