# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: JobRig Pro
- **Group ID**: Auto-generated in App Store Connect

## Free Tier

- Create up to 3 clients
- Create up to 5 quotes/invoices per month
- PDF generation and sharing
- Quote-to-invoice one-tap conversion
- Local data storage
- Offline use

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Pro
- **Product ID**: `com.zzoutuo.JobRig.monthly`
- **Price**: $9.99 per month
- **Display Name**: JobRig Pro Monthly
- **Description**: Unlimited jobs, sync, AI quotes
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Pro
- **Product ID**: `com.zzoutuo.JobRig.yearly`
- **Price**: $69.99 per year (41% savings vs monthly = $5.83/month)
- **Display Name**: JobRig Pro Yearly
- **Description**: Best value, save 41% annually
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.JobRig.lifetime`
- **Price**: $149.99 one-time
- **Display Name**: JobRig Pro Lifetime
- **Description**: Pay once, use forever
- **Localization**: English (US)
- **Note**: One-time purchase, no recurring costs for user. Includes 50 AI suggestions/month.

## Pro Tier Features
- Unlimited clients
- Unlimited quotes/invoices
- CloudKit cloud sync (cross-device)
- AI quote suggestions (GPT-4o-mini, 50/month)
- Payment reminders + smart follow-ups
- Photo documentation (unlimited)
- Data export (CSV/PDF)
- Custom branding/logo on PDFs
- Priority support

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to paid monthly)
- **Applies to**: Monthly and Yearly subscriptions only

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented

## AI Cost Note
- GPT-4o-mini API cost: ~$0.001/call
- 50 calls/month per user = ~$0.05/month
- Far below subscription revenue
- Monthly AI quota resets each billing cycle
