String dateTimeToThaiString(DateTime datetime, {bool withDayOfWeek = false, bool withYear = true, bool withTime = false, bool acronymDay = false, bool acronymMonth = false, bool useBE = true}) {
  const thaiDays = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
  const thaiDaysAcronym = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];

  const thaiMonths = [
    'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
  ];
  const thaiMonthsAcronym = [
    'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
    'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
  ];

  int day = datetime.day;

  late String month;

  if (acronymMonth)
    month = thaiMonthsAcronym[datetime.month - 1];
  else
    month = thaiMonths[datetime.month - 1];

  String result = '';

  if (withDayOfWeek) {
    int weekdayIndex = datetime.weekday - 1;

    if (acronymDay)
      result += '${thaiDaysAcronym[weekdayIndex]} ';
    else
      result += 'วัน${thaiDays[weekdayIndex]}ที่ ';
  }

  result += '$day $month ${withYear ? useBE ? datetime.year + 543 : datetime.year : ''}';

  if (withTime)
    result += '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';

  return result;
}