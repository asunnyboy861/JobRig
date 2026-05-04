import SwiftUI
import SwiftData

@main
struct JobRigApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Client.self, Job.self, LineItem.self, JobPhoto.self, Reminder.self, JobLocation.self])
    }
}
