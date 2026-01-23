import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/core/database/database.dart';
import 'package:goldbook_desktop/features/parties/data/parties_repository.dart';

// Filter state
class PartyTypeFilter extends Notifier<String> {
  @override
  String build() => 'Customer';

  void setType(String type) => state = type;
}

final partyTypeFilterProvider = NotifierProvider<PartyTypeFilter, String>(
  PartyTypeFilter.new,
);

// Parties List Stream
final partiesListProvider = StreamProvider.autoDispose<List<Party>>((ref) {
  final repository = ref.watch(partiesRepositoryProvider);
  final type = ref.watch(partyTypeFilterProvider);
  return repository.watchParties(type);
});

// Single Party Provider
final partyByIdProvider = FutureProvider.family.autoDispose<Party?, int>((
  ref,
  id,
) {
  final repository = ref.watch(partiesRepositoryProvider);
  return repository.getPartyById(id);
});

// AsyncNotifier for Add/Edit operations
class PartiesController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // No initial state
  }

  Future<void> addParty(PartiesCompanion party) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(partiesRepositoryProvider).addParty(party);
    });
  }

  Future<void> updateParty(PartiesCompanion party) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(partiesRepositoryProvider).updatePartyFromCompanion(party);
    });
  }
}

final partiesControllerProvider =
    AsyncNotifierProvider<PartiesController, void>(PartiesController.new);
