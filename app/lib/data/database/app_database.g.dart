// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class Account extends Table with TableInfo<Account, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Account(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(name) BETWEEN 1 AND 60)',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (type IN (\'cash\', \'card\', \'bank\', \'deposit\', \'credit\', \'other\'))',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (length(currency) = 3 AND currency = upper(currency))',
  );
  static const VerificationMeta _openingBalanceMinorMeta =
      const VerificationMeta('openingBalanceMinor');
  late final GeneratedColumn<int> openingBalanceMinor = GeneratedColumn<int>(
    'opening_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _budgetModeMeta = const VerificationMeta(
    'budgetMode',
  );
  late final GeneratedColumn<String> budgetMode = GeneratedColumn<String>(
    'budget_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'on_budget\' CHECK (budget_mode IN (\'on_budget\', \'tracking\'))',
    defaultValue: const CustomExpression('\'on_budget\''),
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (hidden IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  late final GeneratedColumn<int> archivedAt = GeneratedColumn<int>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _colorIndexMeta = const VerificationMeta(
    'colorIndex',
  );
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
    'color_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (color_index BETWEEN 0 AND 6)',
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    currency,
    openingBalanceMinor,
    budgetMode,
    hidden,
    archivedAt,
    colorIndex,
    icon,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('opening_balance_minor')) {
      context.handle(
        _openingBalanceMinorMeta,
        openingBalanceMinor.isAcceptableOrUnknown(
          data['opening_balance_minor']!,
          _openingBalanceMinorMeta,
        ),
      );
    }
    if (data.containsKey('budget_mode')) {
      context.handle(
        _budgetModeMeta,
        budgetMode.isAcceptableOrUnknown(data['budget_mode']!, _budgetModeMeta),
      );
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('color_index')) {
      context.handle(
        _colorIndexMeta,
        colorIndex.isAcceptableOrUnknown(data['color_index']!, _colorIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorIndexMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      openingBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_minor'],
      )!,
      budgetMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_mode'],
      )!,
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at'],
      ),
      colorIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_index'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  Account createAlias(String alias) {
    return Account(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String name;
  final String type;
  final String currency;
  final int openingBalanceMinor;
  final String budgetMode;
  final int hidden;
  final int? archivedAt;
  final int colorIndex;
  final String icon;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const AccountRow({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.openingBalanceMinor,
    required this.budgetMode,
    required this.hidden,
    this.archivedAt,
    required this.colorIndex,
    required this.icon,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['currency'] = Variable<String>(currency);
    map['opening_balance_minor'] = Variable<int>(openingBalanceMinor);
    map['budget_mode'] = Variable<String>(budgetMode);
    map['hidden'] = Variable<int>(hidden);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(archivedAt);
    }
    map['color_index'] = Variable<int>(colorIndex);
    map['icon'] = Variable<String>(icon);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  AccountCompanion toCompanion(bool nullToAbsent) {
    return AccountCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      currency: Value(currency),
      openingBalanceMinor: Value(openingBalanceMinor),
      budgetMode: Value(budgetMode),
      hidden: Value(hidden),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      colorIndex: Value(colorIndex),
      icon: Value(icon),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currency: serializer.fromJson<String>(json['currency']),
      openingBalanceMinor: serializer.fromJson<int>(
        json['opening_balance_minor'],
      ),
      budgetMode: serializer.fromJson<String>(json['budget_mode']),
      hidden: serializer.fromJson<int>(json['hidden']),
      archivedAt: serializer.fromJson<int?>(json['archived_at']),
      colorIndex: serializer.fromJson<int>(json['color_index']),
      icon: serializer.fromJson<String>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
      deletedAt: serializer.fromJson<int?>(json['deleted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currency': serializer.toJson<String>(currency),
      'opening_balance_minor': serializer.toJson<int>(openingBalanceMinor),
      'budget_mode': serializer.toJson<String>(budgetMode),
      'hidden': serializer.toJson<int>(hidden),
      'archived_at': serializer.toJson<int?>(archivedAt),
      'color_index': serializer.toJson<int>(colorIndex),
      'icon': serializer.toJson<String>(icon),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at': serializer.toJson<int>(createdAt),
      'updated_at': serializer.toJson<int>(updatedAt),
      'deleted_at': serializer.toJson<int?>(deletedAt),
    };
  }

  AccountRow copyWith({
    String? id,
    String? name,
    String? type,
    String? currency,
    int? openingBalanceMinor,
    String? budgetMode,
    int? hidden,
    Value<int?> archivedAt = const Value.absent(),
    int? colorIndex,
    String? icon,
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    currency: currency ?? this.currency,
    openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
    budgetMode: budgetMode ?? this.budgetMode,
    hidden: hidden ?? this.hidden,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    colorIndex: colorIndex ?? this.colorIndex,
    icon: icon ?? this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  AccountRow copyWithCompanion(AccountCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      currency: data.currency.present ? data.currency.value : this.currency,
      openingBalanceMinor: data.openingBalanceMinor.present
          ? data.openingBalanceMinor.value
          : this.openingBalanceMinor,
      budgetMode: data.budgetMode.present
          ? data.budgetMode.value
          : this.budgetMode,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      colorIndex: data.colorIndex.present
          ? data.colorIndex.value
          : this.colorIndex,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('budgetMode: $budgetMode, ')
          ..write('hidden: $hidden, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    currency,
    openingBalanceMinor,
    budgetMode,
    hidden,
    archivedAt,
    colorIndex,
    icon,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.currency == this.currency &&
          other.openingBalanceMinor == this.openingBalanceMinor &&
          other.budgetMode == this.budgetMode &&
          other.hidden == this.hidden &&
          other.archivedAt == this.archivedAt &&
          other.colorIndex == this.colorIndex &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AccountCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> currency;
  final Value<int> openingBalanceMinor;
  final Value<String> budgetMode;
  final Value<int> hidden;
  final Value<int?> archivedAt;
  final Value<int> colorIndex;
  final Value<String> icon;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const AccountCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currency = const Value.absent(),
    this.openingBalanceMinor = const Value.absent(),
    this.budgetMode = const Value.absent(),
    this.hidden = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String currency,
    this.openingBalanceMinor = const Value.absent(),
    this.budgetMode = const Value.absent(),
    this.hidden = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required int colorIndex,
    required String icon,
    required int sortOrder,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       currency = Value(currency),
       colorIndex = Value(colorIndex),
       icon = Value(icon),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? currency,
    Expression<int>? openingBalanceMinor,
    Expression<String>? budgetMode,
    Expression<int>? hidden,
    Expression<int>? archivedAt,
    Expression<int>? colorIndex,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currency != null) 'currency': currency,
      if (openingBalanceMinor != null)
        'opening_balance_minor': openingBalanceMinor,
      if (budgetMode != null) 'budget_mode': budgetMode,
      if (hidden != null) 'hidden': hidden,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (colorIndex != null) 'color_index': colorIndex,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? currency,
    Value<int>? openingBalanceMinor,
    Value<String>? budgetMode,
    Value<int>? hidden,
    Value<int?>? archivedAt,
    Value<int>? colorIndex,
    Value<String>? icon,
    Value<int>? sortOrder,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return AccountCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
      budgetMode: budgetMode ?? this.budgetMode,
      hidden: hidden ?? this.hidden,
      archivedAt: archivedAt ?? this.archivedAt,
      colorIndex: colorIndex ?? this.colorIndex,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (openingBalanceMinor.present) {
      map['opening_balance_minor'] = Variable<int>(openingBalanceMinor.value);
    }
    if (budgetMode.present) {
      map['budget_mode'] = Variable<String>(budgetMode.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<int>(hidden.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(archivedAt.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<int>(colorIndex.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currency: $currency, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('budgetMode: $budgetMode, ')
          ..write('hidden: $hidden, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Category extends Table with TableInfo<Category, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Category(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (kind IN (\'expense\', \'income\'))',
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES category(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(name) BETWEEN 1 AND 40)',
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _colorIndexMeta = const VerificationMeta(
    'colorIndex',
  );
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
    'color_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (color_index BETWEEN 0 AND 6)',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _defaultKeyMeta = const VerificationMeta(
    'defaultKey',
  );
  late final GeneratedColumn<String> defaultKey = GeneratedColumn<String>(
    'default_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  late final GeneratedColumn<int> hidden = GeneratedColumn<int>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (hidden IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    parentId,
    name,
    icon,
    colorIndex,
    sortOrder,
    defaultKey,
    hidden,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_index')) {
      context.handle(
        _colorIndexMeta,
        colorIndex.isAcceptableOrUnknown(data['color_index']!, _colorIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorIndexMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('default_key')) {
      context.handle(
        _defaultKeyMeta,
        defaultKey.isAcceptableOrUnknown(data['default_key']!, _defaultKeyMeta),
      );
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_index'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      defaultKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_key'],
      ),
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hidden'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  Category createAlias(String alias) {
    return Category(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String kind;
  final String? parentId;
  final String name;
  final String icon;
  final int colorIndex;
  final int sortOrder;
  final String? defaultKey;
  final int hidden;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const CategoryRow({
    required this.id,
    required this.kind,
    this.parentId,
    required this.name,
    required this.icon,
    required this.colorIndex,
    required this.sortOrder,
    this.defaultKey,
    required this.hidden,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_index'] = Variable<int>(colorIndex);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || defaultKey != null) {
      map['default_key'] = Variable<String>(defaultKey);
    }
    map['hidden'] = Variable<int>(hidden);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      kind: Value(kind),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      icon: Value(icon),
      colorIndex: Value(colorIndex),
      sortOrder: Value(sortOrder),
      defaultKey: defaultKey == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultKey),
      hidden: Value(hidden),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      parentId: serializer.fromJson<String?>(json['parent_id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorIndex: serializer.fromJson<int>(json['color_index']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      defaultKey: serializer.fromJson<String?>(json['default_key']),
      hidden: serializer.fromJson<int>(json['hidden']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
      deletedAt: serializer.fromJson<int?>(json['deleted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'parent_id': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color_index': serializer.toJson<int>(colorIndex),
      'sort_order': serializer.toJson<int>(sortOrder),
      'default_key': serializer.toJson<String?>(defaultKey),
      'hidden': serializer.toJson<int>(hidden),
      'created_at': serializer.toJson<int>(createdAt),
      'updated_at': serializer.toJson<int>(updatedAt),
      'deleted_at': serializer.toJson<int?>(deletedAt),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? kind,
    Value<String?> parentId = const Value.absent(),
    String? name,
    String? icon,
    int? colorIndex,
    int? sortOrder,
    Value<String?> defaultKey = const Value.absent(),
    int? hidden,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => CategoryRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorIndex: colorIndex ?? this.colorIndex,
    sortOrder: sortOrder ?? this.sortOrder,
    defaultKey: defaultKey.present ? defaultKey.value : this.defaultKey,
    hidden: hidden ?? this.hidden,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  CategoryRow copyWithCompanion(CategoryCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorIndex: data.colorIndex.present
          ? data.colorIndex.value
          : this.colorIndex,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      defaultKey: data.defaultKey.present
          ? data.defaultKey.value
          : this.defaultKey,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('defaultKey: $defaultKey, ')
          ..write('hidden: $hidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    parentId,
    name,
    icon,
    colorIndex,
    sortOrder,
    defaultKey,
    hidden,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorIndex == this.colorIndex &&
          other.sortOrder == this.sortOrder &&
          other.defaultKey == this.defaultKey &&
          other.hidden == this.hidden &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CategoryCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> colorIndex;
  final Value<int> sortOrder;
  final Value<String?> defaultKey;
  final Value<int> hidden;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.defaultKey = const Value.absent(),
    this.hidden = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryCompanion.insert({
    required String id,
    required String kind,
    this.parentId = const Value.absent(),
    required String name,
    required String icon,
    required int colorIndex,
    required int sortOrder,
    this.defaultKey = const Value.absent(),
    this.hidden = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       name = Value(name),
       icon = Value(icon),
       colorIndex = Value(colorIndex),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? colorIndex,
    Expression<int>? sortOrder,
    Expression<String>? defaultKey,
    Expression<int>? hidden,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorIndex != null) 'color_index': colorIndex,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (defaultKey != null) 'default_key': defaultKey,
      if (hidden != null) 'hidden': hidden,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String?>? parentId,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? colorIndex,
    Value<int>? sortOrder,
    Value<String?>? defaultKey,
    Value<int>? hidden,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return CategoryCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorIndex: colorIndex ?? this.colorIndex,
      sortOrder: sortOrder ?? this.sortOrder,
      defaultKey: defaultKey ?? this.defaultKey,
      hidden: hidden ?? this.hidden,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<int>(colorIndex.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (defaultKey.present) {
      map['default_key'] = Variable<String>(defaultKey.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<int>(hidden.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('defaultKey: $defaultKey, ')
          ..write('hidden: $hidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class FinTransaction extends Table
    with TableInfo<FinTransaction, FinTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FinTransaction(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (kind IN (\'expense\', \'income\', \'transfer_out\', \'transfer_in\', \'adjustment\', \'debt_out\', \'debt_in\'))',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'posted\' CHECK (status IN (\'posted\', \'planned\'))',
    defaultValue: const CustomExpression('\'posted\''),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES account(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES category(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(currency) = 3)',
  );
  static const VerificationMeta _rateToBaseMeta = const VerificationMeta(
    'rateToBase',
  );
  late final GeneratedColumn<String> rateToBase = GeneratedColumn<String>(
    'rate_to_base',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _amountBaseMinorMeta = const VerificationMeta(
    'amountBaseMinor',
  );
  late final GeneratedColumn<int> amountBaseMinor = GeneratedColumn<int>(
    'amount_base_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reportEffectMeta = const VerificationMeta(
    'reportEffect',
  );
  late final GeneratedColumn<String> reportEffect = GeneratedColumn<String>(
    'report_effect',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (report_effect IN (\'expense\', \'income\', \'none\'))',
  );
  static const VerificationMeta _isRefundMeta = const VerificationMeta(
    'isRefund',
  );
  late final GeneratedColumn<int> isRefund = GeneratedColumn<int>(
    'is_refund',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (is_refund IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (date GLOB \'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\')',
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (time IS NULL OR time GLOB \'[0-2][0-9]:[0-5][0-9]\')',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (note IS NULL OR length(note) <= 500)',
  );
  static const VerificationMeta _transferGroupIdMeta = const VerificationMeta(
    'transferGroupId',
  );
  late final GeneratedColumn<String> transferGroupId = GeneratedColumn<String>(
    'transfer_group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  late final GeneratedColumn<String> debtId = GeneratedColumn<String>(
    'debt_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _recurringPaymentIdMeta =
      const VerificationMeta('recurringPaymentId');
  late final GeneratedColumn<String> recurringPaymentId =
      GeneratedColumn<String>(
        'recurring_payment_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  static const VerificationMeta _voiceSessionIdMeta = const VerificationMeta(
    'voiceSessionId',
  );
  late final GeneratedColumn<String> voiceSessionId = GeneratedColumn<String>(
    'voice_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _importBatchIdMeta = const VerificationMeta(
    'importBatchId',
  );
  late final GeneratedColumn<String> importBatchId = GeneratedColumn<String>(
    'import_batch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    status,
    accountId,
    categoryId,
    amountMinor,
    currency,
    rateToBase,
    amountBaseMinor,
    reportEffect,
    isRefund,
    date,
    time,
    note,
    transferGroupId,
    debtId,
    recurringPaymentId,
    voiceSessionId,
    importBatchId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fin_transaction';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('rate_to_base')) {
      context.handle(
        _rateToBaseMeta,
        rateToBase.isAcceptableOrUnknown(
          data['rate_to_base']!,
          _rateToBaseMeta,
        ),
      );
    }
    if (data.containsKey('amount_base_minor')) {
      context.handle(
        _amountBaseMinorMeta,
        amountBaseMinor.isAcceptableOrUnknown(
          data['amount_base_minor']!,
          _amountBaseMinorMeta,
        ),
      );
    }
    if (data.containsKey('report_effect')) {
      context.handle(
        _reportEffectMeta,
        reportEffect.isAcceptableOrUnknown(
          data['report_effect']!,
          _reportEffectMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reportEffectMeta);
    }
    if (data.containsKey('is_refund')) {
      context.handle(
        _isRefundMeta,
        isRefund.isAcceptableOrUnknown(data['is_refund']!, _isRefundMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('transfer_group_id')) {
      context.handle(
        _transferGroupIdMeta,
        transferGroupId.isAcceptableOrUnknown(
          data['transfer_group_id']!,
          _transferGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('debt_id')) {
      context.handle(
        _debtIdMeta,
        debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta),
      );
    }
    if (data.containsKey('recurring_payment_id')) {
      context.handle(
        _recurringPaymentIdMeta,
        recurringPaymentId.isAcceptableOrUnknown(
          data['recurring_payment_id']!,
          _recurringPaymentIdMeta,
        ),
      );
    }
    if (data.containsKey('voice_session_id')) {
      context.handle(
        _voiceSessionIdMeta,
        voiceSessionId.isAcceptableOrUnknown(
          data['voice_session_id']!,
          _voiceSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('import_batch_id')) {
      context.handle(
        _importBatchIdMeta,
        importBatchId.isAcceptableOrUnknown(
          data['import_batch_id']!,
          _importBatchIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      rateToBase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate_to_base'],
      ),
      amountBaseMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_base_minor'],
      ),
      reportEffect: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_effect'],
      )!,
      isRefund: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_refund'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      transferGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_group_id'],
      ),
      debtId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}debt_id'],
      ),
      recurringPaymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_payment_id'],
      ),
      voiceSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_session_id'],
      ),
      importBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_batch_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  FinTransaction createAlias(String alias) {
    return FinTransaction(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK(kind NOT IN (\'expense\', \'income\') OR category_id IS NOT NULL)',
    'CHECK(kind = \'adjustment\' OR amount_minor >= 0)',
    'CHECK(kind NOT IN (\'transfer_out\', \'transfer_in\') OR transfer_group_id IS NOT NULL)',
    'CHECK(kind NOT IN (\'debt_out\', \'debt_in\') OR debt_id IS NOT NULL)',
    'CHECK((kind = \'expense\' AND report_effect = \'expense\')OR(kind = \'income\' AND report_effect = \'income\')OR(kind IN (\'adjustment\', \'debt_out\', \'debt_in\') AND report_effect = \'none\')OR kind IN (\'transfer_out\', \'transfer_in\'))',
    'CHECK(report_effect = \'none\' OR category_id IS NOT NULL)',
    'CHECK(status = \'posted\' OR recurring_payment_id IS NOT NULL OR kind IN (\'expense\', \'income\', \'transfer_out\', \'transfer_in\'))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class FinTransactionRow extends DataClass
    implements Insertable<FinTransactionRow> {
  final String id;
  final String kind;
  final String status;
  final String accountId;
  final String? categoryId;
  final int amountMinor;
  final String currency;
  final String? rateToBase;
  final int? amountBaseMinor;
  final String reportEffect;
  final int isRefund;
  final String date;
  final String? time;
  final String? note;
  final String? transferGroupId;

  /// Внешние ключи добавляются вместе с таблицами-владельцами (D-062).
  final String? debtId;
  final String? recurringPaymentId;
  final String? voiceSessionId;
  final String? importBatchId;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const FinTransactionRow({
    required this.id,
    required this.kind,
    required this.status,
    required this.accountId,
    this.categoryId,
    required this.amountMinor,
    required this.currency,
    this.rateToBase,
    this.amountBaseMinor,
    required this.reportEffect,
    required this.isRefund,
    required this.date,
    this.time,
    this.note,
    this.transferGroupId,
    this.debtId,
    this.recurringPaymentId,
    this.voiceSessionId,
    this.importBatchId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['status'] = Variable<String>(status);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || rateToBase != null) {
      map['rate_to_base'] = Variable<String>(rateToBase);
    }
    if (!nullToAbsent || amountBaseMinor != null) {
      map['amount_base_minor'] = Variable<int>(amountBaseMinor);
    }
    map['report_effect'] = Variable<String>(reportEffect);
    map['is_refund'] = Variable<int>(isRefund);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || transferGroupId != null) {
      map['transfer_group_id'] = Variable<String>(transferGroupId);
    }
    if (!nullToAbsent || debtId != null) {
      map['debt_id'] = Variable<String>(debtId);
    }
    if (!nullToAbsent || recurringPaymentId != null) {
      map['recurring_payment_id'] = Variable<String>(recurringPaymentId);
    }
    if (!nullToAbsent || voiceSessionId != null) {
      map['voice_session_id'] = Variable<String>(voiceSessionId);
    }
    if (!nullToAbsent || importBatchId != null) {
      map['import_batch_id'] = Variable<String>(importBatchId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  FinTransactionCompanion toCompanion(bool nullToAbsent) {
    return FinTransactionCompanion(
      id: Value(id),
      kind: Value(kind),
      status: Value(status),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      rateToBase: rateToBase == null && nullToAbsent
          ? const Value.absent()
          : Value(rateToBase),
      amountBaseMinor: amountBaseMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(amountBaseMinor),
      reportEffect: Value(reportEffect),
      isRefund: Value(isRefund),
      date: Value(date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      transferGroupId: transferGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferGroupId),
      debtId: debtId == null && nullToAbsent
          ? const Value.absent()
          : Value(debtId),
      recurringPaymentId: recurringPaymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringPaymentId),
      voiceSessionId: voiceSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceSessionId),
      importBatchId: importBatchId == null && nullToAbsent
          ? const Value.absent()
          : Value(importBatchId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory FinTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      status: serializer.fromJson<String>(json['status']),
      accountId: serializer.fromJson<String>(json['account_id']),
      categoryId: serializer.fromJson<String?>(json['category_id']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      currency: serializer.fromJson<String>(json['currency']),
      rateToBase: serializer.fromJson<String?>(json['rate_to_base']),
      amountBaseMinor: serializer.fromJson<int?>(json['amount_base_minor']),
      reportEffect: serializer.fromJson<String>(json['report_effect']),
      isRefund: serializer.fromJson<int>(json['is_refund']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String?>(json['time']),
      note: serializer.fromJson<String?>(json['note']),
      transferGroupId: serializer.fromJson<String?>(json['transfer_group_id']),
      debtId: serializer.fromJson<String?>(json['debt_id']),
      recurringPaymentId: serializer.fromJson<String?>(
        json['recurring_payment_id'],
      ),
      voiceSessionId: serializer.fromJson<String?>(json['voice_session_id']),
      importBatchId: serializer.fromJson<String?>(json['import_batch_id']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
      deletedAt: serializer.fromJson<int?>(json['deleted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'status': serializer.toJson<String>(status),
      'account_id': serializer.toJson<String>(accountId),
      'category_id': serializer.toJson<String?>(categoryId),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'rate_to_base': serializer.toJson<String?>(rateToBase),
      'amount_base_minor': serializer.toJson<int?>(amountBaseMinor),
      'report_effect': serializer.toJson<String>(reportEffect),
      'is_refund': serializer.toJson<int>(isRefund),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String?>(time),
      'note': serializer.toJson<String?>(note),
      'transfer_group_id': serializer.toJson<String?>(transferGroupId),
      'debt_id': serializer.toJson<String?>(debtId),
      'recurring_payment_id': serializer.toJson<String?>(recurringPaymentId),
      'voice_session_id': serializer.toJson<String?>(voiceSessionId),
      'import_batch_id': serializer.toJson<String?>(importBatchId),
      'created_at': serializer.toJson<int>(createdAt),
      'updated_at': serializer.toJson<int>(updatedAt),
      'deleted_at': serializer.toJson<int?>(deletedAt),
    };
  }

  FinTransactionRow copyWith({
    String? id,
    String? kind,
    String? status,
    String? accountId,
    Value<String?> categoryId = const Value.absent(),
    int? amountMinor,
    String? currency,
    Value<String?> rateToBase = const Value.absent(),
    Value<int?> amountBaseMinor = const Value.absent(),
    String? reportEffect,
    int? isRefund,
    String? date,
    Value<String?> time = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> transferGroupId = const Value.absent(),
    Value<String?> debtId = const Value.absent(),
    Value<String?> recurringPaymentId = const Value.absent(),
    Value<String?> voiceSessionId = const Value.absent(),
    Value<String?> importBatchId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => FinTransactionRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    rateToBase: rateToBase.present ? rateToBase.value : this.rateToBase,
    amountBaseMinor: amountBaseMinor.present
        ? amountBaseMinor.value
        : this.amountBaseMinor,
    reportEffect: reportEffect ?? this.reportEffect,
    isRefund: isRefund ?? this.isRefund,
    date: date ?? this.date,
    time: time.present ? time.value : this.time,
    note: note.present ? note.value : this.note,
    transferGroupId: transferGroupId.present
        ? transferGroupId.value
        : this.transferGroupId,
    debtId: debtId.present ? debtId.value : this.debtId,
    recurringPaymentId: recurringPaymentId.present
        ? recurringPaymentId.value
        : this.recurringPaymentId,
    voiceSessionId: voiceSessionId.present
        ? voiceSessionId.value
        : this.voiceSessionId,
    importBatchId: importBatchId.present
        ? importBatchId.value
        : this.importBatchId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  FinTransactionRow copyWithCompanion(FinTransactionCompanion data) {
    return FinTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      rateToBase: data.rateToBase.present
          ? data.rateToBase.value
          : this.rateToBase,
      amountBaseMinor: data.amountBaseMinor.present
          ? data.amountBaseMinor.value
          : this.amountBaseMinor,
      reportEffect: data.reportEffect.present
          ? data.reportEffect.value
          : this.reportEffect,
      isRefund: data.isRefund.present ? data.isRefund.value : this.isRefund,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      note: data.note.present ? data.note.value : this.note,
      transferGroupId: data.transferGroupId.present
          ? data.transferGroupId.value
          : this.transferGroupId,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      recurringPaymentId: data.recurringPaymentId.present
          ? data.recurringPaymentId.value
          : this.recurringPaymentId,
      voiceSessionId: data.voiceSessionId.present
          ? data.voiceSessionId.value
          : this.voiceSessionId,
      importBatchId: data.importBatchId.present
          ? data.importBatchId.value
          : this.importBatchId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinTransactionRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('rateToBase: $rateToBase, ')
          ..write('amountBaseMinor: $amountBaseMinor, ')
          ..write('reportEffect: $reportEffect, ')
          ..write('isRefund: $isRefund, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('note: $note, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('debtId: $debtId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('voiceSessionId: $voiceSessionId, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    kind,
    status,
    accountId,
    categoryId,
    amountMinor,
    currency,
    rateToBase,
    amountBaseMinor,
    reportEffect,
    isRefund,
    date,
    time,
    note,
    transferGroupId,
    debtId,
    recurringPaymentId,
    voiceSessionId,
    importBatchId,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinTransactionRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.rateToBase == this.rateToBase &&
          other.amountBaseMinor == this.amountBaseMinor &&
          other.reportEffect == this.reportEffect &&
          other.isRefund == this.isRefund &&
          other.date == this.date &&
          other.time == this.time &&
          other.note == this.note &&
          other.transferGroupId == this.transferGroupId &&
          other.debtId == this.debtId &&
          other.recurringPaymentId == this.recurringPaymentId &&
          other.voiceSessionId == this.voiceSessionId &&
          other.importBatchId == this.importBatchId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class FinTransactionCompanion extends UpdateCompanion<FinTransactionRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> status;
  final Value<String> accountId;
  final Value<String?> categoryId;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String?> rateToBase;
  final Value<int?> amountBaseMinor;
  final Value<String> reportEffect;
  final Value<int> isRefund;
  final Value<String> date;
  final Value<String?> time;
  final Value<String?> note;
  final Value<String?> transferGroupId;
  final Value<String?> debtId;
  final Value<String?> recurringPaymentId;
  final Value<String?> voiceSessionId;
  final Value<String?> importBatchId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const FinTransactionCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.rateToBase = const Value.absent(),
    this.amountBaseMinor = const Value.absent(),
    this.reportEffect = const Value.absent(),
    this.isRefund = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.note = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.debtId = const Value.absent(),
    this.recurringPaymentId = const Value.absent(),
    this.voiceSessionId = const Value.absent(),
    this.importBatchId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinTransactionCompanion.insert({
    required String id,
    required String kind,
    this.status = const Value.absent(),
    required String accountId,
    this.categoryId = const Value.absent(),
    required int amountMinor,
    required String currency,
    this.rateToBase = const Value.absent(),
    this.amountBaseMinor = const Value.absent(),
    required String reportEffect,
    this.isRefund = const Value.absent(),
    required String date,
    this.time = const Value.absent(),
    this.note = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.debtId = const Value.absent(),
    this.recurringPaymentId = const Value.absent(),
    this.voiceSessionId = const Value.absent(),
    this.importBatchId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       accountId = Value(accountId),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       reportEffect = Value(reportEffect),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FinTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? rateToBase,
    Expression<int>? amountBaseMinor,
    Expression<String>? reportEffect,
    Expression<int>? isRefund,
    Expression<String>? date,
    Expression<String>? time,
    Expression<String>? note,
    Expression<String>? transferGroupId,
    Expression<String>? debtId,
    Expression<String>? recurringPaymentId,
    Expression<String>? voiceSessionId,
    Expression<String>? importBatchId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (rateToBase != null) 'rate_to_base': rateToBase,
      if (amountBaseMinor != null) 'amount_base_minor': amountBaseMinor,
      if (reportEffect != null) 'report_effect': reportEffect,
      if (isRefund != null) 'is_refund': isRefund,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (note != null) 'note': note,
      if (transferGroupId != null) 'transfer_group_id': transferGroupId,
      if (debtId != null) 'debt_id': debtId,
      if (recurringPaymentId != null)
        'recurring_payment_id': recurringPaymentId,
      if (voiceSessionId != null) 'voice_session_id': voiceSessionId,
      if (importBatchId != null) 'import_batch_id': importBatchId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinTransactionCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? status,
    Value<String>? accountId,
    Value<String?>? categoryId,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String?>? rateToBase,
    Value<int?>? amountBaseMinor,
    Value<String>? reportEffect,
    Value<int>? isRefund,
    Value<String>? date,
    Value<String?>? time,
    Value<String?>? note,
    Value<String?>? transferGroupId,
    Value<String?>? debtId,
    Value<String?>? recurringPaymentId,
    Value<String?>? voiceSessionId,
    Value<String?>? importBatchId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return FinTransactionCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      rateToBase: rateToBase ?? this.rateToBase,
      amountBaseMinor: amountBaseMinor ?? this.amountBaseMinor,
      reportEffect: reportEffect ?? this.reportEffect,
      isRefund: isRefund ?? this.isRefund,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
      transferGroupId: transferGroupId ?? this.transferGroupId,
      debtId: debtId ?? this.debtId,
      recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
      voiceSessionId: voiceSessionId ?? this.voiceSessionId,
      importBatchId: importBatchId ?? this.importBatchId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rateToBase.present) {
      map['rate_to_base'] = Variable<String>(rateToBase.value);
    }
    if (amountBaseMinor.present) {
      map['amount_base_minor'] = Variable<int>(amountBaseMinor.value);
    }
    if (reportEffect.present) {
      map['report_effect'] = Variable<String>(reportEffect.value);
    }
    if (isRefund.present) {
      map['is_refund'] = Variable<int>(isRefund.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (transferGroupId.present) {
      map['transfer_group_id'] = Variable<String>(transferGroupId.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<String>(debtId.value);
    }
    if (recurringPaymentId.present) {
      map['recurring_payment_id'] = Variable<String>(recurringPaymentId.value);
    }
    if (voiceSessionId.present) {
      map['voice_session_id'] = Variable<String>(voiceSessionId.value);
    }
    if (importBatchId.present) {
      map['import_batch_id'] = Variable<String>(importBatchId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinTransactionCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('rateToBase: $rateToBase, ')
          ..write('amountBaseMinor: $amountBaseMinor, ')
          ..write('reportEffect: $reportEffect, ')
          ..write('isRefund: $isRefund, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('note: $note, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('debtId: $debtId, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('voiceSessionId: $voiceSessionId, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ExchangeRate extends Table with TableInfo<ExchangeRate, ExchangeRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ExchangeRate(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(currency) = 3)',
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(base_currency) = 3)',
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  late final GeneratedColumn<String> rate = GeneratedColumn<String>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (CAST(rate AS REAL) > 0)',
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (valid_from GLOB \'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\')',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currency,
    baseCurrency,
    rate,
    validFrom,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rate';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  ExchangeRate createAlias(String alias) {
    return ExchangeRate(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK(currency <> base_currency)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ExchangeRateRow extends DataClass implements Insertable<ExchangeRateRow> {
  final String id;
  final String currency;
  final String baseCurrency;
  final String rate;
  final String validFrom;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const ExchangeRateRow({
    required this.id,
    required this.currency,
    required this.baseCurrency,
    required this.rate,
    required this.validFrom,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['currency'] = Variable<String>(currency);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['rate'] = Variable<String>(rate);
    map['valid_from'] = Variable<String>(validFrom);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  ExchangeRateCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRateCompanion(
      id: Value(id),
      currency: Value(currency),
      baseCurrency: Value(baseCurrency),
      rate: Value(rate),
      validFrom: Value(validFrom),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ExchangeRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRateRow(
      id: serializer.fromJson<String>(json['id']),
      currency: serializer.fromJson<String>(json['currency']),
      baseCurrency: serializer.fromJson<String>(json['base_currency']),
      rate: serializer.fromJson<String>(json['rate']),
      validFrom: serializer.fromJson<String>(json['valid_from']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
      deletedAt: serializer.fromJson<int?>(json['deleted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currency': serializer.toJson<String>(currency),
      'base_currency': serializer.toJson<String>(baseCurrency),
      'rate': serializer.toJson<String>(rate),
      'valid_from': serializer.toJson<String>(validFrom),
      'created_at': serializer.toJson<int>(createdAt),
      'updated_at': serializer.toJson<int>(updatedAt),
      'deleted_at': serializer.toJson<int?>(deletedAt),
    };
  }

  ExchangeRateRow copyWith({
    String? id,
    String? currency,
    String? baseCurrency,
    String? rate,
    String? validFrom,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => ExchangeRateRow(
    id: id ?? this.id,
    currency: currency ?? this.currency,
    baseCurrency: baseCurrency ?? this.baseCurrency,
    rate: rate ?? this.rate,
    validFrom: validFrom ?? this.validFrom,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ExchangeRateRow copyWithCompanion(ExchangeRateCompanion data) {
    return ExchangeRateRow(
      id: data.id.present ? data.id.value : this.id,
      currency: data.currency.present ? data.currency.value : this.currency,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRateRow(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('rate: $rate, ')
          ..write('validFrom: $validFrom, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currency,
    baseCurrency,
    rate,
    validFrom,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRateRow &&
          other.id == this.id &&
          other.currency == this.currency &&
          other.baseCurrency == this.baseCurrency &&
          other.rate == this.rate &&
          other.validFrom == this.validFrom &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ExchangeRateCompanion extends UpdateCompanion<ExchangeRateRow> {
  final Value<String> id;
  final Value<String> currency;
  final Value<String> baseCurrency;
  final Value<String> rate;
  final Value<String> validFrom;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const ExchangeRateCompanion({
    this.id = const Value.absent(),
    this.currency = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRateCompanion.insert({
    required String id,
    required String currency,
    required String baseCurrency,
    required String rate,
    required String validFrom,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       currency = Value(currency),
       baseCurrency = Value(baseCurrency),
       rate = Value(rate),
       validFrom = Value(validFrom),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExchangeRateRow> custom({
    Expression<String>? id,
    Expression<String>? currency,
    Expression<String>? baseCurrency,
    Expression<String>? rate,
    Expression<String>? validFrom,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currency != null) 'currency': currency,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (rate != null) 'rate': rate,
      if (validFrom != null) 'valid_from': validFrom,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRateCompanion copyWith({
    Value<String>? id,
    Value<String>? currency,
    Value<String>? baseCurrency,
    Value<String>? rate,
    Value<String>? validFrom,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ExchangeRateCompanion(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rate: rate ?? this.rate,
      validFrom: validFrom ?? this.validFrom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(rate.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRateCompanion(')
          ..write('id: $id, ')
          ..write('currency: $currency, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('rate: $rate, ')
          ..write('validFrom: $validFrom, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_setting';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  final int updatedAt;
  const AppSettingRow({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSettingRow copyWith({String? key, String? value, int? updatedAt}) =>
      AppSettingRow(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Account account = Account(this);
  late final Index accountArchivedSort = Index(
    'account_archived_sort',
    'CREATE INDEX account_archived_sort ON account (archived_at, sort_order)',
  );
  late final Category category = Category(this);
  late final FinTransaction finTransaction = FinTransaction(this);
  late final Trigger accountCurrencyLocked = Trigger(
    'CREATE TRIGGER account_currency_locked BEFORE UPDATE OF currency ON account WHEN OLD.currency <> NEW.currency AND EXISTS (SELECT 1 FROM fin_transaction AS t WHERE t.account_id = OLD.id) BEGIN SELECT RAISE (ABORT, \'account_currency_locked\');END',
    'account_currency_locked',
  );
  late final Index categoryNameUnique = Index(
    'category_name_unique',
    'CREATE UNIQUE INDEX category_name_unique ON category (kind, ifnull(parent_id, \'\'), name COLLATE NOCASE) WHERE deleted_at IS NULL',
  );
  late final Index categoryParent = Index(
    'category_parent',
    'CREATE INDEX category_parent ON category (parent_id)',
  );
  late final Trigger categoryParentInsert = Trigger(
    'CREATE TRIGGER category_parent_insert BEFORE INSERT ON category WHEN NEW.parent_id IS NOT NULL BEGIN SELECT RAISE (ABORT, \'category_parent_invalid\') WHERE NOT EXISTS (SELECT 1 FROM category AS p WHERE p.id = NEW.parent_id AND p.parent_id IS NULL AND p.kind = NEW.kind);END',
    'category_parent_insert',
  );
  late final Trigger categoryParentUpdate = Trigger(
    'CREATE TRIGGER category_parent_update BEFORE UPDATE OF parent_id, kind ON category WHEN NEW.parent_id IS NOT NULL BEGIN SELECT RAISE (ABORT, \'category_parent_invalid\') WHERE NOT EXISTS (SELECT 1 FROM category AS p WHERE p.id = NEW.parent_id AND p.parent_id IS NULL AND p.kind = NEW.kind);END',
    'category_parent_update',
  );
  late final ExchangeRate exchangeRate = ExchangeRate(this);
  late final Index exchangeRateUnique = Index(
    'exchange_rate_unique',
    'CREATE UNIQUE INDEX exchange_rate_unique ON exchange_rate (currency, base_currency, valid_from) WHERE deleted_at IS NULL',
  );
  late final Index finTransactionTransferPair = Index(
    'fin_transaction_transfer_pair',
    'CREATE UNIQUE INDEX fin_transaction_transfer_pair ON fin_transaction (transfer_group_id, kind) WHERE transfer_group_id IS NOT NULL AND deleted_at IS NULL',
  );
  late final Index finTransactionPlannedUnique = Index(
    'fin_transaction_planned_unique',
    'CREATE UNIQUE INDEX fin_transaction_planned_unique ON fin_transaction (recurring_payment_id, date) WHERE status = \'planned\' AND deleted_at IS NULL',
  );
  late final Index finTransactionStatusDate = Index(
    'fin_transaction_status_date',
    'CREATE INDEX fin_transaction_status_date ON fin_transaction (status, date)',
  );
  late final Index finTransactionAccountDate = Index(
    'fin_transaction_account_date',
    'CREATE INDEX fin_transaction_account_date ON fin_transaction (account_id, date)',
  );
  late final Index finTransactionCategoryDate = Index(
    'fin_transaction_category_date',
    'CREATE INDEX fin_transaction_category_date ON fin_transaction (category_id, date) WHERE report_effect <> \'none\'',
  );
  late final Index finTransactionTransferGroup = Index(
    'fin_transaction_transfer_group',
    'CREATE INDEX fin_transaction_transfer_group ON fin_transaction (transfer_group_id)',
  );
  late final Index finTransactionDebt = Index(
    'fin_transaction_debt',
    'CREATE INDEX fin_transaction_debt ON fin_transaction (debt_id)',
  );
  late final Index finTransactionRecurring = Index(
    'fin_transaction_recurring',
    'CREATE INDEX fin_transaction_recurring ON fin_transaction (recurring_payment_id, status, date)',
  );
  late final Index finTransactionImport = Index(
    'fin_transaction_import',
    'CREATE INDEX fin_transaction_import ON fin_transaction (import_batch_id)',
  );
  late final Index finTransactionVoice = Index(
    'fin_transaction_voice',
    'CREATE INDEX fin_transaction_voice ON fin_transaction (voice_session_id)',
  );
  late final Trigger finTransactionCurrencyInsert = Trigger(
    'CREATE TRIGGER fin_transaction_currency_insert BEFORE INSERT ON fin_transaction BEGIN SELECT RAISE (ABORT, \'transaction_currency_mismatch\') WHERE NEW.currency <> (SELECT a.currency FROM account AS a WHERE a.id = NEW.account_id);END',
    'fin_transaction_currency_insert',
  );
  late final Trigger finTransactionCurrencyUpdate = Trigger(
    'CREATE TRIGGER fin_transaction_currency_update BEFORE UPDATE OF currency, account_id ON fin_transaction BEGIN SELECT RAISE (ABORT, \'transaction_currency_mismatch\') WHERE NEW.currency <> (SELECT a.currency FROM account AS a WHERE a.id = NEW.account_id);END',
    'fin_transaction_currency_update',
  );
  late final Trigger finTransactionCategoryKindInsert = Trigger(
    'CREATE TRIGGER fin_transaction_category_kind_insert BEFORE INSERT ON fin_transaction WHEN NEW.category_id IS NOT NULL BEGIN SELECT RAISE (ABORT, \'category_kind_mismatch\') WHERE (SELECT c.kind FROM category AS c WHERE c.id = NEW.category_id) <> CASE WHEN NEW.kind = \'expense\' OR NEW.is_refund = 1 OR NEW.report_effect = \'expense\' THEN \'expense\' ELSE \'income\' END;END',
    'fin_transaction_category_kind_insert',
  );
  late final Trigger finTransactionCategoryKindUpdate = Trigger(
    'CREATE TRIGGER fin_transaction_category_kind_update BEFORE UPDATE OF category_id, kind, is_refund, report_effect ON fin_transaction WHEN NEW.category_id IS NOT NULL BEGIN SELECT RAISE (ABORT, \'category_kind_mismatch\') WHERE (SELECT c.kind FROM category AS c WHERE c.id = NEW.category_id) <> CASE WHEN NEW.kind = \'expense\' OR NEW.is_refund = 1 OR NEW.report_effect = \'expense\' THEN \'expense\' ELSE \'income\' END;END',
    'fin_transaction_category_kind_update',
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  Selectable<ActiveAccountsWithBalanceResult> activeAccountsWithBalance() {
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."name" AS "nested_0.name", "a"."type" AS "nested_0.type", "a"."currency" AS "nested_0.currency", "a"."opening_balance_minor" AS "nested_0.opening_balance_minor", "a"."budget_mode" AS "nested_0.budget_mode", "a"."hidden" AS "nested_0.hidden", "a"."archived_at" AS "nested_0.archived_at", "a"."color_index" AS "nested_0.color_index", "a"."icon" AS "nested_0.icon", "a"."sort_order" AS "nested_0.sort_order", "a"."created_at" AS "nested_0.created_at", "a"."updated_at" AS "nested_0.updated_at", "a"."deleted_at" AS "nested_0.deleted_at", a.opening_balance_minor + COALESCE((SELECT SUM(CASE WHEN t.kind IN (\'income\', \'transfer_in\', \'debt_in\', \'adjustment\') THEN t.amount_minor ELSE -t.amount_minor END) FROM fin_transaction AS t WHERE t.account_id = a.id AND t.status = \'posted\' AND t.deleted_at IS NULL), 0) AS balance_minor FROM account AS a WHERE a.deleted_at IS NULL AND a.archived_at IS NULL ORDER BY a.sort_order, a.created_at',
      variables: [],
      readsFrom: {this.account, this.finTransaction},
    ).asyncMap(
      (QueryRow row) async => ActiveAccountsWithBalanceResult(
        a: await this.account.mapFromRow(row, tablePrefix: 'nested_0'),
        balanceMinor: row.read<int>('balance_minor'),
      ),
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    account,
    accountArchivedSort,
    category,
    finTransaction,
    accountCurrencyLocked,
    categoryNameUnique,
    categoryParent,
    categoryParentInsert,
    categoryParentUpdate,
    exchangeRate,
    exchangeRateUnique,
    finTransactionTransferPair,
    finTransactionPlannedUnique,
    finTransactionStatusDate,
    finTransactionAccountDate,
    finTransactionCategoryDate,
    finTransactionTransferGroup,
    finTransactionDebt,
    finTransactionRecurring,
    finTransactionImport,
    finTransactionVoice,
    finTransactionCurrencyInsert,
    finTransactionCurrencyUpdate,
    finTransactionCategoryKindInsert,
    finTransactionCategoryKindUpdate,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'account',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'category',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'category',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fin_transaction',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fin_transaction',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fin_transaction',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fin_transaction',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
  ]);
}

typedef $AccountCreateCompanionBuilder = AccountCompanion Function({
  required String id,
  required String name,
  required String type,
  required String currency,
  Value<int> openingBalanceMinor,
  Value<String> budgetMode,
  Value<int> hidden,
  Value<int?> archivedAt,
  required int colorIndex,
  required String icon,
  required int sortOrder,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $AccountUpdateCompanionBuilder = AccountCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> currency,
  Value<int> openingBalanceMinor,
  Value<String> budgetMode,
  Value<int> hidden,
  Value<int?> archivedAt,
  Value<int> colorIndex,
  Value<String> icon,
  Value<int> sortOrder,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

final class $AccountReferences
    extends BaseReferences<_$AppDatabase, Account, AccountRow> {
  $AccountReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<FinTransaction, List<FinTransactionRow>>
  _finTransactionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finTransaction,
    aliasName: 'account__id__fin_transaction__account_id',
  );

  $FinTransactionProcessedTableManager get finTransactionRefs {
    final manager = $FinTransactionTableManager(
      $_db,
      $_db.finTransaction,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_finTransactionRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AccountFilterComposer extends Composer<_$AppDatabase, Account> {
  $AccountFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetMode => $composableBuilder(
    column: $table.budgetMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> finTransactionRefs(
    Expression<bool> Function($FinTransactionFilterComposer f) f,
  ) {
    final $FinTransactionFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finTransaction,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FinTransactionFilterComposer(
            $db: $db,
            $table: $db.finTransaction,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountOrderingComposer extends Composer<_$AppDatabase, Account> {
  $AccountOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetMode => $composableBuilder(
    column: $table.budgetMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AccountAnnotationComposer extends Composer<_$AppDatabase, Account> {
  $AccountAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetMode => $composableBuilder(
    column: $table.budgetMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> finTransactionRefs<T extends Object>(
    Expression<T> Function($FinTransactionAnnotationComposer a) f,
  ) {
    final $FinTransactionAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finTransaction,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FinTransactionAnnotationComposer(
            $db: $db,
            $table: $db.finTransaction,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Account,
          AccountRow,
          $AccountFilterComposer,
          $AccountOrderingComposer,
          $AccountAnnotationComposer,
          $AccountCreateCompanionBuilder,
          $AccountUpdateCompanionBuilder,
          (AccountRow, $AccountReferences),
          AccountRow,
          PrefetchHooks Function({bool finTransactionRefs})
        > {
  $AccountTableManager(_$AppDatabase db, Account table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> openingBalanceMinor = const Value.absent(),
                Value<String> budgetMode = const Value.absent(),
                Value<int> hidden = const Value.absent(),
                Value<int?> archivedAt = const Value.absent(),
                Value<int> colorIndex = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountCompanion(
                id: id,
                name: name,
                type: type,
                currency: currency,
                openingBalanceMinor: openingBalanceMinor,
                budgetMode: budgetMode,
                hidden: hidden,
                archivedAt: archivedAt,
                colorIndex: colorIndex,
                icon: icon,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String currency,
                Value<int> openingBalanceMinor = const Value.absent(),
                Value<String> budgetMode = const Value.absent(),
                Value<int> hidden = const Value.absent(),
                Value<int?> archivedAt = const Value.absent(),
                required int colorIndex,
                required String icon,
                required int sortOrder,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountCompanion.insert(
                id: id,
                name: name,
                type: type,
                currency: currency,
                openingBalanceMinor: openingBalanceMinor,
                budgetMode: budgetMode,
                hidden: hidden,
                archivedAt: archivedAt,
                colorIndex: colorIndex,
                icon: icon,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Account, AccountRow>(table),
                  $AccountReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({finTransactionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (finTransactionRefs) db.finTransaction,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (finTransactionRefs)
                    await $_getPrefetchedDataByColumns<
                      AccountRow,
                      Account,
                      FinTransactionRow,
                      FinTransaction
                    >(
                      currentTable: table,
                      referencedTable: $AccountReferences
                          ._finTransactionRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $AccountReferences(db, table, p0).finTransactionRefs,
                      currentColumn: 'id',
                      referencedColumn: 'account_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $AccountProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Account,
      AccountRow,
      $AccountFilterComposer,
      $AccountOrderingComposer,
      $AccountAnnotationComposer,
      $AccountCreateCompanionBuilder,
      $AccountUpdateCompanionBuilder,
      (AccountRow, $AccountReferences),
      AccountRow,
      PrefetchHooks Function({bool finTransactionRefs})
    >;
typedef $CategoryCreateCompanionBuilder = CategoryCompanion Function({
  required String id,
  required String kind,
  Value<String?> parentId,
  required String name,
  required String icon,
  required int colorIndex,
  required int sortOrder,
  Value<String?> defaultKey,
  Value<int> hidden,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $CategoryUpdateCompanionBuilder = CategoryCompanion Function({
  Value<String> id,
  Value<String> kind,
  Value<String?> parentId,
  Value<String> name,
  Value<String> icon,
  Value<int> colorIndex,
  Value<int> sortOrder,
  Value<String?> defaultKey,
  Value<int> hidden,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

final class $CategoryReferences
    extends BaseReferences<_$AppDatabase, Category, CategoryRow> {
  $CategoryReferences(super.$_db, super.$_table, super.$_typedResult);

  static Category _parentIdTable(_$AppDatabase db) =>
      db.category.createAlias('category__parent_id__category__id');

  $CategoryProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $CategoryTableManager(
      $_db,
      $_db.category,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<FinTransaction, List<FinTransactionRow>>
  _finTransactionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.finTransaction,
    aliasName: 'category__id__fin_transaction__category_id',
  );

  $FinTransactionProcessedTableManager get finTransactionRefs {
    final manager = $FinTransactionTableManager(
      $_db,
      $_db.finTransaction,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_finTransactionRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CategoryFilterComposer extends Composer<_$AppDatabase, Category> {
  $CategoryFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $CategoryFilterComposer get parentId {
    final $CategoryFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryFilterComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> finTransactionRefs(
    Expression<bool> Function($FinTransactionFilterComposer f) f,
  ) {
    final $FinTransactionFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finTransaction,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FinTransactionFilterComposer(
            $db: $db,
            $table: $db.finTransaction,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CategoryOrderingComposer extends Composer<_$AppDatabase, Category> {
  $CategoryOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $CategoryOrderingComposer get parentId {
    final $CategoryOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryOrderingComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CategoryAnnotationComposer extends Composer<_$AppDatabase, Category> {
  $CategoryAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get defaultKey => $composableBuilder(
    column: $table.defaultKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $CategoryAnnotationComposer get parentId {
    final $CategoryAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryAnnotationComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> finTransactionRefs<T extends Object>(
    Expression<T> Function($FinTransactionAnnotationComposer a) f,
  ) {
    final $FinTransactionAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finTransaction,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FinTransactionAnnotationComposer(
            $db: $db,
            $table: $db.finTransaction,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CategoryTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Category,
          CategoryRow,
          $CategoryFilterComposer,
          $CategoryOrderingComposer,
          $CategoryAnnotationComposer,
          $CategoryCreateCompanionBuilder,
          $CategoryUpdateCompanionBuilder,
          (CategoryRow, $CategoryReferences),
          CategoryRow,
          PrefetchHooks Function({bool parentId, bool finTransactionRefs})
        > {
  $CategoryTableManager(_$AppDatabase db, Category table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoryFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoryOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoryAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorIndex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> defaultKey = const Value.absent(),
                Value<int> hidden = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryCompanion(
                id: id,
                kind: kind,
                parentId: parentId,
                name: name,
                icon: icon,
                colorIndex: colorIndex,
                sortOrder: sortOrder,
                defaultKey: defaultKey,
                hidden: hidden,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                Value<String?> parentId = const Value.absent(),
                required String name,
                required String icon,
                required int colorIndex,
                required int sortOrder,
                Value<String?> defaultKey = const Value.absent(),
                Value<int> hidden = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryCompanion.insert(
                id: id,
                kind: kind,
                parentId: parentId,
                name: name,
                icon: icon,
                colorIndex: colorIndex,
                sortOrder: sortOrder,
                defaultKey: defaultKey,
                hidden: hidden,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Category, CategoryRow>(table),
                  $CategoryReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({parentId = false, finTransactionRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (finTransactionRefs) db.finTransaction,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $CategoryReferences._parentIdTable(
                              db,
                            ),
                            referencedColumn: $CategoryReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (finTransactionRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          Category,
                          FinTransactionRow,
                          FinTransaction
                        >(
                          currentTable: table,
                          referencedTable: $CategoryReferences
                              ._finTransactionRefsTable(db),
                          managerFromTypedResult: (p0) => $CategoryReferences(
                            db,
                            table,
                            p0,
                          ).finTransactionRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CategoryProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Category,
      CategoryRow,
      $CategoryFilterComposer,
      $CategoryOrderingComposer,
      $CategoryAnnotationComposer,
      $CategoryCreateCompanionBuilder,
      $CategoryUpdateCompanionBuilder,
      (CategoryRow, $CategoryReferences),
      CategoryRow,
      PrefetchHooks Function({bool parentId, bool finTransactionRefs})
    >;
typedef $FinTransactionCreateCompanionBuilder =
    FinTransactionCompanion Function({
      required String id,
      required String kind,
      Value<String> status,
      required String accountId,
      Value<String?> categoryId,
      required int amountMinor,
      required String currency,
      Value<String?> rateToBase,
      Value<int?> amountBaseMinor,
      required String reportEffect,
      Value<int> isRefund,
      required String date,
      Value<String?> time,
      Value<String?> note,
      Value<String?> transferGroupId,
      Value<String?> debtId,
      Value<String?> recurringPaymentId,
      Value<String?> voiceSessionId,
      Value<String?> importBatchId,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $FinTransactionUpdateCompanionBuilder =
    FinTransactionCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> status,
      Value<String> accountId,
      Value<String?> categoryId,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String?> rateToBase,
      Value<int?> amountBaseMinor,
      Value<String> reportEffect,
      Value<int> isRefund,
      Value<String> date,
      Value<String?> time,
      Value<String?> note,
      Value<String?> transferGroupId,
      Value<String?> debtId,
      Value<String?> recurringPaymentId,
      Value<String?> voiceSessionId,
      Value<String?> importBatchId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $FinTransactionReferences
    extends BaseReferences<_$AppDatabase, FinTransaction, FinTransactionRow> {
  $FinTransactionReferences(super.$_db, super.$_table, super.$_typedResult);

  static Account _accountIdTable(_$AppDatabase db) =>
      db.account.createAlias('fin_transaction__account_id__account__id');

  $AccountProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $AccountTableManager(
      $_db,
      $_db.account,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Category _categoryIdTable(_$AppDatabase db) =>
      db.category.createAlias('fin_transaction__category_id__category__id');

  $CategoryProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $CategoryTableManager(
      $_db,
      $_db.category,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $FinTransactionFilterComposer
    extends Composer<_$AppDatabase, FinTransaction> {
  $FinTransactionFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rateToBase => $composableBuilder(
    column: $table.rateToBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountBaseMinor => $composableBuilder(
    column: $table.amountBaseMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportEffect => $composableBuilder(
    column: $table.reportEffect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isRefund => $composableBuilder(
    column: $table.isRefund,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get debtId => $composableBuilder(
    column: $table.debtId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringPaymentId => $composableBuilder(
    column: $table.recurringPaymentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceSessionId => $composableBuilder(
    column: $table.voiceSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importBatchId => $composableBuilder(
    column: $table.importBatchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $AccountFilterComposer get accountId {
    final $AccountFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.account,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountFilterComposer(
            $db: $db,
            $table: $db.account,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CategoryFilterComposer get categoryId {
    final $CategoryFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryFilterComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FinTransactionOrderingComposer
    extends Composer<_$AppDatabase, FinTransaction> {
  $FinTransactionOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateToBase => $composableBuilder(
    column: $table.rateToBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountBaseMinor => $composableBuilder(
    column: $table.amountBaseMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportEffect => $composableBuilder(
    column: $table.reportEffect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isRefund => $composableBuilder(
    column: $table.isRefund,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get debtId => $composableBuilder(
    column: $table.debtId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringPaymentId => $composableBuilder(
    column: $table.recurringPaymentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceSessionId => $composableBuilder(
    column: $table.voiceSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importBatchId => $composableBuilder(
    column: $table.importBatchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $AccountOrderingComposer get accountId {
    final $AccountOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.account,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountOrderingComposer(
            $db: $db,
            $table: $db.account,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CategoryOrderingComposer get categoryId {
    final $CategoryOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryOrderingComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FinTransactionAnnotationComposer
    extends Composer<_$AppDatabase, FinTransaction> {
  $FinTransactionAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get rateToBase => $composableBuilder(
    column: $table.rateToBase,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountBaseMinor => $composableBuilder(
    column: $table.amountBaseMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportEffect => $composableBuilder(
    column: $table.reportEffect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isRefund =>
      $composableBuilder(column: $table.isRefund, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get transferGroupId => $composableBuilder(
    column: $table.transferGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get debtId =>
      $composableBuilder(column: $table.debtId, builder: (column) => column);

  GeneratedColumn<String> get recurringPaymentId => $composableBuilder(
    column: $table.recurringPaymentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voiceSessionId => $composableBuilder(
    column: $table.voiceSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importBatchId => $composableBuilder(
    column: $table.importBatchId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $AccountAnnotationComposer get accountId {
    final $AccountAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.account,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountAnnotationComposer(
            $db: $db,
            $table: $db.account,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CategoryAnnotationComposer get categoryId {
    final $CategoryAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryAnnotationComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FinTransactionTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          FinTransaction,
          FinTransactionRow,
          $FinTransactionFilterComposer,
          $FinTransactionOrderingComposer,
          $FinTransactionAnnotationComposer,
          $FinTransactionCreateCompanionBuilder,
          $FinTransactionUpdateCompanionBuilder,
          (FinTransactionRow, $FinTransactionReferences),
          FinTransactionRow,
          PrefetchHooks Function({bool accountId, bool categoryId})
        > {
  $FinTransactionTableManager(_$AppDatabase db, FinTransaction table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FinTransactionFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FinTransactionOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FinTransactionAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> rateToBase = const Value.absent(),
                Value<int?> amountBaseMinor = const Value.absent(),
                Value<String> reportEffect = const Value.absent(),
                Value<int> isRefund = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> transferGroupId = const Value.absent(),
                Value<String?> debtId = const Value.absent(),
                Value<String?> recurringPaymentId = const Value.absent(),
                Value<String?> voiceSessionId = const Value.absent(),
                Value<String?> importBatchId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinTransactionCompanion(
                id: id,
                kind: kind,
                status: status,
                accountId: accountId,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currency: currency,
                rateToBase: rateToBase,
                amountBaseMinor: amountBaseMinor,
                reportEffect: reportEffect,
                isRefund: isRefund,
                date: date,
                time: time,
                note: note,
                transferGroupId: transferGroupId,
                debtId: debtId,
                recurringPaymentId: recurringPaymentId,
                voiceSessionId: voiceSessionId,
                importBatchId: importBatchId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                Value<String> status = const Value.absent(),
                required String accountId,
                Value<String?> categoryId = const Value.absent(),
                required int amountMinor,
                required String currency,
                Value<String?> rateToBase = const Value.absent(),
                Value<int?> amountBaseMinor = const Value.absent(),
                required String reportEffect,
                Value<int> isRefund = const Value.absent(),
                required String date,
                Value<String?> time = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> transferGroupId = const Value.absent(),
                Value<String?> debtId = const Value.absent(),
                Value<String?> recurringPaymentId = const Value.absent(),
                Value<String?> voiceSessionId = const Value.absent(),
                Value<String?> importBatchId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinTransactionCompanion.insert(
                id: id,
                kind: kind,
                status: status,
                accountId: accountId,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currency: currency,
                rateToBase: rateToBase,
                amountBaseMinor: amountBaseMinor,
                reportEffect: reportEffect,
                isRefund: isRefund,
                date: date,
                time: time,
                note: note,
                transferGroupId: transferGroupId,
                debtId: debtId,
                recurringPaymentId: recurringPaymentId,
                voiceSessionId: voiceSessionId,
                importBatchId: importBatchId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<FinTransaction, FinTransactionRow>(table),
                  $FinTransactionReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $FinTransactionReferences
                            ._accountIdTable(db),
                        referencedColumn: $FinTransactionReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $FinTransactionReferences
                            ._categoryIdTable(db),
                        referencedColumn: $FinTransactionReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $FinTransactionProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      FinTransaction,
      FinTransactionRow,
      $FinTransactionFilterComposer,
      $FinTransactionOrderingComposer,
      $FinTransactionAnnotationComposer,
      $FinTransactionCreateCompanionBuilder,
      $FinTransactionUpdateCompanionBuilder,
      (FinTransactionRow, $FinTransactionReferences),
      FinTransactionRow,
      PrefetchHooks Function({bool accountId, bool categoryId})
    >;
typedef $ExchangeRateCreateCompanionBuilder = ExchangeRateCompanion Function({
  required String id,
  required String currency,
  required String baseCurrency,
  required String rate,
  required String validFrom,
  required int createdAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $ExchangeRateUpdateCompanionBuilder = ExchangeRateCompanion Function({
  Value<String> id,
  Value<String> currency,
  Value<String> baseCurrency,
  Value<String> rate,
  Value<String> validFrom,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> rowid,
});

class $ExchangeRateFilterComposer
    extends Composer<_$AppDatabase, ExchangeRate> {
  $ExchangeRateFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $ExchangeRateOrderingComposer
    extends Composer<_$AppDatabase, ExchangeRate> {
  $ExchangeRateOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ExchangeRateAnnotationComposer
    extends Composer<_$AppDatabase, ExchangeRate> {
  $ExchangeRateAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $ExchangeRateTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ExchangeRate,
          ExchangeRateRow,
          $ExchangeRateFilterComposer,
          $ExchangeRateOrderingComposer,
          $ExchangeRateAnnotationComposer,
          $ExchangeRateCreateCompanionBuilder,
          $ExchangeRateUpdateCompanionBuilder,
          (
            ExchangeRateRow,
            BaseReferences<_$AppDatabase, ExchangeRate, ExchangeRateRow>,
          ),
          ExchangeRateRow,
          PrefetchHooks Function()
        > {
  $ExchangeRateTableManager(_$AppDatabase db, ExchangeRate table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ExchangeRateFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ExchangeRateOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ExchangeRateAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> baseCurrency = const Value.absent(),
                Value<String> rate = const Value.absent(),
                Value<String> validFrom = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRateCompanion(
                id: id,
                currency: currency,
                baseCurrency: baseCurrency,
                rate: rate,
                validFrom: validFrom,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String currency,
                required String baseCurrency,
                required String rate,
                required String validFrom,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRateCompanion.insert(
                id: id,
                currency: currency,
                baseCurrency: baseCurrency,
                rate: rate,
                validFrom: validFrom,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ExchangeRate, ExchangeRateRow>(table),
                  BaseReferences<_$AppDatabase, ExchangeRate, ExchangeRateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ExchangeRateProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ExchangeRate,
      ExchangeRateRow,
      $ExchangeRateFilterComposer,
      $ExchangeRateOrderingComposer,
      $ExchangeRateAnnotationComposer,
      $ExchangeRateCreateCompanionBuilder,
      $ExchangeRateUpdateCompanionBuilder,
      (
        ExchangeRateRow,
        BaseReferences<_$AppDatabase, ExchangeRate, ExchangeRateRow>,
      ),
      ExchangeRateRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $AccountTableManager get account => $AccountTableManager(_db, _db.account);
  $CategoryTableManager get category =>
      $CategoryTableManager(_db, _db.category);
  $FinTransactionTableManager get finTransaction =>
      $FinTransactionTableManager(_db, _db.finTransaction);
  $ExchangeRateTableManager get exchangeRate =>
      $ExchangeRateTableManager(_db, _db.exchangeRate);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}

class ActiveAccountsWithBalanceResult {
  final AccountRow a;
  final int balanceMinor;
  ActiveAccountsWithBalanceResult({
    required this.a,
    required this.balanceMinor,
  });
}
