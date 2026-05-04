import SwiftUI
import SwiftData

struct ClientsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Client.name) private var clients: [Client]
    @State private var searchText = ""
    @State private var showingAddClient = false

    var filteredClients: [Client] {
        if searchText.isEmpty { return clients }
        return clients.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            ($0.company ?? "").localizedCaseInsensitiveContains(searchText) ||
            ($0.email ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if clients.isEmpty {
                ContentUnavailableView(
                    "No Clients Yet",
                    systemImage: "person.2",
                    description: Text("Add your first client to get started")
                )
            } else {
                List {
                    ForEach(filteredClients) { client in
                        NavigationLink(value: client) {
                            ClientRowView(client: client)
                        }
                    }
                    .onDelete(perform: deleteClients)
                }
                .searchable(text: $searchText, prompt: "Search clients")
            }
        }
        .navigationTitle("Clients")
        .navigationDestination(for: Client.self) { client in
            ClientDetailView(client: client)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddClient = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddClient) {
            AddClientView()
        }
    }

    private func deleteClients(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredClients[index])
        }
    }
}

struct ClientRowView: View {
    let client: Client

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(client.name)
                    .font(.headline)
                if let company = client.company {
                    Text(company)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            HStack(spacing: 12) {
                if let phone = client.phone {
                    Label(phone, systemImage: "phone.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let email = client.email {
                    Label(email, systemImage: "envelope.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            Text("\(client.jobs.count) jobs")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct AddClientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var company = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Info") {
                    TextField("Name *", text: $name)
                    TextField("Company", text: $company)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
                Section("Details") {
                    TextField("Address", text: $address)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let client = Client(name: name, company: company.isEmpty ? nil : company, email: email.isEmpty ? nil : email, phone: phone.isEmpty ? nil : phone, address: address.isEmpty ? nil : address, notes: notes.isEmpty ? nil : notes)
                        modelContext.insert(client)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
