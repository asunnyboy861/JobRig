import SwiftUI
import SwiftData

struct QuickQuoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Client.name) private var clients: [Client]
    @State private var jobTitle = ""
    @State private var jobDescription = ""
    @State private var selectedClient: Client?
    @State private var clientSearchText = ""
    @State private var showingNewClient = false
    @State private var lineItems: [LineItemDraft] = [LineItemDraft()]
    @State private var taxRate: Decimal = 0.0
    @State private var jobType: JobType = .quote
    @State private var dueDate: Date = Date().addingTimeInterval(30 * 24 * 3600)
    @FocusState private var focusedField: Field?
    @State private var showingShareSheet = false
    @State private var generatedPDFData: Data?

    enum Field: Hashable {
        case jobTitle, clientName, itemDesc, itemQty, itemPrice
    }

    var subtotal: Decimal {
        lineItems.reduce(0) { $0 + $1.quantity * $1.unitPrice }
    }

    var taxAmount: Decimal {
        lineItems.filter(\.taxable).reduce(0) { $0 + $1.quantity * $1.unitPrice } * (taxRate / 100)
    }

    var total: Decimal { subtotal + taxAmount }

    var filteredClients: [Client] {
        if clientSearchText.isEmpty { return clients }
        return clients.filter { $0.name.localizedCaseInsensitiveContains(clientSearchText) }
    }

    var body: some View {
        Form {
            Section("Job Details") {
                TextField("What's the job?", text: $jobTitle)
                    .focused($focusedField, equals: .jobTitle)
                    .font(.headline)
                    .submitLabel(.next)

                TextField("Description (optional)", text: $jobDescription, axis: .vertical)
                    .lineLimit(2...4)

                Picker("Type", selection: $jobType) {
                    ForEach(JobType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }

            Section {
                HStack {
                    if let client = selectedClient {
                        VStack(alignment: .leading) {
                            Text(client.name)
                                .font(.headline)
                            if let company = client.company {
                                Text(company)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        Button("Change") {
                            selectedClient = nil
                        }
                        .font(.caption)
                    } else {
                        Menu {
                            ForEach(filteredClients) { client in
                                Button(client.name) {
                                    selectedClient = client
                                }
                            }
                            Divider()
                            Button("New Client...") {
                                showingNewClient = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.circle")
                                Text("Select Client")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            } header: {
                Text("Client")
            }

            Section("Line Items") {
                ForEach($lineItems) { $item in
                    LineItemRow(item: $item, focusedField: $focusedField)
                }
                .onDelete { indexSet in
                    lineItems.remove(atOffsets: indexSet)
                }

                Button {
                    withAnimation { lineItems.append(LineItemDraft()) }
                } label: {
                    Label("Add Item", systemImage: "plus.circle.fill")
                }
            }

            Section("Tax") {
                HStack {
                    Text("Tax Rate")
                    Spacer()
                    TextField("0", value: $taxRate, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                    Text("%")
                }
            }

            Section("Total") {
                LabeledContent("Subtotal", value: subtotal, format: .currency(code: "USD"))
                if taxRate > 0 {
                    LabeledContent("Tax (\(NSDecimalNumber(decimal: taxRate).stringValue)%)", value: taxAmount, format: .currency(code: "USD"))
                }
                LabeledContent("Total", value: total, format: .currency(code: "USD"))
                    .font(.headline)
            }

            Section {
                Button {
                    saveAndSend()
                } label: {
                    HStack {
                        Spacer()
                        Text(jobType == .quote ? "Create & Share Quote" : "Create & Share Invoice")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(jobTitle.isEmpty)
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("New Job")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { focusedField = .jobTitle }
        .sheet(isPresented: $showingNewClient) {
            AddClientView()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let data = generatedPDFData {
                ShareSheet(activityItems: [data])
            }
        }
    }

    private func saveAndSend() {
        let client = selectedClient ?? Client(name: "No Client")
        if selectedClient == nil {
            modelContext.insert(client)
        }

        let job = Job(title: jobTitle, jobDescription: jobDescription, jobType: jobType, client: client)
        job.totalAmount = total
        job.taxRate = taxRate
        job.dueDate = dueDate
        job.status = jobType == .quote ? .quoteSent : .invoiceSent

        for (index, draft) in lineItems.enumerated() {
            let item = LineItem(
                itemDescription: draft.itemDescription,
                quantity: draft.quantity,
                unitPrice: draft.unitPrice,
                taxable: draft.taxable
            )
            item.sortOrder = index
            item.job = job
            modelContext.insert(item)
        }

        modelContext.insert(job)

        let generator = PDFInvoiceGenerator()
        generatedPDFData = generator.generate(job: job, taxRate: taxRate)
        showingShareSheet = true
    }
}

struct LineItemDraft: Identifiable {
    let id = UUID()
    var itemDescription: String = ""
    var quantity: Decimal = 1
    var unitPrice: Decimal = 0
    var taxable: Bool = true
}

struct LineItemRow: View {
    @Binding var item: LineItemDraft
    var focusedField: FocusState<QuickQuoteView.Field?>.Binding

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextField("Description", text: $item.itemDescription)
                    .focused(focusedField, equals: .itemDesc)
                    .submitLabel(.next)
                Toggle("Tax", isOn: $item.taxable)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            HStack {
                TextField("Qty", value: $item.quantity, format: .number)
                    .focused(focusedField, equals: .itemQty)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)

                TextField("Price", value: $item.unitPrice, format: .currency(code: "USD"))
                    .focused(focusedField, equals: .itemPrice)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)

                Text(item.quantity * item.unitPrice, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 80, alignment: .trailing)
            }
        }
        .padding(.vertical, 4)
    }
}
