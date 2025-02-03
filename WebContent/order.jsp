<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Evan and Ian's Grocery Order Processing</title>
</head>
<style>
	/* General page styling */
	body {
		font-family: Arial, sans-serif;
		background-color: #f8f9fa;
		margin: 0;
		padding: 20px;
		color: #333;
	}

	h1 {
		color: #343a40;
		font-size: 2em;
		text-align: center;
		margin-bottom: 20px;
	}

	/* Table Styling */
	table {
		width: 100%;
		margin-bottom: 20px;
		border-collapse: collapse;
	}

	th, td {
		border: 1px solid #ddd;
		padding: 10px;
		text-align: left;
	}

	th {
		background-color: #f2f2f2;
		font-weight: bold;
	}

	.product-details th, .product-details td {
		background-color: #fff;
	}

	/* Button Styling */
	button {
		padding: 10px 20px;
		background-color: #007bff;
		color: white;
		border: none;
		border-radius: 5px;
		cursor: pointer;
		font-size: 1em;
	}

	button:hover {
		background-color: #0056b3;
	}

	/* Container for the form button */
	form {
		display: flex;
		justify-content: center;
		margin-top: 30px;
	}

	/* Footer */
	.footer {
		margin-top: 40px;
		text-align: center;
	}

	/* General text styles for the page */
	p {
		font-size: 1.2em;
	}
</style>
<body>

<%
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

try {
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
out.println("ClassNotFoundException: " + e);
}

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
con.setAutoCommit(false);// Start transaction

String customerQuery = "SELECT COUNT(customerId) FROM customer WHERE customerId = ?";
try (PreparedStatement pstmt = con.prepareStatement(customerQuery)) {
pstmt.setString(1, custId);
ResultSet rs = pstmt.executeQuery();
if (rs.next() && rs.getInt(1) == 0) {
out.println("<h4>ERROR: Customer does not exist. </h4>");
return;// Exit the process
}
}

if (productList == null || productList.isEmpty()) {
out.println("<h4>Shopping cart is empty</h4>");
return;// Exit the process
}

String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
int orderId;
try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
pstmt.setString(1, custId);
pstmt.executeUpdate();
ResultSet keys = pstmt.getGeneratedKeys();
keys.next();
orderId = keys.getInt(1);
}

double totalAmount = 0;

String insertProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
try (PreparedStatement pstmt = con.prepareStatement(insertProduct)) {
for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
ArrayList<Object> product = entry.getValue();
String productId = (String) product.get(0);
String price = (String) product.get(2);
double pr = Double.parseDouble(price);
int qty = ((Integer) product.get(3)).intValue();

pstmt.setInt(1, orderId);
pstmt.setString(2, productId);
pstmt.setInt(3, qty);
pstmt.setDouble(4, pr);
pstmt.executeUpdate();

totalAmount += pr * qty;
}
}

String updateTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
try (PreparedStatement pstmt = con.prepareStatement(updateTotal)) {
pstmt.setDouble(1, totalAmount);
pstmt.setInt(2, orderId);
pstmt.executeUpdate();
}
String showOrder = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
try (PreparedStatement pstmt = con.prepareStatement(showOrder)) {
pstmt.setInt(1, orderId);
ResultSet resultSet = pstmt.executeQuery();

out.println("<h1>Order Summary</h1>");
out.println("<table class='product-details'>");
out.println("<tr>");
out.println("<th>Product Id</th>");
out.println("<th>Quantity</th>");
out.println("<th>Price</th>");
out.println("<th>Order Total</th>");
out.println("</tr>");

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
double cumulativeTotal = 0.0;

while (resultSet.next()) {
int productId = resultSet.getInt("productId");
int quantity = resultSet.getInt("quantity");
double price = resultSet.getDouble("price");
double total = quantity * price;
cumulativeTotal += total;

out.println("<tr>");
out.println("<td>" + productId + "</td>");
out.println("<td>" + quantity + "</td>");
out.println("<td>" + currFormat.format(price) + "</td>");
out.println("<td>" + currFormat.format(total) + "</td>");
out.println("</tr>");
}
out.println("<tr>");
out.println("<td colspan='3' style='text-align:right; font-weight:bold;'>Grand Total</td>");
out.println("<td>" + currFormat.format(cumulativeTotal) + "</td>");
out.println("</tr>");
out.println("</table>");
}

String customernameQuery = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
String recipientFirstName = "";
String recipientLastName = "";
try (PreparedStatement pstmt = con.prepareStatement(customernameQuery)) {
pstmt.setString(1, custId);
ResultSet rs = pstmt.executeQuery();
if (rs.next()) {
recipientFirstName = rs.getString("firstName");
recipientLastName = rs.getString("lastName");
} else {
out.println("<h4>ERROR: Customer does not exist.</h4>");
return; 
}
}

session.removeAttribute("productList");
out.println("<h1>Order Processed Successfully</h1>");
out.println("<p>Your reference number is: <strong>" + orderId + "</strong></p>");
out.println("<p>Thank you very much, " + recipientFirstName + " " + recipientLastName + "</p>");

out.println("<form action='shop.html'>");
	out.println("<button type='submit'>Go Back to Shop</button>");
	out.println("</form>");
con.commit();	
}
catch (SQLException e) {
out.println(e);
}
%>
</body>
</html>


