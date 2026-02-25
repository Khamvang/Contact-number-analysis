var NORMALIZED_HEADER = 'Normalized Contact Number';
var HEADER_KEYWORD_PATTERN = /contact/i; // Keywords that signal a header row in column A.

function isLandlinePattern(length, value) {
  // Covers 021/21 prefixes and legacy 6-digit landline-style numbers.
  return (length === 9 && value.indexOf('021') === 0) ||
    (length === 8 && value.indexOf('21') === 0) ||
    length === 6;
}

function isMobilePattern(length, value, firstDigit) {
  return (length === 11 && value.indexOf('020') === 0) ||
    (length === 10 && value.indexOf('20') === 0) ||
    (length === 8 && ['2', '5', '7', '8', '9'].indexOf(firstDigit) !== -1);
}

function is030Pattern(length, value, firstDigit) {
  // Handles 030 numbers and short regional codes that start with 2/4/5/7/9.
  return (length === 10 && value.indexOf('030') === 0) ||
    (length === 9 && value.indexOf('30') === 0) ||
    (length === 7 && ['2', '4', '5', '7', '9'].indexOf(firstDigit) !== -1);
}

function hasHeaderRow(rows) {
  if (!rows.length) return false;
  var firstText = rows[0][0] === null || rows[0][0] === undefined ? '' : String(rows[0][0]).trim();
  var firstIsNumeric = /^\d+$/.test(firstText);
  var secondText = rows.length > 1 && rows[1][0] !== null && rows[1][0] !== undefined ? String(rows[1][0]).trim() : '';
  var secondRowLooksNumeric = rows.length > 1 && /^\d+$/.test(secondText);

  // Treat as header when the first cell is descriptive text (e.g., "Contact Number") and the next row looks numeric.
  return (!firstIsNumeric && secondRowLooksNumeric) || HEADER_KEYWORD_PATTERN.test(firstText);
}

/**
 * Normalize Lao contact numbers in the same way our SQL scripts do.
 * Removes non-digits, applies known prefixes, and returns an 11-digit number where possible.
 * Numbers shorter than 8 digits are returned unchanged for manual follow-up.
 */
function normalizeContactNumber(raw) {
  if (raw === null || raw === undefined) return '';

  var digits = String(raw).replace(/\D+/g, '');
  if (digits === '') return '';

  var len = digits.length;
  var first = digits.charAt(0);

  if (isLandlinePattern(len, digits)) {
    // 9021 prefix marks normalized landline numbers in downstream tables.
    return '9021' + digits.slice(-6);
  }

  // Mobile-style numbers (020/20) become 9020 + last 8 digits.
  if (isMobilePattern(len, digits, first)) {
    return '9020' + digits.slice(-8);
  }

  // 030-series numbers become 9030 + last 7 digits.
  if (is030Pattern(len, digits, first)) {
    return '9030' + digits.slice(-7);
  }

  // If the first digit of the last 8 is 0 or 1, treat as 030-series to cover scraped data missing a full prefix.
  if (len >= 8 && len <= 11) {
    var firstOfLastEight = digits.slice(-8).charAt(0);
    if (firstOfLastEight === '0' || firstOfLastEight === '1') {
      return '9030' + digits.slice(-7);
    }
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
  var hasHeader = hasHeaderRow(values);
  var headerRowIndex = hasHeader ? 0 : -1;
  var normalized = values.map(function (row, index) {
    return [index === headerRowIndex ? NORMALIZED_HEADER : normalizeContactNumber(row[0])];
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
