<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evan and Ian's Grocery</title>
    <style>
body {
    font-family: 'Arial', sans-serif;
    background-color: #f8f9fa; /* Lighter background color for better contrast */
    margin: 0;
    padding: 20px;
    color: #333; /* Dark text for readability */
}

/* Header styling */
h1 {
    color: #343a40; /* Darker text for better contrast */
    text-align: center; /* Center-align header */
    font-size: 2.5em;
    margin-bottom: 20px;
}

/* Form styling */
form {
    margin-bottom: 20px;
    text-align: center; /* Center-align the form */
}

/* Input styling for text fields */
input[type="text"] {
    padding: 12px 15px; /* Increased padding for better usability */
    width: 100%;
    max-width: 400px; /* Limit max width for larger screens */
    border-radius: 8px; /* Rounded corners */
    border: 1px solid #ccc;
    font-size: 16px;
    margin: 15px; /* Added space below input fields */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Subtle shadow for a clean look */
}

/* Submit and reset button styling */
input[type="submit"], input[type="reset"] {
    padding: 12px 30px;
    background-color: #28a745; /* Green background for submit button */
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s ease; /* Smooth transition effect */
    margin: 7px;
}

input[type="reset"] {
    background-color: #dc3545; /* Red background for reset button */
}

input[type="submit"]:hover {
    background-color: #218838; /* Darker green when hovered */
}

input[type="reset"]:hover {
    background-color: #c82333; /* Darker red when hovered */
}

/* Link styling */
a {
    color: #007bff; /* Blue color for links */
    text-decoration: none;
    font-weight: 600; /* Slightly bolder font for links */
}

a:hover {
    text-decoration: underline;
}

/* Product list grid styling */
.product-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); /* Responsive grid */
    gap: 20px; /* Space between product items */
    margin-top: 20px;
}

/* Individual product item styling */
.product-item {
    background-color: #ffffff; /* White background for product items */
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
    transition: transform 0.2s ease, box-shadow 0.2s ease; /* Smooth transition for hover effects */
}

/* Hover effect for product items */
.product-item:hover {
    transform: translateY(-5px); /* Lift effect when hovering */
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); /* Deeper shadow on hover */
}

/* Add to cart button styling */
.addcart {
    display: inline-flex;
    padding: 10px 20px;
    background-color: #007bff; /* Blue button */
    color: white;
    border-radius: 5px;
    font-size: 16px;
    cursor: pointer;
    align-items: center;
    justify-content: center;
    transition: background-color 0.3s ease;
    margin: 5px; 
}

.addcart:hover {
    background-color: #0056b3; /* Darker blue on hover */
}

/* Add to cart button on mobile */
.addcart:active {
    background-color: #004085; /* Even darker blue when clicked */
}

    </style>
</head>
<body>

<h1>What products are you looking for today? </h1>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" placeholder="Enter product name...">
    <input type="submit" value="Submit">
    <input type="reset" value="Reset"> (Leave blank for all products)
</form>

<div class="product-list">
    <%
        String name = request.getParameter("productName");
        try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        String newname = "%" + name + "%";
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String query = "select productId, productName, productPrice from product where productName like ?";
            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, newname);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                String pname = resultSet.getString("productName");
                int pid = resultSet.getInt("productId");
                double pp = resultSet.getDouble("productPrice");

    %>
    <div class="product-item">
        <a class="addcart" href="<%= "addcart.jsp?id=" + pid + "&name=" + URLEncoder.encode(pname, StandardCharsets.UTF_8) + "&price=" + pp %>">Add to cart</a> -
        <strong>
            <a href="<%= "product.jsp?id="+pid %>"> <%= pname %></a>
        </strong> - Price: $<%= pp %>
    </div>
    <%
            }
        } catch (SQLException e) {
            out.println(e);
        }
    %>
</div>

</body>
</html>
