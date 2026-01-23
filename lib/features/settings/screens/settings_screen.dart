import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/features/settings/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Company'),
            Tab(text: 'User Profile'),
            Tab(text: 'Preferences'),
            Tab(text: 'Tax'),
            Tab(text: 'Items'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCompanySettingsTab(),
          _buildUserProfileTab(),
          _buildPreferencesTab(),
          _buildTaxSettingsTab(),
          _buildItemSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildCompanySettingsTab() {
    final companySettings = ref.watch(companySettingsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildSettingField(
                label: 'Company Name',
                initialValue: companySettings.companyName,
                onChanged: (value) {
                  // Stub - not implemented
                  // ref.read(companySettingsProvider.notifier).updateCompanyName(value);
                },
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'Company Code',
                initialValue: companySettings.companyCode ?? '',
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'Address Line 1',
                initialValue: companySettings.address ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSettingField(
                      label: 'City',
                      initialValue: companySettings.city ?? '',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSettingField(
                      label: 'State',
                      initialValue: companySettings.state ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSettingField(
                      label: 'Country',
                      initialValue: companySettings.country ?? '',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSettingField(
                      label: 'PIN Code',
                      initialValue: companySettings.pinCode ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'GSTIN',
                initialValue: companySettings.gstin ?? '',
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'PAN Number',
                initialValue: companySettings.panNumber ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSettingField(
                      label: 'Phone',
                      initialValue: companySettings.phone ?? '',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSettingField(
                      label: 'Email',
                      initialValue: companySettings.email ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'Website',
                initialValue: companySettings.website ?? '',
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Company settings saved successfully'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileTab() {
    final userSettings = ref.watch(userSettingsProvider);
    final fullNameCtrl = TextEditingController(text: userSettings.fullName);
    final emailCtrl = TextEditingController(text: userSettings.email ?? '');
    final passwordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryGold.withValues(
                        alpha: 0.2,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile picture upload coming soon'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload Profile Picture'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSettingField(
                label: 'Username',
                initialValue: userSettings.username ?? '',
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildSettingField(label: 'Full Name', controller: fullNameCtrl),
              const SizedBox(height: 16),
              _buildSettingField(label: 'Email', controller: emailCtrl),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Role: ${userSettings.role ?? 'User'}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Change Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'Current Password',
                controller: passwordCtrl,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'New Password',
                controller: passwordCtrl,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildSettingField(
                label: 'Confirm Password',
                controller: confirmPasswordCtrl,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Stub - not implemented
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Profile'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password changed successfully'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock),
                    label: const Text('Change Password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesTab() {
    final preferences = ref.watch(appPreferencesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Application Preferences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildDropdownField(
                label: 'Date Format',
                value: preferences.dateFormat,
                items: ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd'],
                onChanged: (value) {
                  // Stub - not implemented
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Currency Symbol',
                value: preferences.currencySymbol ?? '₹',
                items: ['₹', '\$', '€', '£', '¥'],
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Number Format',
                value: preferences.numberFormat ?? 'en_IN',
                items: ['en_IN', 'en_US', 'de_DE', 'fr_FR'],
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Decimal Places',
                value: (preferences.decimalPlaces ?? 2).toString(),
                items: ['1', '2', '3', '4', '5'],
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Default Weight Unit',
                value: preferences.defaultUnit ?? 'grams',
                items: ['grams', 'kg', 'milligrams'],
              ),
              const SizedBox(height: 32),
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: preferences.darkMode ?? false,
                onChanged: (value) {
                  // Stub - not implemented
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Backup Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Automatic Backup'),
                subtitle: const Text('Automatically backup data daily'),
                value: preferences.autoBackup ?? false,
                onChanged: (value) {
                  // Handle auto backup toggle
                },
              ),
              const SizedBox(height: 16),
              if (preferences.autoBackup == true)
                _buildDropdownField(
                  label: 'Backup Frequency (Days)',
                  value: (preferences.backupFrequencyDays ?? 7).toString(),
                  items: ['1', '7', '14', '30'],
                ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preferences saved successfully'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Preferences'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaxSettingsTab() {
    final taxSettings = ref.watch(taxSettingsProvider);
    final gstRateCtrl = TextEditingController(
      text: taxSettings.gstRate.toString(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tax Configuration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildSettingField(
                label: 'GST Rate (%)',
                controller: gstRateCtrl,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Apply GST by Default'),
                value: taxSettings.applyGstByDefault ?? false,
                onChanged: (value) {
                  // Handle toggle
                },
              ),
              const SizedBox(height: 32),
              Text(
                'GST Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...(taxSettings.gstCategories ?? []).map((category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(category)),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tax settings saved successfully'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Tax Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemSettingsTab() {
    final itemSettings = ref.watch(itemSettingsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item Configuration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              Text(
                'Metal Types',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...(itemSettings.metals ?? []).map((metal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(metal),
                  ),
                );
              }),
              const SizedBox(height: 32),
              Text(
                'Purity Standards',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...(itemSettings.purities ?? []).map((purity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(purity)),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Stub - not implemented
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddPurityDialog();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Purity'),
              ),
              const SizedBox(height: 32),
              Text(
                'Item Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ...(itemSettings.itemCategories ?? []).map((category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(category),
                  ),
                );
              }),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item settings saved successfully'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Item Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingField({
    required String label,
    String initialValue = '',
    TextEditingController? controller,
    Function(String)? onChanged,
    bool enabled = true,
    bool obscureText = false,
  }) {
    final ctrl = controller ?? TextEditingController(text: initialValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          onChanged: onChanged,
          enabled: enabled,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddPurityDialog() {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Purity'),
        content: TextField(
          controller: textCtrl,
          decoration: InputDecoration(
            hintText: 'E.g., 585 or 14K',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textCtrl.text.isNotEmpty) {
                // Stub - not implemented
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
