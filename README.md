# Evan and Ian's Shop

## Key Highlights
- **Customer Feedback:** Customers have the power to review and provide feedback on products.
- **Store Features:** The website is designed to be intuitive and informative for users.
- **Product Range:** A wide variety of products to meet diverse customer needs.
- **Security:** Secure login system to protect user information, including addresses.

## List of Features

### Documentation
- **Executive Summary** ✔
- **System Features** ✔
- **List of Web and AI Sources Used** (ChatGPT used for debugging and limited coding) ✔
- **Walkthrough with Screenshots** ✔

### Main/Home Page
- Search for a product by name
- Browse products by category
- List products (by search/browse)
- Display product images
- Page header with menu
- Page header shows the logged-in user
- ![Home Page](screenshots/home_page.png)

### Shopping Cart
- Add items to the shopping cart
- View shopping cart
- Update quantity with validation
- Remove item from shopping cart
- ![Shopping Cart](screenshots/shopping_cart.png)

### Checkout
- Checkout with customer ID
- Checkout with payment/shipment information
- Checkout with data validation
- ![Checkout Page](screenshots/checkout.png)

### Product Detail Page
- Product details with item description
- Product image from database
- ![Product Detail](screenshots/product_detail.png)

### User Accounts/Login
- Create user account page
- Create account with data validation
- Edit user account info (address, password)
- Login/logout functionality
- ![User Account](screenshots/user_account.png)

### Warehouses/Inventory
- Display item inventory by store/warehouse
- ![Inventory Page](screenshots/inventory.png)

### Administrator Portal
- Secured login for admins
- List all customers
- Report showing total sales/orders
- Report with a graph (Advanced)
- Add new products
- Update/delete products
- Add/update warehouse and customers
- ![Admin Panel](screenshots/admin_panel.png)

## Walkthrough
1. **Home Page** - Header displays available pages and logged-in user status.
2. **Product Listing (Listprod.jsp)** - Search by category and name.
3. **Shopping Cart (Showcart.jsp)** - Update quantity or remove items.
4. **Checkout Login** - Authenticate with customer ID and password.
5. **Checkout Details** - Auto-populated user details from the database.
6. **Order Confirmation (Order.jsp)** - Validates order, shipping address, and payment.
7. **Product Page (Product.jsp)** - Displays product information and images.
8. **User Account (validateSignUp.jsp)** - Create and validate new user accounts.
9. **Edit Customer Info (editCustomer.jsp)** - Update customer details.
10. **Inventory (Inventory.jsp)** - Displays inventory by warehouse.
11. **Admin Panel (Admin.jsp)** - View total sales and customers.
12. **Manage Products (manageProducts.jsp)** - Add, update, and delete products.
13. **Manage Warehouses (manageWarehouse.jsp)** - Add and update warehouses.

---

## Contributors
- **Evan Paseneau**
- **Ian Downing**

## License
This project is licensed under the MIT License.
