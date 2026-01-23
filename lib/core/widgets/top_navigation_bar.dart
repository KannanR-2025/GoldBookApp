import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goldbook_desktop/config/theme.dart';

class TopNavigationBar extends StatelessWidget {
  final String currentPath;

  const TopNavigationBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo/Brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primaryGoldDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'GoldBook',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGoldDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Navigation Items
          Expanded(
            child: Row(
              children: [
                _NavItem(
                  label: 'Dashboard',
                  path: '/dashboard',
                  currentPath: currentPath,
                  onTap: () => context.go('/dashboard'),
                ),
                _NavItem(
                  label: 'Customers',
                  path: '/customers',
                  currentPath: currentPath,
                  onTap: () => context.go('/customers'),
                ),
                _NavItem(
                  label: 'Suppliers',
                  path: '/suppliers',
                  currentPath: currentPath,
                  onTap: () => context.go('/suppliers'),
                ),
                _NavDropdown(
                  label: 'Items',
                  currentPath: currentPath,
                  basePath: '/items',
                  items: [
                    _DropdownItem(
                      label: 'Item List',
                      path: '/items',
                      onTap: () => context.go('/items'),
                    ),
                    // Future items
                    // _DropdownItem(
                    //   label: 'Tags',
                    //   path: '/items/tags',
                    //   onTap: () => context.go('/items/tags'),
                    // ),
                  ],
                ),
                _NavDropdown(
                  label: 'Transactions',
                  currentPath: currentPath,
                  basePath: '/sales,/purchases,/receipts,/payments',
                  items: [
                    _DropdownItem(
                      label: 'Sales',
                      path: '/sales',
                      onTap: () => context.go('/sales'),
                    ),
                    _DropdownItem(
                      label: 'Purchase',
                      path: '/purchases',
                      onTap: () => context.go('/purchases'),
                    ),
                    _DropdownItem(
                      label: 'Receipt/Payment',
                      path: '/receipts',
                      onTap: () => context.go('/receipts'),
                    ),
                    _DropdownItem(
                      label: 'Metal Issue',
                      path: '/metal-issue/new',
                      onTap: () => context.go('/metal-issue/new'),
                    ),
                    _DropdownItem(
                      label: 'Metal Receipt',
                      path: '/metal-receipt/new',
                      onTap: () => context.go('/metal-receipt/new'),
                    ),
                    // Future items
                    // _DropdownItem(
                    //   label: 'Metal Issue/Receipt',
                    //   path: '/metal-transactions',
                    //   onTap: () => context.go('/metal-transactions'),
                    // ),
                  ],
                ),
                _NavDropdown(
                  label: 'Accountant',
                  currentPath: currentPath,
                  basePath: '/day-book,/cash-book',
                  items: [
                    _DropdownItem(
                      label: 'Day Book',
                      path: '/day-book',
                      onTap: () => context.go('/day-book'),
                    ),
                    _DropdownItem(
                      label: 'Cash Book',
                      path: '/cash-book',
                      onTap: () => context.go('/cash-book'),
                    ),
                  ],
                ),
                _NavDropdown(
                  label: 'Reports',
                  currentPath: currentPath,
                  basePath: '/reports',
                  items: [
                    _DropdownItem(
                      label: 'All Reports',
                      path: '/reports',
                      onTap: () => context.go('/reports'),
                    ),
                    // Future detailed reports
                  ],
                ),
              ],
            ),
          ),

          // Right side actions
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                // Metal Rate Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppTheme.primaryGold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: AppTheme.primaryGoldDark,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '₹6,450/g',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGoldDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // User menu
                PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.primaryGold,
                    child: Icon(Icons.person, size: 18, color: Colors.white),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline, size: 18),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Logout', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.go('/login');
                    } else if (value == 'settings') {
                      context.go('/settings');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Simple navigation item (no dropdown)
class _NavItem extends StatelessWidget {
  final String label;
  final String path;
  final String currentPath;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.path,
    required this.currentPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentPath.startsWith(path);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppTheme.primaryGoldDark : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppTheme.primaryGoldDark : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

// Navigation dropdown
class _NavDropdown extends StatefulWidget {
  final String label;
  final String currentPath;
  final String basePath; // Can be comma-separated for multiple paths
  final List<_DropdownItem> items;

  const _NavDropdown({
    required this.label,
    required this.currentPath,
    required this.basePath,
    required this.items,
  });

  @override
  State<_NavDropdown> createState() => _NavDropdownState();
}

class _NavDropdownState extends State<_NavDropdown> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final paths = widget.basePath.split(',');
    final isActive = paths.any((p) => widget.currentPath.startsWith(p.trim()));

    return PopupMenuButton<VoidCallback>(
      offset: const Offset(0, 8),
      onOpened: () => setState(() => _isHovered = true),
      onCanceled: () => setState(() => _isHovered = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppTheme.primaryGoldDark : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppTheme.primaryGoldDark
                      : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isHovered
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: isActive
                    ? AppTheme.primaryGoldDark
                    : AppTheme.textPrimary,
              ),
            ],
          ),
        ),
      ),
      itemBuilder: (context) {
        setState(() => _isHovered = false);
        return widget.items
            .map(
              (item) => PopupMenuItem<VoidCallback>(
                value: item.onTap,
                child: Text(item.label),
              ),
            )
            .toList();
      },
      onSelected: (callback) => callback(),
    );
  }
}

class _DropdownItem {
  final String label;
  final String path;
  final VoidCallback onTap;

  _DropdownItem({required this.label, required this.path, required this.onTap});
}
