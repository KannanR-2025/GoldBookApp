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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                      _DropdownItem(
                        label: 'Stock Transfer',
                        path: '/stock-transfer',
                        onTap: () => context.go('/stock-transfer'),
                      ),
                      _DropdownItem(
                        label: 'Inventory Adjustment',
                        path: '/inventory-adjustment',
                        onTap: () => context.go('/inventory-adjustment'),
                      ),
                      // Future items
                      // _DropdownItem(
                      //   label: 'Tags',
                      //   path: '/items/tags',
                      //   onTap: () => context.go('/items/tags'),
                      // ),
                    ],
                  ),
                  _MegaNavDropdown(
                    label: 'Transactions',
                    currentPath: currentPath,
                    basePath:
                        '/sales,/purchases,/receipts,/payments,/metal-in-out,/metal-issue,/metal-receipt,/approval',
                    columns: [
                      _MegaColumn(
                        header: 'Sales',
                        items: [
                          _MegaItem(
                            label: 'Sales',
                            icon: Icons.shopping_cart_outlined,
                            onTap: () => context.go('/sales'),
                          ),
                          _MegaItem(
                            label: 'Sales Return',
                            icon: Icons.refresh,
                            onTap: () => _showCoomingSoon(context),
                          ), // Placeholder
                          _MegaItem(
                            label: 'Receipt',
                            icon: Icons.download,
                            onTap: () => context.go('/receipts'),
                          ), // Reused /receipts for now
                          _MegaItem(
                            label: 'Approval Issue',
                            icon: Icons.assignment_turned_in_outlined,
                            onTap: () => _showCoomingSoon(context),
                          ), // Placeholder
                        ],
                      ),
                      _MegaColumn(
                        header: 'Purchase',
                        items: [
                          _MegaItem(
                            label: 'Purchase',
                            icon: Icons.shopping_bag_outlined,
                            onTap: () => context.go('/purchases'),
                          ),
                          _MegaItem(
                            label: 'Purchase Return',
                            icon: Icons.refresh,
                            onTap: () => _showCoomingSoon(context),
                          ), // Placeholder
                          _MegaItem(
                            label: 'Payment',
                            icon: Icons.upload,
                            onTap: () => context.go('/payments'),
                          ), // Reused /payments (mapped to receipts)?? No, usually separate logic, but routing to /receipts/new with type 'Payment'
                          _MegaItem(
                            label: 'Approval Receive',
                            icon: Icons.assignment_return_outlined,
                            onTap: () => _showCoomingSoon(context),
                          ), // Placeholder
                        ],
                      ),
                      _MegaColumn(
                        header: 'Other',
                        items: [
                          _MegaItem(
                            label: 'Rate-Cut',
                            icon: Icons.currency_rupee,
                            onTap: () => context.go('/rate-cut/new'),
                          ),
                          _MegaItem(
                            label: 'Daily Cash',
                            icon: Icons.savings_outlined,
                            onTap: () => context.go('/cash-book'),
                          ), // Mapping to Cash Book
                          _MegaItem(
                            label: 'Metal In/Out',
                            icon: Icons.swap_vert,
                            onTap: () => context.go('/metal-in-out'),
                          ),
                        ],
                      ),
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

  void _showCoomingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Feature Coming Soon')));
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

// --- Mega Menu Implementation ---

class _MegaNavDropdown extends StatefulWidget {
  final String label;
  final String currentPath;
  final String basePath; // comma separated
  final List<_MegaColumn> columns;

  const _MegaNavDropdown({
    required this.label,
    required this.currentPath,
    required this.basePath,
    required this.columns,
  });

  @override
  State<_MegaNavDropdown> createState() => _MegaNavDropdownState();
}

class _MegaNavDropdownState extends State<_MegaNavDropdown> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Full screen transparent detector to close menu when clicking outside
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() => _isHovered = false);
                  _removeOverlay();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            // The Menu
            Positioned(
              width: 600, // Fixed width for Mega Menu
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 50), // Drop down below
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.columns.asMap().entries.map((entry) {
                          final index = entry.key;
                          final col = entry.value;
                          return Expanded(
                            child: Container(
                              decoration: index < widget.columns.length - 1
                                  ? const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: AppTheme.borderLight,
                                        ),
                                      ),
                                    )
                                  : null,
                              padding: EdgeInsets.only(
                                left: index == 0 ? 0 : 24,
                                right: index == widget.columns.length - 1
                                    ? 0
                                    : 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    col.header.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...col.items.map(
                                    (item) => _MegaItemWidget(
                                      item: item,
                                      onTap: () {
                                        setState(() => _isHovered = false);
                                        _removeOverlay();
                                        item.onTap();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paths = widget.basePath.split(',');
    final isActive = paths.any((p) => widget.currentPath.startsWith(p.trim()));

    // Logic to show/hide overlay based on hover state
    // Note: In Flutter Web/Desktop, MouseRegion doesn't perfectly handle "hovering over the overlay" logic
    // without complex hit testing if the overlay is separate.
    // However, clicking label opens it (toggle).

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter:
            (
              _,
            ) {}, // Could auto-open, but click is safer for Overlay management
        child: InkWell(
          onTap: () {
            if (_overlayEntry == null) {
              setState(() => _isHovered = true);
              _showOverlay();
            } else {
              setState(() => _isHovered = false);
              _removeOverlay();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive
                      ? AppTheme.primaryGoldDark
                      : Colors.transparent,
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
                  _isHovered // Use local state or check overlay
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
      ),
    );
  }
}

class _MegaColumn {
  final String header;
  final List<_MegaItem> items;
  _MegaColumn({required this.header, required this.items});
}

class _MegaItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  _MegaItem({required this.label, required this.icon, required this.onTap});
}

class _MegaItemWidget extends StatelessWidget {
  final _MegaItem item;
  final VoidCallback onTap;

  const _MegaItemWidget({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      hoverColor: Colors.grey.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
