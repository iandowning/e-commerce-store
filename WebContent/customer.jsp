<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        table {
            border-collapse: collapse;
            width: 60%;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #333;
        }
        th, td {
            padding: 8px 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<%
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    
    if (authenticatedUser == null) {
%>
        <p class="error">Error: You must be logged in to view this page. Please <a href="login.jsp">login</a> first.</p>
<%
    } else {

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            getConnection(); 
            
            String sql = "SELECT firstName, lastName, email, phonenum, address, city, state, postalCode, country " +
                         "FROM customer WHERE userid = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, authenticatedUser);
            

            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
                String email = rs.getString("email");
                String phone = rs.getString("phonenum");
                String address = rs.getString("address");
                String city = rs.getString("city");
                String state = rs.getString("state");
                String postalCode = rs.getString("postalCode");
                String country = rs.getString("country");
%>
                <!-- Display Customer Information in a Table -->
                <h2>Welcome, <%= firstName %> <%= lastName %>!</h2>
                <table>
                    <tr>
                        <th>First Name</th>
                        <td><%= firstName %></td>
                    </tr>
                    <tr>
                        <th>Last Name</th>
                        <td><%= lastName %></td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td><%= email %></td>
                    </tr>
                    <tr>
                        <th>Phone Number</th>
                        <td><%= phone %></td>
                    </tr>
                    <tr>
                        <th>Address</th>
                        <td><%= address %></td>
                    </tr>
                    <tr>
                        <th>City</th>
                        <td><%= city %></td>
                    </tr>
                    <tr>
                        <th>State</th>
                        <td><%= state %></td>
                    </tr>
                    <tr>
                        <th>Postal Code</th>
                        <td><%= postalCode %></td>
                    </tr>
                    <tr>
                        <th>Country</th>
                        <td><%= country %></td>
                    </tr>
                </table>
<%
            } else {
%>
                <!-- Display Message if No Customer Information Found -->
                <p class="error">No customer information found for the logged-in user.</p>
<%
            }
        } catch (SQLException e) {
%>
            <!-- Display SQL Error Message -->
            <p class="error">An error occurred while retrieving your information: <%= e.getMessage() %></p>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* Ignored */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* Ignored */ }
            closeConnection();            
            }
        }
%>

</body>
</html>
