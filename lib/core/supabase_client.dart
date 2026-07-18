// core/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

// 앱 어디서든 SupabaseClient.db 로 접근
class SupabaseClient {
  static final db = Supabase.instance.client;
}
