import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // 开发环境配置（直接硬编码，方便调试）
  static const String supabaseUrl = 'https://ovytvktzhuapvictznnr.supabase.co';
  // 注意：这里应该使用 Anon Key，不是 Service Role Key
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im92eXR2a3R6aHVhcHZpY3R6bm5yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3NzQxMTksImV4cCI6MjA4NDM1MDExOX0.LVfGFoiNWSMul_f8kjc3nyyJsOuigIrC23ULrMEWVzY';

  // 如果需要使用环境变量，可以这样配置：
  // static const String supabaseUrl = String.fromEnvironment(
  //   'SUPABASE_URL',
  //   defaultValue: 'https://ovytvktzhuapvictznnr.supabase.co',
  // );
  // static const String supabaseAnonKey = String.fromEnvironment(
  //   'SUPABASE_ANON_KEY',
  //   defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  // );

  static Future<void> initialize() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      print('⚠️  Supabase credentials not provided. Using mock data mode.');
      return;
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    print('✅ Supabase initialized successfully');
  }

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}