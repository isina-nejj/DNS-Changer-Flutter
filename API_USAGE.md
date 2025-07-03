# DNS Manager API Integration

این پروژه یک نمونه کامل از استفاده از DNS Manager API در Flutter است.

## ویژگی‌های پیاده‌سازی شده

### 1. مدل‌های داده (Models)
- `DnsRecord`: مدل رکورد DNS
- `DnsRecordRequest`: مدل درخواست ایجاد/ویرایش
- `ApiResponse<T>`: مدل پاسخ کلی API
- `DnsType`: انواع DNS (GENERAL, RADAR, SHEKAN, ...)

### 2. سرویس‌های API (Services)
- `ApiClient`: کلاینت HTTP برای ارسال درخواست‌ها
- `DnsApiService`: سرویس اختصاصی DNS با تمام عملیات CRUD

### 3. عملیات API پیاده‌سازی شده

#### GET Operations
```dart
// دریافت همه رکوردها
Future<ApiResponse<List<DnsRecord>>> getAllDnsRecords()

// دریافت بر اساس نوع
Future<ApiResponse<List<DnsRecord>>> getDnsRecordsByType(DnsType type)

// دریافت بر اساس ID
Future<ApiResponse<DnsRecord>> getDnsRecordById(String id)

// فیلتر پیشرفته
Future<ApiResponse<List<DnsRecord>>> filterDnsRecords({
  DnsType? type,
  String? label,
  String? ip,
  DateTime? fromDate,
  DateTime? toDate,
})
```

#### POST Operations
```dart
// ایجاد رکورد جدید
Future<ApiResponse<DnsRecord>> createDnsRecord(DnsRecordRequest request)

// بررسی دسترسی DNS
Future<ApiResponse<bool>> checkDnsAccess(String ip1, String ip2)
```

#### PATCH Operations
```dart
// ویرایش رکورد
Future<ApiResponse<DnsRecord>> updateDnsRecord(String id, DnsRecordRequest request)
```

#### DELETE Operations
```dart
// حذف رکورد
Future<ApiResponse<bool>> deleteDnsRecord(String id)
```

### 4. رابط کاربری (UI Screens)

#### DnsRecordListScreen
- لیست ساده رکوردهای DNS
- جستجو و فیلتر بر اساس نوع
- امکان ایجاد، ویرایش و حذف

#### DnsManagerScreen
- رابط پیشرفته با تب‌های مختلف
- نمایش آمار
- جستجو پیشرفته
- تست دسترسی DNS

#### DnsApiDemoScreen
- نمایش نحوه استفاده از تمام APIها
- مثال‌های عملی برای هر عملیات
- خروجی کامل درخواست‌ها

#### DnsRecordFormScreen
- فرم ایجاد/ویرایش رکورد
- اعتبارسنجی IP
- انتخاب نوع DNS

### 5. ویجت‌های مشترک (Shared Widgets)

#### DnsRecordCard
- کارت نمایش رکورد DNS
- دکمه‌های ویرایش و حذف
- نمایش رنگ‌بندی بر اساس نوع

#### DnsTypeFilter
- فیلتر افقی انواع DNS
- رنگ‌بندی مخصوص هر نوع

### 6. ابزارهای کمکی (Utilities)

#### DnsValidator
- اعتبارسنجی IP address
- بررسی IP خصوصی
- تشخیص IP محلی

## نحوه استفاده

### 1. ایجاد سرویس
```dart
final DnsApiService dnsApiService = DnsApiService();
```

### 2. دریافت رکوردها
```dart
final response = await dnsApiService.getAllDnsRecords();
if (response.status) {
  final records = response.data!;
  // استفاده از records
}
```

### 3. ایجاد رکورد جدید
```dart
final request = DnsRecordRequest(
  label: 'Google DNS',
  ip1: '8.8.8.8',
  ip2: '8.8.4.4',
  type: DnsType.google,
);

final response = await dnsApiService.createDnsRecord(request);
if (response.status) {
  final newRecord = response.data!;
  // رکورد ایجاد شد
}
```

### 4. فیلتر بر اساس نوع
```dart
final response = await dnsApiService.getDnsRecordsByType(DnsType.shekan);
if (response.status) {
  final shekanRecords = response.data!;
  // استفاده از رکوردهای شکن
}
```

## API Endpoints

Base URL: `https://dns-changer-0.vercel.app`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/dns` | دریافت همه رکوردها |
| GET | `/api/dns?type=SHEKAN` | فیلتر بر اساس نوع |
| POST | `/api/dns` | ایجاد رکورد جدید |
| PATCH | `/api/dns/:id` | ویرایش رکورد |
| DELETE | `/api/dns/:id` | حذف رکورد |

## ساختار پاسخ API

### موفقیت آمیز
```json
{
  "status": true,
  "message": "DNS records fetched successfully.",
  "errorCode": null,
  "data": [...]
}
```

### خطا
```json
{
  "status": false,
  "message": "Error occurred.",
  "errorCode": "DB_CONN_FAIL",
  "data": null
}
```

## انواع DNS پشتیبانی شده

- `GENERAL`: عمومی
- `RADAR`: رادار گیمز
- `SHEKAN`: شکن
- `IRANCELL`: ایرانسل
- `HAMRAHAVAL`: همراه اول
- `GAMING`: گیمینگ
- `TELECOM`: مخابرات
- `OTHER`: سایر
- `IPV6`: IPv6
- `GOOGLE`: گوگل

## مدیریت خطا

تمام APIها خطاهای مختلف را مدیریت می‌کنند:
- خطای شبکه
- خطای JSON Parse
- خطای Timeout
- خطاهای HTTP مختلف

## نصب و راه‌اندازی

1. وابستگی‌ها را نصب کنید:
```bash
flutter pub get
```

2. برنامه را اجرا کنید:
```bash
flutter run
```

3. از منوی بالا سمت راست، گزینه‌های مختلف DNS Manager را انتخاب کنید.

## مثال کامل استفاده

برای مشاهده مثال‌های کامل، صفحه "نمونه API" را در برنامه ببینید که تمام عملیات را با خروجی کامل نشان می‌دهد.
