import SwiftUI

struct MoreView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    DashboardView()
                } label: {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }

                NavigationLink {
                    RemindersView()
                } label: {
                    Label("Reminders", systemImage: "bell.fill")
                }

                NavigationLink {
                    PhotosView()
                } label: {
                    Label("Photos", systemImage: "photo.fill")
                }
            }

            Section {
                NavigationLink {
                    BusinessSettingsView()
                } label: {
                    Label("Business Settings", systemImage: "building.2.fill")
                }

                NavigationLink {
                    PaywallView()
                } label: {
                    Label("Upgrade to Pro", systemImage: "crown.fill")
                }

                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }

            Section {
                NavigationLink {
                    ContactSupportView()
                } label: {
                    Label("Help & Support", systemImage: "questionmark.circle.fill")
                }
            }
        }
        .navigationTitle("More")
    }
}
