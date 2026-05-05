# Git Repositories

## Main App (iOS Application + Policy Pages)

| Item | Value |
|------|-------|
| **Repository Name** | JobRig |
| **Git URL** | git@github.com:asunnyboy861/JobRig.git |
| **Repo URL** | https://github.com/asunnyboy861/JobRig |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/JobRig/ | ✅ Active |
| Support | https://asunnyboy861.github.io/JobRig/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/JobRig/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/JobRig/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

### Main App Repository
```
JobRig/
├── JobRig/                           # iOS App Source Code
│   ├── JobRig.xcodeproj/             # Xcode Project
│   ├── JobRig/                       # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Jobs/
│   │   │   ├── Clients/
│   │   │   ├── QuickCreate/
│   │   │   ├── More/
│   │   │   └── Onboarding/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── JobRigApp.swift
│   │   └── ContentView.swift
│   └── ...
├── docs/                             # Policy Pages (GitHub Pages)
│   ├── support.html                  # Support Page
│   ├── privacy.html                  # Privacy Policy
│   └── terms.html                    # Terms of Use
├── us.md                             # English Development Guide
├── keytext.md                        # App Store Metadata
├── capabilities.md                   # Capabilities Configuration
├── icon.md                           # App Icon Details
├── price.md                          # Pricing Configuration
└── nowgit.md                         # This File
```

## Bundle ID
`com.zzoutuo.JobRig`

## Deployment Target
iOS 17.0

## Monetization Model
Subscription (IAP) - Monthly $9.99, Yearly $69.99, Lifetime $149.99
