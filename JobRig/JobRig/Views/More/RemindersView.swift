import SwiftUI
import SwiftData

struct RemindersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Reminder> { !$0.isSent }, sort: \Reminder.scheduledDate) private var reminders: [Reminder]
    @State private var showingAddReminder = false

    var body: some View {
        List {
            ForEach(reminders) { reminder in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(reminder.reminderType.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        Spacer()
                        Text(reminder.scheduledDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(reminder.title)
                        .font(.headline)
                    if let job = reminder.job {
                        Text(job.title)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
            .onDelete(perform: deleteReminders)
        }
        .navigationTitle("Reminders")
        .overlay {
            if reminders.isEmpty {
                ContentUnavailableView(
                    "No Reminders",
                    systemImage: "bell.slash",
                    description: Text("Add reminders to follow up on quotes and invoices")
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddReminder = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddReminder) {
            AddReminderView()
        }
    }

    private func deleteReminders(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(reminders[index])
        }
    }
}

struct AddReminderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var jobs: [Job]
    @State private var title = ""
    @State private var type: ReminderType = .followUp
    @State private var date = Date().addingTimeInterval(24 * 3600)
    @State private var selectedJob: Job?
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    Picker("Type", selection: $type) {
                        ForEach(ReminderType.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    DatePicker("Date", selection: $date, in: Date.now..., displayedComponents: [.date, .hourAndMinute])
                }

                Section {
                    Picker("Job (optional)", selection: $selectedJob) {
                        Text("None").tag(nil as Job?)
                        ForEach(jobs) { job in
                            Text(job.title).tag(job as Job?)
                        }
                    }
                }

                Section {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let reminder = Reminder(title: title, reminderType: type, scheduledDate: date, notes: notes.isEmpty ? nil : notes)
                        reminder.job = selectedJob
                        modelContext.insert(reminder)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
