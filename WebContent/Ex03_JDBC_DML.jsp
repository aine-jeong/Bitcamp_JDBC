<%@page import="java.util.Scanner"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
/* 
	DML(insert, update, delete)
	JDBC API를 통해서 작업
	1. 결과 집합이 없다
	2. 반영 결과: 반영된 행의 수 return
			
	update emp set sal=0 실행 > return 14
	update emp set sal=100 where empno=1111 >> return 0
	
	JAVA코드에서 조건처리를 통해서 '성공/실패'여부 판단하기
	
	KEY POINT
	1. Oracle DML (developer, cmd, Tool)하면, 기본 옵션이 commit / rollback 강제
	2. JDBC API 사용해서 작업 > DML > default: autocommit
	3. 만약, java코드에서 [delete from emp]를 실행하면 의사와 상관없이 실반영이 일어난다. (자동 commit)
	4. 필요에 따라 commit, rollback을 java코드에서 제어 가능하다
	
	  -시작
		A계좌 인출(update)
		...
		B계좌 입금(update)
	  -종료
	  >> 시작~종료 까지를 하나의 논리적인 단위로 묶는다 (Transaction) : all 성공 또는 all 실패!
	  autocommit 옵션을 false로 바꿀 수 있다 > java코드에서 명시적으로 commit, rollback을 구현해야 한다.
	 
	  =======실습을 위한 테이블 생성 (Oracle)========
	  create table dmlemp
	  as
	  select * from emp;

	  select * from dmlemp;

	  alter table emp
	  add constraint pk_dmlemp_empno primary key(empno);
	  ==========================================
			  
*/
	
	Connection conn = null;
	Statement stmt = null;
	// DML 에서는 ResulSet 필요없음
	
	try{
		conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.54:1521:xe","bituser","1004");
		if(!conn.isClosed()) {
			System.out.println("연결되었습니다.");
		} else {
			System.out.println("연결이 정상적으로 되지 않았습니다.");
		}
		
		stmt = conn.createStatement();
		
		/*
		//INSERT
		int empno=0;
		String ename="";
		int deptno=0;
		
		Scanner sc = new Scanner(System.in);
		System.out.println("사번 입력");
		empno = Integer.parseInt(sc.nextLine());
		
		System.out.println("이름 입력");
		ename = sc.nextLine();
		
		System.out.println("부서명 입력");
		deptno = Integer.parseInt(sc.nextLine());
		
		//insert into emp(empno,ename,deptno) values(2000,'홍길동',30)
		//>> 옛날방식 .... (요즘은 parameter 설정 : values(?,?,?))
		String sql="insert into dmlemp(empno,ename,deptno)";
		sql += "values(" + empno + ",'" + ename + "'," + deptno +")";
		
		int resultrow = stmt.executeUpdate(sql);
		*/
		
		/*
		//UPDATE
		int deptno = 50;
		String sql = "update dmlemp set sal=0 where deptno=" + deptno;
		
		int resultrow = stmt.executeUpdate(sql);
		*/
		
		//DELETE
		int deptno = 20;
		String sql = "delete from dmlemp where deptno=" + deptno;
		
		int resultrow = stmt.executeUpdate(sql);
		
		if(resultrow > 0) {
			System.out.println("반영된 행의 수: " + resultrow);
		}else {
			//POINT
			//else로 온 것 :
			//문제가 생긴 것이 아니고(=예외가 발생된 것이 아니라)
			//반영된 행이 없다는 뜻!
			//실패가 아님!!!! (방어적인 코드는 아래의 catch블럭에 넣는당)
			System.out.println("반영된 행이 없습니다.");
		}
		
		//else문이 예외처리가 아니다 !!
		//에러상황 만들기
		//현재 empno에 pk제약이 걸려있는데, 같은 사번으로 데이터를 추가하려고 시도했을 때!
		//ORA-00001: unique constraint (BITUSER.PK_DMLEMP_EMPNO) violated
		//에러가 나면 else를 타는게 아니라 catch를 탄다 -> 문제가 되는 코드는 catch블럭에서 예외를 처리해야 한다는 이야기~~~~~
		
	}catch(Exception e){
		System.out.println(e.getMessage());
		//#####################################
		//### 예외발생에 대한 코드처리는 여기서~~~~ ###
		//#####################################
	}finally {
		if(stmt != null)try {stmt.close(); System.out.println("연결종료되었습니다.");}catch (Exception e) {}
	    if(conn != null)try {conn.close();}catch (Exception e) {}
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