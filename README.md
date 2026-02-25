# Contact number analysis

Repository for SQL scripts and related utilities.

## Google Apps Script helper
Use `apps_script.gs` in a Google Sheet when you need to normalize contact numbers before importing them to MySQL:
1. In Google Sheets, open **Extensions → Apps Script** and paste the contents of `apps_script.gs`.
2. Ensure contact numbers are in column A; if the first row is a header (e.g., “Contact Number”) it will be preserved, otherwise the first row is treated as data.
3. Refresh the browser tab so the custom menu appears, then run **Contact Tools → Normalize numbers (col A)** to add a “Normalized Contact Number” column.
