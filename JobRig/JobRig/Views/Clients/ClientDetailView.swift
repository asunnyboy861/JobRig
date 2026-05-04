import SwiftUI
import SwiftData

struct ClientDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var client: Client
    @State private var showingEditSheet = false

    var body: some View {
        List {
            Section("Contact") {
                if let email = client.email {
                    LabeledContent("Email", value: email)
                }
                if let phone = client.phone {
                    LabeledContent("Phone", value: phone)
                }
                if let company = client.company {
                    LabeledContent("Company", value: company)
                }
                if let address = client.address {
                    LabeledContent("Address", value: address)
                }
            }

            if let notes = client.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section("Jobs (\(client.jobs.count))") {
                ForEach(client.jobs.sorted { $0.updatedAt > $1.updatedAt }) { job in
                    NavigationLink(value: job) {
                        JobCardView(job: job)
                    }
                }
            }

            Section {
                Button("Edit Client") {
                    showingEditSheet = true
                }
                Button(role: .destructive) {
                    modelContext.delete(client)
                } label: {
                    Label("Delete Client", systemImage: "trash")
                }
            }
        }
        .navigationTitle(client.name)
        .sheet(isPresented: $showingEditSheet) {
            EditClientView(client: client)
        }
    }
}

struct EditClientView: View {
    @Bindable var client: Client
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Info") {
                    TextField("Name", text: $client.name)
                    TextField("Company", text: Binding(
                        get: { client.company ?? "" },
                        set: { client.company = $0.isEmpty ? nil : $0 }
                    ))
                    TextField("Email", text: Binding(
                        get: { client.email ?? "" },
                        set: { client.email = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.emailAddress)
                    TextField("Phone", text: Binding(
                        get: { client.phone ?? "" },
                        set: { client.phone = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.phonePad)
                }
                Section("Details") {
                    TextField("Address", text: Binding(
                        get: { client.address ?? "" },
                        set: { client.address = $0.isEmpty ? nil : $0 }
                    ))
                    TextField("Notes", text: Binding(
                        get: { client.notes ?? "" },
                        set: { client.notes = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        client.updatedAt = Date()
                        dismiss()
                    }
                }
            }
        }
    }
}
