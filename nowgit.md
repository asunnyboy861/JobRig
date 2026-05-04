# JobRig - Contractor Job Tracker

## Overview
JobRig is an iOS app for contractors, freelancers, and small service businesses to create quotes, convert them to invoices, and get paid faster — all from the job site, even offline.

## Tech Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Data Layer**: SwiftData (offline-first)
- **Cloud Sync**: CloudKit
- **Payments**: StoreKit 2 (IAP)
- **PDF Generation**: PDFKit / UIGraphicsPDFRenderer
- **AI**: GPT-4o-mini (quote suggestions)

## Architecture
- MVVM pattern with SwiftData models
- Observable services (SubscriptionManager)
- PDF generation service
- Offline-first with CloudKit sync

## Project Structure
```
JobRig/
├── Models/
│   ├── Client.swift
│   ├── Job.swift
│   ├── LineItem.swift
│   ├── JobPhoto.swift
│   ├── Reminder.swift
│   └── JobLocation.swift
├── Views/
│   ├── MainTabView.swift
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Jobs/
│   │   ├── JobsListView.swift
│   │   ├── JobCardView.swift
│   │   └── JobDetailView.swift
│   ├── Clients/
│   │   ├── ClientsListView.swift
│   │   └── ClientDetailView.swift
│   ├── QuickCreate/
│   │   └── QuickQuoteView.swift
│   └── More/
│       ├── MoreView.swift
│       ├── DashboardView.swift
│       ├── RemindersView.swift
│       ├── PhotosView.swift
│       ├── BusinessSettingsView.swift
│       ├── PaywallView.swift
│       ├── SettingsView.swift
│       └── ContactSupportView.swift
├── Services/
│   ├── PDFInvoiceGenerator.swift
│   └── SubscriptionManager.swift
├── JobRigApp.swift
└── ContentView.swift
```

## Monetization
- **Free**: 3 clients, 5 jobs/month, local storage
- **Monthly**: $9.99/month - Unlimited everything + cloud sync + AI
- **Yearly**: $69.99/year - Save 41%
- **Lifetime**: $149.99 one-time - Pay once, use forever

## Product IDs
| Product | ID |
|---------|-----|
| Monthly | com.zzoutuo.JobRig.monthly |
| Yearly | com.zzoutuo.JobRig.yearly |
| Lifetime | com.zzoutuo.JobRig.lifetime |

## Policy Pages
- Support: https://asunnyboy861.github.io/JobRig/support.html
- Privacy: https://asunnyboy861.github.io/JobRig/privacy.html
- Terms: https://asunnyboy861.github.io/JobRig/terms.html

## Bundle ID
`com.zzoutuo.JobRig`

## Deployment Target
iOS 17.0

## Build & Run
1. Open `JobRig.xcodeproj` in Xcode
2. Select "JobRig" scheme
3. Choose iOS Simulator or device
4. Build & Run (Cmd+R)

## Key Features
- 30-second quote creation
- One-tap quote-to-invoice conversion
- Professional PDF generation with branding
- Offline-first architecture
- CloudKit sync (Pro)
- AI-powered quote suggestions (Pro)
- Payment reminders and follow-ups
- Photo documentation
- Dashboard with revenue tracking
