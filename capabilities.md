# Capabilities Configuration

## Analysis
Based on operation guide analysis, the following capabilities are required:

- **iCloud/CloudKit**: Guide mentions "CloudKit私有数据库" for cloud sync, "离线优先+Core Data同步模式"
- **Push Notifications**: Guide mentions "付款提醒/跟进", "UserNotifications + APNs"
- **In-App Purchase**: Guide mentions "StoreKit 2 + RevenueCat", subscription model with monthly/yearly/lifetime
- **Camera/Photo Library**: Guide mentions "照片文档", "相机集成", "JobPhoto model"
- **Location Services**: Guide mentions "MapKit", "客户地址导航", "JobLocation model"

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| In-App Purchase | ✅ Configured | Xcode Signing & Capabilities |
| Push Notifications | ✅ Configured | Xcode Signing & Capabilities |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| iCloud (CloudKit) | ⏳ Pending | 1. Open Xcode → Signing & Capabilities → + Capability → iCloud 2. Check CloudKit checkbox 3. Create container: iCloud.com.zzoutuo.JobRig 4. Create record types: CD_Client, CD_Job, CD_LineItem in CloudKit Dashboard |
| Camera/Photo Library | ⏳ Pending | 1. Add NSCameraUsageDescription to Info.plist: "JobRig needs camera access to take job site photos" 2. Add NSPhotoLibraryUsageDescription: "JobRig needs photo library access to attach photos to jobs" |
| Location Services | ⏳ Pending | 1. Add NSLocationWhenInUseUsageDescription to Info.plist: "JobRig uses your location to navigate to client addresses" |

## No Configuration Needed

- HealthKit: Not applicable for business app
- Apple Watch: Not in current scope
- Siri: Not in current scope
- Background Modes: Not needed (local notifications handle reminders)
- Sign in with Apple: Not needed (no account system required)
- HomeKit: Not applicable
- Audio: Not applicable

## Verification
- Build succeeded after configuration: ⏳ Pending (will verify after code generation)
- All entitlements correct: ⏳ Pending
