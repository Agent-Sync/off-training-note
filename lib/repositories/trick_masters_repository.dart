import 'package:off_training_note/models/core/trick_masters.dart';
import 'package:off_training_note/services/supabase_client_service.dart';

class TrickMastersRepository {
  const TrickMastersRepository();

  Future<TrickMasterData> fetchMasters() async {
    final grabsRows = await SupabaseClientProvider.guard(
      (client) => client
          .from('grabs')
          .select('code, label_ja, label_en, sort_order')
          .order('sort_order', ascending: true),
    );
    final axesRows = await SupabaseClientProvider.guard(
      (client) => client
          .from('axes')
          .select('code, label_ja, label_en, sort_order')
          .order('sort_order', ascending: true),
    );
    final spinsRows = await SupabaseClientProvider.guard(
      (client) => client
          .from('spins')
          .select('value, label_ja, label_en, sort_order')
          .order('sort_order', ascending: true),
    );

    return TrickMasterData(
      grabs: (grabsRows as List<dynamic>)
          .map((row) => TrickGrabMaster.fromRow(row as Map<String, dynamic>))
          .toList(growable: false),
      axes: (axesRows as List<dynamic>)
          .map((row) => TrickAxisMaster.fromRow(row as Map<String, dynamic>))
          .toList(growable: false),
      spins: (spinsRows as List<dynamic>)
          .map((row) => TrickSpinMaster.fromRow(row as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
