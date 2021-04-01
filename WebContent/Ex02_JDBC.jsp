<%@page import="java.util.Scanner"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 지금 작업은 servlet에서 작업... -->
    
<%
	//인터페이스 생성
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try{
		//2. 드라이버 로딩
		Class.forName("oracle.jdbc.OracleDriver");
		System.out.println("Oracle 로딩...");
		
		//3. 연결 객체 생성
		conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.54:1521:xe","bituser","1004");
		System.out.println("연결이 끊겼닝? : " + conn.isClosed());
		
		//4. 명령 객체 생성
		stmt = conn.createStatement();
		
		//4.1. parameter 설정(옵션)
		String job="";
		Scanner sc = new Scanner(System.in);
		System.out.print("직종 입력: ");
		job=sc.nextLine();
		
		//4.2. 명령구문 생성
		String sql = "select empno, ename, job from emp where job='" + job + "'";
		//where job = 'CLERK' 과 같이 만들기 위한 따옴표..
		
		//5. 명령 실행
		//DQL(select) > stmt.executeQuery(sql) > return ResultSet 타입의 객체 주소
		//DML(insert, delete, update) > 결과 집합(x) > return 반영된 행의 개수 > stmt.executeUpdate()
		//delete from emp; 실행 > return 14
		rs = stmt.executeQuery(sql);
		
		//6. 명령 처리
		//SELECT했을 때 나올 수 있는 경우
		// - 결과가 없는 경우
		// - 결과가 1건일 경우 (PK, Unique 컬럼 조회 등등 (ex. where empno=7788))
		// - 결과가 여러건일 경우 (row (ex. select empno, ename from emp where deptno=20)) 
		
		//(1) 간단하고 단순한 방법
		//		-단점: 결과 집합이 없는 경우 로직 처리가 안된다.
		/*
		while(rs.next()){ // 너 데이터(결과 집합, row) 있닝? (만약 없으면 아예 출력하지 않음ㅠㅠ)
			//rs.getInt("empno") 출력
		}
		*/
		
		//(2) 결과가 있는 경우와 없는 경우 처리
		//		-단점: 1건이 있는 경우는 가능하나, 여러건의 row read가 안된다.
		/* 
			if(rs.next()) {
				
			}else {
				//조회된 데이터가 없습니다.
			}
		*/
			
		//(3) 1,2번 방법 합치기!
		// : 데이터가 1건인 경우, multi row인 경우, 결과가 없는 경우 모두 처리 가능
		if(rs.next()){
			
			do{
				System.out.println("empno: "+rs.getInt("empno") + "/ ename: "+ rs.getString("ename") + "/ job: "+ rs.getString("job"));
			}while(rs.next());
			
		}else {
			System.out.println("조회된 데이터가 없습니다");
		}
		
		
		/* 연결> 명령> 명령구문 생성> 명령 실행> 결과 처리 */
	}catch(Exception e){
		System.out.println(e.getMessage());
	}finally {
		// 자원 해제 작업 넣기
		try{
			stmt.close();
			rs.close();
			conn.close();
		}catch(Exception e){
			
		}
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