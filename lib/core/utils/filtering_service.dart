import 'package:goldbook_desktop/core/database/database.dart';

// Filter Models
class PartyFilter {
  final String? searchText;
  final String? type;
  final double? minBalance;
  final double? maxBalance;
  final String sortBy;
  final bool sortDescending;

  const PartyFilter({
    this.searchText,
    this.type,
    this.minBalance,
    this.maxBalance,
    this.sortBy = 'name',
    this.sortDescending = false,
  });

  PartyFilter copyWith({
    String? searchText,
    String? type,
    double? minBalance,
    double? maxBalance,
    String? sortBy,
    bool? sortDescending,
  }) {
    return PartyFilter(
      searchText: searchText ?? this.searchText,
      type: type ?? this.type,
      minBalance: minBalance ?? this.minBalance,
      maxBalance: maxBalance ?? this.maxBalance,
      sortBy: sortBy ?? this.sortBy,
      sortDescending: sortDescending ?? this.sortDescending,
    );
  }
}

class TransactionFilter {
  final String? searchText;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? partyId;
  final double? minAmount;
  final double? maxAmount;
  final String sortBy;
  final bool sortDescending;

  const TransactionFilter({
    this.searchText,
    this.type,
    this.startDate,
    this.endDate,
    this.partyId,
    this.minAmount,
    this.maxAmount,
    this.sortBy = 'date',
    this.sortDescending = true,
  });

  TransactionFilter copyWith({
    String? searchText,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? partyId,
    double? minAmount,
    double? maxAmount,
    String? sortBy,
    bool? sortDescending,
  }) {
    return TransactionFilter(
      searchText: searchText ?? this.searchText,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      partyId: partyId ?? this.partyId,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      sortBy: sortBy ?? this.sortBy,
      sortDescending: sortDescending ?? this.sortDescending,
    );
  }
}

class ItemFilter {
  final String? searchText;
  final String? metalType;
  final String? purity;
  final double? minStock;
  final String sortBy;
  final bool sortDescending;

  const ItemFilter({
    this.searchText,
    this.metalType,
    this.purity,
    this.minStock,
    this.sortBy = 'name',
    this.sortDescending = false,
  });

  ItemFilter copyWith({
    String? searchText,
    String? metalType,
    String? purity,
    double? minStock,
    String? sortBy,
    bool? sortDescending,
  }) {
    return ItemFilter(
      searchText: searchText ?? this.searchText,
      metalType: metalType ?? this.metalType,
      purity: purity ?? this.purity,
      minStock: minStock ?? this.minStock,
      sortBy: sortBy ?? this.sortBy,
      sortDescending: sortDescending ?? this.sortDescending,
    );
  }
}

// Filtering Utilities
class FilteringService {
  static List<Party> filterParties(List<Party> parties, PartyFilter filter) {
    var filtered = parties;

    if (filter.searchText != null && filter.searchText!.isNotEmpty) {
      final searchLower = filter.searchText!.toLowerCase();
      filtered = filtered
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchLower) ||
                (p.email?.toLowerCase().contains(searchLower) ?? false) ||
                p.mobile.contains(searchLower),
          )
          .toList();
    }

    if (filter.type != null) {
      filtered = filtered.where((p) => p.type == filter.type).toList();
    }

    if (filter.minBalance != null) {
      filtered = filtered
          .where((p) => p.cashBalance >= filter.minBalance!)
          .toList();
    }
    if (filter.maxBalance != null) {
      filtered = filtered
          .where((p) => p.cashBalance <= filter.maxBalance!)
          .toList();
    }

    if (filter.sortBy == 'name') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.name.compareTo(a.name)
            : a.name.compareTo(b.name),
      );
    } else if (filter.sortBy == 'balance') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.cashBalance.compareTo(a.cashBalance)
            : a.cashBalance.compareTo(b.cashBalance),
      );
    }

    return filtered;
  }

  static List<Transaction> filterTransactions(
    List<Transaction> transactions,
    TransactionFilter filter,
  ) {
    var filtered = transactions;

    if (filter.searchText != null && filter.searchText!.isNotEmpty) {
      final searchLower = filter.searchText!.toLowerCase();
      filtered = filtered
          .where(
            (t) => (t.remarks?.toLowerCase().contains(searchLower) ?? false),
          )
          .toList();
    }

    if (filter.type != null) {
      filtered = filtered.where((t) => t.type == filter.type).toList();
    }

    if (filter.startDate != null) {
      filtered = filtered
          .where(
            (t) => t.date.isAfter(
              filter.startDate!.subtract(const Duration(days: 1)),
            ),
          )
          .toList();
    }
    if (filter.endDate != null) {
      filtered = filtered
          .where(
            (t) =>
                t.date.isBefore(filter.endDate!.add(const Duration(days: 1))),
          )
          .toList();
    }

    if (filter.partyId != null) {
      filtered = filtered.where((t) => t.partyId == filter.partyId).toList();
    }

    if (filter.minAmount != null) {
      filtered = filtered
          .where((t) => t.totalAmount >= filter.minAmount!)
          .toList();
    }
    if (filter.maxAmount != null) {
      filtered = filtered
          .where((t) => t.totalAmount <= filter.maxAmount!)
          .toList();
    }

    if (filter.sortBy == 'date') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.date.compareTo(a.date)
            : a.date.compareTo(b.date),
      );
    } else if (filter.sortBy == 'amount') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.totalAmount.compareTo(a.totalAmount)
            : a.totalAmount.compareTo(b.totalAmount),
      );
    }

    return filtered;
  }

  static List<Item> filterItems(List<Item> items, ItemFilter filter) {
    var filtered = items;

    if (filter.searchText != null && filter.searchText!.isNotEmpty) {
      final searchLower = filter.searchText!.toLowerCase();
      filtered = filtered
          .where((i) => i.name.toLowerCase().contains(searchLower))
          .toList();
    }

    if (filter.metalType != null) {
      filtered = filtered
          .where((i) => i.metalType == filter.metalType)
          .toList();
    }

    if (filter.purity != null) {
      filtered = filtered.where((i) => i.purity == filter.purity).toList();
    }

    if (filter.minStock != null) {
      filtered = filtered
          .where((i) => i.stockWeight >= filter.minStock!)
          .toList();
    }

    if (filter.sortBy == 'name') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.name.compareTo(a.name)
            : a.name.compareTo(b.name),
      );
    } else if (filter.sortBy == 'stock') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.stockWeight.compareTo(a.stockWeight)
            : a.stockWeight.compareTo(b.stockWeight),
      );
    } else if (filter.sortBy == 'type') {
      filtered.sort(
        (a, b) => filter.sortDescending
            ? b.metalType.compareTo(a.metalType)
            : a.metalType.compareTo(b.metalType),
      );
    }

    return filtered;
  }
}
