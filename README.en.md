# DNS Changer Flutter

<p align="center">
  <img src="https://raw.githubusercontent.com/isina-nejj/DNS-Changer-Flutter/main/assets/banner.png" alt="DNS Changer Flutter" width="600"/>
</p>

<h1 align="center">DNS Changer Flutter</h1>

<p align="center">
  <b>Professional, open-source DNS override app for Android using a local VPN. Fast, privacy-friendly, and root-free.</b>
</p>

<p align="center">
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/actions"><img src="https://img.shields.io/github/workflow/status/isina-nejj/DNS-Changer-Flutter/Flutter%20CI?style=flat-square" alt="Build Status"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/blob/main/LICENSE"><img src="https://img.shields.io/github/license/isina-nejj/DNS-Changer-Flutter?style=flat-square" alt="License"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/stargazers"><img src="https://img.shields.io/github/stars/isina-nejj/DNS-Changer-Flutter?style=flat-square" alt="Stars"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter/pulls"><img src="https://img.shields.io/github/issues-pr/isina-nejj/DNS-Changer-Flutter?style=flat-square" alt="Pull Requests"></a>
  <a href="https://github.com/isina-nejj/DNS-Changer-Flutter"><img src="https://img.shields.io/badge/platform-Android-blue?style=flat-square" alt="Platform"></a>
</p>

---

A robust Flutter app that launches a local VPN service to override DNS servers on Android devices. Only DNS traffic is routed through the VPN, ensuring all other network traffic remains direct and unrestricted. Includes real-time DNS diagnostics, Google connectivity tests, and a modern, user-friendly interface.


## 🚀 Features

- 🔒 **DNS Override via Local VPN** — Change system DNS to any custom primary and secondary servers, no root required
- ⚡ **Fast & Lightweight** — Minimal VPN routing, only DNS traffic is tunneled
- 📶 **Manual & Auto Ping** — Test DNS latency with color-coded results, auto-ping mode for real-time monitoring
- 📊 **Live Data Usage** — See upload/download stats in real time
- 🌐 **Google Connectivity Test** — One-tap check for ping, DNS, and HTTPS to Google
- 🛠️ **Advanced Diagnostics** — Debug logs, error feedback, and detailed status
- 🖥️ **Modern Flutter UI** — Clean, responsive, and intuitive interface
- 🔄 **Easy Start/Stop** — Toggle VPN with a single switch
- 📝 **Open Source & MIT Licensed**


## 📸 Screenshots

<p align="center">
  <img src="assets/screenshot1.png" alt="Main UI" width="250"/>
  <img src="assets/screenshot2.png" alt="VPN Active" width="250"/>
  <img src="assets/screenshot3.png" alt="Diagnostics" width="250"/>
</p>

> _Tip: Add your own screenshots to the `assets/` folder and update the paths above for a more visual README!_


## 📚 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Usage](#-usage)
- [Advanced Usage](#-advanced-usage)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)
- [Credits](#-credits)

---

## 🛠️ Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.0.0)
- Android device or emulator (API 21+)
- No root required

### Installation

```bash
git clone https://github.com/isina-nejj/DNS-Changer-Flutter.git
cd DNS-Changer-Flutter/dnschenger
flutter pub get
flutter run
```


## 📲 Usage

1. **Launch** the app on your Android device.
2. **Enter DNS**: Set your preferred primary and secondary DNS (default: Shecan `178.22.122.100`, Cloudflare `1.1.1.1`).
3. **Start VPN**: Tap the switch to activate the VPN and override DNS.
4. **Grant Permission**: Approve the VPN permission prompt.
5. **Monitor**: View ping results, data usage, and diagnostics in real time.
6. **Test Google**: Use the "Test Google" button to verify full connectivity (ping, DNS, HTTPS).
7. **Stop VPN**: Tap the switch again to restore your original DNS settings.

---

## ⚙️ Advanced Usage

- **Custom DNS**: Enter any valid IPv4 DNS server addresses.
- **Auto Ping**: Enable auto-ping for continuous DNS health monitoring.
- **Debug Logs**: Use `adb logcat -s DNSChanger` for detailed logs.
- **VPN Exclusion**: Only the app itself is excluded from VPN; all other apps use the overridden DNS.
- **Data Privacy**: No user data is collected or sent externally.

---

## ❓ Troubleshooting & FAQ

**Q: VPN is active but DNS doesn't change?**
A: Ensure you granted VPN permission and no other VPN is running. Some Android ROMs may restrict VPN apps.

**Q: Google services not working?**
A: The app is designed to keep all apps (including Google) online. If issues persist, try a different DNS or restart the device.

**Q: App crashes or doesn't start?**
A: Check your Flutter version, run `flutter clean`, and ensure all permissions are granted.

**Q: How to see debug logs?**
A: Connect your device and run:
```bash
adb logcat -s DNSChanger
```

**Q: Can I use this on iOS?**
A: No, this app is Android-only due to platform VPN limitations.

---


## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome! Please open an [issue](https://github.com/isina-nejj/DNS-Changer-Flutter/issues) or submit a [pull request](https://github.com/isina-nejj/DNS-Changer-Flutter/pulls).

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a pull request

---

## 📄 License

This project is open source under the MIT License. See [LICENSE](LICENSE) for details.

---

## 🙏 Credits

- Inspired by [NetShift](https://github.com/evait-security/netshift) and other open-source DNS/VPN projects
- Built with [Flutter](https://flutter.dev/) and [Kotlin](https://kotlinlang.org/)
- Thanks to all contributors and users!

<p align="center">
  <em>Made with ❤️ by Sina Nejat and the open-source community.</em>
</p>
