<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.management.StandardMBean" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Evan and Ian's Grocery Order List</title>
<style>
body {
    font-family: 'Arial', sans-serif; 
    background-color: #f4f4f9; 
    margin: 20px;
    color: #333; 
}

h1 {
    color: #007BFF; 
    text-align: center; 
    font-size: 2em;
    margin-bottom: 20px;
}

table {
    width: 100%;
    margin-bottom: 30px;
    border-collapse: collapse; 
    background-color: #ffffff; 
}

th, td {
    border: 1px solid #ddd; 
    padding: 12px; 
    text-align: left;
}

th {
    background-color: #4582c2; 
    color: rgb(0, 0, 0); 
    font-weight: bold;
}

td {
    background-color: #f9f9f9; 
}

.order-summary th, .order-summary td {
    background-color: #e6f3ff; 
}

.product-details th, .product-details td {
    background-color: #ffffff; 
}


</style>
</head>
<body>

<h1>Order List</h1>


<%
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    Connection con = null;
    Statement stmt = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    ResultSet productRs = null;

    try {
        con = DriverManager.getConnection(url, uid, pw);
        stmt = con.createStatement();
        
        String query = "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
                       "FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId";
        rs = stmt.executeQuery(query);

        String productQuery = "SELECT orderproduct.productId, orderproduct.quantity, orderproduct.price " +
                              "FROM orderproduct JOIN product ON orderproduct.productId = product.productId WHERE orderproduct.orderId = ?";
        pstmt = con.prepareStatement(productQuery);

        while (rs.next()) {
            out.println("<table class='order-summary'>");
            out.println("<tr>");
            out.println("<th>Order Id</th>");
            out.println("<th>Order Date</th>");
            out.println("<th>Customer Id</th>");
            out.println("<th>Customer Name</th>");
            out.println("<th>Total Amount</th>");
            out.println("</tr>");
            
            out.println("<tr>");
            out.println("<td>" + rs.getInt("orderId") + "</td>");
            out.println("<td>" + rs.getTimestamp("orderDate") + "</td>");
            out.println("<td>" + rs.getInt("customerId") + "</td>");
            out.println("<td>" + rs.getString("firstName") + " " + rs.getString("lastName") + "</td>");
            out.println("<td>" + currFormat.format(rs.getDouble("totalAmount")) + "</td>");
            out.println("</tr>");

            pstmt.setInt(1, rs.getInt("orderId"));
            productRs = pstmt.executeQuery();

            out.println("<tr><td colspan='5'>");
            out.println("<table class='product-details'>");
            out.println("<tr>");
            out.println("<th>Product Id</th>");
            out.println("<th>Quantity</th>");
            out.println("<th>Price</th>");
            out.println("</tr>");

            while (productRs.next()) {
                out.println("<tr>");
                out.println("<td>" + productRs.getInt("productId") + "</td>");
                out.println("<td>" + productRs.getInt("quantity") + "</td>");
                out.println("<td>" + currFormat.format(productRs.getDouble("price")) + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");
            out.println("</td></tr>");
            out.println("</table><br>");
        }
    } catch (SQLException ex) {
        out.println("SQL Error: " + ex.getMessage());
    } finally {
        try {
            if (productRs != null) productRs.close();
            if (pstmt != null) pstmt.close();
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("Error closing resources: " + e.getMessage());
        }
    }
%>


</body>
</html>