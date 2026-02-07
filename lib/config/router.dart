import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/features/auth/login_screen.dart';
import 'package:goldbook_desktop/features/dashboard/dashboard_screen.dart';
import 'package:goldbook_desktop/features/parties/screens/parties_screen.dart';
import 'package:goldbook_desktop/features/inventory/items_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/sale_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/purchase_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/receipt_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/payment_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/transactions_list_screen.dart';
import 'package:goldbook_desktop/features/sales/sales_screen.dart';
import 'package:goldbook_desktop/features/purchases/purchases_screen.dart';
import 'package:goldbook_desktop/features/reports/reports_screen.dart';
import 'package:goldbook_desktop/features/reports/day_book_screen.dart';
import 'package:goldbook_desktop/features/reports/cash_book_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/metal_issue_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/metal_receipt_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/stock_transfer_entry_screen.dart';
import 'package:goldbook_desktop/features/transactions/screens/inventory_adjustment_entry_screen.dart';
import 'package:goldbook_desktop/features/settings/screens/settings_screen.dart';
import 'package:goldbook_desktop/features/reports/financial_reports_screen.dart';

import 'package:goldbook_desktop/features/shared/main_layout_topnav.dart';

// Global Keys
final rootNavigatorKey = GlobalKey<NavigatorState>();

// Router configuration
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // Shell Route for Main App Layout
    ShellRoute(
      builder: (context, state, child) {
        return MainLayoutTopNav(currentPath: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/customers',
          builder: (context, state) =>
              const PartiesScreen(partyType: 'Customer'),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) =>
                  const PartyEntryScreen(type: 'Customer'),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return PartyEntryScreen(type: 'Customer', partyId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/suppliers',
          builder: (context, state) =>
              const PartiesScreen(partyType: 'Supplier'),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) =>
                  const PartyEntryScreen(type: 'Supplier'),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return PartyEntryScreen(type: 'Supplier', partyId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/items',
          builder: (context, state) => const ItemsScreen(),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ItemEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return ItemEntryScreen(itemId: id);
              },
            ),
          ],
        ),
        // Sales routes
        GoRoute(
          path: '/sales',
          builder: (context, state) => const SalesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const SaleEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return SaleEntryScreen(transactionId: id);
              },
            ),
          ],
        ),
        // Purchase routes
        GoRoute(
          path: '/purchases',
          builder: (context, state) => const PurchasesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const PurchaseEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return PurchaseEntryScreen(transactionId: id);
              },
            ),
          ],
        ),
        // Receipt routes
        GoRoute(
          path: '/receipts',
          builder: (context, state) =>
              const TransactionsListScreen(typeFilter: 'Receipt'),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ReceiptEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return ReceiptEntryScreen(transactionId: id);
              },
            ),
          ],
        ),
        // Payment routes
        GoRoute(
          path: '/payments',
          builder: (context, state) =>
              const TransactionsListScreen(typeFilter: 'Payment'),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const PaymentEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return PaymentEntryScreen(transactionId: id);
              },
            ),
          ],
        ),
        // Legacy transactions route (can be removed later)
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsListScreen(),
        ),
        // Metal transactions
        GoRoute(
          path: '/metal-issue/new',
          builder: (context, state) => const MetalIssueEntryScreen(),
        ),
        GoRoute(
          path: '/metal-issue/edit/:id',
          builder: (context, state) => MetalIssueEntryScreen(
            transactionId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/metal-receipt/new',
          builder: (context, state) => const MetalReceiptEntryScreen(),
        ),
        GoRoute(
          path: '/metal-receipt/edit/:id',
          builder: (context, state) => MetalReceiptEntryScreen(
            transactionId: int.parse(state.pathParameters['id']!),
          ),
        ),
        // Stock Transfer
        GoRoute(
          path: '/stock-transfer',
          builder: (context, state) =>
              const TransactionsListScreen(typeFilter: 'Stock Transfer'),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const StockTransferEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return StockTransferEntryScreen(transactionId: id);
              },
            ),
          ],
        ),
        // Inventory Adjustment
        GoRoute(
          path: '/inventory-adjustment',
          builder: (context, state) =>
              const TransactionsListScreen(typeFilter: 'Inventory Adjustment'),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) =>
                  const InventoryAdjustmentEntryScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return InventoryAdjustmentEntryScreen(transactionId: id);
              },
            ),
          ],
        ),
        // Accountant module routes
        GoRoute(
          path: '/day-book',
          builder: (context, state) => const DayBookScreen(),
        ),
        GoRoute(
          path: '/cash-book',
          builder: (context, state) => const CashBookScreen(),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/financial-reports',
          builder: (context, state) => const FinancialReportsScreen(),
        ),
      ],
    ),
  ],
);
