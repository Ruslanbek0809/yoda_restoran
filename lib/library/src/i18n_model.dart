enum LocaleType { en, ru, tk }

final _i18nModel = <LocaleType, Map<String, Object>>{
  LocaleType.en: {
    'cancel': 'Cancel',
    'done': 'Done',
    'today': 'Today',
    'monthShort': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ],
    'monthLong': [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
    'day': ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
    'am': 'AM',
    'pm': 'PM'
  },
  LocaleType.ru: {
    'cancel': 'Отмена',
    'done': 'Подтвердить',
    'today': 'Сегодня',
    'monthShort': [
      'Янв',
      'Фев',
      'Март',
      'Апр',
      'Май',
      'Июнь',
      'Июль',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек'
    ],
    'monthLong': [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ],
    'day': ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
    'am': 'AM',
    'pm': 'PM'
  },
  LocaleType.tk: {
    'cancel': 'Ýatyr',
    'done': 'Tassykla',
    'today': 'Şu gün',
    'monthShort': [
      'Ýan',
      'Few',
      'Mart',
      'Apr',
      'Maý',
      'Iýun',
      'Iýul',
      'Awg',
      'Sen',
      'Okt',
      'Noý',
      'Dek'
    ],
    'monthLong': [
      'Ýanwar',
      'Fewral',
      'Mart',
      'Aprel',
      'Maý',
      'Iýun',
      'Iýul',
      'Awgust',
      'Sentýabr',
      'Oktýabr',
      'Noýabr',
      'Dekabr'
    ],
    'day': ['Duş', 'Siş', 'Çar', 'Pen', 'Anna', 'Şen', 'Ýek'],
    'am': 'AM',
    'pm': 'PM'
  },
};

/// Get international object for [localeType]
Map<String, Object> i18nObjInLocale(LocaleType? localeType) =>
    _i18nModel[localeType] ?? _i18nModel[LocaleType.en] as Map<String, Object>;

/// Get international lookup for a [localeType], [key] and [index].
String i18nObjInLocaleLookup(LocaleType localeType, String key, int index) {
  final i18n = i18nObjInLocale(localeType);
  final i18nKey = i18n[key] as List<String>;
  return i18nKey[index];
}
