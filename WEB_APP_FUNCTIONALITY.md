# GoldBook Web App - Complete Functionality Documentation

**URL**: https://goldbook.in/
**Credentials**: kannan04 / Test@123

## 1. AUTHENTICATION SYSTEM

### Login Screen (`/login`)
- **Username**: Text input field
- **Password**: Password input field
- **Features**:
  - Forgot Password link: `/forgot-password`
  - Terms of Service link: `/terms`
  - Privacy Policy link: `/privacy-policy`
  - Login button
  - Credential-based authentication
  - Cloud-based architecture (accessible from anywhere)
  - Best-in-class security & privacy

### Session Management
- User session tracking
- Redirect to dashboard after successful login
- Session-based navigation

---

## 2. MAIN NAVIGATION

### Sidebar Menu (Main Navigation)
The application typically includes:
- Dashboard
- Parties (Customers & Suppliers)
- Inventory
- Transactions
- Reports
- Settings

---

## 3. DASHBOARD (`/dashboard`)

### Summary Overview Cards
- **Gold Rate (24k)**: Current market gold rate display
- **Gold Stock**: Total gold inventory in grams
- **Silver Stock**: Total silver inventory in grams
- **Customer Gold Balance**: Aggregate gold balance across all customers
- **Customer Cash Balance**: Aggregate cash balance across all customers

### Analytics & Charts
- **Sales Overview**: Bar chart showing weekly sales trends
- **Top Customers**: List of top performing customers with their gold balances

### Quick Access Widgets
- Recent transactions
- Pending actions
- Balance summaries

---

## 4. PARTIES MANAGEMENT

### 4.1 CUSTOMERS

#### Customer List Screen
- Display all customers in tabular format
- Search/Filter functionality
- Add New Customer button
- Action buttons (Edit, Delete, View)
- Sorting capabilities

#### Customer Form (Create/Edit)
**General Information Section**:
- Customer Type: Dropdown (Business/Individual)
- Code: Unique customer identifier
- Company Name: Business name
- Display Name: Short name for display
- Contact Person: Primary contact name
- Mobile Number: Contact mobile
- Work Phone: Office phone
- Email: Email address
- Preferred Courier: Courier selection for shipments

**Address Information Section**:
- Address Line 1: Primary address
- Address Line 2: Secondary address
- Landmark: Location landmark
- City: City name
- State: State/Province
- Country: Country name
- PIN Code: Postal code

**Financial Information Section**:
- Opening Balance - Gold (in grams)
- Opening Balance - Silver (in grams)
- Opening Balance - Cash (in ₹)
- Credit Limit - Gold (in grams)
- Credit Limit - Cash (in ₹)
- GSTIN: GST Identification Number
- PAN Number: Tax identification
- Tax Preference: Dropdown (Taxable/Tax Exempt)

**Additional Section**:
- Notes: Internal notes/remarks

#### Customer Balance Tracking
- **Gold Balance**: Displayed in grams (Color-coded: Green for positive, Red for negative/due)
- **Silver Balance**: Displayed in grams (Color-coded)
- **Cash Balance**: Displayed in ₹ (Color-coded)

#### Customer Analytics
- Transaction history
- Balance trends
- Credit utilization

### 4.2 SUPPLIERS

#### Supplier List Screen
- Similar to customer list with supplier-specific actions
- Display all suppliers in tabular format
- Add New Supplier button
- Search/Filter functionality

#### Supplier Form (Create/Edit)
**Identical Structure to Customers with variations**:
- Supplier Type: Includes "Karigar/Individual" option
- All address and financial information fields
- Balance tracking (Gold, Silver, Cash)
- Credit limits and tax information
- Notes field

#### Supplier Balance Tracking
- Supplier payable/receivable balances
- Credit limits management
- Payment tracking

---

## 5. INVENTORY MANAGEMENT

### 5.1 ITEMS

#### Items List Screen
- Display all inventory items in tabular format
- Add New Item button
- Edit/Delete actions
- Stock level display
- Filter by metal type (Gold/Silver)

#### Item Details Form (Create/Edit)
- **Item Name**: Name of the jewelry item
- **Metal Type**: Dropdown (Gold/Silver)
- **Purity**: Standard purity levels (e.g., 916, 750, 22K, 18K, etc.)
- **Stock Quantity**: Current stock count (in pieces)
- **Total Weight**: Total weight in grams (calculated from transactions)

#### Stock Management
- Real-time stock tracking
- Stock updates through transactions
- Low stock alerts/warnings (if implemented)
- Stock history/audit trail

#### Metal Rates Management
- Gold rate display (24k standard)
- Silver rate display
- Rate history tracking
- Manual rate updates

---

## 6. TRANSACTIONS MANAGEMENT

### 6.1 TRANSACTION TYPES

#### 1. SALES (Sale to Customers)
- Selling finished jewelry to customers
- Updates customer gold/cash balances
- Reduces inventory

#### 2. PURCHASES (Purchase from Suppliers)
- Buying jewelry/metals from suppliers
- Updates supplier balances
- Increases inventory

#### 3. RECEIPTS (Cash/Payment Received)
- Recording customer payments
- Reduces customer cash payable balance
- Records payment date and method

#### 4. PAYMENTS (Payments to Suppliers)
- Recording payments to suppliers
- Reduces supplier payable balance
- Tracks payment method and date

### 6.2 TRANSACTION ENTRY SCREEN

#### Header Information
- **Transaction Type**: Dropdown (Sale/Purchase/Receipt/Payment)
- **Party Selection**: Select customer or supplier based on transaction type
- **Transaction Date**: Date of transaction
- **Remarks**: Optional notes about transaction

#### Line Items Section
For each transaction line item:
- **Item Selection**: Choose from inventory items
- **Description**: Item description
- **Gross Weight**: Total weight in grams
- **Net Weight**: Net weight (after deducting wastage/loss)
- **Purity**: Purity percentage (e.g., 91.6% for 916)
- **Amount**: Transaction amount in ₹

#### Automatic Calculations
- **Total Weight**: Sum of all line items
- **Total Amount**: Sum of all amounts
- **GST Calculation**: If customer/supplier is taxable
- **Net Amount**: After tax
- **Metal Quantity**: Automatic calculation based on purity and weight

#### Transaction Posting
- Save transaction button
- Validate transaction
- Update party balances
- Update inventory stock
- Create audit trail

### 6.3 TRANSACTION LIST

#### Transaction Filtering/Search
- Filter by transaction type
- Filter by party (customer/supplier)
- Filter by date range
- Search functionality

#### Transaction Display
- Transaction number/ID
- Transaction type
- Party name
- Date
- Amount
- Status
- Action buttons (View, Edit, Delete, Print)

### 6.4 TRANSACTION OPERATIONS

#### View Transaction
- Display all transaction details
- Line items breakdown
- Calculations verification
- Print option

#### Edit Transaction
- Modify transaction details (if allowed)
- Update line items
- Recalculate balances

#### Delete Transaction
- Remove transaction
- Reverse balance updates
- Reverse inventory updates
- Maintain audit trail

#### Print/Export
- Print transaction details
- PDF export capability
- Email transaction

---

## 7. REPORTS MODULE

### 7.1 CASH BOOK

#### Cash Book Report
- **Report Type**: Cash flow summary
- **Time Period**: Daily/Monthly/Yearly views
- **Columns**:
  - Date
  - Description/Reference
  - Transaction Type
  - Amount In (₹)
  - Amount Out (₹)
  - Balance (₹)
- **Features**:
  - Running balance calculation
  - Opening and closing balances
  - Filter by date range
  - Export to PDF/Excel

### 7.2 CUSTOMER REPORTS

#### Customer Statement
- Customer-wise transaction summary
- Opening balance
- Transactions (Sales/Receipts)
- Closing balance
- Outstanding amount

#### Customer Balance Report
- List of all customers
- Gold balance (in grams)
- Silver balance (in grams)
- Cash balance (in ₹)
- Credit limit vs. utilized
- Aging analysis (overdue amounts)

#### Sales Report
- Customer-wise sales summary
- Sales amount
- Date range filtering
- Product-wise breakdown

### 7.3 SUPPLIER REPORTS

#### Supplier Statement
- Supplier-wise transaction summary
- Purchase history
- Payment history
- Outstanding amounts

#### Supplier Balance Report
- All suppliers' balances
- Amount payable
- Payment due dates
- Credit limit status

#### Purchase Report
- Supplier-wise purchases
- Item-wise purchases
- Date range filtering

### 7.4 INVENTORY REPORTS

#### Stock Report
- Current stock levels by item
- Metal-wise stock (Gold/Silver)
- Total weight in inventory
- Valuation (stock value)

#### Stock Movement Report
- Item-wise stock transactions
- Opening stock
- Additions
- Sales
- Closing stock

#### Purity-wise Stock Report
- Stock grouped by purity
- Metal type breakdown
- Weight and quantity details

### 7.5 FINANCIAL REPORTS

#### Profit & Loss (P&L)
- Revenue from sales
- Cost of purchases
- Operating expenses
- Net profit/loss
- Period comparison

#### Balance Sheet
- Assets (Inventory value, Cash)
- Liabilities (Supplier payables)
- Capital/Equity
- Period comparison

#### Trial Balance
- All accounts with balances
- Debit/Credit columns
- Verification purpose

---

## 8. SETTINGS & CONFIGURATION

### 8.1 USER MANAGEMENT
- User profile
- Change password
- Account settings

### 8.2 COMPANY SETTINGS
- Company name/details
- Logo upload
- Default currency
- Financial year settings

### 8.3 PREFERENCES
- Date format
- Number format
- Decimal places
- Default units (grams/kilograms)

### 8.4 TAX SETTINGS
- GST rate configuration
- Tax categories
- Tax exemption rules

### 8.5 PARTY SETTINGS
- Customer type definitions
- Supplier type definitions
- Default credit limits
- Payment terms

### 8.6 ITEM SETTINGS
- Item categories
- Metal types
- Purity standards
- Default units

---

## 9. DATA SECURITY & BACKUP

### Features
- Cloud-based storage (no local data vulnerability)
- Data encryption in transit
- User authentication and authorization
- Audit trail for all transactions
- Regular automated backups
- Privacy policy compliance

---

## 10. ADDITIONAL FEATURES

### 10.1 DASHBOARD WIDGETS
- Summary cards for quick overview
- Charts for visual analytics
- Top performers list
- Recent activity feed

### 10.2 SEARCH & FILTERING
- Global search across parties, items, transactions
- Advanced filtering on all list screens
- Date range selection
- Status-based filtering

### 10.3 EXPORT FUNCTIONALITY
- Export lists to Excel/CSV
- Export reports to PDF
- Email reports
- Print functionality

### 10.4 NOTIFICATIONS
- Transaction notifications
- Balance alerts
- Low stock warnings
- Due payment reminders

### 10.5 MOBILE RESPONSIVE
- Responsive design for tablets
- Touch-friendly interface
- Optimized layouts

---

## 11. WORKFLOW SUMMARY

### Typical User Workflows

#### 1. Setting Up a New Customer
1. Navigate to Parties → Customers
2. Click "Add New Customer"
3. Fill in General Information (Name, Type, Contact)
4. Enter Address Details
5. Set Financial Information (Opening Balances, Credit Limits)
6. Save Customer

#### 2. Recording a Sale Transaction
1. Navigate to Transactions
2. Click "New Transaction"
3. Select Transaction Type: "Sale"
4. Select Customer
5. Add line items (Items, Weight, Amount)
6. System calculates totals and GST
7. Post transaction
8. Customer balance automatically updated

#### 3. Generating a Customer Statement
1. Navigate to Reports
2. Select "Customer Statement"
3. Choose Customer
4. Select Date Range
5. View/Print/Export statement

#### 4. Monitoring Cash Flow
1. Navigate to Reports
2. Select "Cash Book"
3. View daily/monthly balance
4. Export for accounting reconciliation

#### 5. Inventory Management
1. Navigate to Inventory → Items
2. View current stock levels
3. Monitor stock movements through transactions
4. Generate stock valuation reports

---

## 12. KEY METRICS & KPIs

The dashboard displays:
- **Total Gold in Stock**: Valuation of gold inventory
- **Total Silver in Stock**: Valuation of silver inventory
- **Customer Receivables**: Total gold + cash due from customers
- **Supplier Payables**: Total owed to suppliers
- **Monthly Sales**: Revenue generation
- **Top Customers**: Revenue contribution

---

## 13. BUSINESS PROCESS SUPPORT

### Jewelry Business Operations
- **Procurement**: Purchase from suppliers (Metal/Finished items)
- **Inventory**: Track gold, silver, and jewelry stock
- **Sales**: Sell to customers with automatic balance updates
- **Collections**: Record customer payments
- **Payments**: Record supplier payments
- **Accounting**: Generate financial reports for reconciliation

---

**Application Status**: Production (Cloud-based at goldbook.in)
**Last Updated**: January 22, 2026
