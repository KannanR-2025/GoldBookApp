# GoldBook Flutter Desktop - Quick Reference Guide

## New Features Added (January 22, 2026)

### 1. Settings Module

#### Access
- Click user avatar/menu in top right → Select "Settings"
- Or navigate to `/settings`

#### Features Available:
1. **Company Settings**
   - Update company name, address, contact info
   - Configure GSTIN, PAN, website
   - Save company branding

2. **User Profile**
   - Update full name and email
   - Change password
   - Upload profile picture
   - View current role

3. **Preferences**
   - Choose date format (dd/MM/yyyy, MM/dd/yyyy, etc)
   - Set currency symbol
   - Configure number format
   - Adjust decimal places
   - Enable/disable dark mode
   - Configure auto-backup

4. **Tax Settings**
   - Set GST rate
   - Configure tax categories
   - Manage tax exemptions

5. **Items Configuration**
   - View metal types (Gold, Silver)
   - Manage purity standards
   - Add custom purities (click "Add Purity")
   - Configure item categories

---

### 2. Enhanced Authentication

#### Login Credentials (Demo):

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | Admin@123 |
| Accountant | kannan04 | Test@123 |
| Operator | operator | Operator@123 |

#### Features:
- Real credential validation (not mock)
- Error messages for invalid login
- User role assignment
- Session tracking
- Remember me option (coming soon)

---

### 3. Financial Reports

#### Access
- Reports → Financial Reports (new menu item)
- Or navigate to `/financial-reports`

#### Available Reports:

1. **P&L Statement**
   - Revenue calculation
   - Cost of Goods Sold
   - Gross Profit
   - Operating Expenses
   - Net Profit/Loss
   - Summary metrics

2. **Balance Sheet**
   - Assets (Cash, Inventory, Receivables)
   - Liabilities (Supplier Payables)
   - Equity
   - Balance verification
   - Print-friendly format

3. **Trial Balance**
   - All accounts with debit/credit
   - Automatic balance verification
   - Validation status display

#### Features:
- ✅ Date range selection
- ✅ Automatic calculations
- ✅ Summary cards
- ✅ Refresh data
- ✅ Professional formatting

---

### 4. Advanced Search & Filtering

#### Where Available:
- Customers list
- Suppliers list
- Transactions list
- Items list
- (Can be integrated into all list screens)

#### Filter Types:

**For Parties (Customers/Suppliers):**
- Search by name, email, or phone
- Filter by party type
- Filter by balance range
- Sort by name or balance
- Ascending/descending

**For Transactions:**
- Search by party name or remarks
- Filter by transaction type (Sale, Purchase, Receipt, Payment)
- Filter by date range
- Filter by specific party
- Filter by amount range
- Sort by date, amount, or party

**For Items:**
- Search by name or purity
- Filter by metal type (Gold/Silver)
- Filter by specific purity
- Filter by minimum stock
- Sort by name, stock, or type

#### Features:
- Real-time filtering
- Multiple filters combine automatically
- Reset filters button
- Persistent filter state

---

### 5. PDF Export Service

#### Available For:
- Sales Report
- Purchase Report
- Custom report exports

#### Features:
- Professional document formatting
- Summary information
- Tables with proper formatting
- Header and footer
- Currency formatting
- Date formatting
- Page breaks

#### Usage:
1. Open any report
2. Click "Export to PDF" button (when implemented in reports)
3. Choose save location
4. Document downloads in PDF format

---

## Keyboard Shortcuts (Coming Soon)

| Action | Shortcut |
|--------|----------|
| New Transaction | Ctrl + N |
| Search | Ctrl + F |
| Save | Ctrl + S |
| Print | Ctrl + P |
| Settings | Ctrl + , |
| Dashboard | Ctrl + H |

---

## Tips & Tricks

### Settings
- Settings are saved automatically
- Changes take effect immediately
- Refresh browser if needed

### Filtering
- Use multiple filters together
- Filters reset when navigating away (unless saved as preset)
- Search is case-insensitive

### Reports
- Use date range to filter data
- Reports calculate in real-time
- Export before leaving the screen

### Authentication
- Password is case-sensitive
- First login may take a moment
- Session lasts 8 hours
- Click logout to end session immediately

---

## Common Issues & Solutions

### Issue: Settings not saving
**Solution**: 
- Refresh the page
- Check that all required fields are filled
- Verify you have "admin" role

### Issue: Filters not working
**Solution**:
- Clear search text
- Reset filters using "Reset" button
- Refresh the page

### Issue: Reports showing no data
**Solution**:
- Verify date range is correct
- Check that transactions exist in that date range
- Refresh the page

### Issue: PDF export failing
**Solution**:
- Check browser download settings
- Ensure popup is not blocked
- Try a different browser

---

## Role-Based Features

### Admin
- ✅ All features
- ✅ Settings management
- ✅ User management
- ✅ Full report access

### Accountant
- ✅ Report viewing
- ✅ Transaction entry
- ✅ Customer/Supplier management
- ✅ Financial reports
- ⛔ No user management
- ⛔ Limited settings

### Operator
- ✅ Transaction entry
- ✅ Basic reports
- ✅ Party management (view only)
- ⛔ No financial reports
- ⛔ No settings

---

## Database Backup

### Automatic Backup
- Configure in Settings → Preferences
- Enable "Automatic Backup"
- Set frequency (daily, weekly, monthly)
- Backups stored locally

### Manual Backup
- Coming soon
- Export all data to file
- Import from backup file

---

## Performance Tips

1. **Filtering**: Use filters before exporting large reports
2. **Reports**: Select specific date range to reduce data load
3. **Search**: Use specific keywords for faster results
4. **Settings**: Save changes before navigating away

---

## FAQ

**Q: How do I reset my password?**
A: Click "Forgot Password?" on login screen (feature coming soon)

**Q: Can I add more users?**
A: Yes, Admin users can manage users in Settings (feature coming soon)

**Q: How often should I backup?**
A: Recommend daily backups for production use

**Q: Can I export to Excel?**
A: PDF export available now; Excel coming soon

**Q: What formats are supported for import?**
A: CSV and Excel (coming soon)

**Q: How do I change my company logo?**
A: Upload in Settings → Company Tab (feature coming soon)

**Q: Can I use dark mode?**
A: Yes, enable in Settings → Preferences → Dark Mode toggle

**Q: How do I view audit logs?**
A: Coming soon in Settings → Audit section

---

## Getting Help

### Documentation
- Hover over fields for tooltips
- Check settings screen for explanations
- Read field labels carefully

### Support
- Contact: support@goldbook.in
- Bugs: report@goldbook.in
- Feature requests: features@goldbook.in

---

## Version Info

**GoldBook Desktop**
- Version: 2.0.0
- Build: January 22, 2026
- Platform: Flutter Desktop (macOS)
- Features: Full web app parity

---

**Last Updated**: January 22, 2026
**Next Update**: February 2026 (Mobile version)

