package kr.or.bit.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SingletonHelper {

/*
  	public static Connection getConnection(String dsn) { 
		// Oracle이던, MySQL이던 다 사용 가능했으면 좋게따
		Connection conn = null;
 
	 if(dsn.equals("oracle")) {
			Class.forName("oracle.jdbc.OracleDriver");
			conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.54:1521:xe","bituser","1004");
		}else if(dsn.equals("mysql")) {
			Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://192.168.0.54:3306/sampledb?characterEncoding=UTF-8&serverTimezone=UTC&useSSL=true","bituser","1004");
		} 
*/
	//목적: 항상 같은 연결(주소)을 return하는 것
	private static Connection conn = null;
	
	private SingletonHelper() {};
	
	public static Connection getConnection(String dsn) {
		if(conn != null) {
			return conn;
		}
		
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
	
	public static void close(Connection conn) {
		if(conn != null) {
			try {
				conn.close();
			}catch (Exception e) {
				
			}
		}
	}
	
	public static void close(Statement stmt) {
		if(stmt != null) {
			try {
				stmt.close();
			}catch (Exception e) {
				
			}
		}
	}
	
	public static void close(PreparedStatement pstmt) {
		if(pstmt != null) {
			try {
				pstmt.close();
			}catch (Exception e) {
				
			}
		}
	}
	
	public static void close(ResultSet rs) {
		if(rs != null) {
			try {
				rs.close();
			}catch (Exception e) {
				
			}
		}
	}
	
}
