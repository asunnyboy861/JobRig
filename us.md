# JobRig - iOS Development Guide

## Executive Summary

**JobRig** is a mobile-first, offline-first contractor job tracker designed for solo and small-team contractors (plumbers, electricians, HVAC technicians, handymen, landscapers, painters, roofers). The core value proposition: create a professional quote in 30 seconds, convert it to an invoice with one tap, and get paid faster — all from the job site, even without cell signal.

**Target Audience**: 1-2 person contractor teams earning $50K-$500K/year who are overpaying for bloated field service software ($49-300+/month) and need a simple, fast, affordable tool.

**Key Differentiators**:
- 30-second quote creation from the job site
- One-tap quote-to-invoice conversion
- Fully offline-first architecture (works in basements, crawl spaces, rural areas)
- $9.99/month vs competitors' $49-300+/month
- $149.99 lifetime purchase option (no competitor offers this)
- AI-assisted quote suggestions (GPT-4o-mini)
- Setup in under 5 minutes vs competitors' hours/days

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| **Jobber** ($49+/mo) | Mature platform, 250K+ users, QuickBooks integration, GPS routing, AI voice/chat | Expensive for solo contractors, complex setup, limited offline, QuickBooks sync issues, feature bloat | 80% cheaper, simpler, offline-first, faster quote creation, lifetime option |
| **Housecall Pro** ($79+/mo) | Strong invoicing, online payments, good dispatch, customer communication | Very expensive for 1-2 person teams, desktop-first design, days to set up, no offline | 87% cheaper, mobile-first, instant setup, works offline, one-tap conversion |
| **Joist** (Free-$15/mo) | Free tier, simple estimates, good for basic quoting | 5 documents/month limit on free tier, limited features, no offline, no AI | More generous free tier, offline-first, AI suggestions, full invoice workflow |
| **C-Money** ($19.99/mo) | Affordable, simple, mobile-first | Limited features, no cloud sync, no AI, basic UI | Comparable price with more features (AI, sync, reminders, photos) |
| **ServiceTitan** ($400+/mo) | Enterprise-grade, full ERP, powerful reporting | Way too expensive/complex for solo contractors, weeks to set up | Targets the market ServiceTitan ignores: solo/small contractors |

## Apple Design Guidelines Compliance

- **HIG - Navigation**: Tab bar with 4 tabs (Jobs, Clients, Quick Create, More) following standard iOS navigation patterns
- **HIG - Data Entry**: Large touch targets (44pt minimum), auto-focus keyboard, smart defaults for fast data entry
- **HIG - Feedback**: Haptic feedback on key actions, visual status indicators with color coding, toast notifications
- **HIG - Dark Mode**: Full dark mode support using system colors and semantic color assets
- **HIG - Accessibility**: Dynamic Type support, VoiceOver labels on all interactive elements, high contrast colors
- **HIG - Modality**: Quick quote uses sheet presentation for focused data entry; PDF preview uses full-screen presentation
- **HIG - Gestures**: Swipe-to-action on job cards (quote to invoice, delete), pull-to-refresh for sync status
- **App Store Review 3.1.2**: Subscription clearly presented with auto-renewal terms, cancellation instructions, and restore purchases button
- **App Store Review 5.1.1**: Privacy policy linked in Settings, minimal data collection (CloudKit private database only)

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (PDF generation via UIGraphicsPDFRenderer)
- **Data**: SwiftData with @Model classes for local persistence
- **Cloud Sync**: CloudKit private database (optional, user-controlled)
- **PDF**: PDFKit + UIGraphicsPDFRenderer for quote/invoice generation
- **Payments**: StoreKit 2 for in-app subscriptions
- **AI**: OpenAI API (GPT-4o-mini) for quote suggestions
- **Analytics**: TelemetryDeck (privacy-friendly)
- **Crash**: Firebase Crashlytics
- **Maps**: MapKit for client address navigation
- **Notifications**: UserNotifications for payment reminders and follow-ups
- **Minimum iOS**: 17.0 (SwiftData requirement)

## Module Structure

```
JobRig/
├── JobRigApp.swift
├── Models/
│   ├── Client.swift
│   ├── Job.swift
│   ├── LineItem.swift
│   ├── JobPhoto.swift
│   ├── Reminder.swift
│   ├── JobLocation.swift
│   └── Enums.swift
├── Views/
│   ├── MainTabView.swift
│   ├── Jobs/
│   │   ├── JobsListView.swift
│   │   ├── JobDetailView.swift
│   │   └── JobCardView.swift
│   ├── Clients/
│   │   ├── ClientsListView.swift
│   │   └── ClientDetailView.swift
│   ├── QuickCreate/
│   │   ├── QuickQuoteView.swift
│   │   └── LineItemRow.swift
│   ├── More/
│   │   ├── MoreView.swift
│   │   ├── DashboardView.swift
│   │   ├── RemindersView.swift
│   │   ├── PhotosView.swift
│   │   ├── ExportView.swift
│   │   ├── BusinessSettingsView.swift
│   │   ├── PaywallView.swift
│   │   └── SettingsView.swift
│   └── Onboarding/
│       └── OnboardingView.swift
├── ViewModels/
│   ├── JobsViewModel.swift
│   ├── ClientsViewModel.swift
│   ├── QuickQuoteViewModel.swift
│   └── DashboardViewModel.swift
├── Services/
│   ├── PDFInvoiceGenerator.swift
│   ├── PDFShareHelper.swift
│   ├── SubscriptionManager.swift
│   ├── SyncManager.swift
│   ├── ReminderManager.swift
│   └── AIService.swift
├── Repositories/
│   ├── ClientRepository.swift
│   ├── JobRepository.swift
│   └── ReminderRepository.swift
└── Utils/
    ├── Constants.swift
    ├── Extensions.swift
    └── HapticManager.swift
```

## Implementation Flow

1. Configure SwiftData container with all @Model classes
2. Build MainTabView with 4-tab navigation (Jobs, Clients, Quick Create, More)
3. Implement Client model and CRUD views with search
4. Implement Job model with status workflow (Draft → Quote Sent → Approved → Invoice Sent → Paid)
5. Build QuickQuoteView with auto-focus, line items, and tax calculation
6. Implement PDFInvoiceGenerator using UIGraphicsPDFRenderer
7. Implement one-tap quote-to-invoice conversion
8. Add PDF sharing via UIActivityViewController (email, SMS, AirDrop)
9. Implement SubscriptionManager with StoreKit 2
10. Build PaywallView with free/pro tier comparison
11. Add CloudKit sync with offline-first architecture
12. Implement ReminderManager with local notifications
13. Add AI quote suggestions via OpenAI API
14. Build DashboardView with revenue and job stats
15. Add photo documentation with camera integration
16. Implement data export (CSV/PDF)
17. Build OnboardingView for first-launch setup
18. Add Business Settings (company name, logo, tax rate, bank info)
19. Integrate Contact Support with feedback backend
20. Add SettingsView with policy links and subscription management

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: #007AFF (system blue — professional, trust)
  - Success: #34C759 (green — paid/completed)
  - Warning: #FF9500 (orange — pending/reminders)
  - Danger: #FF3B30 (red — overdue/urgent)
  - Inactive: #8E8E93 (gray — draft/cancelled)
  - Background: System background (auto dark mode)
  - Card: Secondary system grouped background

- **Typography**:
  - Large Title: 34pt bold (tab headers)
  - Title 2: 22pt bold (section headers)
  - Headline: 17pt semibold (card titles)
  - Body: 17pt regular (content)
  - Caption: 12pt regular (metadata)
  - All using SF Pro system font

- **Layout**:
  - 16pt horizontal padding
  - 12pt vertical spacing between cards
  - 12pt corner radius on cards
  - 44pt minimum touch target
  - iPad: max content width 720pt, centered
  - Tab bar with .ultraThinMaterial background

- **Animations**:
  - Card status color transition: 0.3s ease
  - Payment success: green pulse + confetti
  - Button press: scale 0.97 + haptic light
  - Swipe action: spring animation
  - Tab switch: crossfade 0.2s

- **Status Color Mapping**:
  - Draft → Gray
  - Quote Sent → Orange
  - Approved → Blue
  - In Progress → Blue
  - Invoice Sent → Orange
  - Paid → Green
  - Overdue → Red
  - Cancelled → Gray

## Code Generation Rules

- Architecture: MVVM + Repository Pattern
- Naming: PascalCase for types, camelCase for methods/properties
- Error handling: Swift Concurrency try/await with custom AppError enum
- Concurrency: @MainActor on ViewModels, SwiftData @Model auto-Sendable
- UI updates: @Observable + @Bindable (no Combine)
- Offline-first: All writes to local SwiftData first, async CloudKit sync
- No external dependencies except StoreKit 2 (Apple native)
- Minimum iOS 17.0 (SwiftData requirement)
- No code comments (self-documenting code)
- All SwiftData attributes must be optional or have default values
- All relationships must have inverse relationships
- iPad layout: .frame(maxWidth: 720).frame(maxWidth: .infinity) for scrollable content
- Never use .tabViewStyle(.sidebarAdaptable)

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.JobRig
2. Verify Deployment Target: iOS 17.0
3. Configure App Icon (1024x1024 in Asset Catalog)
4. Enable capabilities: CloudKit, Push Notifications, In-App Purchase
5. Create StoreKit Configuration file for testing
6. Build and test on iPhone XS Max simulator
7. Build and test on iPad Pro 13-inch (M4) simulator
8. Verify offline functionality (airplane mode test)
9. Verify dark mode on all screens
10. Push to GitHub repository
11. Deploy policy pages to GitHub Pages
12. Generate App Store screenshots
13. Submit to App Store Connect
