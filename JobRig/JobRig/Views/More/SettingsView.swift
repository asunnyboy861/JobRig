import SwiftUI

struct SettingsView: View {
    @AppStorage("useCloudKit") private var useCloudKit = false
    @State private var subscriptionManager = SubscriptionManager()

    var body: some View {
        List {
            Section("Sync") {
                Toggle("iCloud Sync", isOn: $useCloudKit)
                Text("Sync data across all your devices via iCloud")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section("Subscription") {
                HStack {
                    Text("Status")
                    Spacer()
                    Text(subscriptionManager.isSubscribed ? "Pro" : "Free")
                        .foregroundColor(subscriptionManager.isSubscribed ? .green : .secondary)
                }
                NavigationLink {
                    PaywallView()
                } label: {
                    Text(subscriptionManager.isSubscribed ? "Manage Subscription" : "Upgrade to Pro")
                }
                Button("Restore Purchases") {
                    Task {
                        await subscriptionManager.restorePurchases()
                    }
                }
            }

            Section("Legal") {
                Link("Support", destination: URL(string: "https://asunnyboy861.github.io/JobRig/support.html")!)
                Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/JobRig/privacy.html")!)
                Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/JobRig/terms.html")!)
            }

            Section {
                NavigationLink {
                    ContactSupportView()
                } label: {
                    Label("Contact Support", systemImage: "envelope.fill")
                }
            }

            Section {
                HStack {
                    Spacer()
                    Text("JobRig v1.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .navigationTitle("Settings")
        .task {
            await subscriptionManager.checkSubscriptionStatus()
        }
    }
}
