
<p align="center">
  <img src="https://raw.githubusercontent.com/isina-nejj/DNS-Changer-Flutter/main/assets/banner.png" alt="DNS Changer Flutter" width="600"/>
</p>

<h1 align="center">تغییر دهنده DNS  — اندروید</h1>

<p align="center">
  <b>اپلیکیشن حرفه‌ای و متن‌باز برای تغییر DNS سیستم اندروید با استفاده از VPN محلی. سریع، امن، بدون نیاز به روت و با حفظ حریم خصوصی.</b>
</p>

<p align="center">
  <a href="README.en.md">English Version</a> •
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/actions"><img src="https://img.shields.io/github/workflow/status/isina-nejj/DNS-Changer-Flutter/Flutter%20CI?style=flat-square" alt="Build Status"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/blob/main/LICENSE"><img src="https://img.shields.io/github/license/isina-nejj/DNS-Changer-Flutter?style=flat-square" alt="License"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/stargazers"><img src="https://img.shields.io/github/stars/isina-nejj/DNS-Changer-Flutter?style=flat-square" alt="Stars"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/pulls"><img src="https://img.shields.io/github/issues-pr/isina-nejj/DNS-Changer-Flutter?style=flat-square" alt="Pull Requests"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter"><img src="https://img.shields.io/badge/platform-Android-blue?style=flat-square" alt="Platform"></a>
</p>

---

یک اپلیکیشن قدرتمند Flutter که با راه‌اندازی سرویس VPN محلی، امکان تغییر DNS سیستم اندروید را بدون نیاز به روت فراهم می‌کند. فقط ترافیک DNS از طریق VPN عبور داده می‌شود و سایر ترافیک‌ها مستقیم باقی می‌ماند. دارای ابزارهای تشخیص و عیب‌یابی پیشرفته، تست اتصال به گوگل و رابط کاربری مدرن و کاربرپسند.


## 🚀 ویژگی‌ها

- 🔒 **تغییر DNS با VPN محلی** — تغییر DNS سیستم به هر سرور دلخواه، بدون نیاز به روت
- ⚡ **سریع و سبک** — فقط ترافیک DNS از VPN عبور می‌کند
- 📶 **پینگ دستی و خودکار** — تست تاخیر DNS با نمایش رنگی، حالت خودکار برای پایش لحظه‌ای
- 📊 **نمایش مصرف داده زنده** — مشاهده آپلود و دانلود به صورت لحظه‌ای
- 🌐 **تست اتصال به گوگل** — بررسی پینگ، DNS و HTTPS به گوگل با یک کلیک
- 🛠️ **عیب‌یابی پیشرفته** — لاگ‌گیری، نمایش خطا و وضعیت دقیق
- 🖥️ **رابط کاربری مدرن Flutter** — زیبا، واکنش‌گرا و ساده
- 🔄 **شروع/توقف آسان** — فعال/غیرفعال کردن VPN با یک سوییچ
- 📝 **متن‌باز و لایسنس MIT**


## 📸 اسکرین‌شات‌ها

<p align="center">
  <img src="assets/screenshot1.png" alt="رابط اصلی" width="250"/>
  <img src="assets/screenshot2.png" alt="VPN فعال" width="250"/>
  <img src="assets/screenshot3.png" alt="عیب‌یابی" width="250"/>
</p>

> _برای زیبایی بیشتر، اسکرین‌شات‌های خود را در پوشه `assets/` قرار دهید و مسیرها را به‌روزرسانی کنید._


## 📚 فهرست مطالب

- [ویژگی‌ها](#-ویژگیها)
- [اسکرین‌شات‌ها](#-اسکرینشاتها)
- [شروع سریع](#-شروع-سریع)
- [راهنما](#-راهنما)
- [پیشرفته](#-پیشرفته)
- [سوالات متداول](#-سوالات-متداول)
- [مشارکت](#-مشارکت)
- [لایسنس](#-لایسنس)
- [تقدیر](#-تقدیر)

---

## 🛠️ شروع سریع

### پیش‌نیازها

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (نسخه ۳ به بالا)
- دستگاه یا شبیه‌ساز اندروید (API 21+)
- بدون نیاز به روت

### نصب

```bash
git clone https://github.com/isina-nejj/DNS-Changer-Flutter.git
cd DNS-Changer-Flutter/dnschenger
flutter pub get
flutter run
```


## 📲 راهنما

1. **اپ را اجرا کنید** روی دستگاه اندرویدی خود.
2. **DNS دلخواه را وارد کنید** (پیش‌فرض: Shecan `178.22.122.100`، Cloudflare `1.1.1.1`).
3. **VPN را فعال کنید** با سوییچ موجود.
4. **مجوز VPN را تایید کنید**.
5. **پایش کنید**: نتایج پینگ، مصرف داده و عیب‌یابی را به صورت زنده ببینید.
6. **تست گوگل**: با دکمه "تست گوگل" اتصال کامل را بررسی کنید (پینگ، DNS، HTTPS).
7. **VPN را غیرفعال کنید** تا DNS به حالت اولیه بازگردد.

---

## ⚙️ پیشرفته

- **DNS سفارشی**: هر آدرس معتبر IPv4 را وارد کنید.
- **پینگ خودکار**: برای پایش سلامت DNS به صورت مداوم فعال کنید.
- **لاگ‌گیری**: با دستور `adb logcat -s DNSChanger` لاگ‌ها را ببینید.
- **استثنا شدن اپ**: فقط خود اپ از VPN مستثناست؛ سایر اپ‌ها از DNS جدید استفاده می‌کنند.
- **حریم خصوصی**: هیچ داده‌ای جمع‌آوری یا ارسال نمی‌شود.

---

## ❓ سوالات متداول

**س: VPN فعال است اما DNS تغییر نمی‌کند؟**
ج: مطمئن شوید مجوز VPN را داده‌اید و هیچ VPN دیگری فعال نیست. برخی رام‌های اندروید ممکن است محدودیت داشته باشند.

**س: سرویس‌های گوگل کار نمی‌کنند؟**
ج: اپ طوری طراحی شده که همه اپ‌ها (از جمله گوگل) آنلاین بمانند. اگر مشکل داشتید DNS را تغییر دهید یا دستگاه را ریستارت کنید.

**س: اپ کرش می‌کند یا اجرا نمی‌شود؟**
ج: نسخه Flutter را بررسی کنید، `flutter clean` بزنید و مجوزها را بدهید.

**س: چطور لاگ‌ها را ببینم؟**
دستگاه را وصل کنید و دستور زیر را اجرا کنید:
```bash
adb logcat -s DNSChanger
```

**س: آیا روی iOS هم کار می‌کند؟**
خیر، فقط اندروید به دلیل محدودیت‌های VPN در iOS.

---


## 🤝 مشارکت

پیشنهادات، گزارش باگ و درخواست ویژگی جدید خوش‌آمد است! لطفاً [issue](https://github.com/isina-nejj/DNS-Changer-Flutter/issues) باز کنید یا [pull request](https://github.com/isina-nejj/DNS-Changer-Flutter/pulls) ارسال نمایید.

1. ریپو را fork کنید
2. شاخه جدید بسازید (`git checkout -b feature/AmazingFeature`)
3. تغییرات را کامیت کنید (`git commit -m 'افزودن ویژگی جدید'`)
4. به شاخه خود push کنید (`git push origin feature/AmazingFeature`)
5. Pull Request باز کنید

---

## 📄 لایسنس

این پروژه تحت لایسنس MIT متن‌باز است. [LICENSE](LICENSE) را ببینید.

---

## 🙏 تقدیر

- ساخته شده با [Flutter](https://flutter.dev/) و [Kotlin](https://kotlinlang.org/)
- سپاس از همه مشارکت‌کنندگان و کاربران!

<p align="center">
  <em>ساخته شده با ❤️ توسط سینا نژادحسینی و جامعه متن‌باز.</em>
</p>
