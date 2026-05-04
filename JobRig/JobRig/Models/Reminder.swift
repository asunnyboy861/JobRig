import SwiftData
import Foundation

enum ReminderType: String, Codable, CaseIterable {
    case followUp = "Follow Up"
    case paymentDue = "Payment Due"
    case scheduleJob = "Schedule Job"
    case custom = "Custom"
}

@Model
final class Reminder {
    @Attribute(.unique) var id: UUID
    var title: String
    var reminderType: ReminderType
    var scheduledDate: Date
    var isSent: Bool
    var notes: String?

    var job: Job?

    init(title: String, reminderType: ReminderType = .followUp, scheduledDate: Date, notes: String? = nil) {
        self.id = UUID()
        self.title = title
        self.reminderType = reminderType
        self.scheduledDate = scheduledDate
        self.isSent = false
        self.notes = notes
    }
}
