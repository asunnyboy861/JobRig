import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Client.self, Job.self, LineItem.self, JobPhoto.self, Reminder.self, JobLocation.self], inMemory: true)
}
