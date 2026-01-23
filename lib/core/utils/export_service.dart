import 'package:goldbook_desktop/core/database/database.dart';

/// Service for exporting data to various formats
class ExportService {
  /// Generate a CSV representation of transactions
  static String generateTransactionsCSV(List<Transaction> transactions) {
    final buffer = StringBuffer();
    buffer.writeln('Date,Type,Party ID,Amount,Remarks');
    for (final transaction in transactions) {
      final date = transaction.date.toIso8601String().split('T')[0];
      final amount = transaction.totalAmount.toStringAsFixed(2);
      final remarks = transaction.remarks ?? '';
      buffer.writeln(
        '$date,${transaction.type},${transaction.partyId},$amount,"$remarks"',
      );
    }
    return buffer.toString();
  }
}
