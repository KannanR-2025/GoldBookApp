import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              border: Border(
                right: BorderSide(color: AppTheme.borderLight, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo Area
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.borderLight, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: AppTheme.primaryGold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'GoldBook',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    children: [
                      _NavItem(
                        icon: Icons.dashboard_outlined,
                        label: 'Dashboard',
                        isSelected: currentPath == '/dashboard',
                        onTap: () => context.go('/dashboard'),
                      ),
                      _NavItem(
                        icon: Icons.people_outline,
                        label: 'Customers',
                        isSelected: currentPath == '/customers',
                        onTap: () => context.go('/customers'),
                      ),
                      _NavItem(
                        icon: Icons.store_outlined,
                        label: 'Suppliers',
                        isSelected: currentPath == '/suppliers',
                        onTap: () => context.go('/suppliers'),
                      ),
                      _NavItem(
                        icon: Icons.inventory_2_outlined,
                        label: 'Items',
                        isSelected: currentPath == '/items',
                        onTap: () => context.go('/items'),
                      ),
                      _ExpandableNavItem(
                        icon: Icons.receipt_long_outlined,
                        label: 'Transactions',
                        isExpanded:
                            currentPath.startsWith('/sales') ||
                            currentPath.startsWith('/purchases') ||
                            currentPath.startsWith('/receipts') ||
                            currentPath.startsWith('/payments') ||
                            currentPath == '/transactions',
                        children: [
                          _NavItem(
                            icon: Icons.shopping_cart_outlined,
                            label: 'Sales',
                            isSelected: currentPath == '/sales',
                            onTap: () => context.go('/sales'),
                            isSubItem: true,
                          ),
                          _NavItem(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Purchases',
                            isSelected: currentPath == '/purchases',
                            onTap: () => context.go('/purchases'),
                            isSubItem: true,
                          ),
                          _NavItem(
                            icon: Icons.arrow_downward,
                            label: 'Receipts',
                            isSelected: currentPath == '/receipts',
                            onTap: () => context.go('/receipts'),
                            isSubItem: true,
                          ),
                          _NavItem(
                            icon: Icons.arrow_upward,
                            label: 'Payments',
                            isSelected: currentPath == '/payments',
                            onTap: () => context.go('/payments'),
                            isSubItem: true,
                          ),
                        ],
                      ),
                      _NavItem(
                        icon: Icons.assessment_outlined,
                        label: 'Reports',
                        isSelected: currentPath == '/reports',
                        onTap: () => context.go('/reports'),
                      ),
                    ],
                  ),
                ),

                // User Profile / Bottom Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.borderLight, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'K',
                            style: TextStyle(
                              color: AppTheme.primaryGoldDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kannan',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            Text(
                              'Admin',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 20),
                        color: AppTheme.textSecondary,
                        onPressed: () => context.go('/login'),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    border: Border(
                      bottom: BorderSide(color: AppTheme.borderLight, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getPageTitle(currentPath),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                      ),
                      // Search Bar
                      Container(
                        width: 300,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: AppTheme.textTertiary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            hintStyle: TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Notifications
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              size: 24,
                              color: AppTheme.textSecondary,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                        tooltip: 'Notifications',
                      ),
                    ],
                  ),
                ),
                // Page Content
                Expanded(
                  child: Container(
                    color: AppTheme.backgroundLight,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(String path) {
    if (path.startsWith('/sales')) return 'Sales';
    if (path.startsWith('/purchases')) return 'Purchases';
    if (path.startsWith('/receipts')) return 'Receipts';
    if (path.startsWith('/payments')) return 'Payments';

    switch (path) {
      case '/dashboard':
        return 'Dashboard';
      case '/customers':
        return 'Customers';
      case '/suppliers':
        return 'Suppliers';
      case '/items':
        return 'Inventory Items';
      case '/transactions':
        return 'Transactions';
      case '/reports':
        return 'Reports';
      default:
        return 'GoldBook';
    }
  }
}

class _ExpandableNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isExpanded;
  final List<Widget> children;

  const _ExpandableNavItem({
    required this.icon,
    required this.label,
    required this.isExpanded,
    required this.children,
  });

  @override
  State<_ExpandableNavItem> createState() => _ExpandableNavItemState();
}

class _ExpandableNavItemState extends State<_ExpandableNavItem> {
  bool _localExpanded = false;

  @override
  void initState() {
    super.initState();
    _localExpanded = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant _ExpandableNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded && widget.isExpanded) {
      _localExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NavItem(
          icon: widget.icon,
          label: widget.label,
          isSelected: widget.isExpanded,
          onTap: () => setState(() => _localExpanded = !_localExpanded),
          trailing: Icon(
            _localExpanded ? Icons.expand_less : Icons.expand_more,
            size: 16,
            color: widget.isExpanded
                ? AppTheme.primaryGoldDark
                : AppTheme.textSecondary,
          ),
        ),
        if (_localExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(children: widget.children),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSubItem;
  final Widget? trailing;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSubItem = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected && !isSubItem
                  ? AppTheme.primaryGold.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected && !isSubItem
                  ? Border.all(
                      color: AppTheme.primaryGold.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: isSubItem ? 18 : 20,
                  color: isSelected
                      ? AppTheme.primaryGoldDark
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryGoldDark
                          : AppTheme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: isSubItem ? 13 : 14,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  trailing!,
                ] else if (isSelected) ...[
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryGoldDark,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
