# GoldBook Application - Complete Details

## Overview
**GoldBook** is a comprehensive Jewellery Accounting & Management System designed for gold and silver jewelry businesses. The application manages customers, suppliers, inventory, transactions, and financial tracking.

## Application Type
- **Platform**: Flutter Desktop Application (macOS)
- **Web Version**: Available at https://goldbook.in/
- **Database**: SQLite (using Drift ORM)
- **State Management**: Riverpod
- **Routing**: GoRouter

## Core Features

### 1. Authentication
- **Login Screen**: Username/Password authentication
- **Mock Authentication**: Currently accepts any non-empty credentials
- **Session Management**: Routes to dashboard after successful login

### 2. Dashboard
The dashboard provides a comprehensive overview with:

#### Summary Cards:
- **Gold Rate (24k)**: Current gold rate display
- **Gold Stock**: Total gold inventory in grams
- **Silver Stock**: Total silver inventory in grams
- **Customer Gold Balance**: Total gold balance across all customers
- **Customer Cash Balance**: Total cash balance across all customers

#### Charts & Analytics:
- **Sales Overview**: Bar chart showing weekly sales data
- **Top Customers**: List of top customers with gold balances

### 3. Parties Management

#### Customers
- Complete customer database with:
  - **General Information**:
    - Customer Type (Business/Individual)
    - Code, Company Name, Display Name
    - Contact Person, Mobile, Work Phone
    - Email, Preferred Courier
  - **Address Details**:
    - Address Line 1 & 2
    - Landmark, City, State, Country, PIN Code
  - **Financial Information**:
    - Opening Balances (Gold, Silver, Cash)
    - Credit Limits (Gold, Cash)
    - GSTIN, PAN Number
    - Tax Preference (Taxable/Tax Exempt)
  - **Notes**: Internal notes field

- **Balance Tracking**:
  - Gold Balance (in grams)
  - Silver Balance (in grams)
  - Cash Balance (in ₹)
  - Color-coded display (Green: Positive, Red: Negative)

#### Suppliers
- Similar structure to customers
- Supports "Karigar / Individual" type for suppliers
- Tracks supplier balances and credit limits

### 4. Inventory Management

#### Items
- **Item Properties**:
  - Name
  - Metal Type (Gold/Silver)
  - Purity (e.g., 916, 750)
  - Stock Quantity
  - Total Weight (in grams)

- **Stock Tracking**: Real-time inventory management

### 5. Transactions

#### Transaction Types:
1. **Sale**: Selling jewelry to customers
2. **Purchase**: Buying from suppliers
3. **Receipt**: Receiving payment/metal from customers
4. **Payment**: Paying suppliers

#### Transaction Entry:
- **Header Information**:
  - Transaction Type
  - Party Selection (Customer/Supplier based on type)
  - Date
  - Remarks

- **Transaction Lines**:
  - Multiple line items per transaction
  - Item Selection (from inventory)
  - Description
  - Gross Weight
  - Net Weight
  - Purity (%)
  - Amount

- **Automatic Calculations**:
  - Fine Gold = Net Weight × (Purity / 100)
  - Total Fine Gold across all lines
  - Total Amount

- **Balance Updates**:
  - Automatically updates party balances based on transaction type
  - Updates inventory stock levels

#### Transaction List:
- View all transactions
- Shows party name, transaction type, date
- Displays gold weight and total amount
- Color-coded transaction icons

### 6. Reports
- Placeholder screen (to be implemented)
- Expected to include:
  - Financial reports
  - Inventory reports
  - Customer/Supplier statements
  - Transaction history

## Database Schema

### Tables:

#### 1. Parties
- **Primary Key**: id (auto-increment)
- **Type**: Customer or Supplier
- **Contact Info**: name, mobile, email, companyName, code, contactPerson, workPhone, courier
- **Address**: addressLine1, addressLine2, landmark, city, state, country, pinCode
- **Tax**: gstin, panNumber, taxPreference
- **Balances**: 
  - openingGoldBalance, openingSilverBalance, openingCashBalance
  - goldBalance, silverBalance, cashBalance
- **Limits**: creditLimitGold, creditLimitCash
- **Metadata**: notes, createdAt

#### 2. Items
- **Primary Key**: id (auto-increment)
- **Properties**: name, metalType, purity
- **Stock**: stockQty, stockWeight

#### 3. Transactions
- **Primary Key**: id (auto-increment)
- **Foreign Key**: partyId → Parties.id
- **Properties**: date, type, totalGoldWeight, totalSilverWeight, totalAmount, remarks

#### 4. TransactionLines
- **Primary Key**: id (auto-increment)
- **Foreign Keys**: 
  - transactionId → Transactions.id
  - itemId → Items.id (nullable)
- **Properties**: 
  - description, grossWeight, netWeight, purity
  - stoneWeight, wastage, makingCharges
  - rate, amount

## Technical Stack

### Dependencies:
- **flutter_riverpod**: ^3.2.0 - State management
- **go_router**: ^17.0.1 - Navigation/routing
- **fl_chart**: ^1.1.1 - Charts and graphs
- **google_fonts**: ^7.0.2 - Typography
- **intl**: ^0.20.2 - Internationalization/formatting
- **drift**: ^2.30.1 - SQLite ORM
- **sqlite3**: ^2.9.4 - SQLite database
- **path_provider**: ^2.1.5 - File system paths

### Architecture:
- **Feature-based folder structure**
- **Repository pattern** for data access
- **Provider pattern** for state management
- **Database**: Local SQLite database stored in application documents directory

## UI/UX Design

### Theme:
- **Primary Color**: Gold (#D4AF37)
- **Background**: Light gray (#F5F5F7)
- **Typography**: Google Fonts (Inter)
- **Material Design 3**: Enabled

### Layout:
- **Sidebar Navigation**: 250px width
- **Main Content Area**: Responsive
- **Card-based Design**: Clean, modern interface
- **Color Coding**: 
  - Green for positive balances
  - Red for negative balances
  - Gold accents throughout

### Navigation Structure:
```
/login
/dashboard
/customers
/suppliers
/items
/transactions
  /transactions/new
/reports
```

## Key Business Logic

### Balance Calculation:
- **Sale Transaction**: 
  - Increases customer gold balance (they owe gold)
  - Increases cash receivable
  - Decreases inventory stock

- **Purchase Transaction**:
  - Decreases supplier gold balance (we owe them)
  - Increases cash payable
  - Increases inventory stock

- **Receipt Transaction**:
  - Decreases customer balances (payment received)

- **Payment Transaction**:
  - Increases supplier balances (payment made)

### Fine Gold Calculation:
```
Fine Gold = Net Weight × (Purity / 100)
```

## Current Status

### Implemented:
✅ Authentication (mock)
✅ Dashboard with summary cards and charts
✅ Customer/Supplier management (CRUD)
✅ Inventory items management
✅ Transaction entry and listing
✅ Database schema and repositories
✅ Balance tracking and updates

### Pending/Placeholder:
⏳ Reports module
⏳ Sales module (separate from transactions)
⏳ Purchases module (separate from transactions)
⏳ Real authentication (currently mock)
⏳ Advanced reporting and analytics
⏳ Print/Export functionality
⏳ Multi-user support
⏳ Data backup/restore

## File Structure
```
lib/
├── config/
│   ├── router.dart          # Navigation routes
│   └── theme.dart            # App theme and styling
├── core/
│   └── database/
│       ├── database.dart     # Database schema
│       └── database.g.dart   # Generated code
├── features/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── parties/
│   │   ├── data/
│   │   │   └── parties_repository.dart
│   │   ├── providers/
│   │   │   └── parties_provider.dart
│   │   └── screens/
│   │       └── parties_screen.dart
│   ├── inventory/
│   │   ├── items_provider.dart
│   │   └── items_screen.dart
│   ├── transactions/
│   │   ├── data/
│   │   │   └── transactions_repository.dart
│   │   ├── providers/
│   │   │   └── transactions_provider.dart
│   │   └── screens/
│   │       ├── transaction_entry_screen.dart
│   │       └── transactions_list_screen.dart
│   └── shared/
│       ├── main_layout.dart
│       └── mock_data.dart
└── main.dart
```

## Notes for Web Application Exploration

Since I cannot directly access the live website at https://goldbook.in/, the above documentation is based on the Flutter desktop application codebase. The web version may have:

1. **Additional Features**: Features not yet implemented in the desktop version
2. **Different UI**: Web-optimized interface
3. **Backend Integration**: API calls instead of local database
4. **User Management**: Multi-user authentication and permissions
5. **Cloud Storage**: Data stored on servers instead of locally
6. **Real-time Updates**: Live gold rate updates, notifications
7. **Mobile Responsiveness**: Responsive design for tablets/phones

To get complete details of the web application, you would need to:
- Manually browse the website
- Test all features with the provided credentials
- Document the UI/UX differences
- Note any additional features not in the desktop version
- Check API endpoints and backend architecture (if accessible)

---

**Generated**: Based on Flutter Desktop Application Codebase
**Web URL**: https://goldbook.in/
**Login Credentials Provided**: 
- Username: kannan04
- Password: Test@123
