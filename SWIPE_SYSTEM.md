# 🚀 سیستم کشیدن چهار جهته در DNS Changer

## 📱 نحوه عملکرد

از صفحه اصلی (Home Screen) می‌توانید با کشیدن به هر جهت به صفحات مختلف دسترسی پیدا کنید:

### 🔽 **کشیدن به پایین** → صفحه تنظیمات قرمز
- **طراحی**: پس‌زمینه گرادیانت قرمز
- **محتوا**:
  - Auto start on boot (کلید تغییر وضعیت)
  - Dark theme (کلید تغییر وضعیت)
  - About My DNS (دکمه)
  - Support this app (دکمه با آیکون قلب)
  - My DNS (دکمه)
- **برگشت**: کشیدن به بالا

### ⬅️ **کشیدن به چپ** → صفحه Personal
- **طراحی**: پس‌زمینه خاکستری روشن با کارت‌های سفید
- **محتوا**:
  - Header "Personal" با آیکون apps
  - UI specs (نمایش Corners 2dp, Border 4dp)
  - Change Server (دکمه تعویض سرور)
  - اطلاعات DNS زنده (DNS1, DNS2, IPv4)
  - Notifications (کلید تغییر وضعیت)
- **برگشت**: کشیدن به راست

### ➡️ **کشیدن به راست** → صفحه Config
- **طراحی**: پس‌زمینه خاکستری روشن
- **محتوا**:
  - آیکون شبکه سبز و عنوان "config"
  - انتخاب Provider (Google, Cloudflare, etc.)
  - دکمه Connect
  - لیست Servers (benchmark):
    - Google (8.8.8.8)
    - Cloudflare (1.1.1.1)
    - Quad9 (9.9.9.9)
    - OpenDNS Home (208.67.222.222)
    - Verisign (64.6.64.6)
- **برگشت**: کشیدن به چپ

## 🔧 پیاده‌سازی فنی

### ساختار فایل‌ها:
```
lib/widgets/
├── red_settings_page.dart     # صفحه تنظیمات قرمز (پایین)
├── personal_page.dart         # صفحه Personal (چپ)
├── config_page.dart          # صفحه Config (راست)
└── settings_drawer.dart      # کشوی اصلی (قدیمی)
```

### سیستم تشخیص کشیدن:
```dart
GestureDetector(
  onPanEnd: (details) {
    const double threshold = 100.0;
    
    // تشخیص جهت کشیدن بر اساس velocity
    if (details.velocity.pixelsPerSecond.dy > threshold) {
      // کشیدن به پایین → Red Settings
    }
    else if (details.velocity.pixelsPerSecond.dx < -threshold) {
      // کشیدن به چپ → Personal
    }
    else if (details.velocity.pixelsPerSecond.dx > threshold) {
      // کشیدن به راست → Config
    }
  },
  child: // محتوای صفحه اصلی
)
```

### سیستم برگشت در هر صفحه:
```dart
// در صفحه تنظیمات قرمز
onPanUpdate: (details) {
  if (details.delta.dy < -5) { // کشیدن به بالا
    Navigator.pop(context);
  }
}

// در صفحه Personal  
onPanUpdate: (details) {
  if (details.delta.dx > 5) { // کشیدن به راست
    Navigator.pop(context);
  }
}

// در صفحه Config
onPanUpdate: (details) {
  if (details.delta.dx < -5) { // کشیدن به چپ
    Navigator.pop(context);
  }
}
```

## 🎯 ویژگی‌های کلیدی

### ✅ **تجربه کاربری روان**
- تشخیص دقیق جهت کشیدن
- انیمیشن‌های روان Navigator
- برگشت آسان با کشیدن معکوس

### ✅ **حفظ State**
- تمام تنظیمات در طول انتقال حفظ می‌شوند
- Callback های مشترک برای به‌روزرسانی state
- سنکرون بودن داده‌ها بین صفحات

### ✅ **طراحی مطابق Mock-up**
- دقیقاً مطابق تصاویر ارائه شده
- رنگ‌بندی و Typography صحیح
- Layout و spacing دقیق

## 🚦 نحوه استفاده

1. **شروع**: از صفحه اصلی Home شروع کنید
2. **انتخاب جهت**: 
   - پایین = تنظیمات قرمز
   - چپ = Personal
   - راست = Config
3. **برگشت**: با کشیدن خلاف جهت اولیه برگردید
4. **دسترسی آسان**: تمام عملکردهای اصلی در دسترس

## 🔄 مزایای سیستم

### 📱 **دسترسی سریع**
- بدون نیاز به دکمه یا منو
- تشخیص natural gesture ها
- کاهش تعداد tap ها

### 🎨 **تجربه بصری بهتر**
- انتقال روان بین صفحات
- حفظ context کاربر
- UI یکپارچه و منسجم

### ⚡ **کارایی بالا**
- navigation سریع
- عدم تداخل با عملکردهای اصلی
- مدیریت memory صحیح

## 🛠️ Build و اجرا

```bash
# تحلیل کد
flutter analyze

# ساخت APK تست
flutter build apk --debug

# اجرا روی دستگاه
flutter run
```

تمام فایل‌ها آماده هستند و سیستم کشیدن چهار جهته کاملاً کاربردی است! 🎉
