import SwiftUI
import StoreKit

struct PaywallView: View {
    @State private var subscriptionManager = SubscriptionManager()
    @State private var selectedTier: SubscriptionTier = .yearly
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.yellow)
                    .padding(.top, 20)

                Text("Upgrade to JobRig Pro")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Unlock unlimited clients, jobs, cloud sync, AI quotes, and more")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    FeatureRow(icon: "person.2.fill", text: "Unlimited Clients")
                    FeatureRow(icon: "doc.fill", text: "Unlimited Quotes & Invoices")
                    FeatureRow(icon: "icloud.fill", text: "Cloud Sync Across Devices")
                    FeatureRow(icon: "brain", text: "AI Quote Suggestions")
                    FeatureRow(icon: "bell.fill", text: "Payment Reminders")
                    FeatureRow(icon: "photo.fill", text: "Unlimited Photo Docs")
                    FeatureRow(icon: "square.and.arrow.up.fill", text: "Data Export (CSV/PDF)")
                    FeatureRow(icon: "paintbrush.fill", text: "Custom Branding on PDFs")
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    SubscriptionOptionCard(
                        tier: .monthly,
                        price: subscriptionManager.monthlyPrice,
                        isSelected: selectedTier == .monthly,
                        action: { selectedTier = .monthly }
                    )

                    SubscriptionOptionCard(
                        tier: .yearly,
                        price: subscriptionManager.yearlyPrice,
                        isSelected: selectedTier == .yearly,
                        badge: "BEST VALUE",
                        action: { selectedTier = .yearly }
                    )

                    SubscriptionOptionCard(
                        tier: .lifetime,
                        price: "$149.99",
                        isSelected: selectedTier == .lifetime,
                        badge: "PAY ONCE",
                        action: { selectedTier = .lifetime }
                    )
                }
                .padding(.horizontal)

                Button {
                    Task {
                        await subscriptionManager.purchase(tier: selectedTier)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Subscribe")
                            .fontWeight(.semibold)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                Button("Restore Purchases") {
                    Task {
                        await subscriptionManager.restorePurchases()
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Text("Subscription auto-renews. Cancel anytime in Settings > Subscriptions.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .navigationTitle("Pro")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
        }
        .task {
            await subscriptionManager.loadProducts()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
}

struct SubscriptionOptionCard: View {
    let tier: SubscriptionTier
    let price: String?
    let isSelected: Bool
    var badge: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tier.displayName)
                            .font(.headline)
                        if let badge = badge {
                            Text(badge)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    Text(tier.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(price ?? "Loading...")
                    .font(.headline)
                    .fontWeight(.semibold)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

enum SubscriptionTier: String, CaseIterable {
    case monthly = "com.zzoutuo.JobRig.monthly"
    case yearly = "com.zzoutuo.JobRig.yearly"
    case lifetime = "com.zzoutuo.JobRig.lifetime"

    var displayName: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .lifetime: return "Lifetime"
        }
    }

    var subtitle: String {
        switch self {
        case .monthly: return "$9.99/month"
        case .yearly: return "$69.99/year — Save 41%"
        case .lifetime: return "One-time purchase"
        }
    }
}
