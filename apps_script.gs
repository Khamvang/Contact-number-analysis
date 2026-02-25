/**
 * Normalize Lao contact numbers in the same way our SQL scripts do.
 * Removes non-digits, applies known prefixes, and returns a consistent 11-digit number.
 */
function normalizeContactNumber(raw) {
  if (raw === null || raw === undefined) return '';

  var digits = String(raw).replace(/\D+/g, '');
  if (digits === '') return '';

  var len = digits.length;
  var first = digits.charAt(0);

  // Landline-style numbers (021/21) become 9021 + last 6 digits.
  if ((len === 9 && digits.indexOf('021') === 0) || (len === 8 && digits.indexOf('21') === 0) || len === 6) {
    return '9021' + digits.slice(-6);
  }

  // Mobile-style numbers (020/20) become 9020 + last 8 digits.
  if ((len === 11 && digits.indexOf('020') === 0) || (len === 10 && digits.indexOf('20') === 0) || (len === 8 && ['2', '5', '7', '8', '9'].indexOf(first) !== -1)) {
    return '9020' + digits.slice(-8);
  }

  // 030-series numbers become 9030 + last 7 digits.
  if ((len === 10 && digits.indexOf('030') === 0) || (len === 9 && digits.indexOf('30') === 0) || (len === 7 && ['2', '4', '5', '7', '9'].indexOf(first) !== -1)) {
    return '9030' + digits.slice(-7);
  }

  // If the first digit of the last 8 is 0 or 1, treat as 030-series.
  var firstOfLastEight = digits.slice(-8).charAt(0);
  if (firstOfLastEight === '0' || firstOfLastEight === '1') {
    return '9030' + digits.slice(-7);
  }

  // Default: use 9020 prefix for remaining 8+ digit numbers; shorter numbers are left as-is.
  return len >= 8 ? '9020' + digits.slice(-8) : digits;
}

/**
 * Append a "Normalized Contact Number" column based on values in column A.
 */
function updateNormalizedNumbers() {
  var sheet = SpreadsheetApp.getActiveSheet();
  var range = sheet.getDataRange();
  var values = range.getValues();

  if (!values.length) return;

  var targetCol = range.getLastColumn() + 1;
  var normalized = values.map(function (row, index) {
    return [index === 0 ? 'Normalized Contact Number' : normalizeContactNumber(row[0])];
  });

  sheet.getRange(1, targetCol, normalized.length, 1).setValues(normalized);
}

/**
 * Add a simple menu entry to trigger normalization from the Sheet UI.
 */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('Contact Tools')
    .addItem('Normalize numbers (col A)', 'updateNormalizedNumbers')
    .addToUi();
}
