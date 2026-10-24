import 'package:material_ui/material_ui.dart';

/// Ключи иконок из базы (`icon TEXT`, DATABASE §1) → иконки приложения.
///
/// В M1 — встроенные контурные иконки Material (D-063): пакет иконок (Phosphor / Lucide)
/// ещё не выбран, а ключи в базе от пакета не зависят. Неизвестный ключ — «Другое».
abstract final class AppIcons {
  static const _byKey = <String, IconData>{
    'cart': Icons.shopping_cart_outlined,
    'cafe': Icons.local_cafe_outlined,
    'bus': Icons.directions_bus_outlined,
    'taxi': Icons.local_taxi_outlined,
    'fuel': Icons.local_gas_station_outlined,
    'home': Icons.home_outlined,
    'bolt': Icons.bolt_outlined,
    'phone': Icons.smartphone_outlined,
    'health': Icons.favorite_border,
    'shirt': Icons.checkroom_outlined,
    'school': Icons.school_outlined,
    'film': Icons.movie_outlined,
    'repeat': Icons.autorenew,
    'gift': Icons.card_giftcard_outlined,
    'bank': Icons.account_balance_outlined,
    'dots': Icons.more_horiz,
    'question': Icons.help_outline,
    'work': Icons.work_outline,
    'percent': Icons.percent,
    'cash': Icons.payments_outlined,
    'card': Icons.credit_card_outlined,
    'savings': Icons.savings_outlined,
    'credit': Icons.request_quote_outlined,
    'wallet': Icons.account_balance_wallet_outlined,
    'transfer': Icons.swap_horiz,
    'adjustment': Icons.tune,
  };

  static IconData of(String key) => _byKey[key] ?? Icons.more_horiz;

  static const chevron = Icons.chevron_right;
}
