<%@page import="kr.or.bit.utils.SingletonHelper"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
PreparedStatement (준비된 Statement )

(1) 설명 
미리 SQL문이 셋팅된 Statement가 DB가에 전송되어져서 컴파일되어지고, 
SQL문의 ?만 나중에 추가 셋팅해서 실행이 되어지는 준비된 Statement 

(2) 장점
<1> Statement 에 비해서 반복적인 SQL문을 사용할 경우에 더 빠르다. ( 특히, 검색문 )
<2> DB컬럼타입과 상관없이 ?하나로 표시하면 되므로 개발자가 헷갈리지 않고 쉽다. ( 특히, INSERT문 )
(이유: ?를 제외한 SQL문이 DB에서 미리 컴파일되어져서 대기)

(3) 단점
SQL문마다 PreparedStatement 객체를 각각 생성해야 하므로 재사용불가
(but, Statement 객체는 SQL문이 달라지더라도 한 개만 생성해서 재사용이 가능하다. )

(4) 특징
<1> Statement stmt = con.createStatement(); //생성 stmt.execute(sql);//실행
<2> PreparedStatement pstmt = con.prepareStatement(sql); //생성 pstmt.execute(); //실행

(5) 주의
DB 객체들(table, ..)의 뼈대( 테이블명 or 컬럼명 or 시퀀스명 등의 객체나 속성명)은 ?로 표시할 수 없다.
즉, data 자리에만 ?로 표시할 수 있다.
cf) 그래서, DDL문에서는 PreparedStatement를 사용하지 않는다.

4. CallableStatement ( 호출할 수 있는 Statement )

(1) 설명
DataBase 에 미리 컴파일되어 있는 Stored Procedure 를 호출하기 위한 Statement

(2) 생성 / 호출
String sql = "{call incre(?,?)}";
CallableStatement cstmt = con.prepareCall(sql);
(ex: day3/JDBC12.java )

5. 동적 커서 이동

(1) 설명
JDBC 2.0 부터는 ResultSet 의 커서가 원하는 위치대로 이동 가능 함
-> 이용하려면 stmt 생성시 아래의 방법으로 옵션을 줌

(2) 방법
-> con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
ResultSet.CONCUR_UPDATABLE);
/* Statement createStatement(int resultSetType,
int resultSetConcurrency)
throws SQLException

1.resultSetType

(1) ResultSet.TYPE_FORWARD_ONLY,
(2) ResultSet.TYPE_SCROLL_INSENSITIVE,
(3) ResultSet.TYPE_SCROLL_SENSITIVE

2.resultSetConcurrency

(1) ResultSet.CONCUR_READ_ONLY
(2) ResultSet.CONCUR_UPDATABLE */
(3) 주요 ResultSet 의 커서 이동 메소드

<1> rs.next(); //커서를 한칸씩 내림
<2> rs.previous(); //커서를 한칸씩 올림
<3> rs.beforeFirst(); //커서를 BOF에 위치
<4> rs.afterLast(); // 커서를 EOF에 위치

6. JAVA에서의 Transaction 처리
(1) 설명
트랜젝션이란 분리되어서는 안 될 (논리적)작업의 단위이다.
JDBC에서 Connection 객체는 autoCommit Flag가 true로 지정된다.
즉, 매번 갱신문이 수행될 때마다 자동으로 commit()메소드가 수행되는 것과 같은 효과가 나타난다.(SQL:Transaction=1:1)
그러나, autoCommit Flag가 false로 줌으로써 여러 SQL문을 하나의 작업단위(Transaction)로 묶을 수 있다.

(2) 방법
con.setAutoCommit(false);
con.commit(); 또는 con.rollback();
(ex: JDBC13.java )

-->
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		conn = SingletonHelper.getConnection("oracle");
		String sql = "select empno, ename from emp where deptno=?";
		
		//where empno=? and deptno=? and sal > ?
		//pstmo.setInt(1, 7788); > 첫번째 물음표의 값 7788
		//pstmo.setInt(2, 30); > 두번째 물음표의 값 30
		//pstmo.setInt(3, 1000); > 세번째 물음표의 값 1000
		
		//stmt = conn.createStatement();
		pstmt = conn.prepareStatement(sql); //명령객체 생성시 oracle 쿼리 미리 보내서 컴파일
		
		pstmt.setInt(1, 30); // ? > parameter 설정
		
		//rs = stmt.executeQuery(sql); 
		rs = pstmt.executeQuery(); // 여기서 실행시 oracle parameter값만
		
		if(rs.next()){
			do{
				System.out.println(rs.getInt("empno") + " / " + rs.getString("ename"));
			}while(rs.next());
		}else {
			System.out.println("조회된 데이터가 없습니다.");
		}
	} catch(Exception e) {
		
	} finally {
		SingletonHelper.close(pstmt);
		SingletonHelper.close(rs);
		//SingletonHelper.close(conn);
		//공유객체인 Singleton은 작업이 다 끝날때까지 닫으면 안대영 ...
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>