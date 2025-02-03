<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>

<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    NumberFormat nf = NumberFormat.getCurrencyInstance();
%>

<%
try {
    getConnection();
    String sql = "SELECT CAST(orderDate AS DATE) AS order_day, SUM(totalAmount) AS total_sales FROM ordersummary" +
              " GROUP BY CAST(orderDate AS DATE) ORDER BY order_day DESC";
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();

%>
    <table class="table table-striped table-bordered mt-3">
        <thead class="thead-dark">
            <tr>
                <th>Date</th>
                <th>Total Sales</th>
            </tr>
        </thead>
    <tbody>

    <%
            while (rs.next()) {
                Date orderDay = rs.getDate("order_day");
                double totalSales = rs.getDouble("total_sales");
    %>
            <tr>
                    <td><%= orderDay %></td>
                    <td><%= nf.format(totalSales) %></td>
            </tr>
                <%
            }
    %>
                </tbody>
            </table>
     <%
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger' role='alert'>Error retrieving sales data: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            closeConnection();
            }
    %>

</body>
</html>

