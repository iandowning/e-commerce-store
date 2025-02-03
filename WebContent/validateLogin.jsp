<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch(IOException e) {
        System.err.println(e);
    }

    if(authenticatedUser != null) {
        response.sendRedirect("index.jsp");        
    } else {
        response.sendRedirect("login.jsp");        
    }
%>


<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");    // 'username' from form mapped to 'userid'
        String password = request.getParameter("password");
        String retStr = null;

		// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        if(username == null || password == null)
            return null;
        if(username.trim().isEmpty() || password.trim().isEmpty())
            return null;

        try {
            getConnection();

     
            String sql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);  
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                retStr = rs.getString("userid");   
                session.removeAttribute("loginMessage");   
                session.setAttribute("authenticatedUser", username); 
            } else {
                retStr = null;
                session.setAttribute("loginMessage", "Invalid username or password.");
            }
        } catch (SQLException ex) {
            out.println("Database Error: " + ex.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* Ignored */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* Ignored */ }
            closeConnection();
        }   

        return retStr;
    }
%>



