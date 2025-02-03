<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Evan and Ian's - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<%
    getConnection();

    String productId = request.getParameter("id");
    NumberFormat nf = NumberFormat.getCurrencyInstance();

    int prodId = 0;
    try {
        prodId = Integer.parseInt(productId);
    } catch (NumberFormatException e) {
        prodId = 0; // Invalid ID
    }

    // Get product name to search for
    // TODO: Retrieve and display info for the product
    // String productId = request.getParameter("id");
    
    String sql = "SELECT * FROM product WHERE productId = ?";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, prodId);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            String productName = rs.getString("productName");
            String productDesc = rs.getString("productDesc");
            double productPrice = rs.getDouble("productPrice");
            String productImageURL = rs.getString("productImageURL");
            Blob productImage = rs.getBlob("productImage");
%>

<div class="container">
    <h2><%= productName %></h2>
    <p><%= productDesc %></p>
    <p>Price: <%= nf.format(productPrice) %></p>

    <%
        if (productImageURL != null && !productImageURL.isEmpty()) {
    %>
        <img src="<%= productImageURL %>" alt="<%= productName %>" class="img-responsive">
    <%
        } else if (productImage != null && productImage.length() > 0) {
    %>
        <img src="displayImage.jsp?id=<%= productId %>" alt="<%= productName %>" class="img-responsive">
    <%
        } else {
    %>
        <img src="img/no-image-available.png" alt="No image available" class="img-responsive">
    <%
        }
    %>

    <!-- Links to Add to Cart and Continue Shopping -->
    <p>
        <a href="addcart.jsp?id=<%= productId %>" class="btn btn-primary">Add to Cart</a>
        <a href="listprod.jsp" class="btn btn-default">Continue Shopping</a>
    </p>
</div>

<%
        } else {
%>
<div class="container">
    <p>Product not found.</p>
    <a href="listprod.jsp" class="btn btn-default">Back to Products</a>
</div>
<%
        }
    } catch (SQLException e) {
        e.printStackTrace();
%>
<div class="container">
    <p>Error retrieving product information.</p>
    <a href="listprod.jsp" class="btn btn-default">Back to Products</a>
</div>
<%
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        closeConnection(); // Close the database connection
    }
%>

</body>
</html>
