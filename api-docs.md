
# 📡 DNS Manager API Documentation

مستندات کامل برای استفاده از API در کلاینت‌های موبایل یا فرانت‌اند (Android / iOS / Web).

---

## 🔹 Base URL

برای محیط Production:
```
https://dns-changer-0.vercel.app
```

---

## 📦 DnsRecord Data Structure

```json
{
  "id": "abc123",
  "label": "DNS - Shekan",
  "ip1": "178.22.122.100",
  "ip2": "185.51.200.2",
  "type": "SHEKAN",
  "createdAt": "2024-06-01T08:15:30.000Z"
}
```

---

## 🔸 Enum Values (type)

```text
GENERAL | RADAR | SHEKAN | IRANCELL | HAMRAHAVAL | GAMING | TELECOM | OTHER | IPV6 | GOOGLE
```

---

## 📋 Endpoints Summary

### ✅ GET `/api/dns`

- دریافت همه رکوردهای DNS
- **Query params:**
  - `type`: (اختیاری) فیلتر بر اساس نوع DNS

**نمونه:**
```
GET /api/dns?type=SHEKAN
```

### ✅ POST `/api/dns`

- ایجاد رکورد جدید

**Body:**
```json
{
  "label": "DNS - Example",
  "ip1": "1.1.1.1",
  "ip2": "1.0.0.1",
  "type": "GENERAL"
}
```

### ✅ PATCH `/api/dns/:id`

- ویرایش رکورد مشخص

**Body:**
```json
{
  "label": "DNS - Updated",
  "ip1": "1.1.1.1",
  "ip2": "1.0.0.1",
  "type": "RADAR"
}
```

### ✅ DELETE `/api/dns/:id`

- حذف رکورد DNS

---

## 📥 Response Format

تمام پاسخ‌ها دارای ساختار یکسانی هستند:

```json
{
  "status": true,
  "message": "DNS records fetched successfully.",
  "errorCode": null,
  "data": [ /* آرایه‌ای از DnsRecord */ ]
}
```

در صورت خطا:

```json
{
  "status": false,
  "message": "Error occurred.",
  "errorCode": "DB_CONN_FAIL",
  "data": null
}
```

---

## 🛠️ ساخته شده با

- Next.js 15
- Prisma ORM
- MongoDB Atlas
- TailwindCSS
- Shadcn/ui

---

## ✉️ تماس با توسعه‌دهنده

در صورت نیاز به پشتیبانی بیشتر، با توسعه‌دهنده این پروژه تماس بگیرید.
