		package bbs;
		
		import java.sql.Connection;
		import java.sql.DriverManager;
	//	import java.sql.PreparedStatement;
		import java.sql.ResultSet;
		import java.util.ArrayList;
		import user.User;
		import user.UserDAO;
		import java.sql.Statement;
		
		public class BbsDAO {
			private Connection conn;
			private ResultSet rs;
			private Statement stmt;
			
			// DB 연결
			public BbsDAO() {
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
		
//		// 현재 시간을 가져오는 함수
//		public String getDate() {
//			String SQL = "SELECT NOW()";
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				rs = pstmt.executeQuery();
//				if (rs.next()) {
//					return rs.getString(1);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return ""; // 데이터베이스 오류
//		}
		
		// 현재 시간을 가져오는 함수 (SQL 인젝션 취약)
	    public String getDate() {
	        String SQL = "SELECT NOW()";
	        try {
	            Statement stmt = conn.createStatement();
	            rs = stmt.executeQuery(SQL);
	            if (rs.next()) {
	                return rs.getString(1);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return ""; // 데이터베이스 오류
	    }
		
//		// 작성된 글 번호를 가져오는 함수
//		public int getNext() {
//			String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
//			try {
//				Statement stmt = conn.prepareStatement(SQL);
//				rs = pstmt.executeQuery();
//				if (rs.next()) {
//					return rs.getInt(1) +1;
//				}
//				return 1; // 첫 번째 게시물인 경우
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return -1; // 데이터베이스 오류
//		}
		
		// 작성된 글 번호를 가져오는 함수 (SQL 인젝션 취약)
	    public int getNext() {
	        String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
	        try {
	            Statement stmt = conn.createStatement();
	            rs = stmt.executeQuery(SQL);
	            if (rs.next()) {
	                return rs.getInt(1) + 1;
	            }
	            return 1; // 첫 번째 게시물인 경우
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return -1; // 데이터베이스 오류
	    }
		
//		// 게시판에 글쓰기 기능 구현 함수
//		public int write(String bbsTitle, String userID, String bbsContent) {
//			String SQL ="INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				pstmt.setInt(1, getNext());
//				pstmt.setString(2, bbsTitle);
//				pstmt.setString(3, userID);
//				pstmt.setString(4, getDate());
//				pstmt.setString(5, bbsContent);
//				pstmt.setInt(6, 1);
//				return pstmt.executeUpdate();
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return -1; // 데이터베이스 오류
//		}
		
		// 게시판에 글쓰기 기능 구현 함수 (SQL 인젝션 취약)
	    public int write(String bbsTitle, String userID, String bbsContent, String fileName, String fileRealName) {
	        String SQL = "INSERT INTO BBS VALUES (" + getNext() + ", '" + bbsTitle + "', '" + userID + "', '" + getDate() + "', '" + bbsContent + "', 1, '" + fileName + "', '" + fileRealName + "')";
	        try {
	            Statement stmt = conn.createStatement();
	            return stmt.executeUpdate(SQL);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return -1; // 데이터베이스 오류
	    }

		
//		// 게시판페이지에 글 목록 나타내는 함수
//		public ArrayList<Bbs> getList(int pageNumber) {
//			String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
//			ArrayList<Bbs> list = new ArrayList<Bbs>();
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				pstmt.setInt(1, getNext() - (pageNumber -1 ) * 10);
//				rs = pstmt.executeQuery();
//				while (rs.next()) {
//					Bbs bbs = new Bbs();
//					bbs.setBbsID(rs.getInt(1));
//					bbs.setBbsTitle(rs.getString(2));
//					String userID = rs.getString(3);
//					bbs.setUserID(userID);
//					if (userID != null && !userID.isEmpty()) {
//		                UserDAO userDAO = new UserDAO();
//		                String userName = userDAO.getUserNameByUserID(userID); // userName을 가져오는 메서드 호출
//		                bbs.setUserName(userName != null ? userName : "알 수 없음"); // userName이 null이면 "알 수 없음" 표시
//		            } else {
//		                bbs.setUserName("알 수 없음"); // userID가 없는 경우 처리
//		            }
//
//					bbs.setBbsDate(rs.getString(4));
//					bbs.setBbsContent(rs.getString(5));
//					bbs.setBbsAvailable(rs.getInt(6));
//					list.add(bbs);
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return list;
//		}
		
		// 게시판페이지에 글 목록 나타내는 함수 (SQL 인젝션 취약)
	    public ArrayList<Bbs> getList(int pageNumber) {
	        String SQL = "SELECT * FROM BBS WHERE bbsID < " + (getNext() - (pageNumber - 1) * 10) + " AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
	        ArrayList<Bbs> list = new ArrayList<Bbs>();
	        try {
	            Statement stmt = conn.createStatement();
	            rs = stmt.executeQuery(SQL);
	            while (rs.next()) {
	                Bbs bbs = new Bbs();
	                bbs.setBbsID(rs.getInt(1));
	                bbs.setBbsTitle(rs.getString(2));
	                String userID = rs.getString(3);
	                bbs.setUserID(userID);
					if (userID != null && !userID.isEmpty()) {
		                UserDAO userDAO = new UserDAO();
		                String userName = userDAO.getUserNameByUserID(userID); // userName을 가져오는 메서드 호출
		                bbs.setUserName(userName != null ? userName : "알 수 없음"); // userName이 null이면 "알 수 없음" 표시
		            } else {
		                bbs.setUserName("알 수 없음"); // userID가 없는 경우 처리
		            }
	                bbs.setBbsDate(rs.getString(4));
	                bbs.setBbsContent(rs.getString(5));
	                bbs.setBbsAvailable(rs.getInt(6));
	                list.add(bbs);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return list;
	    }
		
//		// 페이징 처리를 위해 존재하는 함수
//		public boolean nextPage(int pageNumber) {
//			String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				pstmt.setInt(1, getNext() - (pageNumber -1 ) * 10);
//				rs = pstmt.executeQuery();
//				if (rs.next()) {
//					return true;
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return false;
//		}
		
		// 페이징 처리를 위해 존재하는 함수 (SQL 인젝션 취약)
	    public boolean nextPage(int pageNumber) {
	        String SQL = "SELECT * FROM BBS WHERE bbsID < " + (getNext() - (pageNumber - 1) * 10) + " AND bbsAvailable = 1";
	        try {
	            Statement stmt = conn.createStatement();
	            rs = stmt.executeQuery(SQL);
	            if (rs.next()) {
	                return true;
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	    
//	    // 게시글 정보를 불러오는 함수
//	    public Bbs getBbs(int bbsID) {
//			String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				pstmt.setInt(1, bbsID);
//				rs = pstmt.executeQuery();
//				if (rs.next()) {
//					Bbs bbs = new Bbs();
//					bbs.setBbsID(rs.getInt(1));
//					bbs.setBbsTitle(rs.getString(2));
//					String userID = rs.getString(3);
//					bbs.setUserID(userID);
//					if (userID != null && !userID.isEmpty()) {
//		                UserDAO userDAO = new UserDAO();
//		                String userName = userDAO.getUserNameByUserID(userID); // userName을 가져오는 메서드 호출
//		                bbs.setUserName(userName != null ? userName : "알 수 없음"); // userName이 null이면 "알 수 없음" 표시
//		            } else {
//		                bbs.setUserName("알 수 없음"); // userID가 없는 경우 처리
//		            }
//
//					bbs.setBbsDate(rs.getString(4));
//					bbs.setBbsContent(rs.getString(5));
//					bbs.setBbsAvailable(rs.getInt(6));
//					return bbs;
//				}
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return null;
//		}
	    
		// 게시글 정보를 불러오는 함수 (SQL 인젝션 취약)
		public Bbs getBbs(int bbsID) {
			String SQL = "SELECT * FROM BBS WHERE bbsID = " + bbsID;
			try {
				Statement stmt = conn.createStatement();
			    rs = stmt.executeQuery(SQL);
				if (rs.next()) {
					Bbs bbs = new Bbs();
					bbs.setBbsID(rs.getInt(1));
					bbs.setBbsTitle(rs.getString(2));
					String userID = rs.getString(3);
					bbs.setUserID(userID);
					if (userID != null && !userID.isEmpty()) {
		                UserDAO userDAO = new UserDAO();
		                String userName = userDAO.getUserNameByUserID(userID); // userName을 가져오는 메서드 호출
		                bbs.setUserName(userName != null ? userName : "알 수 없음"); // userName이 null이면 "알 수 없음" 표시
		            } else {
		                bbs.setUserName("알 수 없음"); // userID가 없는 경우 처리
		            }
					bbs.setBbsDate(rs.getString(4));
					bbs.setBbsContent(rs.getString(5));
					bbs.setBbsAvailable(rs.getInt(6));
					bbs.setFileName(rs.getString(7));
					bbs.setFileRealName(rs.getString(8));
					return bbs;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}
		
//		// 게시판 글 수정 함수
//		public int update(int bbsID, String bbsTitle, String bbsContent) {
//			String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				pstmt.setString(1, bbsTitle);
//				pstmt.setString(2, bbsContent);
//				pstmt.setInt(3, bbsID);
//				return pstmt.executeUpdate();
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return -1; // 데이터베이스 오류
//		}
		
		// 게시판 글 수정 기능 (SQL 인젝션 취약)
	    public int update(int bbsID, String bbsTitle, String bbsContent) {
	        String SQL = "UPDATE BBS SET bbsTitle = '" + bbsTitle + "', bbsContent = '" + bbsContent + "' WHERE bbsID = " + bbsID;
	        try {
	            Statement stmt = conn.createStatement();
	            return stmt.executeUpdate(SQL);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return -1; // 데이터베이스 오류
	    }
		
//		// 게시판 글 삭제 함수
//		public int delete(int bbsID) {
//			String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
//			try {
//				PreparedStatement pstmt = conn.prepareStatement(SQL);
//				pstmt.setInt(1, bbsID);
//				return pstmt.executeUpdate();
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			return -1; // 데이터베이스 오류
//		}
		
		 // 게시판 글 삭제 기능 (SQL 인젝션 취약)
	    public int delete(int bbsID) {
	        String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = " + bbsID;
	        try {
	            Statement stmt = conn.createStatement();
	            return stmt.executeUpdate(SQL);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return -1; // 데이터베이스 오류
	    }
	    
//		// 게시글 검색 기능
//		public ArrayList<Bbs> searchList(String search, int pageNumber) {
//		    ArrayList<Bbs> list = new ArrayList<Bbs>();
//		    String SQL = "SELECT * FROM BBS WHERE bbsTitle LIKE ? OR bbsContent LIKE ? ORDER BY bbsID DESC LIMIT ?, 10";
//		    
//		    try {
//		        PreparedStatement pstmt = conn.prepareStatement(SQL);
//		        pstmt.setString(1, "%" + search + "%"); // 제목에서 검색
//		        pstmt.setString(2, "%" + search + "%"); // 내용에서 검색
//		        pstmt.setInt(3, (pageNumber - 1) * 10);
//		        ResultSet rs = pstmt.executeQuery();
//		        
//		        while (rs.next()) {
//		            Bbs bbs = new Bbs();
//		            bbs.setBbsID(rs.getInt(1));
//		            bbs.setBbsTitle(rs.getString(2));
//		            bbs.setUserName(rs.getString(3));
//		            bbs.setBbsDate(rs.getString(4));
//		            list.add(bbs);
//		        }
//		    } catch (Exception e) {
//		        e.printStackTrace();
//		    }
//		    return list;
//		}
		
		// 게시글 검색 기능 (SQL 인젝션 취약)
	    public ArrayList<Bbs> searchList(String search, int pageNumber) {
	        ArrayList<Bbs> list = new ArrayList<Bbs>();
	        String SQL = "SELECT * FROM BBS WHERE bbsTitle LIKE '%" + search + "%' or bbsContent Like '%" + search + "%' ORDER BY bbsID DESC LIMIT " + (pageNumber - 1) * 10 + ", 10";
	        try {
	            Statement stmt = conn.createStatement();
	            rs = stmt.executeQuery(SQL);
	            while (rs.next()) {
	                Bbs bbs = new Bbs();
	                bbs.setBbsID(rs.getInt(1));
	                bbs.setBbsTitle(rs.getString(2));
	                bbs.setUserName(rs.getString(3));
	                bbs.setBbsDate(rs.getString(4));
	                list.add(bbs);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return list;
	    }
	   
	    // 검색기능 페이징처리
	    public boolean SearchNextPage(String search, int pageNumber) {
	        String SQL = "SELECT COUNT(*) FROM BBS WHERE (bbsTitle LIKE '%" + search + "%' OR bbsContent LIKE '%" + search + "%') AND bbsAvailable = 1";
	        
	        try {
	            Statement stmt = conn.createStatement();
	            rs = stmt.executeQuery(SQL);
	            if (rs.next()) {
	                int totalResults = rs.getInt(1);
	                return totalResults > pageNumber * 10;
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return false;
	    }	    
	
	}