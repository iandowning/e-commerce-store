<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Evan and Ian's Grocery Shipment Processing</title>
</head>
<body>

<%@ include file="header.jsp" %>

<%
    String strOrderId = request.getParameter("orderId");
    if (strOrderId == null || strOrderId.trim().isEmpty()) {
%>
        <p style="color: red;">Error: Order ID is missing.</p>
        <h2><a href="shop.html">Back to Main Page</a></h2>
<%
        return;
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean sufficientInventory = true; 
    String insufficientProduct = "";   
    boolean hasItems = false;         

    try {
        int orderId = Integer.parseInt(strOrderId);
        getConnection();

        String retrieveItemsSql = "SELECT op.productId, op.quantity, pi.quantity AS inventory, p.productName " +
                                  "FROM orderproduct op " +
                                  "JOIN productinventory pi ON op.productId = pi.productId " +
                                  "JOIN product p ON op.productId = p.productId " +
                                  "WHERE op.orderId = ? AND pi.warehouseId = 1";
        pstmt = con.prepareStatement(retrieveItemsSql);
        pstmt.setInt(1, orderId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            hasItems = true;
            int productId = rs.getInt("productId");
            String productName = rs.getString("productName");
            int orderedQuantity = rs.getInt("quantity");
            int currentInventory = rs.getInt("inventory");
			int newInventory = currentInventory - orderedQuantity;
			
			%>
            <p>Ordered Product: <%= productId %> Qty: <%= orderedQuantity %> Previous Inventory: <%= currentInventory %> New Inventory: <%= newInventory %></p>	
            <%
			if (currentInventory < orderedQuantity) {
                sufficientInventory = false;
                insufficientProduct = productName;
                break;
            }
        }

        if (!hasItems) {
%>
            <p>No items found for Order ID <%= orderId %>.</p>
<%
        } else if (!sufficientInventory) {
%>
            <p>Shipment not done. Insufficient inventory for product "<%= insufficientProduct %>".</p>
<%
        } else {
%>
            <p>Shipment successfully posted for Order ID <%= orderId %>.</p>
<%
        }
    } catch (Exception e) {
%>
        <p>Error: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    }
%>

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
