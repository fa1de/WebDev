package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private Statement stmt;
	
	// DB연결
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID ="root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 로그인 기능 구현 함수
//	public int login(String userID, String userPassword) {
//		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
//		try {
//			pstmt = conn.prepareStatement(SQL);
//			pstmt.setString(1, userID);
//			rs = pstmt.executeQuery();
//			if (rs.next()) {
//				if(rs.getString(1).equals(userPassword)) {
//					return 1; // 로그인 성공
//				}
//				else
//					return 0; // 비밀번호 불일치
//			}
//			return -1; // 아이디가 없음
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return -2; // 데이터베이스 오류
//	}
	
	// DB에서 userID를 가져오는 함수
	public String getUserIDFromDB(String userID) {
	    String SQL = "SELECT userID FROM USER WHERE userID = '" + userID + "'";
	    try {
	        stmt = conn.createStatement();
	        rs = stmt.executeQuery(SQL);
	        if (rs.next()) {
	            return rs.getString("userID");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null; // 존재하지 않는 경우
	}
	
	// 로그인 기능 구현 함수 (SQL 인젝션 취약)
	public int login(String userID, String userPassword) {
		String SQL = "SELECT * FROM USER WHERE userID = '" + userID + "' and userPassword = '" + userPassword + "'";
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(SQL);
//			System.out.println(SQL);
			if (rs.next()) {
				return 1; // 로그인 성공
			}
			return 0; // 아이디 혹은 비밀번호 불일치
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}	
	
	// 회원가입 기능 구현 함수
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
				try {
					pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, user.getUserID());
					pstmt.setString(2, user.getUserPassword());
					pstmt.setString(3, user.getUserName());
					pstmt.setString(4, user.getUserGender());
					pstmt.setString(5, user.getUserEmail());
					return pstmt.executeUpdate();
				}catch(Exception e) {
					e.printStackTrace();
				}
				return -1; // 데이터베이스 오류
	}
	
	// 회원의 이름을 가져오는 기능
		public String getUserNameByUserID(String userID) {
		    String SQL = "SELECT userName FROM USER WHERE userID = ?";
		    try {
		        PreparedStatement pstmt = conn.prepareStatement(SQL);
		        pstmt.setString(1, userID);
		        rs = pstmt.executeQuery();
		        if (rs.next()) {
		            return rs.getString("userName"); // userName을 반환
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return null; // userName이 없을 때
		}
		
		// ID에 있는 데이터 가져오기
		public User getUserByUserID(String userID) {
		    String SQL = "SELECT * FROM USER WHERE userID = '" + userID + "'"; // userID를 SQL 쿼리문에 직접 삽입
		    try {
		        stmt = conn.createStatement();
		        rs = stmt.executeQuery(SQL);
		        if (rs.next()) {
		            User user = new User();
		            user.setUserID(rs.getString("userID"));
		            user.setUserName(rs.getString("userName"));
		            user.setUserPassword(rs.getString("userPassword"));
		            user.setUserGender(rs.getString("userGender"));
		            user.setUserEmail(rs.getString("userEmail"));
		            return user;
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return null; // userID가 없을 때
		}
		
		// 회원정보 수정하는 함수
		public int modify(String userID, String userName, String userPassword, String userGender, String userEmail) {
			String SQL = "UPDATE USER SET userName = '" + userName + "', userPassword = '" + userPassword + "', userGender = '" + userGender + "', userEmail = '" + userEmail + "' WHERE userID = '" + userID + "'";
//			System.out.println(SQL);
			try {
				Statement stmt = conn.createStatement();
				return stmt.executeUpdate(SQL);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; 
		}
		
		// 회원 탈퇴
		public int delete(String userID) {
			String SQL = "DELETE FROM USER WHERE USERID = '" + userID + "'";
			System.out.println(SQL);
			try {
				Statement stmt = conn.createStatement();
				int result = stmt.executeUpdate(SQL);
			    return result;  // 삭제된 행 개수 반환 (1 이상이면 성공)
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1;  // 오류 발생 시 -1 반환
		}
}
