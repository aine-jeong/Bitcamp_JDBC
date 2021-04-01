package kr.or.bit.utils;

import java.sql.Connection;
import java.sql.DriverManager;

/*
 전체 프로젝트(회원 전체조회 조건조회, 삽입, 삭제, 수정 ...)
 각각의 작업을 하기 위한 공통적인 작업요소
 1. 드라이버 로딩
 2. 연결 객체 생성
 3. 명령 객체 생성
 4. 자원 해제
	...

=====
개선 (리팩토링: 반복적인 코드 제거)
모든 페이지가 가지고 있는 공통적인 요소를 한곳에 모으자!

즉, 공통적인 내용을 가지는 클래스 설계
> 이 클래스를 좀 더 편하게 사용하려면, 객체지향 기법 중 무엇을 사용할 수 있을까?
  자주 사용하는 함수 > static > overloading > 다형성 등등
 
 
 
 */

public class ConnectionHelper {
	public static Connection getConnection(String dsn) { 
		// Oracle이던, MySQL이던 다 사용 가능했으면 좋게따
		Connection conn = null;
		try {
			if(dsn.equals("oracle")) {
				Class.forName("oracle.jdbc.OracleDriver");
				conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.54:1521:xe","bituser","1004");
			}else if(dsn.equals("mysql")) {
				Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://192.168.0.54:3306/sampledb?characterEncoding=UTF-8&serverTimezone=UTC&useSSL=true","bituser","1004");
			}
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}
		
		return conn;
	}


public static Connection getConnection(String dsn, String id, String pwd) { // oracle, mysql..
    Connection conn = null;
    try {
       if(dsn.equals("oracle")) {
          // oracle
          Class.forName("oracle.jdbc.OracleDriver");
          conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe",id,pwd);
          
       }else if(dsn.equals("mysql")) {
          //mysql
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection("jdbc:mysql://192.168.0.57:3306/sampledb?characterEncoding=UTF-8&serverTimezone=UTC&useSSL=true",id,pwd);
       }
    } catch (Exception e) {
       System.out.println(e.getMessage());
    }
    
    return conn;
 }

}