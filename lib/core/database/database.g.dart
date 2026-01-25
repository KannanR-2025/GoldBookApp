// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
    'mobile',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workPhoneMeta = const VerificationMeta(
    'workPhone',
  );
  @override
  late final GeneratedColumn<String> workPhone = GeneratedColumn<String>(
    'work_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alternatePhoneMeta = const VerificationMeta(
    'alternatePhone',
  );
  @override
  late final GeneratedColumn<String> alternatePhone = GeneratedColumn<String>(
    'alternate_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _courierMeta = const VerificationMeta(
    'courier',
  );
  @override
  late final GeneratedColumn<String> courier = GeneratedColumn<String>(
    'courier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anniversaryDateMeta = const VerificationMeta(
    'anniversaryDate',
  );
  @override
  late final GeneratedColumn<DateTime> anniversaryDate =
      GeneratedColumn<DateTime>(
        'anniversary_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _referredByMeta = const VerificationMeta(
    'referredBy',
  );
  @override
  late final GeneratedColumn<String> referredBy = GeneratedColumn<String>(
    'referred_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Active'),
  );
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>(
        'discount_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _paymentTermsMeta = const VerificationMeta(
    'paymentTerms',
  );
  @override
  late final GeneratedColumn<String> paymentTerms = GeneratedColumn<String>(
    'payment_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankAccountNumberMeta = const VerificationMeta(
    'bankAccountNumber',
  );
  @override
  late final GeneratedColumn<String> bankAccountNumber =
      GeneratedColumn<String>(
        'bank_account_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ifscCodeMeta = const VerificationMeta(
    'ifscCode',
  );
  @override
  late final GeneratedColumn<String> ifscCode = GeneratedColumn<String>(
    'ifsc_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastVisitDateMeta = const VerificationMeta(
    'lastVisitDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastVisitDate =
      GeneratedColumn<DateTime>(
        'last_visit_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _taxPreferenceMeta = const VerificationMeta(
    'taxPreference',
  );
  @override
  late final GeneratedColumn<String> taxPreference = GeneratedColumn<String>(
    'tax_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Taxable'),
  );
  static const VerificationMeta _landmarkMeta = const VerificationMeta(
    'landmark',
  );
  @override
  late final GeneratedColumn<String> landmark = GeneratedColumn<String>(
    'landmark',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('India'),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinCodeMeta = const VerificationMeta(
    'pinCode',
  );
  @override
  late final GeneratedColumn<String> pinCode = GeneratedColumn<String>(
    'pin_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panNumberMeta = const VerificationMeta(
    'panNumber',
  );
  @override
  late final GeneratedColumn<String> panNumber = GeneratedColumn<String>(
    'pan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openingGoldBalanceMeta =
      const VerificationMeta('openingGoldBalance');
  @override
  late final GeneratedColumn<double> openingGoldBalance =
      GeneratedColumn<double>(
        'opening_gold_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _openingSilverBalanceMeta =
      const VerificationMeta('openingSilverBalance');
  @override
  late final GeneratedColumn<double> openingSilverBalance =
      GeneratedColumn<double>(
        'opening_silver_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _openingCashBalanceMeta =
      const VerificationMeta('openingCashBalance');
  @override
  late final GeneratedColumn<double> openingCashBalance =
      GeneratedColumn<double>(
        'opening_cash_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _goldBalanceMeta = const VerificationMeta(
    'goldBalance',
  );
  @override
  late final GeneratedColumn<double> goldBalance = GeneratedColumn<double>(
    'gold_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _silverBalanceMeta = const VerificationMeta(
    'silverBalance',
  );
  @override
  late final GeneratedColumn<double> silverBalance = GeneratedColumn<double>(
    'silver_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cashBalanceMeta = const VerificationMeta(
    'cashBalance',
  );
  @override
  late final GeneratedColumn<double> cashBalance = GeneratedColumn<double>(
    'cash_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditLimitGoldMeta = const VerificationMeta(
    'creditLimitGold',
  );
  @override
  late final GeneratedColumn<double> creditLimitGold = GeneratedColumn<double>(
    'credit_limit_gold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _creditLimitCashMeta = const VerificationMeta(
    'creditLimitCash',
  );
  @override
  late final GeneratedColumn<double> creditLimitCash = GeneratedColumn<double>(
    'credit_limit_cash',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _defaultWastageMeta = const VerificationMeta(
    'defaultWastage',
  );
  @override
  late final GeneratedColumn<double> defaultWastage = GeneratedColumn<double>(
    'default_wastage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultRateMeta = const VerificationMeta(
    'defaultRate',
  );
  @override
  late final GeneratedColumn<double> defaultRate = GeneratedColumn<double>(
    'default_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    mobile,
    email,
    companyName,
    code,
    title,
    contactPerson,
    workPhone,
    whatsappNumber,
    alternatePhone,
    courier,
    notes,
    gender,
    dateOfBirth,
    anniversaryDate,
    referredBy,
    status,
    discountPercentage,
    paymentTerms,
    bankName,
    bankAccountNumber,
    ifscCode,
    lastVisitDate,
    taxPreference,
    landmark,
    country,
    address,
    addressLine1,
    addressLine2,
    city,
    state,
    pinCode,
    type,
    gstin,
    panNumber,
    openingGoldBalance,
    openingSilverBalance,
    openingCashBalance,
    goldBalance,
    silverBalance,
    cashBalance,
    creditLimitGold,
    creditLimitCash,
    createdAt,
    defaultWastage,
    defaultRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Party> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(
        _mobileMeta,
        mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta),
      );
    } else if (isInserting) {
      context.missing(_mobileMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('work_phone')) {
      context.handle(
        _workPhoneMeta,
        workPhone.isAcceptableOrUnknown(data['work_phone']!, _workPhoneMeta),
      );
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    if (data.containsKey('alternate_phone')) {
      context.handle(
        _alternatePhoneMeta,
        alternatePhone.isAcceptableOrUnknown(
          data['alternate_phone']!,
          _alternatePhoneMeta,
        ),
      );
    }
    if (data.containsKey('courier')) {
      context.handle(
        _courierMeta,
        courier.isAcceptableOrUnknown(data['courier']!, _courierMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('anniversary_date')) {
      context.handle(
        _anniversaryDateMeta,
        anniversaryDate.isAcceptableOrUnknown(
          data['anniversary_date']!,
          _anniversaryDateMeta,
        ),
      );
    }
    if (data.containsKey('referred_by')) {
      context.handle(
        _referredByMeta,
        referredBy.isAcceptableOrUnknown(data['referred_by']!, _referredByMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
        _discountPercentageMeta,
        discountPercentage.isAcceptableOrUnknown(
          data['discount_percentage']!,
          _discountPercentageMeta,
        ),
      );
    }
    if (data.containsKey('payment_terms')) {
      context.handle(
        _paymentTermsMeta,
        paymentTerms.isAcceptableOrUnknown(
          data['payment_terms']!,
          _paymentTermsMeta,
        ),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('bank_account_number')) {
      context.handle(
        _bankAccountNumberMeta,
        bankAccountNumber.isAcceptableOrUnknown(
          data['bank_account_number']!,
          _bankAccountNumberMeta,
        ),
      );
    }
    if (data.containsKey('ifsc_code')) {
      context.handle(
        _ifscCodeMeta,
        ifscCode.isAcceptableOrUnknown(data['ifsc_code']!, _ifscCodeMeta),
      );
    }
    if (data.containsKey('last_visit_date')) {
      context.handle(
        _lastVisitDateMeta,
        lastVisitDate.isAcceptableOrUnknown(
          data['last_visit_date']!,
          _lastVisitDateMeta,
        ),
      );
    }
    if (data.containsKey('tax_preference')) {
      context.handle(
        _taxPreferenceMeta,
        taxPreference.isAcceptableOrUnknown(
          data['tax_preference']!,
          _taxPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('landmark')) {
      context.handle(
        _landmarkMeta,
        landmark.isAcceptableOrUnknown(data['landmark']!, _landmarkMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('pin_code')) {
      context.handle(
        _pinCodeMeta,
        pinCode.isAcceptableOrUnknown(data['pin_code']!, _pinCodeMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('pan_number')) {
      context.handle(
        _panNumberMeta,
        panNumber.isAcceptableOrUnknown(data['pan_number']!, _panNumberMeta),
      );
    }
    if (data.containsKey('opening_gold_balance')) {
      context.handle(
        _openingGoldBalanceMeta,
        openingGoldBalance.isAcceptableOrUnknown(
          data['opening_gold_balance']!,
          _openingGoldBalanceMeta,
        ),
      );
    }
    if (data.containsKey('opening_silver_balance')) {
      context.handle(
        _openingSilverBalanceMeta,
        openingSilverBalance.isAcceptableOrUnknown(
          data['opening_silver_balance']!,
          _openingSilverBalanceMeta,
        ),
      );
    }
    if (data.containsKey('opening_cash_balance')) {
      context.handle(
        _openingCashBalanceMeta,
        openingCashBalance.isAcceptableOrUnknown(
          data['opening_cash_balance']!,
          _openingCashBalanceMeta,
        ),
      );
    }
    if (data.containsKey('gold_balance')) {
      context.handle(
        _goldBalanceMeta,
        goldBalance.isAcceptableOrUnknown(
          data['gold_balance']!,
          _goldBalanceMeta,
        ),
      );
    }
    if (data.containsKey('silver_balance')) {
      context.handle(
        _silverBalanceMeta,
        silverBalance.isAcceptableOrUnknown(
          data['silver_balance']!,
          _silverBalanceMeta,
        ),
      );
    }
    if (data.containsKey('cash_balance')) {
      context.handle(
        _cashBalanceMeta,
        cashBalance.isAcceptableOrUnknown(
          data['cash_balance']!,
          _cashBalanceMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit_gold')) {
      context.handle(
        _creditLimitGoldMeta,
        creditLimitGold.isAcceptableOrUnknown(
          data['credit_limit_gold']!,
          _creditLimitGoldMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit_cash')) {
      context.handle(
        _creditLimitCashMeta,
        creditLimitCash.isAcceptableOrUnknown(
          data['credit_limit_cash']!,
          _creditLimitCashMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('default_wastage')) {
      context.handle(
        _defaultWastageMeta,
        defaultWastage.isAcceptableOrUnknown(
          data['default_wastage']!,
          _defaultWastageMeta,
        ),
      );
    }
    if (data.containsKey('default_rate')) {
      context.handle(
        _defaultRateMeta,
        defaultRate.isAcceptableOrUnknown(
          data['default_rate']!,
          _defaultRateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mobile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      ),
      workPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_phone'],
      ),
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      ),
      alternatePhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternate_phone'],
      ),
      courier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}courier'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      anniversaryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}anniversary_date'],
      ),
      referredBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referred_by'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      discountPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percentage'],
      )!,
      paymentTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_terms'],
      ),
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      bankAccountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account_number'],
      ),
      ifscCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ifsc_code'],
      ),
      lastVisitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_visit_date'],
      ),
      taxPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_preference'],
      )!,
      landmark: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}landmark'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      ),
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      pinCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_code'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      panNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_number'],
      ),
      openingGoldBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_gold_balance'],
      )!,
      openingSilverBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_silver_balance'],
      )!,
      openingCashBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_cash_balance'],
      )!,
      goldBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gold_balance'],
      )!,
      silverBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}silver_balance'],
      )!,
      cashBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cash_balance'],
      )!,
      creditLimitGold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit_gold'],
      )!,
      creditLimitCash: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit_cash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      defaultWastage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_wastage'],
      ),
      defaultRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_rate'],
      ),
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }
}

class Party extends DataClass implements Insertable<Party> {
  final int id;
  final String name;
  final String mobile;
  final String? email;
  final String? companyName;
  final String? code;
  final String? title;
  final String? contactPerson;
  final String? workPhone;
  final String? whatsappNumber;
  final String? alternatePhone;
  final String? courier;
  final String? notes;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? anniversaryDate;
  final String? referredBy;
  final String status;
  final double discountPercentage;
  final String? paymentTerms;
  final String? bankName;
  final String? bankAccountNumber;
  final String? ifscCode;
  final DateTime? lastVisitDate;
  final String taxPreference;
  final String? landmark;
  final String country;
  final String? address;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? pinCode;
  final String type;
  final String? gstin;
  final String? panNumber;
  final double openingGoldBalance;
  final double openingSilverBalance;
  final double openingCashBalance;
  final double goldBalance;
  final double silverBalance;
  final double cashBalance;
  final double creditLimitGold;
  final double creditLimitCash;
  final DateTime createdAt;
  final double? defaultWastage;
  final double? defaultRate;
  const Party({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.companyName,
    this.code,
    this.title,
    this.contactPerson,
    this.workPhone,
    this.whatsappNumber,
    this.alternatePhone,
    this.courier,
    this.notes,
    this.gender,
    this.dateOfBirth,
    this.anniversaryDate,
    this.referredBy,
    required this.status,
    required this.discountPercentage,
    this.paymentTerms,
    this.bankName,
    this.bankAccountNumber,
    this.ifscCode,
    this.lastVisitDate,
    required this.taxPreference,
    this.landmark,
    required this.country,
    this.address,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pinCode,
    required this.type,
    this.gstin,
    this.panNumber,
    required this.openingGoldBalance,
    required this.openingSilverBalance,
    required this.openingCashBalance,
    required this.goldBalance,
    required this.silverBalance,
    required this.cashBalance,
    required this.creditLimitGold,
    required this.creditLimitCash,
    required this.createdAt,
    this.defaultWastage,
    this.defaultRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['mobile'] = Variable<String>(mobile);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || workPhone != null) {
      map['work_phone'] = Variable<String>(workPhone);
    }
    if (!nullToAbsent || whatsappNumber != null) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber);
    }
    if (!nullToAbsent || alternatePhone != null) {
      map['alternate_phone'] = Variable<String>(alternatePhone);
    }
    if (!nullToAbsent || courier != null) {
      map['courier'] = Variable<String>(courier);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || anniversaryDate != null) {
      map['anniversary_date'] = Variable<DateTime>(anniversaryDate);
    }
    if (!nullToAbsent || referredBy != null) {
      map['referred_by'] = Variable<String>(referredBy);
    }
    map['status'] = Variable<String>(status);
    map['discount_percentage'] = Variable<double>(discountPercentage);
    if (!nullToAbsent || paymentTerms != null) {
      map['payment_terms'] = Variable<String>(paymentTerms);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || bankAccountNumber != null) {
      map['bank_account_number'] = Variable<String>(bankAccountNumber);
    }
    if (!nullToAbsent || ifscCode != null) {
      map['ifsc_code'] = Variable<String>(ifscCode);
    }
    if (!nullToAbsent || lastVisitDate != null) {
      map['last_visit_date'] = Variable<DateTime>(lastVisitDate);
    }
    map['tax_preference'] = Variable<String>(taxPreference);
    if (!nullToAbsent || landmark != null) {
      map['landmark'] = Variable<String>(landmark);
    }
    map['country'] = Variable<String>(country);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || pinCode != null) {
      map['pin_code'] = Variable<String>(pinCode);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || panNumber != null) {
      map['pan_number'] = Variable<String>(panNumber);
    }
    map['opening_gold_balance'] = Variable<double>(openingGoldBalance);
    map['opening_silver_balance'] = Variable<double>(openingSilverBalance);
    map['opening_cash_balance'] = Variable<double>(openingCashBalance);
    map['gold_balance'] = Variable<double>(goldBalance);
    map['silver_balance'] = Variable<double>(silverBalance);
    map['cash_balance'] = Variable<double>(cashBalance);
    map['credit_limit_gold'] = Variable<double>(creditLimitGold);
    map['credit_limit_cash'] = Variable<double>(creditLimitCash);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || defaultWastage != null) {
      map['default_wastage'] = Variable<double>(defaultWastage);
    }
    if (!nullToAbsent || defaultRate != null) {
      map['default_rate'] = Variable<double>(defaultRate);
    }
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: Value(id),
      name: Value(name),
      mobile: Value(mobile),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      workPhone: workPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(workPhone),
      whatsappNumber: whatsappNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappNumber),
      alternatePhone: alternatePhone == null && nullToAbsent
          ? const Value.absent()
          : Value(alternatePhone),
      courier: courier == null && nullToAbsent
          ? const Value.absent()
          : Value(courier),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      anniversaryDate: anniversaryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(anniversaryDate),
      referredBy: referredBy == null && nullToAbsent
          ? const Value.absent()
          : Value(referredBy),
      status: Value(status),
      discountPercentage: Value(discountPercentage),
      paymentTerms: paymentTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentTerms),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      bankAccountNumber: bankAccountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccountNumber),
      ifscCode: ifscCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ifscCode),
      lastVisitDate: lastVisitDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisitDate),
      taxPreference: Value(taxPreference),
      landmark: landmark == null && nullToAbsent
          ? const Value.absent()
          : Value(landmark),
      country: Value(country),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      pinCode: pinCode == null && nullToAbsent
          ? const Value.absent()
          : Value(pinCode),
      type: Value(type),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      panNumber: panNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(panNumber),
      openingGoldBalance: Value(openingGoldBalance),
      openingSilverBalance: Value(openingSilverBalance),
      openingCashBalance: Value(openingCashBalance),
      goldBalance: Value(goldBalance),
      silverBalance: Value(silverBalance),
      cashBalance: Value(cashBalance),
      creditLimitGold: Value(creditLimitGold),
      creditLimitCash: Value(creditLimitCash),
      createdAt: Value(createdAt),
      defaultWastage: defaultWastage == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWastage),
      defaultRate: defaultRate == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultRate),
    );
  }

  factory Party.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mobile: serializer.fromJson<String>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      companyName: serializer.fromJson<String?>(json['companyName']),
      code: serializer.fromJson<String?>(json['code']),
      title: serializer.fromJson<String?>(json['title']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      workPhone: serializer.fromJson<String?>(json['workPhone']),
      whatsappNumber: serializer.fromJson<String?>(json['whatsappNumber']),
      alternatePhone: serializer.fromJson<String?>(json['alternatePhone']),
      courier: serializer.fromJson<String?>(json['courier']),
      notes: serializer.fromJson<String?>(json['notes']),
      gender: serializer.fromJson<String?>(json['gender']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      anniversaryDate: serializer.fromJson<DateTime?>(json['anniversaryDate']),
      referredBy: serializer.fromJson<String?>(json['referredBy']),
      status: serializer.fromJson<String>(json['status']),
      discountPercentage: serializer.fromJson<double>(
        json['discountPercentage'],
      ),
      paymentTerms: serializer.fromJson<String?>(json['paymentTerms']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      bankAccountNumber: serializer.fromJson<String?>(
        json['bankAccountNumber'],
      ),
      ifscCode: serializer.fromJson<String?>(json['ifscCode']),
      lastVisitDate: serializer.fromJson<DateTime?>(json['lastVisitDate']),
      taxPreference: serializer.fromJson<String>(json['taxPreference']),
      landmark: serializer.fromJson<String?>(json['landmark']),
      country: serializer.fromJson<String>(json['country']),
      address: serializer.fromJson<String?>(json['address']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      pinCode: serializer.fromJson<String?>(json['pinCode']),
      type: serializer.fromJson<String>(json['type']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      panNumber: serializer.fromJson<String?>(json['panNumber']),
      openingGoldBalance: serializer.fromJson<double>(
        json['openingGoldBalance'],
      ),
      openingSilverBalance: serializer.fromJson<double>(
        json['openingSilverBalance'],
      ),
      openingCashBalance: serializer.fromJson<double>(
        json['openingCashBalance'],
      ),
      goldBalance: serializer.fromJson<double>(json['goldBalance']),
      silverBalance: serializer.fromJson<double>(json['silverBalance']),
      cashBalance: serializer.fromJson<double>(json['cashBalance']),
      creditLimitGold: serializer.fromJson<double>(json['creditLimitGold']),
      creditLimitCash: serializer.fromJson<double>(json['creditLimitCash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      defaultWastage: serializer.fromJson<double?>(json['defaultWastage']),
      defaultRate: serializer.fromJson<double?>(json['defaultRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'mobile': serializer.toJson<String>(mobile),
      'email': serializer.toJson<String?>(email),
      'companyName': serializer.toJson<String?>(companyName),
      'code': serializer.toJson<String?>(code),
      'title': serializer.toJson<String?>(title),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'workPhone': serializer.toJson<String?>(workPhone),
      'whatsappNumber': serializer.toJson<String?>(whatsappNumber),
      'alternatePhone': serializer.toJson<String?>(alternatePhone),
      'courier': serializer.toJson<String?>(courier),
      'notes': serializer.toJson<String?>(notes),
      'gender': serializer.toJson<String?>(gender),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'anniversaryDate': serializer.toJson<DateTime?>(anniversaryDate),
      'referredBy': serializer.toJson<String?>(referredBy),
      'status': serializer.toJson<String>(status),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
      'paymentTerms': serializer.toJson<String?>(paymentTerms),
      'bankName': serializer.toJson<String?>(bankName),
      'bankAccountNumber': serializer.toJson<String?>(bankAccountNumber),
      'ifscCode': serializer.toJson<String?>(ifscCode),
      'lastVisitDate': serializer.toJson<DateTime?>(lastVisitDate),
      'taxPreference': serializer.toJson<String>(taxPreference),
      'landmark': serializer.toJson<String?>(landmark),
      'country': serializer.toJson<String>(country),
      'address': serializer.toJson<String?>(address),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'pinCode': serializer.toJson<String?>(pinCode),
      'type': serializer.toJson<String>(type),
      'gstin': serializer.toJson<String?>(gstin),
      'panNumber': serializer.toJson<String?>(panNumber),
      'openingGoldBalance': serializer.toJson<double>(openingGoldBalance),
      'openingSilverBalance': serializer.toJson<double>(openingSilverBalance),
      'openingCashBalance': serializer.toJson<double>(openingCashBalance),
      'goldBalance': serializer.toJson<double>(goldBalance),
      'silverBalance': serializer.toJson<double>(silverBalance),
      'cashBalance': serializer.toJson<double>(cashBalance),
      'creditLimitGold': serializer.toJson<double>(creditLimitGold),
      'creditLimitCash': serializer.toJson<double>(creditLimitCash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'defaultWastage': serializer.toJson<double?>(defaultWastage),
      'defaultRate': serializer.toJson<double?>(defaultRate),
    };
  }

  Party copyWith({
    int? id,
    String? name,
    String? mobile,
    Value<String?> email = const Value.absent(),
    Value<String?> companyName = const Value.absent(),
    Value<String?> code = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> contactPerson = const Value.absent(),
    Value<String?> workPhone = const Value.absent(),
    Value<String?> whatsappNumber = const Value.absent(),
    Value<String?> alternatePhone = const Value.absent(),
    Value<String?> courier = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<DateTime?> anniversaryDate = const Value.absent(),
    Value<String?> referredBy = const Value.absent(),
    String? status,
    double? discountPercentage,
    Value<String?> paymentTerms = const Value.absent(),
    Value<String?> bankName = const Value.absent(),
    Value<String?> bankAccountNumber = const Value.absent(),
    Value<String?> ifscCode = const Value.absent(),
    Value<DateTime?> lastVisitDate = const Value.absent(),
    String? taxPreference,
    Value<String?> landmark = const Value.absent(),
    String? country,
    Value<String?> address = const Value.absent(),
    Value<String?> addressLine1 = const Value.absent(),
    Value<String?> addressLine2 = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> pinCode = const Value.absent(),
    String? type,
    Value<String?> gstin = const Value.absent(),
    Value<String?> panNumber = const Value.absent(),
    double? openingGoldBalance,
    double? openingSilverBalance,
    double? openingCashBalance,
    double? goldBalance,
    double? silverBalance,
    double? cashBalance,
    double? creditLimitGold,
    double? creditLimitCash,
    DateTime? createdAt,
    Value<double?> defaultWastage = const Value.absent(),
    Value<double?> defaultRate = const Value.absent(),
  }) => Party(
    id: id ?? this.id,
    name: name ?? this.name,
    mobile: mobile ?? this.mobile,
    email: email.present ? email.value : this.email,
    companyName: companyName.present ? companyName.value : this.companyName,
    code: code.present ? code.value : this.code,
    title: title.present ? title.value : this.title,
    contactPerson: contactPerson.present
        ? contactPerson.value
        : this.contactPerson,
    workPhone: workPhone.present ? workPhone.value : this.workPhone,
    whatsappNumber: whatsappNumber.present
        ? whatsappNumber.value
        : this.whatsappNumber,
    alternatePhone: alternatePhone.present
        ? alternatePhone.value
        : this.alternatePhone,
    courier: courier.present ? courier.value : this.courier,
    notes: notes.present ? notes.value : this.notes,
    gender: gender.present ? gender.value : this.gender,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    anniversaryDate: anniversaryDate.present
        ? anniversaryDate.value
        : this.anniversaryDate,
    referredBy: referredBy.present ? referredBy.value : this.referredBy,
    status: status ?? this.status,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    paymentTerms: paymentTerms.present ? paymentTerms.value : this.paymentTerms,
    bankName: bankName.present ? bankName.value : this.bankName,
    bankAccountNumber: bankAccountNumber.present
        ? bankAccountNumber.value
        : this.bankAccountNumber,
    ifscCode: ifscCode.present ? ifscCode.value : this.ifscCode,
    lastVisitDate: lastVisitDate.present
        ? lastVisitDate.value
        : this.lastVisitDate,
    taxPreference: taxPreference ?? this.taxPreference,
    landmark: landmark.present ? landmark.value : this.landmark,
    country: country ?? this.country,
    address: address.present ? address.value : this.address,
    addressLine1: addressLine1.present ? addressLine1.value : this.addressLine1,
    addressLine2: addressLine2.present ? addressLine2.value : this.addressLine2,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    pinCode: pinCode.present ? pinCode.value : this.pinCode,
    type: type ?? this.type,
    gstin: gstin.present ? gstin.value : this.gstin,
    panNumber: panNumber.present ? panNumber.value : this.panNumber,
    openingGoldBalance: openingGoldBalance ?? this.openingGoldBalance,
    openingSilverBalance: openingSilverBalance ?? this.openingSilverBalance,
    openingCashBalance: openingCashBalance ?? this.openingCashBalance,
    goldBalance: goldBalance ?? this.goldBalance,
    silverBalance: silverBalance ?? this.silverBalance,
    cashBalance: cashBalance ?? this.cashBalance,
    creditLimitGold: creditLimitGold ?? this.creditLimitGold,
    creditLimitCash: creditLimitCash ?? this.creditLimitCash,
    createdAt: createdAt ?? this.createdAt,
    defaultWastage: defaultWastage.present
        ? defaultWastage.value
        : this.defaultWastage,
    defaultRate: defaultRate.present ? defaultRate.value : this.defaultRate,
  );
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      workPhone: data.workPhone.present ? data.workPhone.value : this.workPhone,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      alternatePhone: data.alternatePhone.present
          ? data.alternatePhone.value
          : this.alternatePhone,
      courier: data.courier.present ? data.courier.value : this.courier,
      notes: data.notes.present ? data.notes.value : this.notes,
      gender: data.gender.present ? data.gender.value : this.gender,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      anniversaryDate: data.anniversaryDate.present
          ? data.anniversaryDate.value
          : this.anniversaryDate,
      referredBy: data.referredBy.present
          ? data.referredBy.value
          : this.referredBy,
      status: data.status.present ? data.status.value : this.status,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      paymentTerms: data.paymentTerms.present
          ? data.paymentTerms.value
          : this.paymentTerms,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      bankAccountNumber: data.bankAccountNumber.present
          ? data.bankAccountNumber.value
          : this.bankAccountNumber,
      ifscCode: data.ifscCode.present ? data.ifscCode.value : this.ifscCode,
      lastVisitDate: data.lastVisitDate.present
          ? data.lastVisitDate.value
          : this.lastVisitDate,
      taxPreference: data.taxPreference.present
          ? data.taxPreference.value
          : this.taxPreference,
      landmark: data.landmark.present ? data.landmark.value : this.landmark,
      country: data.country.present ? data.country.value : this.country,
      address: data.address.present ? data.address.value : this.address,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      pinCode: data.pinCode.present ? data.pinCode.value : this.pinCode,
      type: data.type.present ? data.type.value : this.type,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      panNumber: data.panNumber.present ? data.panNumber.value : this.panNumber,
      openingGoldBalance: data.openingGoldBalance.present
          ? data.openingGoldBalance.value
          : this.openingGoldBalance,
      openingSilverBalance: data.openingSilverBalance.present
          ? data.openingSilverBalance.value
          : this.openingSilverBalance,
      openingCashBalance: data.openingCashBalance.present
          ? data.openingCashBalance.value
          : this.openingCashBalance,
      goldBalance: data.goldBalance.present
          ? data.goldBalance.value
          : this.goldBalance,
      silverBalance: data.silverBalance.present
          ? data.silverBalance.value
          : this.silverBalance,
      cashBalance: data.cashBalance.present
          ? data.cashBalance.value
          : this.cashBalance,
      creditLimitGold: data.creditLimitGold.present
          ? data.creditLimitGold.value
          : this.creditLimitGold,
      creditLimitCash: data.creditLimitCash.present
          ? data.creditLimitCash.value
          : this.creditLimitCash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      defaultWastage: data.defaultWastage.present
          ? data.defaultWastage.value
          : this.defaultWastage,
      defaultRate: data.defaultRate.present
          ? data.defaultRate.value
          : this.defaultRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Party(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('companyName: $companyName, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('workPhone: $workPhone, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('alternatePhone: $alternatePhone, ')
          ..write('courier: $courier, ')
          ..write('notes: $notes, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('anniversaryDate: $anniversaryDate, ')
          ..write('referredBy: $referredBy, ')
          ..write('status: $status, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountNumber: $bankAccountNumber, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('lastVisitDate: $lastVisitDate, ')
          ..write('taxPreference: $taxPreference, ')
          ..write('landmark: $landmark, ')
          ..write('country: $country, ')
          ..write('address: $address, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pinCode: $pinCode, ')
          ..write('type: $type, ')
          ..write('gstin: $gstin, ')
          ..write('panNumber: $panNumber, ')
          ..write('openingGoldBalance: $openingGoldBalance, ')
          ..write('openingSilverBalance: $openingSilverBalance, ')
          ..write('openingCashBalance: $openingCashBalance, ')
          ..write('goldBalance: $goldBalance, ')
          ..write('silverBalance: $silverBalance, ')
          ..write('cashBalance: $cashBalance, ')
          ..write('creditLimitGold: $creditLimitGold, ')
          ..write('creditLimitCash: $creditLimitCash, ')
          ..write('createdAt: $createdAt, ')
          ..write('defaultWastage: $defaultWastage, ')
          ..write('defaultRate: $defaultRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    mobile,
    email,
    companyName,
    code,
    title,
    contactPerson,
    workPhone,
    whatsappNumber,
    alternatePhone,
    courier,
    notes,
    gender,
    dateOfBirth,
    anniversaryDate,
    referredBy,
    status,
    discountPercentage,
    paymentTerms,
    bankName,
    bankAccountNumber,
    ifscCode,
    lastVisitDate,
    taxPreference,
    landmark,
    country,
    address,
    addressLine1,
    addressLine2,
    city,
    state,
    pinCode,
    type,
    gstin,
    panNumber,
    openingGoldBalance,
    openingSilverBalance,
    openingCashBalance,
    goldBalance,
    silverBalance,
    cashBalance,
    creditLimitGold,
    creditLimitCash,
    createdAt,
    defaultWastage,
    defaultRate,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Party &&
          other.id == this.id &&
          other.name == this.name &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.companyName == this.companyName &&
          other.code == this.code &&
          other.title == this.title &&
          other.contactPerson == this.contactPerson &&
          other.workPhone == this.workPhone &&
          other.whatsappNumber == this.whatsappNumber &&
          other.alternatePhone == this.alternatePhone &&
          other.courier == this.courier &&
          other.notes == this.notes &&
          other.gender == this.gender &&
          other.dateOfBirth == this.dateOfBirth &&
          other.anniversaryDate == this.anniversaryDate &&
          other.referredBy == this.referredBy &&
          other.status == this.status &&
          other.discountPercentage == this.discountPercentage &&
          other.paymentTerms == this.paymentTerms &&
          other.bankName == this.bankName &&
          other.bankAccountNumber == this.bankAccountNumber &&
          other.ifscCode == this.ifscCode &&
          other.lastVisitDate == this.lastVisitDate &&
          other.taxPreference == this.taxPreference &&
          other.landmark == this.landmark &&
          other.country == this.country &&
          other.address == this.address &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.pinCode == this.pinCode &&
          other.type == this.type &&
          other.gstin == this.gstin &&
          other.panNumber == this.panNumber &&
          other.openingGoldBalance == this.openingGoldBalance &&
          other.openingSilverBalance == this.openingSilverBalance &&
          other.openingCashBalance == this.openingCashBalance &&
          other.goldBalance == this.goldBalance &&
          other.silverBalance == this.silverBalance &&
          other.cashBalance == this.cashBalance &&
          other.creditLimitGold == this.creditLimitGold &&
          other.creditLimitCash == this.creditLimitCash &&
          other.createdAt == this.createdAt &&
          other.defaultWastage == this.defaultWastage &&
          other.defaultRate == this.defaultRate);
}

class PartiesCompanion extends UpdateCompanion<Party> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> mobile;
  final Value<String?> email;
  final Value<String?> companyName;
  final Value<String?> code;
  final Value<String?> title;
  final Value<String?> contactPerson;
  final Value<String?> workPhone;
  final Value<String?> whatsappNumber;
  final Value<String?> alternatePhone;
  final Value<String?> courier;
  final Value<String?> notes;
  final Value<String?> gender;
  final Value<DateTime?> dateOfBirth;
  final Value<DateTime?> anniversaryDate;
  final Value<String?> referredBy;
  final Value<String> status;
  final Value<double> discountPercentage;
  final Value<String?> paymentTerms;
  final Value<String?> bankName;
  final Value<String?> bankAccountNumber;
  final Value<String?> ifscCode;
  final Value<DateTime?> lastVisitDate;
  final Value<String> taxPreference;
  final Value<String?> landmark;
  final Value<String> country;
  final Value<String?> address;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> pinCode;
  final Value<String> type;
  final Value<String?> gstin;
  final Value<String?> panNumber;
  final Value<double> openingGoldBalance;
  final Value<double> openingSilverBalance;
  final Value<double> openingCashBalance;
  final Value<double> goldBalance;
  final Value<double> silverBalance;
  final Value<double> cashBalance;
  final Value<double> creditLimitGold;
  final Value<double> creditLimitCash;
  final Value<DateTime> createdAt;
  final Value<double?> defaultWastage;
  final Value<double?> defaultRate;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.companyName = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.workPhone = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.alternatePhone = const Value.absent(),
    this.courier = const Value.absent(),
    this.notes = const Value.absent(),
    this.gender = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.anniversaryDate = const Value.absent(),
    this.referredBy = const Value.absent(),
    this.status = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountNumber = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.lastVisitDate = const Value.absent(),
    this.taxPreference = const Value.absent(),
    this.landmark = const Value.absent(),
    this.country = const Value.absent(),
    this.address = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.pinCode = const Value.absent(),
    this.type = const Value.absent(),
    this.gstin = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.openingGoldBalance = const Value.absent(),
    this.openingSilverBalance = const Value.absent(),
    this.openingCashBalance = const Value.absent(),
    this.goldBalance = const Value.absent(),
    this.silverBalance = const Value.absent(),
    this.cashBalance = const Value.absent(),
    this.creditLimitGold = const Value.absent(),
    this.creditLimitCash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.defaultWastage = const Value.absent(),
    this.defaultRate = const Value.absent(),
  });
  PartiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String mobile,
    this.email = const Value.absent(),
    this.companyName = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.workPhone = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.alternatePhone = const Value.absent(),
    this.courier = const Value.absent(),
    this.notes = const Value.absent(),
    this.gender = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.anniversaryDate = const Value.absent(),
    this.referredBy = const Value.absent(),
    this.status = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountNumber = const Value.absent(),
    this.ifscCode = const Value.absent(),
    this.lastVisitDate = const Value.absent(),
    this.taxPreference = const Value.absent(),
    this.landmark = const Value.absent(),
    this.country = const Value.absent(),
    this.address = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.pinCode = const Value.absent(),
    required String type,
    this.gstin = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.openingGoldBalance = const Value.absent(),
    this.openingSilverBalance = const Value.absent(),
    this.openingCashBalance = const Value.absent(),
    this.goldBalance = const Value.absent(),
    this.silverBalance = const Value.absent(),
    this.cashBalance = const Value.absent(),
    this.creditLimitGold = const Value.absent(),
    this.creditLimitCash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.defaultWastage = const Value.absent(),
    this.defaultRate = const Value.absent(),
  }) : name = Value(name),
       mobile = Value(mobile),
       type = Value(type);
  static Insertable<Party> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? companyName,
    Expression<String>? code,
    Expression<String>? title,
    Expression<String>? contactPerson,
    Expression<String>? workPhone,
    Expression<String>? whatsappNumber,
    Expression<String>? alternatePhone,
    Expression<String>? courier,
    Expression<String>? notes,
    Expression<String>? gender,
    Expression<DateTime>? dateOfBirth,
    Expression<DateTime>? anniversaryDate,
    Expression<String>? referredBy,
    Expression<String>? status,
    Expression<double>? discountPercentage,
    Expression<String>? paymentTerms,
    Expression<String>? bankName,
    Expression<String>? bankAccountNumber,
    Expression<String>? ifscCode,
    Expression<DateTime>? lastVisitDate,
    Expression<String>? taxPreference,
    Expression<String>? landmark,
    Expression<String>? country,
    Expression<String>? address,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? pinCode,
    Expression<String>? type,
    Expression<String>? gstin,
    Expression<String>? panNumber,
    Expression<double>? openingGoldBalance,
    Expression<double>? openingSilverBalance,
    Expression<double>? openingCashBalance,
    Expression<double>? goldBalance,
    Expression<double>? silverBalance,
    Expression<double>? cashBalance,
    Expression<double>? creditLimitGold,
    Expression<double>? creditLimitCash,
    Expression<DateTime>? createdAt,
    Expression<double>? defaultWastage,
    Expression<double>? defaultRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (companyName != null) 'company_name': companyName,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (workPhone != null) 'work_phone': workPhone,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (alternatePhone != null) 'alternate_phone': alternatePhone,
      if (courier != null) 'courier': courier,
      if (notes != null) 'notes': notes,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (anniversaryDate != null) 'anniversary_date': anniversaryDate,
      if (referredBy != null) 'referred_by': referredBy,
      if (status != null) 'status': status,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (paymentTerms != null) 'payment_terms': paymentTerms,
      if (bankName != null) 'bank_name': bankName,
      if (bankAccountNumber != null) 'bank_account_number': bankAccountNumber,
      if (ifscCode != null) 'ifsc_code': ifscCode,
      if (lastVisitDate != null) 'last_visit_date': lastVisitDate,
      if (taxPreference != null) 'tax_preference': taxPreference,
      if (landmark != null) 'landmark': landmark,
      if (country != null) 'country': country,
      if (address != null) 'address': address,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pinCode != null) 'pin_code': pinCode,
      if (type != null) 'type': type,
      if (gstin != null) 'gstin': gstin,
      if (panNumber != null) 'pan_number': panNumber,
      if (openingGoldBalance != null)
        'opening_gold_balance': openingGoldBalance,
      if (openingSilverBalance != null)
        'opening_silver_balance': openingSilverBalance,
      if (openingCashBalance != null)
        'opening_cash_balance': openingCashBalance,
      if (goldBalance != null) 'gold_balance': goldBalance,
      if (silverBalance != null) 'silver_balance': silverBalance,
      if (cashBalance != null) 'cash_balance': cashBalance,
      if (creditLimitGold != null) 'credit_limit_gold': creditLimitGold,
      if (creditLimitCash != null) 'credit_limit_cash': creditLimitCash,
      if (createdAt != null) 'created_at': createdAt,
      if (defaultWastage != null) 'default_wastage': defaultWastage,
      if (defaultRate != null) 'default_rate': defaultRate,
    });
  }

  PartiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? mobile,
    Value<String?>? email,
    Value<String?>? companyName,
    Value<String?>? code,
    Value<String?>? title,
    Value<String?>? contactPerson,
    Value<String?>? workPhone,
    Value<String?>? whatsappNumber,
    Value<String?>? alternatePhone,
    Value<String?>? courier,
    Value<String?>? notes,
    Value<String?>? gender,
    Value<DateTime?>? dateOfBirth,
    Value<DateTime?>? anniversaryDate,
    Value<String?>? referredBy,
    Value<String>? status,
    Value<double>? discountPercentage,
    Value<String?>? paymentTerms,
    Value<String?>? bankName,
    Value<String?>? bankAccountNumber,
    Value<String?>? ifscCode,
    Value<DateTime?>? lastVisitDate,
    Value<String>? taxPreference,
    Value<String?>? landmark,
    Value<String>? country,
    Value<String?>? address,
    Value<String?>? addressLine1,
    Value<String?>? addressLine2,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? pinCode,
    Value<String>? type,
    Value<String?>? gstin,
    Value<String?>? panNumber,
    Value<double>? openingGoldBalance,
    Value<double>? openingSilverBalance,
    Value<double>? openingCashBalance,
    Value<double>? goldBalance,
    Value<double>? silverBalance,
    Value<double>? cashBalance,
    Value<double>? creditLimitGold,
    Value<double>? creditLimitCash,
    Value<DateTime>? createdAt,
    Value<double?>? defaultWastage,
    Value<double?>? defaultRate,
  }) {
    return PartiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      code: code ?? this.code,
      title: title ?? this.title,
      contactPerson: contactPerson ?? this.contactPerson,
      workPhone: workPhone ?? this.workPhone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      courier: courier ?? this.courier,
      notes: notes ?? this.notes,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      referredBy: referredBy ?? this.referredBy,
      status: status ?? this.status,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      taxPreference: taxPreference ?? this.taxPreference,
      landmark: landmark ?? this.landmark,
      country: country ?? this.country,
      address: address ?? this.address,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      type: type ?? this.type,
      gstin: gstin ?? this.gstin,
      panNumber: panNumber ?? this.panNumber,
      openingGoldBalance: openingGoldBalance ?? this.openingGoldBalance,
      openingSilverBalance: openingSilverBalance ?? this.openingSilverBalance,
      openingCashBalance: openingCashBalance ?? this.openingCashBalance,
      goldBalance: goldBalance ?? this.goldBalance,
      silverBalance: silverBalance ?? this.silverBalance,
      cashBalance: cashBalance ?? this.cashBalance,
      creditLimitGold: creditLimitGold ?? this.creditLimitGold,
      creditLimitCash: creditLimitCash ?? this.creditLimitCash,
      createdAt: createdAt ?? this.createdAt,
      defaultWastage: defaultWastage ?? this.defaultWastage,
      defaultRate: defaultRate ?? this.defaultRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (workPhone.present) {
      map['work_phone'] = Variable<String>(workPhone.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (alternatePhone.present) {
      map['alternate_phone'] = Variable<String>(alternatePhone.value);
    }
    if (courier.present) {
      map['courier'] = Variable<String>(courier.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (anniversaryDate.present) {
      map['anniversary_date'] = Variable<DateTime>(anniversaryDate.value);
    }
    if (referredBy.present) {
      map['referred_by'] = Variable<String>(referredBy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (paymentTerms.present) {
      map['payment_terms'] = Variable<String>(paymentTerms.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (bankAccountNumber.present) {
      map['bank_account_number'] = Variable<String>(bankAccountNumber.value);
    }
    if (ifscCode.present) {
      map['ifsc_code'] = Variable<String>(ifscCode.value);
    }
    if (lastVisitDate.present) {
      map['last_visit_date'] = Variable<DateTime>(lastVisitDate.value);
    }
    if (taxPreference.present) {
      map['tax_preference'] = Variable<String>(taxPreference.value);
    }
    if (landmark.present) {
      map['landmark'] = Variable<String>(landmark.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (pinCode.present) {
      map['pin_code'] = Variable<String>(pinCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (panNumber.present) {
      map['pan_number'] = Variable<String>(panNumber.value);
    }
    if (openingGoldBalance.present) {
      map['opening_gold_balance'] = Variable<double>(openingGoldBalance.value);
    }
    if (openingSilverBalance.present) {
      map['opening_silver_balance'] = Variable<double>(
        openingSilverBalance.value,
      );
    }
    if (openingCashBalance.present) {
      map['opening_cash_balance'] = Variable<double>(openingCashBalance.value);
    }
    if (goldBalance.present) {
      map['gold_balance'] = Variable<double>(goldBalance.value);
    }
    if (silverBalance.present) {
      map['silver_balance'] = Variable<double>(silverBalance.value);
    }
    if (cashBalance.present) {
      map['cash_balance'] = Variable<double>(cashBalance.value);
    }
    if (creditLimitGold.present) {
      map['credit_limit_gold'] = Variable<double>(creditLimitGold.value);
    }
    if (creditLimitCash.present) {
      map['credit_limit_cash'] = Variable<double>(creditLimitCash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (defaultWastage.present) {
      map['default_wastage'] = Variable<double>(defaultWastage.value);
    }
    if (defaultRate.present) {
      map['default_rate'] = Variable<double>(defaultRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('companyName: $companyName, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('workPhone: $workPhone, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('alternatePhone: $alternatePhone, ')
          ..write('courier: $courier, ')
          ..write('notes: $notes, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('anniversaryDate: $anniversaryDate, ')
          ..write('referredBy: $referredBy, ')
          ..write('status: $status, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountNumber: $bankAccountNumber, ')
          ..write('ifscCode: $ifscCode, ')
          ..write('lastVisitDate: $lastVisitDate, ')
          ..write('taxPreference: $taxPreference, ')
          ..write('landmark: $landmark, ')
          ..write('country: $country, ')
          ..write('address: $address, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('pinCode: $pinCode, ')
          ..write('type: $type, ')
          ..write('gstin: $gstin, ')
          ..write('panNumber: $panNumber, ')
          ..write('openingGoldBalance: $openingGoldBalance, ')
          ..write('openingSilverBalance: $openingSilverBalance, ')
          ..write('openingCashBalance: $openingCashBalance, ')
          ..write('goldBalance: $goldBalance, ')
          ..write('silverBalance: $silverBalance, ')
          ..write('cashBalance: $cashBalance, ')
          ..write('creditLimitGold: $creditLimitGold, ')
          ..write('creditLimitCash: $creditLimitCash, ')
          ..write('createdAt: $createdAt, ')
          ..write('defaultWastage: $defaultWastage, ')
          ..write('defaultRate: $defaultRate')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metalTypeMeta = const VerificationMeta(
    'metalType',
  );
  @override
  late final GeneratedColumn<String> metalType = GeneratedColumn<String>(
    'metal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purityMeta = const VerificationMeta('purity');
  @override
  late final GeneratedColumn<String> purity = GeneratedColumn<String>(
    'purity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costPriceMeta = const VerificationMeta(
    'costPrice',
  );
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
    'cost_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _makingChargesMeta = const VerificationMeta(
    'makingCharges',
  );
  @override
  late final GeneratedColumn<double> makingCharges = GeneratedColumn<double>(
    'making_charges',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _wastagePercentageMeta = const VerificationMeta(
    'wastagePercentage',
  );
  @override
  late final GeneratedColumn<double> wastagePercentage =
      GeneratedColumn<double>(
        'wastage_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<double> stockQty = GeneratedColumn<double>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _stockWeightMeta = const VerificationMeta(
    'stockWeight',
  );
  @override
  late final GeneratedColumn<double> stockWeight = GeneratedColumn<double>(
    'stock_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _minimumStockLevelMeta = const VerificationMeta(
    'minimumStockLevel',
  );
  @override
  late final GeneratedColumn<double> minimumStockLevel =
      GeneratedColumn<double>(
        'minimum_stock_level',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _reorderLevelMeta = const VerificationMeta(
    'reorderLevel',
  );
  @override
  late final GeneratedColumn<double> reorderLevel = GeneratedColumn<double>(
    'reorder_level',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _unitOfMeasurementMeta = const VerificationMeta(
    'unitOfMeasurement',
  );
  @override
  late final GeneratedColumn<String> unitOfMeasurement =
      GeneratedColumn<String>(
        'unit_of_measurement',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('g'),
      );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stampMeta = const VerificationMeta('stamp');
  @override
  late final GeneratedColumn<String> stamp = GeneratedColumn<String>(
    'stamp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stoneDetailsMeta = const VerificationMeta(
    'stoneDetails',
  );
  @override
  late final GeneratedColumn<String> stoneDetails = GeneratedColumn<String>(
    'stone_details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Active'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Goods'),
  );
  static const VerificationMeta _maintainStockInMeta = const VerificationMeta(
    'maintainStockIn',
  );
  @override
  late final GeneratedColumn<String> maintainStockIn = GeneratedColumn<String>(
    'maintain_stock_in',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Grams'),
  );
  static const VerificationMeta _isStuddedMeta = const VerificationMeta(
    'isStudded',
  );
  @override
  late final GeneratedColumn<bool> isStudded = GeneratedColumn<bool>(
    'is_studded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_studded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fetchGoldRateMeta = const VerificationMeta(
    'fetchGoldRate',
  );
  @override
  late final GeneratedColumn<bool> fetchGoldRate = GeneratedColumn<bool>(
    'fetch_gold_rate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fetch_gold_rate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _defaultGoldRateMeta = const VerificationMeta(
    'defaultGoldRate',
  );
  @override
  late final GeneratedColumn<String> defaultGoldRate = GeneratedColumn<String>(
    'default_gold_rate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultTouchMeta = const VerificationMeta(
    'defaultTouch',
  );
  @override
  late final GeneratedColumn<double> defaultTouch = GeneratedColumn<double>(
    'default_touch',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxPreferenceMeta = const VerificationMeta(
    'taxPreference',
  );
  @override
  late final GeneratedColumn<String> taxPreference = GeneratedColumn<String>(
    'tax_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Taxable'),
  );
  static const VerificationMeta _purchaseWastageMeta = const VerificationMeta(
    'purchaseWastage',
  );
  @override
  late final GeneratedColumn<double> purchaseWastage = GeneratedColumn<double>(
    'purchase_wastage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _purchaseMakingChargesMeta =
      const VerificationMeta('purchaseMakingCharges');
  @override
  late final GeneratedColumn<double> purchaseMakingCharges =
      GeneratedColumn<double>(
        'purchase_making_charges',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _jobworkRateMeta = const VerificationMeta(
    'jobworkRate',
  );
  @override
  late final GeneratedColumn<double> jobworkRate = GeneratedColumn<double>(
    'jobwork_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _discountLedgerMeta = const VerificationMeta(
    'discountLedger',
  );
  @override
  late final GeneratedColumn<String> discountLedger = GeneratedColumn<String>(
    'discount_ledger',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockMethodMeta = const VerificationMeta(
    'stockMethod',
  );
  @override
  late final GeneratedColumn<String> stockMethod = GeneratedColumn<String>(
    'stock_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Loose'),
  );
  static const VerificationMeta _tagPrefixMeta = const VerificationMeta(
    'tagPrefix',
  );
  @override
  late final GeneratedColumn<String> tagPrefix = GeneratedColumn<String>(
    'tag_prefix',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minStockPcsMeta = const VerificationMeta(
    'minStockPcs',
  );
  @override
  late final GeneratedColumn<double> minStockPcs = GeneratedColumn<double>(
    'min_stock_pcs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxStockGmMeta = const VerificationMeta(
    'maxStockGm',
  );
  @override
  late final GeneratedColumn<double> maxStockGm = GeneratedColumn<double>(
    'max_stock_gm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxStockPcsMeta = const VerificationMeta(
    'maxStockPcs',
  );
  @override
  late final GeneratedColumn<double> maxStockPcs = GeneratedColumn<double>(
    'max_stock_pcs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    metalType,
    purity,
    category,
    description,
    hsnCode,
    costPrice,
    sellingPrice,
    makingCharges,
    wastagePercentage,
    stockQty,
    stockWeight,
    minimumStockLevel,
    reorderLevel,
    unitOfMeasurement,
    brand,
    manufacturer,
    size,
    color,
    stamp,
    stoneDetails,
    status,
    notes,
    itemType,
    maintainStockIn,
    isStudded,
    fetchGoldRate,
    defaultGoldRate,
    defaultTouch,
    taxPreference,
    purchaseWastage,
    purchaseMakingCharges,
    jobworkRate,
    discountLedger,
    stockMethod,
    tagPrefix,
    minStockPcs,
    maxStockGm,
    maxStockPcs,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('metal_type')) {
      context.handle(
        _metalTypeMeta,
        metalType.isAcceptableOrUnknown(data['metal_type']!, _metalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_metalTypeMeta);
    }
    if (data.containsKey('purity')) {
      context.handle(
        _purityMeta,
        purity.isAcceptableOrUnknown(data['purity']!, _purityMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('cost_price')) {
      context.handle(
        _costPriceMeta,
        costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    }
    if (data.containsKey('making_charges')) {
      context.handle(
        _makingChargesMeta,
        makingCharges.isAcceptableOrUnknown(
          data['making_charges']!,
          _makingChargesMeta,
        ),
      );
    }
    if (data.containsKey('wastage_percentage')) {
      context.handle(
        _wastagePercentageMeta,
        wastagePercentage.isAcceptableOrUnknown(
          data['wastage_percentage']!,
          _wastagePercentageMeta,
        ),
      );
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('stock_weight')) {
      context.handle(
        _stockWeightMeta,
        stockWeight.isAcceptableOrUnknown(
          data['stock_weight']!,
          _stockWeightMeta,
        ),
      );
    }
    if (data.containsKey('minimum_stock_level')) {
      context.handle(
        _minimumStockLevelMeta,
        minimumStockLevel.isAcceptableOrUnknown(
          data['minimum_stock_level']!,
          _minimumStockLevelMeta,
        ),
      );
    }
    if (data.containsKey('reorder_level')) {
      context.handle(
        _reorderLevelMeta,
        reorderLevel.isAcceptableOrUnknown(
          data['reorder_level']!,
          _reorderLevelMeta,
        ),
      );
    }
    if (data.containsKey('unit_of_measurement')) {
      context.handle(
        _unitOfMeasurementMeta,
        unitOfMeasurement.isAcceptableOrUnknown(
          data['unit_of_measurement']!,
          _unitOfMeasurementMeta,
        ),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('stamp')) {
      context.handle(
        _stampMeta,
        stamp.isAcceptableOrUnknown(data['stamp']!, _stampMeta),
      );
    }
    if (data.containsKey('stone_details')) {
      context.handle(
        _stoneDetailsMeta,
        stoneDetails.isAcceptableOrUnknown(
          data['stone_details']!,
          _stoneDetailsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    }
    if (data.containsKey('maintain_stock_in')) {
      context.handle(
        _maintainStockInMeta,
        maintainStockIn.isAcceptableOrUnknown(
          data['maintain_stock_in']!,
          _maintainStockInMeta,
        ),
      );
    }
    if (data.containsKey('is_studded')) {
      context.handle(
        _isStuddedMeta,
        isStudded.isAcceptableOrUnknown(data['is_studded']!, _isStuddedMeta),
      );
    }
    if (data.containsKey('fetch_gold_rate')) {
      context.handle(
        _fetchGoldRateMeta,
        fetchGoldRate.isAcceptableOrUnknown(
          data['fetch_gold_rate']!,
          _fetchGoldRateMeta,
        ),
      );
    }
    if (data.containsKey('default_gold_rate')) {
      context.handle(
        _defaultGoldRateMeta,
        defaultGoldRate.isAcceptableOrUnknown(
          data['default_gold_rate']!,
          _defaultGoldRateMeta,
        ),
      );
    }
    if (data.containsKey('default_touch')) {
      context.handle(
        _defaultTouchMeta,
        defaultTouch.isAcceptableOrUnknown(
          data['default_touch']!,
          _defaultTouchMeta,
        ),
      );
    }
    if (data.containsKey('tax_preference')) {
      context.handle(
        _taxPreferenceMeta,
        taxPreference.isAcceptableOrUnknown(
          data['tax_preference']!,
          _taxPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('purchase_wastage')) {
      context.handle(
        _purchaseWastageMeta,
        purchaseWastage.isAcceptableOrUnknown(
          data['purchase_wastage']!,
          _purchaseWastageMeta,
        ),
      );
    }
    if (data.containsKey('purchase_making_charges')) {
      context.handle(
        _purchaseMakingChargesMeta,
        purchaseMakingCharges.isAcceptableOrUnknown(
          data['purchase_making_charges']!,
          _purchaseMakingChargesMeta,
        ),
      );
    }
    if (data.containsKey('jobwork_rate')) {
      context.handle(
        _jobworkRateMeta,
        jobworkRate.isAcceptableOrUnknown(
          data['jobwork_rate']!,
          _jobworkRateMeta,
        ),
      );
    }
    if (data.containsKey('discount_ledger')) {
      context.handle(
        _discountLedgerMeta,
        discountLedger.isAcceptableOrUnknown(
          data['discount_ledger']!,
          _discountLedgerMeta,
        ),
      );
    }
    if (data.containsKey('stock_method')) {
      context.handle(
        _stockMethodMeta,
        stockMethod.isAcceptableOrUnknown(
          data['stock_method']!,
          _stockMethodMeta,
        ),
      );
    }
    if (data.containsKey('tag_prefix')) {
      context.handle(
        _tagPrefixMeta,
        tagPrefix.isAcceptableOrUnknown(data['tag_prefix']!, _tagPrefixMeta),
      );
    }
    if (data.containsKey('min_stock_pcs')) {
      context.handle(
        _minStockPcsMeta,
        minStockPcs.isAcceptableOrUnknown(
          data['min_stock_pcs']!,
          _minStockPcsMeta,
        ),
      );
    }
    if (data.containsKey('max_stock_gm')) {
      context.handle(
        _maxStockGmMeta,
        maxStockGm.isAcceptableOrUnknown(
          data['max_stock_gm']!,
          _maxStockGmMeta,
        ),
      );
    }
    if (data.containsKey('max_stock_pcs')) {
      context.handle(
        _maxStockPcsMeta,
        maxStockPcs.isAcceptableOrUnknown(
          data['max_stock_pcs']!,
          _maxStockPcsMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      metalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metal_type'],
      )!,
      purity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purity'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      costPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_price'],
      )!,
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}selling_price'],
      )!,
      makingCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}making_charges'],
      )!,
      wastagePercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wastage_percentage'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_qty'],
      )!,
      stockWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_weight'],
      )!,
      minimumStockLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}minimum_stock_level'],
      )!,
      reorderLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reorder_level'],
      )!,
      unitOfMeasurement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_of_measurement'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}size'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      stamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stamp'],
      ),
      stoneDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stone_details'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      maintainStockIn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maintain_stock_in'],
      )!,
      isStudded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_studded'],
      )!,
      fetchGoldRate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fetch_gold_rate'],
      )!,
      defaultGoldRate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_gold_rate'],
      ),
      defaultTouch: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_touch'],
      )!,
      taxPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_preference'],
      )!,
      purchaseWastage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_wastage'],
      )!,
      purchaseMakingCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_making_charges'],
      )!,
      jobworkRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jobwork_rate'],
      )!,
      discountLedger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_ledger'],
      ),
      stockMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stock_method'],
      )!,
      tagPrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_prefix'],
      ),
      minStockPcs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_stock_pcs'],
      )!,
      maxStockGm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_stock_gm'],
      )!,
      maxStockPcs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_stock_pcs'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String name;
  final String? code;
  final String metalType;
  final String? purity;
  final String? category;
  final String? description;
  final String? hsnCode;
  final double costPrice;
  final double sellingPrice;
  final double makingCharges;
  final double wastagePercentage;
  final double stockQty;
  final double stockWeight;
  final double minimumStockLevel;
  final double reorderLevel;
  final String unitOfMeasurement;
  final String? brand;
  final String? manufacturer;
  final String? size;
  final String? color;
  final String? stamp;
  final String? stoneDetails;
  final String status;
  final String? notes;
  final String itemType;
  final String maintainStockIn;
  final bool isStudded;
  final bool fetchGoldRate;
  final String? defaultGoldRate;
  final double defaultTouch;
  final String taxPreference;
  final double purchaseWastage;
  final double purchaseMakingCharges;
  final double jobworkRate;
  final String? discountLedger;
  final String stockMethod;
  final String? tagPrefix;
  final double minStockPcs;
  final double maxStockGm;
  final double maxStockPcs;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Item({
    required this.id,
    required this.name,
    this.code,
    required this.metalType,
    this.purity,
    this.category,
    this.description,
    this.hsnCode,
    required this.costPrice,
    required this.sellingPrice,
    required this.makingCharges,
    required this.wastagePercentage,
    required this.stockQty,
    required this.stockWeight,
    required this.minimumStockLevel,
    required this.reorderLevel,
    required this.unitOfMeasurement,
    this.brand,
    this.manufacturer,
    this.size,
    this.color,
    this.stamp,
    this.stoneDetails,
    required this.status,
    this.notes,
    required this.itemType,
    required this.maintainStockIn,
    required this.isStudded,
    required this.fetchGoldRate,
    this.defaultGoldRate,
    required this.defaultTouch,
    required this.taxPreference,
    required this.purchaseWastage,
    required this.purchaseMakingCharges,
    required this.jobworkRate,
    this.discountLedger,
    required this.stockMethod,
    this.tagPrefix,
    required this.minStockPcs,
    required this.maxStockGm,
    required this.maxStockPcs,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['metal_type'] = Variable<String>(metalType);
    if (!nullToAbsent || purity != null) {
      map['purity'] = Variable<String>(purity);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['cost_price'] = Variable<double>(costPrice);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['making_charges'] = Variable<double>(makingCharges);
    map['wastage_percentage'] = Variable<double>(wastagePercentage);
    map['stock_qty'] = Variable<double>(stockQty);
    map['stock_weight'] = Variable<double>(stockWeight);
    map['minimum_stock_level'] = Variable<double>(minimumStockLevel);
    map['reorder_level'] = Variable<double>(reorderLevel);
    map['unit_of_measurement'] = Variable<String>(unitOfMeasurement);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<String>(size);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || stamp != null) {
      map['stamp'] = Variable<String>(stamp);
    }
    if (!nullToAbsent || stoneDetails != null) {
      map['stone_details'] = Variable<String>(stoneDetails);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['item_type'] = Variable<String>(itemType);
    map['maintain_stock_in'] = Variable<String>(maintainStockIn);
    map['is_studded'] = Variable<bool>(isStudded);
    map['fetch_gold_rate'] = Variable<bool>(fetchGoldRate);
    if (!nullToAbsent || defaultGoldRate != null) {
      map['default_gold_rate'] = Variable<String>(defaultGoldRate);
    }
    map['default_touch'] = Variable<double>(defaultTouch);
    map['tax_preference'] = Variable<String>(taxPreference);
    map['purchase_wastage'] = Variable<double>(purchaseWastage);
    map['purchase_making_charges'] = Variable<double>(purchaseMakingCharges);
    map['jobwork_rate'] = Variable<double>(jobworkRate);
    if (!nullToAbsent || discountLedger != null) {
      map['discount_ledger'] = Variable<String>(discountLedger);
    }
    map['stock_method'] = Variable<String>(stockMethod);
    if (!nullToAbsent || tagPrefix != null) {
      map['tag_prefix'] = Variable<String>(tagPrefix);
    }
    map['min_stock_pcs'] = Variable<double>(minStockPcs);
    map['max_stock_gm'] = Variable<double>(maxStockGm);
    map['max_stock_pcs'] = Variable<double>(maxStockPcs);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      metalType: Value(metalType),
      purity: purity == null && nullToAbsent
          ? const Value.absent()
          : Value(purity),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      costPrice: Value(costPrice),
      sellingPrice: Value(sellingPrice),
      makingCharges: Value(makingCharges),
      wastagePercentage: Value(wastagePercentage),
      stockQty: Value(stockQty),
      stockWeight: Value(stockWeight),
      minimumStockLevel: Value(minimumStockLevel),
      reorderLevel: Value(reorderLevel),
      unitOfMeasurement: Value(unitOfMeasurement),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      stamp: stamp == null && nullToAbsent
          ? const Value.absent()
          : Value(stamp),
      stoneDetails: stoneDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(stoneDetails),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      itemType: Value(itemType),
      maintainStockIn: Value(maintainStockIn),
      isStudded: Value(isStudded),
      fetchGoldRate: Value(fetchGoldRate),
      defaultGoldRate: defaultGoldRate == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultGoldRate),
      defaultTouch: Value(defaultTouch),
      taxPreference: Value(taxPreference),
      purchaseWastage: Value(purchaseWastage),
      purchaseMakingCharges: Value(purchaseMakingCharges),
      jobworkRate: Value(jobworkRate),
      discountLedger: discountLedger == null && nullToAbsent
          ? const Value.absent()
          : Value(discountLedger),
      stockMethod: Value(stockMethod),
      tagPrefix: tagPrefix == null && nullToAbsent
          ? const Value.absent()
          : Value(tagPrefix),
      minStockPcs: Value(minStockPcs),
      maxStockGm: Value(maxStockGm),
      maxStockPcs: Value(maxStockPcs),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      metalType: serializer.fromJson<String>(json['metalType']),
      purity: serializer.fromJson<String?>(json['purity']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      makingCharges: serializer.fromJson<double>(json['makingCharges']),
      wastagePercentage: serializer.fromJson<double>(json['wastagePercentage']),
      stockQty: serializer.fromJson<double>(json['stockQty']),
      stockWeight: serializer.fromJson<double>(json['stockWeight']),
      minimumStockLevel: serializer.fromJson<double>(json['minimumStockLevel']),
      reorderLevel: serializer.fromJson<double>(json['reorderLevel']),
      unitOfMeasurement: serializer.fromJson<String>(json['unitOfMeasurement']),
      brand: serializer.fromJson<String?>(json['brand']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      size: serializer.fromJson<String?>(json['size']),
      color: serializer.fromJson<String?>(json['color']),
      stamp: serializer.fromJson<String?>(json['stamp']),
      stoneDetails: serializer.fromJson<String?>(json['stoneDetails']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      itemType: serializer.fromJson<String>(json['itemType']),
      maintainStockIn: serializer.fromJson<String>(json['maintainStockIn']),
      isStudded: serializer.fromJson<bool>(json['isStudded']),
      fetchGoldRate: serializer.fromJson<bool>(json['fetchGoldRate']),
      defaultGoldRate: serializer.fromJson<String?>(json['defaultGoldRate']),
      defaultTouch: serializer.fromJson<double>(json['defaultTouch']),
      taxPreference: serializer.fromJson<String>(json['taxPreference']),
      purchaseWastage: serializer.fromJson<double>(json['purchaseWastage']),
      purchaseMakingCharges: serializer.fromJson<double>(
        json['purchaseMakingCharges'],
      ),
      jobworkRate: serializer.fromJson<double>(json['jobworkRate']),
      discountLedger: serializer.fromJson<String?>(json['discountLedger']),
      stockMethod: serializer.fromJson<String>(json['stockMethod']),
      tagPrefix: serializer.fromJson<String?>(json['tagPrefix']),
      minStockPcs: serializer.fromJson<double>(json['minStockPcs']),
      maxStockGm: serializer.fromJson<double>(json['maxStockGm']),
      maxStockPcs: serializer.fromJson<double>(json['maxStockPcs']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'metalType': serializer.toJson<String>(metalType),
      'purity': serializer.toJson<String?>(purity),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'costPrice': serializer.toJson<double>(costPrice),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'makingCharges': serializer.toJson<double>(makingCharges),
      'wastagePercentage': serializer.toJson<double>(wastagePercentage),
      'stockQty': serializer.toJson<double>(stockQty),
      'stockWeight': serializer.toJson<double>(stockWeight),
      'minimumStockLevel': serializer.toJson<double>(minimumStockLevel),
      'reorderLevel': serializer.toJson<double>(reorderLevel),
      'unitOfMeasurement': serializer.toJson<String>(unitOfMeasurement),
      'brand': serializer.toJson<String?>(brand),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'size': serializer.toJson<String?>(size),
      'color': serializer.toJson<String?>(color),
      'stamp': serializer.toJson<String?>(stamp),
      'stoneDetails': serializer.toJson<String?>(stoneDetails),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'itemType': serializer.toJson<String>(itemType),
      'maintainStockIn': serializer.toJson<String>(maintainStockIn),
      'isStudded': serializer.toJson<bool>(isStudded),
      'fetchGoldRate': serializer.toJson<bool>(fetchGoldRate),
      'defaultGoldRate': serializer.toJson<String?>(defaultGoldRate),
      'defaultTouch': serializer.toJson<double>(defaultTouch),
      'taxPreference': serializer.toJson<String>(taxPreference),
      'purchaseWastage': serializer.toJson<double>(purchaseWastage),
      'purchaseMakingCharges': serializer.toJson<double>(purchaseMakingCharges),
      'jobworkRate': serializer.toJson<double>(jobworkRate),
      'discountLedger': serializer.toJson<String?>(discountLedger),
      'stockMethod': serializer.toJson<String>(stockMethod),
      'tagPrefix': serializer.toJson<String?>(tagPrefix),
      'minStockPcs': serializer.toJson<double>(minStockPcs),
      'maxStockGm': serializer.toJson<double>(maxStockGm),
      'maxStockPcs': serializer.toJson<double>(maxStockPcs),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Item copyWith({
    int? id,
    String? name,
    Value<String?> code = const Value.absent(),
    String? metalType,
    Value<String?> purity = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> hsnCode = const Value.absent(),
    double? costPrice,
    double? sellingPrice,
    double? makingCharges,
    double? wastagePercentage,
    double? stockQty,
    double? stockWeight,
    double? minimumStockLevel,
    double? reorderLevel,
    String? unitOfMeasurement,
    Value<String?> brand = const Value.absent(),
    Value<String?> manufacturer = const Value.absent(),
    Value<String?> size = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> stamp = const Value.absent(),
    Value<String?> stoneDetails = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    String? itemType,
    String? maintainStockIn,
    bool? isStudded,
    bool? fetchGoldRate,
    Value<String?> defaultGoldRate = const Value.absent(),
    double? defaultTouch,
    String? taxPreference,
    double? purchaseWastage,
    double? purchaseMakingCharges,
    double? jobworkRate,
    Value<String?> discountLedger = const Value.absent(),
    String? stockMethod,
    Value<String?> tagPrefix = const Value.absent(),
    double? minStockPcs,
    double? maxStockGm,
    double? maxStockPcs,
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Item(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    metalType: metalType ?? this.metalType,
    purity: purity.present ? purity.value : this.purity,
    category: category.present ? category.value : this.category,
    description: description.present ? description.value : this.description,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    costPrice: costPrice ?? this.costPrice,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    makingCharges: makingCharges ?? this.makingCharges,
    wastagePercentage: wastagePercentage ?? this.wastagePercentage,
    stockQty: stockQty ?? this.stockQty,
    stockWeight: stockWeight ?? this.stockWeight,
    minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
    reorderLevel: reorderLevel ?? this.reorderLevel,
    unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
    brand: brand.present ? brand.value : this.brand,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    size: size.present ? size.value : this.size,
    color: color.present ? color.value : this.color,
    stamp: stamp.present ? stamp.value : this.stamp,
    stoneDetails: stoneDetails.present ? stoneDetails.value : this.stoneDetails,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    itemType: itemType ?? this.itemType,
    maintainStockIn: maintainStockIn ?? this.maintainStockIn,
    isStudded: isStudded ?? this.isStudded,
    fetchGoldRate: fetchGoldRate ?? this.fetchGoldRate,
    defaultGoldRate: defaultGoldRate.present
        ? defaultGoldRate.value
        : this.defaultGoldRate,
    defaultTouch: defaultTouch ?? this.defaultTouch,
    taxPreference: taxPreference ?? this.taxPreference,
    purchaseWastage: purchaseWastage ?? this.purchaseWastage,
    purchaseMakingCharges: purchaseMakingCharges ?? this.purchaseMakingCharges,
    jobworkRate: jobworkRate ?? this.jobworkRate,
    discountLedger: discountLedger.present
        ? discountLedger.value
        : this.discountLedger,
    stockMethod: stockMethod ?? this.stockMethod,
    tagPrefix: tagPrefix.present ? tagPrefix.value : this.tagPrefix,
    minStockPcs: minStockPcs ?? this.minStockPcs,
    maxStockGm: maxStockGm ?? this.maxStockGm,
    maxStockPcs: maxStockPcs ?? this.maxStockPcs,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      metalType: data.metalType.present ? data.metalType.value : this.metalType,
      purity: data.purity.present ? data.purity.value : this.purity,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      makingCharges: data.makingCharges.present
          ? data.makingCharges.value
          : this.makingCharges,
      wastagePercentage: data.wastagePercentage.present
          ? data.wastagePercentage.value
          : this.wastagePercentage,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      stockWeight: data.stockWeight.present
          ? data.stockWeight.value
          : this.stockWeight,
      minimumStockLevel: data.minimumStockLevel.present
          ? data.minimumStockLevel.value
          : this.minimumStockLevel,
      reorderLevel: data.reorderLevel.present
          ? data.reorderLevel.value
          : this.reorderLevel,
      unitOfMeasurement: data.unitOfMeasurement.present
          ? data.unitOfMeasurement.value
          : this.unitOfMeasurement,
      brand: data.brand.present ? data.brand.value : this.brand,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      size: data.size.present ? data.size.value : this.size,
      color: data.color.present ? data.color.value : this.color,
      stamp: data.stamp.present ? data.stamp.value : this.stamp,
      stoneDetails: data.stoneDetails.present
          ? data.stoneDetails.value
          : this.stoneDetails,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      maintainStockIn: data.maintainStockIn.present
          ? data.maintainStockIn.value
          : this.maintainStockIn,
      isStudded: data.isStudded.present ? data.isStudded.value : this.isStudded,
      fetchGoldRate: data.fetchGoldRate.present
          ? data.fetchGoldRate.value
          : this.fetchGoldRate,
      defaultGoldRate: data.defaultGoldRate.present
          ? data.defaultGoldRate.value
          : this.defaultGoldRate,
      defaultTouch: data.defaultTouch.present
          ? data.defaultTouch.value
          : this.defaultTouch,
      taxPreference: data.taxPreference.present
          ? data.taxPreference.value
          : this.taxPreference,
      purchaseWastage: data.purchaseWastage.present
          ? data.purchaseWastage.value
          : this.purchaseWastage,
      purchaseMakingCharges: data.purchaseMakingCharges.present
          ? data.purchaseMakingCharges.value
          : this.purchaseMakingCharges,
      jobworkRate: data.jobworkRate.present
          ? data.jobworkRate.value
          : this.jobworkRate,
      discountLedger: data.discountLedger.present
          ? data.discountLedger.value
          : this.discountLedger,
      stockMethod: data.stockMethod.present
          ? data.stockMethod.value
          : this.stockMethod,
      tagPrefix: data.tagPrefix.present ? data.tagPrefix.value : this.tagPrefix,
      minStockPcs: data.minStockPcs.present
          ? data.minStockPcs.value
          : this.minStockPcs,
      maxStockGm: data.maxStockGm.present
          ? data.maxStockGm.value
          : this.maxStockGm,
      maxStockPcs: data.maxStockPcs.present
          ? data.maxStockPcs.value
          : this.maxStockPcs,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('metalType: $metalType, ')
          ..write('purity: $purity, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('costPrice: $costPrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('makingCharges: $makingCharges, ')
          ..write('wastagePercentage: $wastagePercentage, ')
          ..write('stockQty: $stockQty, ')
          ..write('stockWeight: $stockWeight, ')
          ..write('minimumStockLevel: $minimumStockLevel, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('unitOfMeasurement: $unitOfMeasurement, ')
          ..write('brand: $brand, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('size: $size, ')
          ..write('color: $color, ')
          ..write('stamp: $stamp, ')
          ..write('stoneDetails: $stoneDetails, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('itemType: $itemType, ')
          ..write('maintainStockIn: $maintainStockIn, ')
          ..write('isStudded: $isStudded, ')
          ..write('fetchGoldRate: $fetchGoldRate, ')
          ..write('defaultGoldRate: $defaultGoldRate, ')
          ..write('defaultTouch: $defaultTouch, ')
          ..write('taxPreference: $taxPreference, ')
          ..write('purchaseWastage: $purchaseWastage, ')
          ..write('purchaseMakingCharges: $purchaseMakingCharges, ')
          ..write('jobworkRate: $jobworkRate, ')
          ..write('discountLedger: $discountLedger, ')
          ..write('stockMethod: $stockMethod, ')
          ..write('tagPrefix: $tagPrefix, ')
          ..write('minStockPcs: $minStockPcs, ')
          ..write('maxStockGm: $maxStockGm, ')
          ..write('maxStockPcs: $maxStockPcs, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    code,
    metalType,
    purity,
    category,
    description,
    hsnCode,
    costPrice,
    sellingPrice,
    makingCharges,
    wastagePercentage,
    stockQty,
    stockWeight,
    minimumStockLevel,
    reorderLevel,
    unitOfMeasurement,
    brand,
    manufacturer,
    size,
    color,
    stamp,
    stoneDetails,
    status,
    notes,
    itemType,
    maintainStockIn,
    isStudded,
    fetchGoldRate,
    defaultGoldRate,
    defaultTouch,
    taxPreference,
    purchaseWastage,
    purchaseMakingCharges,
    jobworkRate,
    discountLedger,
    stockMethod,
    tagPrefix,
    minStockPcs,
    maxStockGm,
    maxStockPcs,
    photoPath,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.metalType == this.metalType &&
          other.purity == this.purity &&
          other.category == this.category &&
          other.description == this.description &&
          other.hsnCode == this.hsnCode &&
          other.costPrice == this.costPrice &&
          other.sellingPrice == this.sellingPrice &&
          other.makingCharges == this.makingCharges &&
          other.wastagePercentage == this.wastagePercentage &&
          other.stockQty == this.stockQty &&
          other.stockWeight == this.stockWeight &&
          other.minimumStockLevel == this.minimumStockLevel &&
          other.reorderLevel == this.reorderLevel &&
          other.unitOfMeasurement == this.unitOfMeasurement &&
          other.brand == this.brand &&
          other.manufacturer == this.manufacturer &&
          other.size == this.size &&
          other.color == this.color &&
          other.stamp == this.stamp &&
          other.stoneDetails == this.stoneDetails &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.itemType == this.itemType &&
          other.maintainStockIn == this.maintainStockIn &&
          other.isStudded == this.isStudded &&
          other.fetchGoldRate == this.fetchGoldRate &&
          other.defaultGoldRate == this.defaultGoldRate &&
          other.defaultTouch == this.defaultTouch &&
          other.taxPreference == this.taxPreference &&
          other.purchaseWastage == this.purchaseWastage &&
          other.purchaseMakingCharges == this.purchaseMakingCharges &&
          other.jobworkRate == this.jobworkRate &&
          other.discountLedger == this.discountLedger &&
          other.stockMethod == this.stockMethod &&
          other.tagPrefix == this.tagPrefix &&
          other.minStockPcs == this.minStockPcs &&
          other.maxStockGm == this.maxStockGm &&
          other.maxStockPcs == this.maxStockPcs &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<String> metalType;
  final Value<String?> purity;
  final Value<String?> category;
  final Value<String?> description;
  final Value<String?> hsnCode;
  final Value<double> costPrice;
  final Value<double> sellingPrice;
  final Value<double> makingCharges;
  final Value<double> wastagePercentage;
  final Value<double> stockQty;
  final Value<double> stockWeight;
  final Value<double> minimumStockLevel;
  final Value<double> reorderLevel;
  final Value<String> unitOfMeasurement;
  final Value<String?> brand;
  final Value<String?> manufacturer;
  final Value<String?> size;
  final Value<String?> color;
  final Value<String?> stamp;
  final Value<String?> stoneDetails;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String> itemType;
  final Value<String> maintainStockIn;
  final Value<bool> isStudded;
  final Value<bool> fetchGoldRate;
  final Value<String?> defaultGoldRate;
  final Value<double> defaultTouch;
  final Value<String> taxPreference;
  final Value<double> purchaseWastage;
  final Value<double> purchaseMakingCharges;
  final Value<double> jobworkRate;
  final Value<String?> discountLedger;
  final Value<String> stockMethod;
  final Value<String?> tagPrefix;
  final Value<double> minStockPcs;
  final Value<double> maxStockGm;
  final Value<double> maxStockPcs;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.metalType = const Value.absent(),
    this.purity = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.makingCharges = const Value.absent(),
    this.wastagePercentage = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.stockWeight = const Value.absent(),
    this.minimumStockLevel = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.unitOfMeasurement = const Value.absent(),
    this.brand = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.size = const Value.absent(),
    this.color = const Value.absent(),
    this.stamp = const Value.absent(),
    this.stoneDetails = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.itemType = const Value.absent(),
    this.maintainStockIn = const Value.absent(),
    this.isStudded = const Value.absent(),
    this.fetchGoldRate = const Value.absent(),
    this.defaultGoldRate = const Value.absent(),
    this.defaultTouch = const Value.absent(),
    this.taxPreference = const Value.absent(),
    this.purchaseWastage = const Value.absent(),
    this.purchaseMakingCharges = const Value.absent(),
    this.jobworkRate = const Value.absent(),
    this.discountLedger = const Value.absent(),
    this.stockMethod = const Value.absent(),
    this.tagPrefix = const Value.absent(),
    this.minStockPcs = const Value.absent(),
    this.maxStockGm = const Value.absent(),
    this.maxStockPcs = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    required String metalType,
    this.purity = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.makingCharges = const Value.absent(),
    this.wastagePercentage = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.stockWeight = const Value.absent(),
    this.minimumStockLevel = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.unitOfMeasurement = const Value.absent(),
    this.brand = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.size = const Value.absent(),
    this.color = const Value.absent(),
    this.stamp = const Value.absent(),
    this.stoneDetails = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.itemType = const Value.absent(),
    this.maintainStockIn = const Value.absent(),
    this.isStudded = const Value.absent(),
    this.fetchGoldRate = const Value.absent(),
    this.defaultGoldRate = const Value.absent(),
    this.defaultTouch = const Value.absent(),
    this.taxPreference = const Value.absent(),
    this.purchaseWastage = const Value.absent(),
    this.purchaseMakingCharges = const Value.absent(),
    this.jobworkRate = const Value.absent(),
    this.discountLedger = const Value.absent(),
    this.stockMethod = const Value.absent(),
    this.tagPrefix = const Value.absent(),
    this.minStockPcs = const Value.absent(),
    this.maxStockGm = const Value.absent(),
    this.maxStockPcs = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       metalType = Value(metalType);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? metalType,
    Expression<String>? purity,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? hsnCode,
    Expression<double>? costPrice,
    Expression<double>? sellingPrice,
    Expression<double>? makingCharges,
    Expression<double>? wastagePercentage,
    Expression<double>? stockQty,
    Expression<double>? stockWeight,
    Expression<double>? minimumStockLevel,
    Expression<double>? reorderLevel,
    Expression<String>? unitOfMeasurement,
    Expression<String>? brand,
    Expression<String>? manufacturer,
    Expression<String>? size,
    Expression<String>? color,
    Expression<String>? stamp,
    Expression<String>? stoneDetails,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? itemType,
    Expression<String>? maintainStockIn,
    Expression<bool>? isStudded,
    Expression<bool>? fetchGoldRate,
    Expression<String>? defaultGoldRate,
    Expression<double>? defaultTouch,
    Expression<String>? taxPreference,
    Expression<double>? purchaseWastage,
    Expression<double>? purchaseMakingCharges,
    Expression<double>? jobworkRate,
    Expression<String>? discountLedger,
    Expression<String>? stockMethod,
    Expression<String>? tagPrefix,
    Expression<double>? minStockPcs,
    Expression<double>? maxStockGm,
    Expression<double>? maxStockPcs,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (metalType != null) 'metal_type': metalType,
      if (purity != null) 'purity': purity,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (costPrice != null) 'cost_price': costPrice,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (makingCharges != null) 'making_charges': makingCharges,
      if (wastagePercentage != null) 'wastage_percentage': wastagePercentage,
      if (stockQty != null) 'stock_qty': stockQty,
      if (stockWeight != null) 'stock_weight': stockWeight,
      if (minimumStockLevel != null) 'minimum_stock_level': minimumStockLevel,
      if (reorderLevel != null) 'reorder_level': reorderLevel,
      if (unitOfMeasurement != null) 'unit_of_measurement': unitOfMeasurement,
      if (brand != null) 'brand': brand,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (size != null) 'size': size,
      if (color != null) 'color': color,
      if (stamp != null) 'stamp': stamp,
      if (stoneDetails != null) 'stone_details': stoneDetails,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (itemType != null) 'item_type': itemType,
      if (maintainStockIn != null) 'maintain_stock_in': maintainStockIn,
      if (isStudded != null) 'is_studded': isStudded,
      if (fetchGoldRate != null) 'fetch_gold_rate': fetchGoldRate,
      if (defaultGoldRate != null) 'default_gold_rate': defaultGoldRate,
      if (defaultTouch != null) 'default_touch': defaultTouch,
      if (taxPreference != null) 'tax_preference': taxPreference,
      if (purchaseWastage != null) 'purchase_wastage': purchaseWastage,
      if (purchaseMakingCharges != null)
        'purchase_making_charges': purchaseMakingCharges,
      if (jobworkRate != null) 'jobwork_rate': jobworkRate,
      if (discountLedger != null) 'discount_ledger': discountLedger,
      if (stockMethod != null) 'stock_method': stockMethod,
      if (tagPrefix != null) 'tag_prefix': tagPrefix,
      if (minStockPcs != null) 'min_stock_pcs': minStockPcs,
      if (maxStockGm != null) 'max_stock_gm': maxStockGm,
      if (maxStockPcs != null) 'max_stock_pcs': maxStockPcs,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? code,
    Value<String>? metalType,
    Value<String?>? purity,
    Value<String?>? category,
    Value<String?>? description,
    Value<String?>? hsnCode,
    Value<double>? costPrice,
    Value<double>? sellingPrice,
    Value<double>? makingCharges,
    Value<double>? wastagePercentage,
    Value<double>? stockQty,
    Value<double>? stockWeight,
    Value<double>? minimumStockLevel,
    Value<double>? reorderLevel,
    Value<String>? unitOfMeasurement,
    Value<String?>? brand,
    Value<String?>? manufacturer,
    Value<String?>? size,
    Value<String?>? color,
    Value<String?>? stamp,
    Value<String?>? stoneDetails,
    Value<String>? status,
    Value<String?>? notes,
    Value<String>? itemType,
    Value<String>? maintainStockIn,
    Value<bool>? isStudded,
    Value<bool>? fetchGoldRate,
    Value<String?>? defaultGoldRate,
    Value<double>? defaultTouch,
    Value<String>? taxPreference,
    Value<double>? purchaseWastage,
    Value<double>? purchaseMakingCharges,
    Value<double>? jobworkRate,
    Value<String?>? discountLedger,
    Value<String>? stockMethod,
    Value<String?>? tagPrefix,
    Value<double>? minStockPcs,
    Value<double>? maxStockGm,
    Value<double>? maxStockPcs,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      metalType: metalType ?? this.metalType,
      purity: purity ?? this.purity,
      category: category ?? this.category,
      description: description ?? this.description,
      hsnCode: hsnCode ?? this.hsnCode,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      makingCharges: makingCharges ?? this.makingCharges,
      wastagePercentage: wastagePercentage ?? this.wastagePercentage,
      stockQty: stockQty ?? this.stockQty,
      stockWeight: stockWeight ?? this.stockWeight,
      minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      size: size ?? this.size,
      color: color ?? this.color,
      stamp: stamp ?? this.stamp,
      stoneDetails: stoneDetails ?? this.stoneDetails,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      itemType: itemType ?? this.itemType,
      maintainStockIn: maintainStockIn ?? this.maintainStockIn,
      isStudded: isStudded ?? this.isStudded,
      fetchGoldRate: fetchGoldRate ?? this.fetchGoldRate,
      defaultGoldRate: defaultGoldRate ?? this.defaultGoldRate,
      defaultTouch: defaultTouch ?? this.defaultTouch,
      taxPreference: taxPreference ?? this.taxPreference,
      purchaseWastage: purchaseWastage ?? this.purchaseWastage,
      purchaseMakingCharges:
          purchaseMakingCharges ?? this.purchaseMakingCharges,
      jobworkRate: jobworkRate ?? this.jobworkRate,
      discountLedger: discountLedger ?? this.discountLedger,
      stockMethod: stockMethod ?? this.stockMethod,
      tagPrefix: tagPrefix ?? this.tagPrefix,
      minStockPcs: minStockPcs ?? this.minStockPcs,
      maxStockGm: maxStockGm ?? this.maxStockGm,
      maxStockPcs: maxStockPcs ?? this.maxStockPcs,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (metalType.present) {
      map['metal_type'] = Variable<String>(metalType.value);
    }
    if (purity.present) {
      map['purity'] = Variable<String>(purity.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (makingCharges.present) {
      map['making_charges'] = Variable<double>(makingCharges.value);
    }
    if (wastagePercentage.present) {
      map['wastage_percentage'] = Variable<double>(wastagePercentage.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<double>(stockQty.value);
    }
    if (stockWeight.present) {
      map['stock_weight'] = Variable<double>(stockWeight.value);
    }
    if (minimumStockLevel.present) {
      map['minimum_stock_level'] = Variable<double>(minimumStockLevel.value);
    }
    if (reorderLevel.present) {
      map['reorder_level'] = Variable<double>(reorderLevel.value);
    }
    if (unitOfMeasurement.present) {
      map['unit_of_measurement'] = Variable<String>(unitOfMeasurement.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (stamp.present) {
      map['stamp'] = Variable<String>(stamp.value);
    }
    if (stoneDetails.present) {
      map['stone_details'] = Variable<String>(stoneDetails.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (maintainStockIn.present) {
      map['maintain_stock_in'] = Variable<String>(maintainStockIn.value);
    }
    if (isStudded.present) {
      map['is_studded'] = Variable<bool>(isStudded.value);
    }
    if (fetchGoldRate.present) {
      map['fetch_gold_rate'] = Variable<bool>(fetchGoldRate.value);
    }
    if (defaultGoldRate.present) {
      map['default_gold_rate'] = Variable<String>(defaultGoldRate.value);
    }
    if (defaultTouch.present) {
      map['default_touch'] = Variable<double>(defaultTouch.value);
    }
    if (taxPreference.present) {
      map['tax_preference'] = Variable<String>(taxPreference.value);
    }
    if (purchaseWastage.present) {
      map['purchase_wastage'] = Variable<double>(purchaseWastage.value);
    }
    if (purchaseMakingCharges.present) {
      map['purchase_making_charges'] = Variable<double>(
        purchaseMakingCharges.value,
      );
    }
    if (jobworkRate.present) {
      map['jobwork_rate'] = Variable<double>(jobworkRate.value);
    }
    if (discountLedger.present) {
      map['discount_ledger'] = Variable<String>(discountLedger.value);
    }
    if (stockMethod.present) {
      map['stock_method'] = Variable<String>(stockMethod.value);
    }
    if (tagPrefix.present) {
      map['tag_prefix'] = Variable<String>(tagPrefix.value);
    }
    if (minStockPcs.present) {
      map['min_stock_pcs'] = Variable<double>(minStockPcs.value);
    }
    if (maxStockGm.present) {
      map['max_stock_gm'] = Variable<double>(maxStockGm.value);
    }
    if (maxStockPcs.present) {
      map['max_stock_pcs'] = Variable<double>(maxStockPcs.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('metalType: $metalType, ')
          ..write('purity: $purity, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('costPrice: $costPrice, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('makingCharges: $makingCharges, ')
          ..write('wastagePercentage: $wastagePercentage, ')
          ..write('stockQty: $stockQty, ')
          ..write('stockWeight: $stockWeight, ')
          ..write('minimumStockLevel: $minimumStockLevel, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('unitOfMeasurement: $unitOfMeasurement, ')
          ..write('brand: $brand, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('size: $size, ')
          ..write('color: $color, ')
          ..write('stamp: $stamp, ')
          ..write('stoneDetails: $stoneDetails, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('itemType: $itemType, ')
          ..write('maintainStockIn: $maintainStockIn, ')
          ..write('isStudded: $isStudded, ')
          ..write('fetchGoldRate: $fetchGoldRate, ')
          ..write('defaultGoldRate: $defaultGoldRate, ')
          ..write('defaultTouch: $defaultTouch, ')
          ..write('taxPreference: $taxPreference, ')
          ..write('purchaseWastage: $purchaseWastage, ')
          ..write('purchaseMakingCharges: $purchaseMakingCharges, ')
          ..write('jobworkRate: $jobworkRate, ')
          ..write('discountLedger: $discountLedger, ')
          ..write('stockMethod: $stockMethod, ')
          ..write('tagPrefix: $tagPrefix, ')
          ..write('minStockPcs: $minStockPcs, ')
          ..write('maxStockGm: $maxStockGm, ')
          ..write('maxStockPcs: $maxStockPcs, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionNumberMeta = const VerificationMeta(
    'transactionNumber',
  );
  @override
  late final GeneratedColumn<String> transactionNumber =
      GeneratedColumn<String>(
        'transaction_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<int> partyId = GeneratedColumn<int>(
    'party_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parties (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentReferenceMeta = const VerificationMeta(
    'paymentReference',
  );
  @override
  late final GeneratedColumn<String> paymentReference = GeneratedColumn<String>(
    'payment_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>(
        'discount_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxPercentageMeta = const VerificationMeta(
    'taxPercentage',
  );
  @override
  late final GeneratedColumn<double> taxPercentage = GeneratedColumn<double>(
    'tax_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalGoldWeightMeta = const VerificationMeta(
    'totalGoldWeight',
  );
  @override
  late final GeneratedColumn<double> totalGoldWeight = GeneratedColumn<double>(
    'total_gold_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalSilverWeightMeta = const VerificationMeta(
    'totalSilverWeight',
  );
  @override
  late final GeneratedColumn<double> totalSilverWeight =
      GeneratedColumn<double>(
        'total_silver_weight',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Draft'),
  );
  static const VerificationMeta _dueDaysMeta = const VerificationMeta(
    'dueDays',
  );
  @override
  late final GeneratedColumn<int> dueDays = GeneratedColumn<int>(
    'due_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partyPoNumberMeta = const VerificationMeta(
    'partyPoNumber',
  );
  @override
  late final GeneratedColumn<String> partyPoNumber = GeneratedColumn<String>(
    'party_po_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionNumber,
    date,
    partyId,
    type,
    paymentMethod,
    paymentReference,
    discountAmount,
    discountPercentage,
    taxAmount,
    taxPercentage,
    totalGoldWeight,
    totalSilverWeight,
    subtotal,
    totalAmount,
    remarks,
    status,
    dueDays,
    dueDate,
    partyPoNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_number')) {
      context.handle(
        _transactionNumberMeta,
        transactionNumber.isAcceptableOrUnknown(
          data['transaction_number']!,
          _transactionNumberMeta,
        ),
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
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('payment_reference')) {
      context.handle(
        _paymentReferenceMeta,
        paymentReference.isAcceptableOrUnknown(
          data['payment_reference']!,
          _paymentReferenceMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
        _discountPercentageMeta,
        discountPercentage.isAcceptableOrUnknown(
          data['discount_percentage']!,
          _discountPercentageMeta,
        ),
      );
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    }
    if (data.containsKey('tax_percentage')) {
      context.handle(
        _taxPercentageMeta,
        taxPercentage.isAcceptableOrUnknown(
          data['tax_percentage']!,
          _taxPercentageMeta,
        ),
      );
    }
    if (data.containsKey('total_gold_weight')) {
      context.handle(
        _totalGoldWeightMeta,
        totalGoldWeight.isAcceptableOrUnknown(
          data['total_gold_weight']!,
          _totalGoldWeightMeta,
        ),
      );
    }
    if (data.containsKey('total_silver_weight')) {
      context.handle(
        _totalSilverWeightMeta,
        totalSilverWeight.isAcceptableOrUnknown(
          data['total_silver_weight']!,
          _totalSilverWeightMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('due_days')) {
      context.handle(
        _dueDaysMeta,
        dueDays.isAcceptableOrUnknown(data['due_days']!, _dueDaysMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('party_po_number')) {
      context.handle(
        _partyPoNumberMeta,
        partyPoNumber.isAcceptableOrUnknown(
          data['party_po_number']!,
          _partyPoNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_number'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}party_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      paymentReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_reference'],
      ),
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      )!,
      discountPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percentage'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      taxPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_percentage'],
      )!,
      totalGoldWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_gold_weight'],
      )!,
      totalSilverWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_silver_weight'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dueDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_days'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      partyPoNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_po_number'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String? transactionNumber;
  final DateTime date;
  final int partyId;
  final String type;
  final String? paymentMethod;
  final String? paymentReference;
  final double discountAmount;
  final double discountPercentage;
  final double taxAmount;
  final double taxPercentage;
  final double totalGoldWeight;
  final double totalSilverWeight;
  final double subtotal;
  final double totalAmount;
  final String? remarks;
  final String status;
  final int? dueDays;
  final DateTime? dueDate;
  final String? partyPoNumber;
  const Transaction({
    required this.id,
    this.transactionNumber,
    required this.date,
    required this.partyId,
    required this.type,
    this.paymentMethod,
    this.paymentReference,
    required this.discountAmount,
    required this.discountPercentage,
    required this.taxAmount,
    required this.taxPercentage,
    required this.totalGoldWeight,
    required this.totalSilverWeight,
    required this.subtotal,
    required this.totalAmount,
    this.remarks,
    required this.status,
    this.dueDays,
    this.dueDate,
    this.partyPoNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || transactionNumber != null) {
      map['transaction_number'] = Variable<String>(transactionNumber);
    }
    map['date'] = Variable<DateTime>(date);
    map['party_id'] = Variable<int>(partyId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || paymentReference != null) {
      map['payment_reference'] = Variable<String>(paymentReference);
    }
    map['discount_amount'] = Variable<double>(discountAmount);
    map['discount_percentage'] = Variable<double>(discountPercentage);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['tax_percentage'] = Variable<double>(taxPercentage);
    map['total_gold_weight'] = Variable<double>(totalGoldWeight);
    map['total_silver_weight'] = Variable<double>(totalSilverWeight);
    map['subtotal'] = Variable<double>(subtotal);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dueDays != null) {
      map['due_days'] = Variable<int>(dueDays);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || partyPoNumber != null) {
      map['party_po_number'] = Variable<String>(partyPoNumber);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      transactionNumber: transactionNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionNumber),
      date: Value(date),
      partyId: Value(partyId),
      type: Value(type),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      paymentReference: paymentReference == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentReference),
      discountAmount: Value(discountAmount),
      discountPercentage: Value(discountPercentage),
      taxAmount: Value(taxAmount),
      taxPercentage: Value(taxPercentage),
      totalGoldWeight: Value(totalGoldWeight),
      totalSilverWeight: Value(totalSilverWeight),
      subtotal: Value(subtotal),
      totalAmount: Value(totalAmount),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      status: Value(status),
      dueDays: dueDays == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDays),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      partyPoNumber: partyPoNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partyPoNumber),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      transactionNumber: serializer.fromJson<String?>(
        json['transactionNumber'],
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      partyId: serializer.fromJson<int>(json['partyId']),
      type: serializer.fromJson<String>(json['type']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      paymentReference: serializer.fromJson<String?>(json['paymentReference']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      discountPercentage: serializer.fromJson<double>(
        json['discountPercentage'],
      ),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      taxPercentage: serializer.fromJson<double>(json['taxPercentage']),
      totalGoldWeight: serializer.fromJson<double>(json['totalGoldWeight']),
      totalSilverWeight: serializer.fromJson<double>(json['totalSilverWeight']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      status: serializer.fromJson<String>(json['status']),
      dueDays: serializer.fromJson<int?>(json['dueDays']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      partyPoNumber: serializer.fromJson<String?>(json['partyPoNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionNumber': serializer.toJson<String?>(transactionNumber),
      'date': serializer.toJson<DateTime>(date),
      'partyId': serializer.toJson<int>(partyId),
      'type': serializer.toJson<String>(type),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'paymentReference': serializer.toJson<String?>(paymentReference),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'taxPercentage': serializer.toJson<double>(taxPercentage),
      'totalGoldWeight': serializer.toJson<double>(totalGoldWeight),
      'totalSilverWeight': serializer.toJson<double>(totalSilverWeight),
      'subtotal': serializer.toJson<double>(subtotal),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'remarks': serializer.toJson<String?>(remarks),
      'status': serializer.toJson<String>(status),
      'dueDays': serializer.toJson<int?>(dueDays),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'partyPoNumber': serializer.toJson<String?>(partyPoNumber),
    };
  }

  Transaction copyWith({
    int? id,
    Value<String?> transactionNumber = const Value.absent(),
    DateTime? date,
    int? partyId,
    String? type,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> paymentReference = const Value.absent(),
    double? discountAmount,
    double? discountPercentage,
    double? taxAmount,
    double? taxPercentage,
    double? totalGoldWeight,
    double? totalSilverWeight,
    double? subtotal,
    double? totalAmount,
    Value<String?> remarks = const Value.absent(),
    String? status,
    Value<int?> dueDays = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> partyPoNumber = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    transactionNumber: transactionNumber.present
        ? transactionNumber.value
        : this.transactionNumber,
    date: date ?? this.date,
    partyId: partyId ?? this.partyId,
    type: type ?? this.type,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    paymentReference: paymentReference.present
        ? paymentReference.value
        : this.paymentReference,
    discountAmount: discountAmount ?? this.discountAmount,
    discountPercentage: discountPercentage ?? this.discountPercentage,
    taxAmount: taxAmount ?? this.taxAmount,
    taxPercentage: taxPercentage ?? this.taxPercentage,
    totalGoldWeight: totalGoldWeight ?? this.totalGoldWeight,
    totalSilverWeight: totalSilverWeight ?? this.totalSilverWeight,
    subtotal: subtotal ?? this.subtotal,
    totalAmount: totalAmount ?? this.totalAmount,
    remarks: remarks.present ? remarks.value : this.remarks,
    status: status ?? this.status,
    dueDays: dueDays.present ? dueDays.value : this.dueDays,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    partyPoNumber: partyPoNumber.present
        ? partyPoNumber.value
        : this.partyPoNumber,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      transactionNumber: data.transactionNumber.present
          ? data.transactionNumber.value
          : this.transactionNumber,
      date: data.date.present ? data.date.value : this.date,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      type: data.type.present ? data.type.value : this.type,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentReference: data.paymentReference.present
          ? data.paymentReference.value
          : this.paymentReference,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      taxPercentage: data.taxPercentage.present
          ? data.taxPercentage.value
          : this.taxPercentage,
      totalGoldWeight: data.totalGoldWeight.present
          ? data.totalGoldWeight.value
          : this.totalGoldWeight,
      totalSilverWeight: data.totalSilverWeight.present
          ? data.totalSilverWeight.value
          : this.totalSilverWeight,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      status: data.status.present ? data.status.value : this.status,
      dueDays: data.dueDays.present ? data.dueDays.value : this.dueDays,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      partyPoNumber: data.partyPoNumber.present
          ? data.partyPoNumber.value
          : this.partyPoNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('transactionNumber: $transactionNumber, ')
          ..write('date: $date, ')
          ..write('partyId: $partyId, ')
          ..write('type: $type, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentReference: $paymentReference, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('totalGoldWeight: $totalGoldWeight, ')
          ..write('totalSilverWeight: $totalSilverWeight, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('remarks: $remarks, ')
          ..write('status: $status, ')
          ..write('dueDays: $dueDays, ')
          ..write('dueDate: $dueDate, ')
          ..write('partyPoNumber: $partyPoNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionNumber,
    date,
    partyId,
    type,
    paymentMethod,
    paymentReference,
    discountAmount,
    discountPercentage,
    taxAmount,
    taxPercentage,
    totalGoldWeight,
    totalSilverWeight,
    subtotal,
    totalAmount,
    remarks,
    status,
    dueDays,
    dueDate,
    partyPoNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.transactionNumber == this.transactionNumber &&
          other.date == this.date &&
          other.partyId == this.partyId &&
          other.type == this.type &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentReference == this.paymentReference &&
          other.discountAmount == this.discountAmount &&
          other.discountPercentage == this.discountPercentage &&
          other.taxAmount == this.taxAmount &&
          other.taxPercentage == this.taxPercentage &&
          other.totalGoldWeight == this.totalGoldWeight &&
          other.totalSilverWeight == this.totalSilverWeight &&
          other.subtotal == this.subtotal &&
          other.totalAmount == this.totalAmount &&
          other.remarks == this.remarks &&
          other.status == this.status &&
          other.dueDays == this.dueDays &&
          other.dueDate == this.dueDate &&
          other.partyPoNumber == this.partyPoNumber);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String?> transactionNumber;
  final Value<DateTime> date;
  final Value<int> partyId;
  final Value<String> type;
  final Value<String?> paymentMethod;
  final Value<String?> paymentReference;
  final Value<double> discountAmount;
  final Value<double> discountPercentage;
  final Value<double> taxAmount;
  final Value<double> taxPercentage;
  final Value<double> totalGoldWeight;
  final Value<double> totalSilverWeight;
  final Value<double> subtotal;
  final Value<double> totalAmount;
  final Value<String?> remarks;
  final Value<String> status;
  final Value<int?> dueDays;
  final Value<DateTime?> dueDate;
  final Value<String?> partyPoNumber;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.transactionNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.partyId = const Value.absent(),
    this.type = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentReference = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    this.totalGoldWeight = const Value.absent(),
    this.totalSilverWeight = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.remarks = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.partyPoNumber = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.transactionNumber = const Value.absent(),
    required DateTime date,
    required int partyId,
    required String type,
    this.paymentMethod = const Value.absent(),
    this.paymentReference = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    this.totalGoldWeight = const Value.absent(),
    this.totalSilverWeight = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.remarks = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.partyPoNumber = const Value.absent(),
  }) : date = Value(date),
       partyId = Value(partyId),
       type = Value(type);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? transactionNumber,
    Expression<DateTime>? date,
    Expression<int>? partyId,
    Expression<String>? type,
    Expression<String>? paymentMethod,
    Expression<String>? paymentReference,
    Expression<double>? discountAmount,
    Expression<double>? discountPercentage,
    Expression<double>? taxAmount,
    Expression<double>? taxPercentage,
    Expression<double>? totalGoldWeight,
    Expression<double>? totalSilverWeight,
    Expression<double>? subtotal,
    Expression<double>? totalAmount,
    Expression<String>? remarks,
    Expression<String>? status,
    Expression<int>? dueDays,
    Expression<DateTime>? dueDate,
    Expression<String>? partyPoNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionNumber != null) 'transaction_number': transactionNumber,
      if (date != null) 'date': date,
      if (partyId != null) 'party_id': partyId,
      if (type != null) 'type': type,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentReference != null) 'payment_reference': paymentReference,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (taxPercentage != null) 'tax_percentage': taxPercentage,
      if (totalGoldWeight != null) 'total_gold_weight': totalGoldWeight,
      if (totalSilverWeight != null) 'total_silver_weight': totalSilverWeight,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (remarks != null) 'remarks': remarks,
      if (status != null) 'status': status,
      if (dueDays != null) 'due_days': dueDays,
      if (dueDate != null) 'due_date': dueDate,
      if (partyPoNumber != null) 'party_po_number': partyPoNumber,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? transactionNumber,
    Value<DateTime>? date,
    Value<int>? partyId,
    Value<String>? type,
    Value<String?>? paymentMethod,
    Value<String?>? paymentReference,
    Value<double>? discountAmount,
    Value<double>? discountPercentage,
    Value<double>? taxAmount,
    Value<double>? taxPercentage,
    Value<double>? totalGoldWeight,
    Value<double>? totalSilverWeight,
    Value<double>? subtotal,
    Value<double>? totalAmount,
    Value<String?>? remarks,
    Value<String>? status,
    Value<int?>? dueDays,
    Value<DateTime?>? dueDate,
    Value<String?>? partyPoNumber,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      date: date ?? this.date,
      partyId: partyId ?? this.partyId,
      type: type ?? this.type,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      taxAmount: taxAmount ?? this.taxAmount,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      totalGoldWeight: totalGoldWeight ?? this.totalGoldWeight,
      totalSilverWeight: totalSilverWeight ?? this.totalSilverWeight,
      subtotal: subtotal ?? this.subtotal,
      totalAmount: totalAmount ?? this.totalAmount,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
      dueDays: dueDays ?? this.dueDays,
      dueDate: dueDate ?? this.dueDate,
      partyPoNumber: partyPoNumber ?? this.partyPoNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionNumber.present) {
      map['transaction_number'] = Variable<String>(transactionNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<int>(partyId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentReference.present) {
      map['payment_reference'] = Variable<String>(paymentReference.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (taxPercentage.present) {
      map['tax_percentage'] = Variable<double>(taxPercentage.value);
    }
    if (totalGoldWeight.present) {
      map['total_gold_weight'] = Variable<double>(totalGoldWeight.value);
    }
    if (totalSilverWeight.present) {
      map['total_silver_weight'] = Variable<double>(totalSilverWeight.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dueDays.present) {
      map['due_days'] = Variable<int>(dueDays.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (partyPoNumber.present) {
      map['party_po_number'] = Variable<String>(partyPoNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('transactionNumber: $transactionNumber, ')
          ..write('date: $date, ')
          ..write('partyId: $partyId, ')
          ..write('type: $type, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentReference: $paymentReference, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('totalGoldWeight: $totalGoldWeight, ')
          ..write('totalSilverWeight: $totalSilverWeight, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('remarks: $remarks, ')
          ..write('status: $status, ')
          ..write('dueDays: $dueDays, ')
          ..write('dueDate: $dueDate, ')
          ..write('partyPoNumber: $partyPoNumber')
          ..write(')'))
        .toString();
  }
}

class $TransactionLinesTable extends TransactionLines
    with TableInfo<$TransactionLinesTable, TransactionLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grossWeightMeta = const VerificationMeta(
    'grossWeight',
  );
  @override
  late final GeneratedColumn<double> grossWeight = GeneratedColumn<double>(
    'gross_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _netWeightMeta = const VerificationMeta(
    'netWeight',
  );
  @override
  late final GeneratedColumn<double> netWeight = GeneratedColumn<double>(
    'net_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _purityMeta = const VerificationMeta('purity');
  @override
  late final GeneratedColumn<double> purity = GeneratedColumn<double>(
    'purity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stoneWeightMeta = const VerificationMeta(
    'stoneWeight',
  );
  @override
  late final GeneratedColumn<double> stoneWeight = GeneratedColumn<double>(
    'stone_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _wastageMeta = const VerificationMeta(
    'wastage',
  );
  @override
  late final GeneratedColumn<double> wastage = GeneratedColumn<double>(
    'wastage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _makingChargesMeta = const VerificationMeta(
    'makingCharges',
  );
  @override
  late final GeneratedColumn<double> makingCharges = GeneratedColumn<double>(
    'making_charges',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _stampMeta = const VerificationMeta('stamp');
  @override
  late final GeneratedColumn<String> stamp = GeneratedColumn<String>(
    'stamp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateOnMeta = const VerificationMeta('rateOn');
  @override
  late final GeneratedColumn<String> rateOn = GeneratedColumn<String>(
    'rate_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ghatWeightMeta = const VerificationMeta(
    'ghatWeight',
  );
  @override
  late final GeneratedColumn<double> ghatWeight = GeneratedColumn<double>(
    'ghat_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lineTypeMeta = const VerificationMeta(
    'lineType',
  );
  @override
  late final GeneratedColumn<String> lineType = GeneratedColumn<String>(
    'line_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    itemId,
    description,
    grossWeight,
    netWeight,
    purity,
    stoneWeight,
    wastage,
    makingCharges,
    rate,
    amount,
    stamp,
    size,
    color,
    rateOn,
    ghatWeight,
    qty,
    lineType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('gross_weight')) {
      context.handle(
        _grossWeightMeta,
        grossWeight.isAcceptableOrUnknown(
          data['gross_weight']!,
          _grossWeightMeta,
        ),
      );
    }
    if (data.containsKey('net_weight')) {
      context.handle(
        _netWeightMeta,
        netWeight.isAcceptableOrUnknown(data['net_weight']!, _netWeightMeta),
      );
    }
    if (data.containsKey('purity')) {
      context.handle(
        _purityMeta,
        purity.isAcceptableOrUnknown(data['purity']!, _purityMeta),
      );
    }
    if (data.containsKey('stone_weight')) {
      context.handle(
        _stoneWeightMeta,
        stoneWeight.isAcceptableOrUnknown(
          data['stone_weight']!,
          _stoneWeightMeta,
        ),
      );
    }
    if (data.containsKey('wastage')) {
      context.handle(
        _wastageMeta,
        wastage.isAcceptableOrUnknown(data['wastage']!, _wastageMeta),
      );
    }
    if (data.containsKey('making_charges')) {
      context.handle(
        _makingChargesMeta,
        makingCharges.isAcceptableOrUnknown(
          data['making_charges']!,
          _makingChargesMeta,
        ),
      );
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('stamp')) {
      context.handle(
        _stampMeta,
        stamp.isAcceptableOrUnknown(data['stamp']!, _stampMeta),
      );
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('rate_on')) {
      context.handle(
        _rateOnMeta,
        rateOn.isAcceptableOrUnknown(data['rate_on']!, _rateOnMeta),
      );
    }
    if (data.containsKey('ghat_weight')) {
      context.handle(
        _ghatWeightMeta,
        ghatWeight.isAcceptableOrUnknown(data['ghat_weight']!, _ghatWeightMeta),
      );
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    }
    if (data.containsKey('line_type')) {
      context.handle(
        _lineTypeMeta,
        lineType.isAcceptableOrUnknown(data['line_type']!, _lineTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      grossWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gross_weight'],
      )!,
      netWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}net_weight'],
      )!,
      purity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purity'],
      ),
      stoneWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stone_weight'],
      )!,
      wastage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wastage'],
      )!,
      makingCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}making_charges'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      stamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stamp'],
      ),
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}size'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      rateOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate_on'],
      ),
      ghatWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ghat_weight'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      )!,
      lineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_type'],
      ),
    );
  }

  @override
  $TransactionLinesTable createAlias(String alias) {
    return $TransactionLinesTable(attachedDatabase, alias);
  }
}

class TransactionLine extends DataClass implements Insertable<TransactionLine> {
  final int id;
  final int transactionId;
  final int? itemId;
  final String? description;
  final double grossWeight;
  final double netWeight;
  final double? purity;
  final double stoneWeight;
  final double wastage;
  final double makingCharges;
  final double rate;
  final double amount;
  final String? stamp;
  final String? size;
  final String? color;
  final String? rateOn;
  final double ghatWeight;
  final double qty;
  final String? lineType;
  const TransactionLine({
    required this.id,
    required this.transactionId,
    this.itemId,
    this.description,
    required this.grossWeight,
    required this.netWeight,
    this.purity,
    required this.stoneWeight,
    required this.wastage,
    required this.makingCharges,
    required this.rate,
    required this.amount,
    this.stamp,
    this.size,
    this.color,
    this.rateOn,
    required this.ghatWeight,
    required this.qty,
    this.lineType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['gross_weight'] = Variable<double>(grossWeight);
    map['net_weight'] = Variable<double>(netWeight);
    if (!nullToAbsent || purity != null) {
      map['purity'] = Variable<double>(purity);
    }
    map['stone_weight'] = Variable<double>(stoneWeight);
    map['wastage'] = Variable<double>(wastage);
    map['making_charges'] = Variable<double>(makingCharges);
    map['rate'] = Variable<double>(rate);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || stamp != null) {
      map['stamp'] = Variable<String>(stamp);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<String>(size);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || rateOn != null) {
      map['rate_on'] = Variable<String>(rateOn);
    }
    map['ghat_weight'] = Variable<double>(ghatWeight);
    map['qty'] = Variable<double>(qty);
    if (!nullToAbsent || lineType != null) {
      map['line_type'] = Variable<String>(lineType);
    }
    return map;
  }

  TransactionLinesCompanion toCompanion(bool nullToAbsent) {
    return TransactionLinesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      grossWeight: Value(grossWeight),
      netWeight: Value(netWeight),
      purity: purity == null && nullToAbsent
          ? const Value.absent()
          : Value(purity),
      stoneWeight: Value(stoneWeight),
      wastage: Value(wastage),
      makingCharges: Value(makingCharges),
      rate: Value(rate),
      amount: Value(amount),
      stamp: stamp == null && nullToAbsent
          ? const Value.absent()
          : Value(stamp),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      rateOn: rateOn == null && nullToAbsent
          ? const Value.absent()
          : Value(rateOn),
      ghatWeight: Value(ghatWeight),
      qty: Value(qty),
      lineType: lineType == null && nullToAbsent
          ? const Value.absent()
          : Value(lineType),
    );
  }

  factory TransactionLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionLine(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      description: serializer.fromJson<String?>(json['description']),
      grossWeight: serializer.fromJson<double>(json['grossWeight']),
      netWeight: serializer.fromJson<double>(json['netWeight']),
      purity: serializer.fromJson<double?>(json['purity']),
      stoneWeight: serializer.fromJson<double>(json['stoneWeight']),
      wastage: serializer.fromJson<double>(json['wastage']),
      makingCharges: serializer.fromJson<double>(json['makingCharges']),
      rate: serializer.fromJson<double>(json['rate']),
      amount: serializer.fromJson<double>(json['amount']),
      stamp: serializer.fromJson<String?>(json['stamp']),
      size: serializer.fromJson<String?>(json['size']),
      color: serializer.fromJson<String?>(json['color']),
      rateOn: serializer.fromJson<String?>(json['rateOn']),
      ghatWeight: serializer.fromJson<double>(json['ghatWeight']),
      qty: serializer.fromJson<double>(json['qty']),
      lineType: serializer.fromJson<String?>(json['lineType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'itemId': serializer.toJson<int?>(itemId),
      'description': serializer.toJson<String?>(description),
      'grossWeight': serializer.toJson<double>(grossWeight),
      'netWeight': serializer.toJson<double>(netWeight),
      'purity': serializer.toJson<double?>(purity),
      'stoneWeight': serializer.toJson<double>(stoneWeight),
      'wastage': serializer.toJson<double>(wastage),
      'makingCharges': serializer.toJson<double>(makingCharges),
      'rate': serializer.toJson<double>(rate),
      'amount': serializer.toJson<double>(amount),
      'stamp': serializer.toJson<String?>(stamp),
      'size': serializer.toJson<String?>(size),
      'color': serializer.toJson<String?>(color),
      'rateOn': serializer.toJson<String?>(rateOn),
      'ghatWeight': serializer.toJson<double>(ghatWeight),
      'qty': serializer.toJson<double>(qty),
      'lineType': serializer.toJson<String?>(lineType),
    };
  }

  TransactionLine copyWith({
    int? id,
    int? transactionId,
    Value<int?> itemId = const Value.absent(),
    Value<String?> description = const Value.absent(),
    double? grossWeight,
    double? netWeight,
    Value<double?> purity = const Value.absent(),
    double? stoneWeight,
    double? wastage,
    double? makingCharges,
    double? rate,
    double? amount,
    Value<String?> stamp = const Value.absent(),
    Value<String?> size = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> rateOn = const Value.absent(),
    double? ghatWeight,
    double? qty,
    Value<String?> lineType = const Value.absent(),
  }) => TransactionLine(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    itemId: itemId.present ? itemId.value : this.itemId,
    description: description.present ? description.value : this.description,
    grossWeight: grossWeight ?? this.grossWeight,
    netWeight: netWeight ?? this.netWeight,
    purity: purity.present ? purity.value : this.purity,
    stoneWeight: stoneWeight ?? this.stoneWeight,
    wastage: wastage ?? this.wastage,
    makingCharges: makingCharges ?? this.makingCharges,
    rate: rate ?? this.rate,
    amount: amount ?? this.amount,
    stamp: stamp.present ? stamp.value : this.stamp,
    size: size.present ? size.value : this.size,
    color: color.present ? color.value : this.color,
    rateOn: rateOn.present ? rateOn.value : this.rateOn,
    ghatWeight: ghatWeight ?? this.ghatWeight,
    qty: qty ?? this.qty,
    lineType: lineType.present ? lineType.value : this.lineType,
  );
  TransactionLine copyWithCompanion(TransactionLinesCompanion data) {
    return TransactionLine(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      description: data.description.present
          ? data.description.value
          : this.description,
      grossWeight: data.grossWeight.present
          ? data.grossWeight.value
          : this.grossWeight,
      netWeight: data.netWeight.present ? data.netWeight.value : this.netWeight,
      purity: data.purity.present ? data.purity.value : this.purity,
      stoneWeight: data.stoneWeight.present
          ? data.stoneWeight.value
          : this.stoneWeight,
      wastage: data.wastage.present ? data.wastage.value : this.wastage,
      makingCharges: data.makingCharges.present
          ? data.makingCharges.value
          : this.makingCharges,
      rate: data.rate.present ? data.rate.value : this.rate,
      amount: data.amount.present ? data.amount.value : this.amount,
      stamp: data.stamp.present ? data.stamp.value : this.stamp,
      size: data.size.present ? data.size.value : this.size,
      color: data.color.present ? data.color.value : this.color,
      rateOn: data.rateOn.present ? data.rateOn.value : this.rateOn,
      ghatWeight: data.ghatWeight.present
          ? data.ghatWeight.value
          : this.ghatWeight,
      qty: data.qty.present ? data.qty.value : this.qty,
      lineType: data.lineType.present ? data.lineType.value : this.lineType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLine(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('itemId: $itemId, ')
          ..write('description: $description, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('netWeight: $netWeight, ')
          ..write('purity: $purity, ')
          ..write('stoneWeight: $stoneWeight, ')
          ..write('wastage: $wastage, ')
          ..write('makingCharges: $makingCharges, ')
          ..write('rate: $rate, ')
          ..write('amount: $amount, ')
          ..write('stamp: $stamp, ')
          ..write('size: $size, ')
          ..write('color: $color, ')
          ..write('rateOn: $rateOn, ')
          ..write('ghatWeight: $ghatWeight, ')
          ..write('qty: $qty, ')
          ..write('lineType: $lineType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    itemId,
    description,
    grossWeight,
    netWeight,
    purity,
    stoneWeight,
    wastage,
    makingCharges,
    rate,
    amount,
    stamp,
    size,
    color,
    rateOn,
    ghatWeight,
    qty,
    lineType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionLine &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.itemId == this.itemId &&
          other.description == this.description &&
          other.grossWeight == this.grossWeight &&
          other.netWeight == this.netWeight &&
          other.purity == this.purity &&
          other.stoneWeight == this.stoneWeight &&
          other.wastage == this.wastage &&
          other.makingCharges == this.makingCharges &&
          other.rate == this.rate &&
          other.amount == this.amount &&
          other.stamp == this.stamp &&
          other.size == this.size &&
          other.color == this.color &&
          other.rateOn == this.rateOn &&
          other.ghatWeight == this.ghatWeight &&
          other.qty == this.qty &&
          other.lineType == this.lineType);
}

class TransactionLinesCompanion extends UpdateCompanion<TransactionLine> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int?> itemId;
  final Value<String?> description;
  final Value<double> grossWeight;
  final Value<double> netWeight;
  final Value<double?> purity;
  final Value<double> stoneWeight;
  final Value<double> wastage;
  final Value<double> makingCharges;
  final Value<double> rate;
  final Value<double> amount;
  final Value<String?> stamp;
  final Value<String?> size;
  final Value<String?> color;
  final Value<String?> rateOn;
  final Value<double> ghatWeight;
  final Value<double> qty;
  final Value<String?> lineType;
  const TransactionLinesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.description = const Value.absent(),
    this.grossWeight = const Value.absent(),
    this.netWeight = const Value.absent(),
    this.purity = const Value.absent(),
    this.stoneWeight = const Value.absent(),
    this.wastage = const Value.absent(),
    this.makingCharges = const Value.absent(),
    this.rate = const Value.absent(),
    this.amount = const Value.absent(),
    this.stamp = const Value.absent(),
    this.size = const Value.absent(),
    this.color = const Value.absent(),
    this.rateOn = const Value.absent(),
    this.ghatWeight = const Value.absent(),
    this.qty = const Value.absent(),
    this.lineType = const Value.absent(),
  });
  TransactionLinesCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    this.itemId = const Value.absent(),
    this.description = const Value.absent(),
    this.grossWeight = const Value.absent(),
    this.netWeight = const Value.absent(),
    this.purity = const Value.absent(),
    this.stoneWeight = const Value.absent(),
    this.wastage = const Value.absent(),
    this.makingCharges = const Value.absent(),
    this.rate = const Value.absent(),
    this.amount = const Value.absent(),
    this.stamp = const Value.absent(),
    this.size = const Value.absent(),
    this.color = const Value.absent(),
    this.rateOn = const Value.absent(),
    this.ghatWeight = const Value.absent(),
    this.qty = const Value.absent(),
    this.lineType = const Value.absent(),
  }) : transactionId = Value(transactionId);
  static Insertable<TransactionLine> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? itemId,
    Expression<String>? description,
    Expression<double>? grossWeight,
    Expression<double>? netWeight,
    Expression<double>? purity,
    Expression<double>? stoneWeight,
    Expression<double>? wastage,
    Expression<double>? makingCharges,
    Expression<double>? rate,
    Expression<double>? amount,
    Expression<String>? stamp,
    Expression<String>? size,
    Expression<String>? color,
    Expression<String>? rateOn,
    Expression<double>? ghatWeight,
    Expression<double>? qty,
    Expression<String>? lineType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (itemId != null) 'item_id': itemId,
      if (description != null) 'description': description,
      if (grossWeight != null) 'gross_weight': grossWeight,
      if (netWeight != null) 'net_weight': netWeight,
      if (purity != null) 'purity': purity,
      if (stoneWeight != null) 'stone_weight': stoneWeight,
      if (wastage != null) 'wastage': wastage,
      if (makingCharges != null) 'making_charges': makingCharges,
      if (rate != null) 'rate': rate,
      if (amount != null) 'amount': amount,
      if (stamp != null) 'stamp': stamp,
      if (size != null) 'size': size,
      if (color != null) 'color': color,
      if (rateOn != null) 'rate_on': rateOn,
      if (ghatWeight != null) 'ghat_weight': ghatWeight,
      if (qty != null) 'qty': qty,
      if (lineType != null) 'line_type': lineType,
    });
  }

  TransactionLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<int?>? itemId,
    Value<String?>? description,
    Value<double>? grossWeight,
    Value<double>? netWeight,
    Value<double?>? purity,
    Value<double>? stoneWeight,
    Value<double>? wastage,
    Value<double>? makingCharges,
    Value<double>? rate,
    Value<double>? amount,
    Value<String?>? stamp,
    Value<String?>? size,
    Value<String?>? color,
    Value<String?>? rateOn,
    Value<double>? ghatWeight,
    Value<double>? qty,
    Value<String?>? lineType,
  }) {
    return TransactionLinesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      itemId: itemId ?? this.itemId,
      description: description ?? this.description,
      grossWeight: grossWeight ?? this.grossWeight,
      netWeight: netWeight ?? this.netWeight,
      purity: purity ?? this.purity,
      stoneWeight: stoneWeight ?? this.stoneWeight,
      wastage: wastage ?? this.wastage,
      makingCharges: makingCharges ?? this.makingCharges,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
      stamp: stamp ?? this.stamp,
      size: size ?? this.size,
      color: color ?? this.color,
      rateOn: rateOn ?? this.rateOn,
      ghatWeight: ghatWeight ?? this.ghatWeight,
      qty: qty ?? this.qty,
      lineType: lineType ?? this.lineType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (grossWeight.present) {
      map['gross_weight'] = Variable<double>(grossWeight.value);
    }
    if (netWeight.present) {
      map['net_weight'] = Variable<double>(netWeight.value);
    }
    if (purity.present) {
      map['purity'] = Variable<double>(purity.value);
    }
    if (stoneWeight.present) {
      map['stone_weight'] = Variable<double>(stoneWeight.value);
    }
    if (wastage.present) {
      map['wastage'] = Variable<double>(wastage.value);
    }
    if (makingCharges.present) {
      map['making_charges'] = Variable<double>(makingCharges.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (stamp.present) {
      map['stamp'] = Variable<String>(stamp.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (rateOn.present) {
      map['rate_on'] = Variable<String>(rateOn.value);
    }
    if (ghatWeight.present) {
      map['ghat_weight'] = Variable<double>(ghatWeight.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (lineType.present) {
      map['line_type'] = Variable<String>(lineType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLinesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('itemId: $itemId, ')
          ..write('description: $description, ')
          ..write('grossWeight: $grossWeight, ')
          ..write('netWeight: $netWeight, ')
          ..write('purity: $purity, ')
          ..write('stoneWeight: $stoneWeight, ')
          ..write('wastage: $wastage, ')
          ..write('makingCharges: $makingCharges, ')
          ..write('rate: $rate, ')
          ..write('amount: $amount, ')
          ..write('stamp: $stamp, ')
          ..write('size: $size, ')
          ..write('color: $color, ')
          ..write('rateOn: $rateOn, ')
          ..write('ghatWeight: $ghatWeight, ')
          ..write('qty: $qty, ')
          ..write('lineType: $lineType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionLinesTable transactionLines = $TransactionLinesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    parties,
    items,
    transactions,
    transactionLines,
  ];
}

typedef $$PartiesTableCreateCompanionBuilder =
    PartiesCompanion Function({
      Value<int> id,
      required String name,
      required String mobile,
      Value<String?> email,
      Value<String?> companyName,
      Value<String?> code,
      Value<String?> title,
      Value<String?> contactPerson,
      Value<String?> workPhone,
      Value<String?> whatsappNumber,
      Value<String?> alternatePhone,
      Value<String?> courier,
      Value<String?> notes,
      Value<String?> gender,
      Value<DateTime?> dateOfBirth,
      Value<DateTime?> anniversaryDate,
      Value<String?> referredBy,
      Value<String> status,
      Value<double> discountPercentage,
      Value<String?> paymentTerms,
      Value<String?> bankName,
      Value<String?> bankAccountNumber,
      Value<String?> ifscCode,
      Value<DateTime?> lastVisitDate,
      Value<String> taxPreference,
      Value<String?> landmark,
      Value<String> country,
      Value<String?> address,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> pinCode,
      required String type,
      Value<String?> gstin,
      Value<String?> panNumber,
      Value<double> openingGoldBalance,
      Value<double> openingSilverBalance,
      Value<double> openingCashBalance,
      Value<double> goldBalance,
      Value<double> silverBalance,
      Value<double> cashBalance,
      Value<double> creditLimitGold,
      Value<double> creditLimitCash,
      Value<DateTime> createdAt,
      Value<double?> defaultWastage,
      Value<double?> defaultRate,
    });
typedef $$PartiesTableUpdateCompanionBuilder =
    PartiesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> mobile,
      Value<String?> email,
      Value<String?> companyName,
      Value<String?> code,
      Value<String?> title,
      Value<String?> contactPerson,
      Value<String?> workPhone,
      Value<String?> whatsappNumber,
      Value<String?> alternatePhone,
      Value<String?> courier,
      Value<String?> notes,
      Value<String?> gender,
      Value<DateTime?> dateOfBirth,
      Value<DateTime?> anniversaryDate,
      Value<String?> referredBy,
      Value<String> status,
      Value<double> discountPercentage,
      Value<String?> paymentTerms,
      Value<String?> bankName,
      Value<String?> bankAccountNumber,
      Value<String?> ifscCode,
      Value<DateTime?> lastVisitDate,
      Value<String> taxPreference,
      Value<String?> landmark,
      Value<String> country,
      Value<String?> address,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> pinCode,
      Value<String> type,
      Value<String?> gstin,
      Value<String?> panNumber,
      Value<double> openingGoldBalance,
      Value<double> openingSilverBalance,
      Value<double> openingCashBalance,
      Value<double> goldBalance,
      Value<double> silverBalance,
      Value<double> cashBalance,
      Value<double> creditLimitGold,
      Value<double> creditLimitCash,
      Value<DateTime> createdAt,
      Value<double?> defaultWastage,
      Value<double?> defaultRate,
    });

final class $$PartiesTableReferences
    extends BaseReferences<_$AppDatabase, $PartiesTable, Party> {
  $$PartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(db.parties.id, db.transactions.partyId),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.partyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workPhone => $composableBuilder(
    column: $table.workPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternatePhone => $composableBuilder(
    column: $table.alternatePhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courier => $composableBuilder(
    column: $table.courier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get anniversaryDate => $composableBuilder(
    column: $table.anniversaryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referredBy => $composableBuilder(
    column: $table.referredBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankAccountNumber => $composableBuilder(
    column: $table.bankAccountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ifscCode => $composableBuilder(
    column: $table.ifscCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVisitDate => $composableBuilder(
    column: $table.lastVisitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxPreference => $composableBuilder(
    column: $table.taxPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landmark => $composableBuilder(
    column: $table.landmark,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinCode => $composableBuilder(
    column: $table.pinCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingGoldBalance => $composableBuilder(
    column: $table.openingGoldBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingSilverBalance => $composableBuilder(
    column: $table.openingSilverBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingCashBalance => $composableBuilder(
    column: $table.openingCashBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goldBalance => $composableBuilder(
    column: $table.goldBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get silverBalance => $composableBuilder(
    column: $table.silverBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cashBalance => $composableBuilder(
    column: $table.cashBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimitGold => $composableBuilder(
    column: $table.creditLimitGold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimitCash => $composableBuilder(
    column: $table.creditLimitCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultWastage => $composableBuilder(
    column: $table.defaultWastage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultRate => $composableBuilder(
    column: $table.defaultRate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobile => $composableBuilder(
    column: $table.mobile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workPhone => $composableBuilder(
    column: $table.workPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternatePhone => $composableBuilder(
    column: $table.alternatePhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courier => $composableBuilder(
    column: $table.courier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get anniversaryDate => $composableBuilder(
    column: $table.anniversaryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referredBy => $composableBuilder(
    column: $table.referredBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankAccountNumber => $composableBuilder(
    column: $table.bankAccountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ifscCode => $composableBuilder(
    column: $table.ifscCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVisitDate => $composableBuilder(
    column: $table.lastVisitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxPreference => $composableBuilder(
    column: $table.taxPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landmark => $composableBuilder(
    column: $table.landmark,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinCode => $composableBuilder(
    column: $table.pinCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingGoldBalance => $composableBuilder(
    column: $table.openingGoldBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingSilverBalance => $composableBuilder(
    column: $table.openingSilverBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingCashBalance => $composableBuilder(
    column: $table.openingCashBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goldBalance => $composableBuilder(
    column: $table.goldBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get silverBalance => $composableBuilder(
    column: $table.silverBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cashBalance => $composableBuilder(
    column: $table.cashBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimitGold => $composableBuilder(
    column: $table.creditLimitGold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimitCash => $composableBuilder(
    column: $table.creditLimitCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultWastage => $composableBuilder(
    column: $table.defaultWastage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultRate => $composableBuilder(
    column: $table.defaultRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workPhone =>
      $composableBuilder(column: $table.workPhone, builder: (column) => column);

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alternatePhone => $composableBuilder(
    column: $table.alternatePhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get courier =>
      $composableBuilder(column: $table.courier, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get anniversaryDate => $composableBuilder(
    column: $table.anniversaryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referredBy => $composableBuilder(
    column: $table.referredBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get bankAccountNumber => $composableBuilder(
    column: $table.bankAccountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ifscCode =>
      $composableBuilder(column: $table.ifscCode, builder: (column) => column);

  GeneratedColumn<DateTime> get lastVisitDate => $composableBuilder(
    column: $table.lastVisitDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxPreference => $composableBuilder(
    column: $table.taxPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get landmark =>
      $composableBuilder(column: $table.landmark, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get pinCode =>
      $composableBuilder(column: $table.pinCode, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get panNumber =>
      $composableBuilder(column: $table.panNumber, builder: (column) => column);

  GeneratedColumn<double> get openingGoldBalance => $composableBuilder(
    column: $table.openingGoldBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get openingSilverBalance => $composableBuilder(
    column: $table.openingSilverBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get openingCashBalance => $composableBuilder(
    column: $table.openingCashBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get goldBalance => $composableBuilder(
    column: $table.goldBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get silverBalance => $composableBuilder(
    column: $table.silverBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cashBalance => $composableBuilder(
    column: $table.cashBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditLimitGold => $composableBuilder(
    column: $table.creditLimitGold,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditLimitCash => $composableBuilder(
    column: $table.creditLimitCash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get defaultWastage => $composableBuilder(
    column: $table.defaultWastage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultRate => $composableBuilder(
    column: $table.defaultRate,
    builder: (column) => column,
  );

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.partyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartiesTable,
          Party,
          $$PartiesTableFilterComposer,
          $$PartiesTableOrderingComposer,
          $$PartiesTableAnnotationComposer,
          $$PartiesTableCreateCompanionBuilder,
          $$PartiesTableUpdateCompanionBuilder,
          (Party, $$PartiesTableReferences),
          Party,
          PrefetchHooks Function({bool transactionsRefs})
        > {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mobile = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> workPhone = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<String?> alternatePhone = const Value.absent(),
                Value<String?> courier = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<DateTime?> anniversaryDate = const Value.absent(),
                Value<String?> referredBy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> discountPercentage = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccountNumber = const Value.absent(),
                Value<String?> ifscCode = const Value.absent(),
                Value<DateTime?> lastVisitDate = const Value.absent(),
                Value<String> taxPreference = const Value.absent(),
                Value<String?> landmark = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> pinCode = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<double> openingGoldBalance = const Value.absent(),
                Value<double> openingSilverBalance = const Value.absent(),
                Value<double> openingCashBalance = const Value.absent(),
                Value<double> goldBalance = const Value.absent(),
                Value<double> silverBalance = const Value.absent(),
                Value<double> cashBalance = const Value.absent(),
                Value<double> creditLimitGold = const Value.absent(),
                Value<double> creditLimitCash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double?> defaultWastage = const Value.absent(),
                Value<double?> defaultRate = const Value.absent(),
              }) => PartiesCompanion(
                id: id,
                name: name,
                mobile: mobile,
                email: email,
                companyName: companyName,
                code: code,
                title: title,
                contactPerson: contactPerson,
                workPhone: workPhone,
                whatsappNumber: whatsappNumber,
                alternatePhone: alternatePhone,
                courier: courier,
                notes: notes,
                gender: gender,
                dateOfBirth: dateOfBirth,
                anniversaryDate: anniversaryDate,
                referredBy: referredBy,
                status: status,
                discountPercentage: discountPercentage,
                paymentTerms: paymentTerms,
                bankName: bankName,
                bankAccountNumber: bankAccountNumber,
                ifscCode: ifscCode,
                lastVisitDate: lastVisitDate,
                taxPreference: taxPreference,
                landmark: landmark,
                country: country,
                address: address,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                pinCode: pinCode,
                type: type,
                gstin: gstin,
                panNumber: panNumber,
                openingGoldBalance: openingGoldBalance,
                openingSilverBalance: openingSilverBalance,
                openingCashBalance: openingCashBalance,
                goldBalance: goldBalance,
                silverBalance: silverBalance,
                cashBalance: cashBalance,
                creditLimitGold: creditLimitGold,
                creditLimitCash: creditLimitCash,
                createdAt: createdAt,
                defaultWastage: defaultWastage,
                defaultRate: defaultRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String mobile,
                Value<String?> email = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> workPhone = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<String?> alternatePhone = const Value.absent(),
                Value<String?> courier = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<DateTime?> anniversaryDate = const Value.absent(),
                Value<String?> referredBy = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> discountPercentage = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccountNumber = const Value.absent(),
                Value<String?> ifscCode = const Value.absent(),
                Value<DateTime?> lastVisitDate = const Value.absent(),
                Value<String> taxPreference = const Value.absent(),
                Value<String?> landmark = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> pinCode = const Value.absent(),
                required String type,
                Value<String?> gstin = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<double> openingGoldBalance = const Value.absent(),
                Value<double> openingSilverBalance = const Value.absent(),
                Value<double> openingCashBalance = const Value.absent(),
                Value<double> goldBalance = const Value.absent(),
                Value<double> silverBalance = const Value.absent(),
                Value<double> cashBalance = const Value.absent(),
                Value<double> creditLimitGold = const Value.absent(),
                Value<double> creditLimitCash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double?> defaultWastage = const Value.absent(),
                Value<double?> defaultRate = const Value.absent(),
              }) => PartiesCompanion.insert(
                id: id,
                name: name,
                mobile: mobile,
                email: email,
                companyName: companyName,
                code: code,
                title: title,
                contactPerson: contactPerson,
                workPhone: workPhone,
                whatsappNumber: whatsappNumber,
                alternatePhone: alternatePhone,
                courier: courier,
                notes: notes,
                gender: gender,
                dateOfBirth: dateOfBirth,
                anniversaryDate: anniversaryDate,
                referredBy: referredBy,
                status: status,
                discountPercentage: discountPercentage,
                paymentTerms: paymentTerms,
                bankName: bankName,
                bankAccountNumber: bankAccountNumber,
                ifscCode: ifscCode,
                lastVisitDate: lastVisitDate,
                taxPreference: taxPreference,
                landmark: landmark,
                country: country,
                address: address,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                pinCode: pinCode,
                type: type,
                gstin: gstin,
                panNumber: panNumber,
                openingGoldBalance: openingGoldBalance,
                openingSilverBalance: openingSilverBalance,
                openingCashBalance: openingCashBalance,
                goldBalance: goldBalance,
                silverBalance: silverBalance,
                cashBalance: cashBalance,
                creditLimitGold: creditLimitGold,
                creditLimitCash: creditLimitCash,
                createdAt: createdAt,
                defaultWastage: defaultWastage,
                defaultRate: defaultRate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<
                      Party,
                      $PartiesTable,
                      Transaction
                    >(
                      currentTable: table,
                      referencedTable: $$PartiesTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PartiesTableReferences(
                        db,
                        table,
                        p0,
                      ).transactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.partyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartiesTable,
      Party,
      $$PartiesTableFilterComposer,
      $$PartiesTableOrderingComposer,
      $$PartiesTableAnnotationComposer,
      $$PartiesTableCreateCompanionBuilder,
      $$PartiesTableUpdateCompanionBuilder,
      (Party, $$PartiesTableReferences),
      Party,
      PrefetchHooks Function({bool transactionsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> code,
      required String metalType,
      Value<String?> purity,
      Value<String?> category,
      Value<String?> description,
      Value<String?> hsnCode,
      Value<double> costPrice,
      Value<double> sellingPrice,
      Value<double> makingCharges,
      Value<double> wastagePercentage,
      Value<double> stockQty,
      Value<double> stockWeight,
      Value<double> minimumStockLevel,
      Value<double> reorderLevel,
      Value<String> unitOfMeasurement,
      Value<String?> brand,
      Value<String?> manufacturer,
      Value<String?> size,
      Value<String?> color,
      Value<String?> stamp,
      Value<String?> stoneDetails,
      Value<String> status,
      Value<String?> notes,
      Value<String> itemType,
      Value<String> maintainStockIn,
      Value<bool> isStudded,
      Value<bool> fetchGoldRate,
      Value<String?> defaultGoldRate,
      Value<double> defaultTouch,
      Value<String> taxPreference,
      Value<double> purchaseWastage,
      Value<double> purchaseMakingCharges,
      Value<double> jobworkRate,
      Value<String?> discountLedger,
      Value<String> stockMethod,
      Value<String?> tagPrefix,
      Value<double> minStockPcs,
      Value<double> maxStockGm,
      Value<double> maxStockPcs,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> code,
      Value<String> metalType,
      Value<String?> purity,
      Value<String?> category,
      Value<String?> description,
      Value<String?> hsnCode,
      Value<double> costPrice,
      Value<double> sellingPrice,
      Value<double> makingCharges,
      Value<double> wastagePercentage,
      Value<double> stockQty,
      Value<double> stockWeight,
      Value<double> minimumStockLevel,
      Value<double> reorderLevel,
      Value<String> unitOfMeasurement,
      Value<String?> brand,
      Value<String?> manufacturer,
      Value<String?> size,
      Value<String?> color,
      Value<String?> stamp,
      Value<String?> stoneDetails,
      Value<String> status,
      Value<String?> notes,
      Value<String> itemType,
      Value<String> maintainStockIn,
      Value<bool> isStudded,
      Value<bool> fetchGoldRate,
      Value<String?> defaultGoldRate,
      Value<double> defaultTouch,
      Value<String> taxPreference,
      Value<double> purchaseWastage,
      Value<double> purchaseMakingCharges,
      Value<double> jobworkRate,
      Value<String?> discountLedger,
      Value<String> stockMethod,
      Value<String?> tagPrefix,
      Value<double> minStockPcs,
      Value<double> maxStockGm,
      Value<double> maxStockPcs,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionLinesTable, List<TransactionLine>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: $_aliasNameGenerator(db.items.id, db.transactionLines.itemId),
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metalType => $composableBuilder(
    column: $table.metalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purity => $composableBuilder(
    column: $table.purity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get makingCharges => $composableBuilder(
    column: $table.makingCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wastagePercentage => $composableBuilder(
    column: $table.wastagePercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockWeight => $composableBuilder(
    column: $table.stockWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minimumStockLevel => $composableBuilder(
    column: $table.minimumStockLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitOfMeasurement => $composableBuilder(
    column: $table.unitOfMeasurement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stamp => $composableBuilder(
    column: $table.stamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stoneDetails => $composableBuilder(
    column: $table.stoneDetails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maintainStockIn => $composableBuilder(
    column: $table.maintainStockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStudded => $composableBuilder(
    column: $table.isStudded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fetchGoldRate => $composableBuilder(
    column: $table.fetchGoldRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultGoldRate => $composableBuilder(
    column: $table.defaultGoldRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultTouch => $composableBuilder(
    column: $table.defaultTouch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxPreference => $composableBuilder(
    column: $table.taxPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchaseWastage => $composableBuilder(
    column: $table.purchaseWastage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchaseMakingCharges => $composableBuilder(
    column: $table.purchaseMakingCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jobworkRate => $composableBuilder(
    column: $table.jobworkRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountLedger => $composableBuilder(
    column: $table.discountLedger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stockMethod => $composableBuilder(
    column: $table.stockMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagPrefix => $composableBuilder(
    column: $table.tagPrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minStockPcs => $composableBuilder(
    column: $table.minStockPcs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxStockGm => $composableBuilder(
    column: $table.maxStockGm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxStockPcs => $composableBuilder(
    column: $table.maxStockPcs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metalType => $composableBuilder(
    column: $table.metalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purity => $composableBuilder(
    column: $table.purity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costPrice => $composableBuilder(
    column: $table.costPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get makingCharges => $composableBuilder(
    column: $table.makingCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wastagePercentage => $composableBuilder(
    column: $table.wastagePercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockWeight => $composableBuilder(
    column: $table.stockWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minimumStockLevel => $composableBuilder(
    column: $table.minimumStockLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitOfMeasurement => $composableBuilder(
    column: $table.unitOfMeasurement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stamp => $composableBuilder(
    column: $table.stamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stoneDetails => $composableBuilder(
    column: $table.stoneDetails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maintainStockIn => $composableBuilder(
    column: $table.maintainStockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStudded => $composableBuilder(
    column: $table.isStudded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fetchGoldRate => $composableBuilder(
    column: $table.fetchGoldRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultGoldRate => $composableBuilder(
    column: $table.defaultGoldRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultTouch => $composableBuilder(
    column: $table.defaultTouch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxPreference => $composableBuilder(
    column: $table.taxPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchaseWastage => $composableBuilder(
    column: $table.purchaseWastage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchaseMakingCharges => $composableBuilder(
    column: $table.purchaseMakingCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jobworkRate => $composableBuilder(
    column: $table.jobworkRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountLedger => $composableBuilder(
    column: $table.discountLedger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stockMethod => $composableBuilder(
    column: $table.stockMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagPrefix => $composableBuilder(
    column: $table.tagPrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minStockPcs => $composableBuilder(
    column: $table.minStockPcs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxStockGm => $composableBuilder(
    column: $table.maxStockGm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxStockPcs => $composableBuilder(
    column: $table.maxStockPcs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get metalType =>
      $composableBuilder(column: $table.metalType, builder: (column) => column);

  GeneratedColumn<String> get purity =>
      $composableBuilder(column: $table.purity, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get makingCharges => $composableBuilder(
    column: $table.makingCharges,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wastagePercentage => $composableBuilder(
    column: $table.wastagePercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<double> get stockWeight => $composableBuilder(
    column: $table.stockWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minimumStockLevel => $composableBuilder(
    column: $table.minimumStockLevel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitOfMeasurement => $composableBuilder(
    column: $table.unitOfMeasurement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get stamp =>
      $composableBuilder(column: $table.stamp, builder: (column) => column);

  GeneratedColumn<String> get stoneDetails => $composableBuilder(
    column: $table.stoneDetails,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get maintainStockIn => $composableBuilder(
    column: $table.maintainStockIn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStudded =>
      $composableBuilder(column: $table.isStudded, builder: (column) => column);

  GeneratedColumn<bool> get fetchGoldRate => $composableBuilder(
    column: $table.fetchGoldRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultGoldRate => $composableBuilder(
    column: $table.defaultGoldRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultTouch => $composableBuilder(
    column: $table.defaultTouch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxPreference => $composableBuilder(
    column: $table.taxPreference,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchaseWastage => $composableBuilder(
    column: $table.purchaseWastage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchaseMakingCharges => $composableBuilder(
    column: $table.purchaseMakingCharges,
    builder: (column) => column,
  );

  GeneratedColumn<double> get jobworkRate => $composableBuilder(
    column: $table.jobworkRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountLedger => $composableBuilder(
    column: $table.discountLedger,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stockMethod => $composableBuilder(
    column: $table.stockMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagPrefix =>
      $composableBuilder(column: $table.tagPrefix, builder: (column) => column);

  GeneratedColumn<double> get minStockPcs => $composableBuilder(
    column: $table.minStockPcs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxStockGm => $composableBuilder(
    column: $table.maxStockGm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxStockPcs => $composableBuilder(
    column: $table.maxStockPcs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, $$ItemsTableReferences),
          Item,
          PrefetchHooks Function({bool transactionLinesRefs})
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> metalType = const Value.absent(),
                Value<String?> purity = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> costPrice = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> makingCharges = const Value.absent(),
                Value<double> wastagePercentage = const Value.absent(),
                Value<double> stockQty = const Value.absent(),
                Value<double> stockWeight = const Value.absent(),
                Value<double> minimumStockLevel = const Value.absent(),
                Value<double> reorderLevel = const Value.absent(),
                Value<String> unitOfMeasurement = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> size = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> stamp = const Value.absent(),
                Value<String?> stoneDetails = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> maintainStockIn = const Value.absent(),
                Value<bool> isStudded = const Value.absent(),
                Value<bool> fetchGoldRate = const Value.absent(),
                Value<String?> defaultGoldRate = const Value.absent(),
                Value<double> defaultTouch = const Value.absent(),
                Value<String> taxPreference = const Value.absent(),
                Value<double> purchaseWastage = const Value.absent(),
                Value<double> purchaseMakingCharges = const Value.absent(),
                Value<double> jobworkRate = const Value.absent(),
                Value<String?> discountLedger = const Value.absent(),
                Value<String> stockMethod = const Value.absent(),
                Value<String?> tagPrefix = const Value.absent(),
                Value<double> minStockPcs = const Value.absent(),
                Value<double> maxStockGm = const Value.absent(),
                Value<double> maxStockPcs = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                name: name,
                code: code,
                metalType: metalType,
                purity: purity,
                category: category,
                description: description,
                hsnCode: hsnCode,
                costPrice: costPrice,
                sellingPrice: sellingPrice,
                makingCharges: makingCharges,
                wastagePercentage: wastagePercentage,
                stockQty: stockQty,
                stockWeight: stockWeight,
                minimumStockLevel: minimumStockLevel,
                reorderLevel: reorderLevel,
                unitOfMeasurement: unitOfMeasurement,
                brand: brand,
                manufacturer: manufacturer,
                size: size,
                color: color,
                stamp: stamp,
                stoneDetails: stoneDetails,
                status: status,
                notes: notes,
                itemType: itemType,
                maintainStockIn: maintainStockIn,
                isStudded: isStudded,
                fetchGoldRate: fetchGoldRate,
                defaultGoldRate: defaultGoldRate,
                defaultTouch: defaultTouch,
                taxPreference: taxPreference,
                purchaseWastage: purchaseWastage,
                purchaseMakingCharges: purchaseMakingCharges,
                jobworkRate: jobworkRate,
                discountLedger: discountLedger,
                stockMethod: stockMethod,
                tagPrefix: tagPrefix,
                minStockPcs: minStockPcs,
                maxStockGm: maxStockGm,
                maxStockPcs: maxStockPcs,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> code = const Value.absent(),
                required String metalType,
                Value<String?> purity = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> costPrice = const Value.absent(),
                Value<double> sellingPrice = const Value.absent(),
                Value<double> makingCharges = const Value.absent(),
                Value<double> wastagePercentage = const Value.absent(),
                Value<double> stockQty = const Value.absent(),
                Value<double> stockWeight = const Value.absent(),
                Value<double> minimumStockLevel = const Value.absent(),
                Value<double> reorderLevel = const Value.absent(),
                Value<String> unitOfMeasurement = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> size = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> stamp = const Value.absent(),
                Value<String?> stoneDetails = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> maintainStockIn = const Value.absent(),
                Value<bool> isStudded = const Value.absent(),
                Value<bool> fetchGoldRate = const Value.absent(),
                Value<String?> defaultGoldRate = const Value.absent(),
                Value<double> defaultTouch = const Value.absent(),
                Value<String> taxPreference = const Value.absent(),
                Value<double> purchaseWastage = const Value.absent(),
                Value<double> purchaseMakingCharges = const Value.absent(),
                Value<double> jobworkRate = const Value.absent(),
                Value<String?> discountLedger = const Value.absent(),
                Value<String> stockMethod = const Value.absent(),
                Value<String?> tagPrefix = const Value.absent(),
                Value<double> minStockPcs = const Value.absent(),
                Value<double> maxStockGm = const Value.absent(),
                Value<double> maxStockPcs = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                name: name,
                code: code,
                metalType: metalType,
                purity: purity,
                category: category,
                description: description,
                hsnCode: hsnCode,
                costPrice: costPrice,
                sellingPrice: sellingPrice,
                makingCharges: makingCharges,
                wastagePercentage: wastagePercentage,
                stockQty: stockQty,
                stockWeight: stockWeight,
                minimumStockLevel: minimumStockLevel,
                reorderLevel: reorderLevel,
                unitOfMeasurement: unitOfMeasurement,
                brand: brand,
                manufacturer: manufacturer,
                size: size,
                color: color,
                stamp: stamp,
                stoneDetails: stoneDetails,
                status: status,
                notes: notes,
                itemType: itemType,
                maintainStockIn: maintainStockIn,
                isStudded: isStudded,
                fetchGoldRate: fetchGoldRate,
                defaultGoldRate: defaultGoldRate,
                defaultTouch: defaultTouch,
                taxPreference: taxPreference,
                purchaseWastage: purchaseWastage,
                purchaseMakingCharges: purchaseMakingCharges,
                jobworkRate: jobworkRate,
                discountLedger: discountLedger,
                stockMethod: stockMethod,
                tagPrefix: tagPrefix,
                minStockPcs: minStockPcs,
                maxStockGm: maxStockGm,
                maxStockPcs: maxStockPcs,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ItemsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({transactionLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionLinesRefs) db.transactionLines,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionLinesRefs)
                    await $_getPrefetchedData<
                      Item,
                      $ItemsTable,
                      TransactionLine
                    >(
                      currentTable: table,
                      referencedTable: $$ItemsTableReferences
                          ._transactionLinesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ItemsTableReferences(
                        db,
                        table,
                        p0,
                      ).transactionLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.itemId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, $$ItemsTableReferences),
      Item,
      PrefetchHooks Function({bool transactionLinesRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String?> transactionNumber,
      required DateTime date,
      required int partyId,
      required String type,
      Value<String?> paymentMethod,
      Value<String?> paymentReference,
      Value<double> discountAmount,
      Value<double> discountPercentage,
      Value<double> taxAmount,
      Value<double> taxPercentage,
      Value<double> totalGoldWeight,
      Value<double> totalSilverWeight,
      Value<double> subtotal,
      Value<double> totalAmount,
      Value<String?> remarks,
      Value<String> status,
      Value<int?> dueDays,
      Value<DateTime?> dueDate,
      Value<String?> partyPoNumber,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String?> transactionNumber,
      Value<DateTime> date,
      Value<int> partyId,
      Value<String> type,
      Value<String?> paymentMethod,
      Value<String?> paymentReference,
      Value<double> discountAmount,
      Value<double> discountPercentage,
      Value<double> taxAmount,
      Value<double> taxPercentage,
      Value<double> totalGoldWeight,
      Value<double> totalSilverWeight,
      Value<double> subtotal,
      Value<double> totalAmount,
      Value<String?> remarks,
      Value<String> status,
      Value<int?> dueDays,
      Value<DateTime?> dueDate,
      Value<String?> partyPoNumber,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartiesTable _partyIdTable(_$AppDatabase db) =>
      db.parties.createAlias(
        $_aliasNameGenerator(db.transactions.partyId, db.parties.id),
      );

  $$PartiesTableProcessedTableManager get partyId {
    final $_column = $_itemColumn<int>('party_id')!;

    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionLinesTable, List<TransactionLine>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.transactionLines.transactionId,
    ),
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionNumber => $composableBuilder(
    column: $table.transactionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentReference => $composableBuilder(
    column: $table.paymentReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxPercentage => $composableBuilder(
    column: $table.taxPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalGoldWeight => $composableBuilder(
    column: $table.totalGoldWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSilverWeight => $composableBuilder(
    column: $table.totalSilverWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDays => $composableBuilder(
    column: $table.dueDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyPoNumber => $composableBuilder(
    column: $table.partyPoNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$PartiesTableFilterComposer get partyId {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionNumber => $composableBuilder(
    column: $table.transactionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentReference => $composableBuilder(
    column: $table.paymentReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxPercentage => $composableBuilder(
    column: $table.taxPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalGoldWeight => $composableBuilder(
    column: $table.totalGoldWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSilverWeight => $composableBuilder(
    column: $table.totalSilverWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDays => $composableBuilder(
    column: $table.dueDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyPoNumber => $composableBuilder(
    column: $table.partyPoNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartiesTableOrderingComposer get partyId {
    final $$PartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableOrderingComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionNumber => $composableBuilder(
    column: $table.transactionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentReference => $composableBuilder(
    column: $table.paymentReference,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
    column: $table.discountPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get taxPercentage => $composableBuilder(
    column: $table.taxPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalGoldWeight => $composableBuilder(
    column: $table.totalGoldWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSilverWeight => $composableBuilder(
    column: $table.totalSilverWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get dueDays =>
      $composableBuilder(column: $table.dueDays, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get partyPoNumber => $composableBuilder(
    column: $table.partyPoNumber,
    builder: (column) => column,
  );

  $$PartiesTableAnnotationComposer get partyId {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partyId,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({bool partyId, bool transactionLinesRefs})
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> transactionNumber = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> partyId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> paymentReference = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double> discountPercentage = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> taxPercentage = const Value.absent(),
                Value<double> totalGoldWeight = const Value.absent(),
                Value<double> totalSilverWeight = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> dueDays = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> partyPoNumber = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                transactionNumber: transactionNumber,
                date: date,
                partyId: partyId,
                type: type,
                paymentMethod: paymentMethod,
                paymentReference: paymentReference,
                discountAmount: discountAmount,
                discountPercentage: discountPercentage,
                taxAmount: taxAmount,
                taxPercentage: taxPercentage,
                totalGoldWeight: totalGoldWeight,
                totalSilverWeight: totalSilverWeight,
                subtotal: subtotal,
                totalAmount: totalAmount,
                remarks: remarks,
                status: status,
                dueDays: dueDays,
                dueDate: dueDate,
                partyPoNumber: partyPoNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> transactionNumber = const Value.absent(),
                required DateTime date,
                required int partyId,
                required String type,
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> paymentReference = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double> discountPercentage = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> taxPercentage = const Value.absent(),
                Value<double> totalGoldWeight = const Value.absent(),
                Value<double> totalSilverWeight = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> dueDays = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> partyPoNumber = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                transactionNumber: transactionNumber,
                date: date,
                partyId: partyId,
                type: type,
                paymentMethod: paymentMethod,
                paymentReference: paymentReference,
                discountAmount: discountAmount,
                discountPercentage: discountPercentage,
                taxAmount: taxAmount,
                taxPercentage: taxPercentage,
                totalGoldWeight: totalGoldWeight,
                totalSilverWeight: totalSilverWeight,
                subtotal: subtotal,
                totalAmount: totalAmount,
                remarks: remarks,
                status: status,
                dueDays: dueDays,
                dueDate: dueDate,
                partyPoNumber: partyPoNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({partyId = false, transactionLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionLinesRefs) db.transactionLines,
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
                        if (partyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.partyId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._partyIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._partyIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionLinesRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          TransactionLine
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({bool partyId, bool transactionLinesRefs})
    >;
typedef $$TransactionLinesTableCreateCompanionBuilder =
    TransactionLinesCompanion Function({
      Value<int> id,
      required int transactionId,
      Value<int?> itemId,
      Value<String?> description,
      Value<double> grossWeight,
      Value<double> netWeight,
      Value<double?> purity,
      Value<double> stoneWeight,
      Value<double> wastage,
      Value<double> makingCharges,
      Value<double> rate,
      Value<double> amount,
      Value<String?> stamp,
      Value<String?> size,
      Value<String?> color,
      Value<String?> rateOn,
      Value<double> ghatWeight,
      Value<double> qty,
      Value<String?> lineType,
    });
typedef $$TransactionLinesTableUpdateCompanionBuilder =
    TransactionLinesCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<int?> itemId,
      Value<String?> description,
      Value<double> grossWeight,
      Value<double> netWeight,
      Value<double?> purity,
      Value<double> stoneWeight,
      Value<double> wastage,
      Value<double> makingCharges,
      Value<double> rate,
      Value<double> amount,
      Value<String?> stamp,
      Value<String?> size,
      Value<String?> color,
      Value<String?> rateOn,
      Value<double> ghatWeight,
      Value<double> qty,
      Value<String?> lineType,
    });

final class $$TransactionLinesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TransactionLinesTable, TransactionLine> {
  $$TransactionLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.transactionLines.transactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items.createAlias(
    $_aliasNameGenerator(db.transactionLines.itemId, db.items.id),
  );

  $$ItemsTableProcessedTableManager? get itemId {
    final $_column = $_itemColumn<int>('item_id');
    if ($_column == null) return null;
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionLinesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netWeight => $composableBuilder(
    column: $table.netWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purity => $composableBuilder(
    column: $table.purity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stoneWeight => $composableBuilder(
    column: $table.stoneWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wastage => $composableBuilder(
    column: $table.wastage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get makingCharges => $composableBuilder(
    column: $table.makingCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stamp => $composableBuilder(
    column: $table.stamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rateOn => $composableBuilder(
    column: $table.rateOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ghatWeight => $composableBuilder(
    column: $table.ghatWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineType => $composableBuilder(
    column: $table.lineType,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netWeight => $composableBuilder(
    column: $table.netWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purity => $composableBuilder(
    column: $table.purity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stoneWeight => $composableBuilder(
    column: $table.stoneWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wastage => $composableBuilder(
    column: $table.wastage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get makingCharges => $composableBuilder(
    column: $table.makingCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stamp => $composableBuilder(
    column: $table.stamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateOn => $composableBuilder(
    column: $table.rateOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ghatWeight => $composableBuilder(
    column: $table.ghatWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineType => $composableBuilder(
    column: $table.lineType,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grossWeight => $composableBuilder(
    column: $table.grossWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get netWeight =>
      $composableBuilder(column: $table.netWeight, builder: (column) => column);

  GeneratedColumn<double> get purity =>
      $composableBuilder(column: $table.purity, builder: (column) => column);

  GeneratedColumn<double> get stoneWeight => $composableBuilder(
    column: $table.stoneWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wastage =>
      $composableBuilder(column: $table.wastage, builder: (column) => column);

  GeneratedColumn<double> get makingCharges => $composableBuilder(
    column: $table.makingCharges,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get stamp =>
      $composableBuilder(column: $table.stamp, builder: (column) => column);

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get rateOn =>
      $composableBuilder(column: $table.rateOn, builder: (column) => column);

  GeneratedColumn<double> get ghatWeight => $composableBuilder(
    column: $table.ghatWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<String> get lineType =>
      $composableBuilder(column: $table.lineType, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionLinesTable,
          TransactionLine,
          $$TransactionLinesTableFilterComposer,
          $$TransactionLinesTableOrderingComposer,
          $$TransactionLinesTableAnnotationComposer,
          $$TransactionLinesTableCreateCompanionBuilder,
          $$TransactionLinesTableUpdateCompanionBuilder,
          (TransactionLine, $$TransactionLinesTableReferences),
          TransactionLine,
          PrefetchHooks Function({bool transactionId, bool itemId})
        > {
  $$TransactionLinesTableTableManager(
    _$AppDatabase db,
    $TransactionLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int?> itemId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> grossWeight = const Value.absent(),
                Value<double> netWeight = const Value.absent(),
                Value<double?> purity = const Value.absent(),
                Value<double> stoneWeight = const Value.absent(),
                Value<double> wastage = const Value.absent(),
                Value<double> makingCharges = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> stamp = const Value.absent(),
                Value<String?> size = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> rateOn = const Value.absent(),
                Value<double> ghatWeight = const Value.absent(),
                Value<double> qty = const Value.absent(),
                Value<String?> lineType = const Value.absent(),
              }) => TransactionLinesCompanion(
                id: id,
                transactionId: transactionId,
                itemId: itemId,
                description: description,
                grossWeight: grossWeight,
                netWeight: netWeight,
                purity: purity,
                stoneWeight: stoneWeight,
                wastage: wastage,
                makingCharges: makingCharges,
                rate: rate,
                amount: amount,
                stamp: stamp,
                size: size,
                color: color,
                rateOn: rateOn,
                ghatWeight: ghatWeight,
                qty: qty,
                lineType: lineType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                Value<int?> itemId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> grossWeight = const Value.absent(),
                Value<double> netWeight = const Value.absent(),
                Value<double?> purity = const Value.absent(),
                Value<double> stoneWeight = const Value.absent(),
                Value<double> wastage = const Value.absent(),
                Value<double> makingCharges = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> stamp = const Value.absent(),
                Value<String?> size = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> rateOn = const Value.absent(),
                Value<double> ghatWeight = const Value.absent(),
                Value<double> qty = const Value.absent(),
                Value<String?> lineType = const Value.absent(),
              }) => TransactionLinesCompanion.insert(
                id: id,
                transactionId: transactionId,
                itemId: itemId,
                description: description,
                grossWeight: grossWeight,
                netWeight: netWeight,
                purity: purity,
                stoneWeight: stoneWeight,
                wastage: wastage,
                makingCharges: makingCharges,
                rate: rate,
                amount: amount,
                stamp: stamp,
                size: size,
                color: color,
                rateOn: rateOn,
                ghatWeight: ghatWeight,
                qty: qty,
                lineType: lineType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false, itemId = false}) {
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
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable:
                                    $$TransactionLinesTableReferences
                                        ._transactionIdTable(db),
                                referencedColumn:
                                    $$TransactionLinesTableReferences
                                        ._transactionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable:
                                    $$TransactionLinesTableReferences
                                        ._itemIdTable(db),
                                referencedColumn:
                                    $$TransactionLinesTableReferences
                                        ._itemIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$TransactionLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionLinesTable,
      TransactionLine,
      $$TransactionLinesTableFilterComposer,
      $$TransactionLinesTableOrderingComposer,
      $$TransactionLinesTableAnnotationComposer,
      $$TransactionLinesTableCreateCompanionBuilder,
      $$TransactionLinesTableUpdateCompanionBuilder,
      (TransactionLine, $$TransactionLinesTableReferences),
      TransactionLine,
      PrefetchHooks Function({bool transactionId, bool itemId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionLinesTableTableManager get transactionLines =>
      $$TransactionLinesTableTableManager(_db, _db.transactionLines);
}
