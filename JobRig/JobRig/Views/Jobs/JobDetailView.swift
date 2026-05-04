import SwiftUI
import SwiftData

struct JobDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var job: Job
    @State private var showingConvertConfirmation = false
    @State private var showingPDFPreview = false
    @State private var showingShareSheet = false
    @State private var generatedPDFData: Data?

    var subtotal: Decimal {
        job.lineItems.reduce(0) { $0 + $1.total }
    }

    var taxAmount: Decimal {
        job.lineItems.filter(\.taxable).reduce(Decimal(0)) { $0 + $1.total } * (job.taxRate / 100)
    }

    var total: Decimal {
        subtotal + taxAmount
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Label(job.status.rawValue, systemImage: statusIcon)
                        .foregroundColor(statusColor)
                    Spacer()
                    Menu {
                        ForEach(JobStatus.allCases, id: \.self) { status in
                            Button(status.rawValue) {
                                job.status = status
                                job.updatedAt = Date()
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                }

                if let client = job.client {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CLIENT")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(client.name)
                            .font(.headline)
                        if let phone = client.phone {
                            Link(phone, destination: URL(string: "tel:\(phone)")!)
                                .font(.subheadline)
                        }
                        if let email = client.email {
                            Link(email, destination: URL(string: "mailto:\(email)")!)
                                .font(.subheadline)
                        }
                    }
                }
            }

            Section("Line Items") {
                ForEach(job.lineItems.sorted { $0.sortOrder < $1.sortOrder }) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.itemDescription)
                                .font(.subheadline)
                            Text("\(item.quantity) x \(item.unitPrice, format: .currency(code: "USD"))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(item.total, format: .currency(code: "USD"))
                            .font(.subheadline)
                    }
                }
            }

            Section("Totals") {
                LabeledContent("Subtotal", value: subtotal, format: .currency(code: "USD"))
                if job.taxRate > 0 {
                    LabeledContent("Tax (\(NSDecimalNumber(decimal: job.taxRate).stringValue)%)", value: taxAmount, format: .currency(code: "USD"))
                }
                LabeledContent("Total", value: total, format: .currency(code: "USD"))
                    .font(.headline)
            }

            Section {
                if job.jobType == .quote {
                    Button {
                        showingConvertConfirmation = true
                    } label: {
                        Label("Convert to Invoice", systemImage: "doc.on.doc.fill")
                    }
                    .foregroundColor(.blue)
                }

                Button {
                    generateAndSharePDF()
                } label: {
                    Label("Share PDF", systemImage: "square.and.arrow.up")
                }

                Button(role: .destructive) {
                    modelContext.delete(job)
                } label: {
                    Label("Delete Job", systemImage: "trash")
                }
            }
        }
        .navigationTitle(job.title)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Convert to Invoice?", isPresented: $showingConvertConfirmation) {
            Button("Convert") {
                let _ = job.convertToInvoice(in: modelContext)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will create a new invoice with the same line items.")
        }
        .sheet(isPresented: $showingShareSheet) {
            if let data = generatedPDFData {
                ShareSheet(activityItems: [data])
            }
        }
    }

    private var statusIcon: String {
        switch job.status {
        case .draft: return "doc"
        case .quoteSent: return "paperplane"
        case .approved: return "checkmark.circle"
        case .inProgress: return "wrench.and.screwdriver"
        case .invoiceSent: return "doc.text"
        case .paid: return "checkmark.circle.fill"
        case .overdue: return "exclamationmark.triangle"
        case .cancelled: return "xmark.circle"
        }
    }

    private var statusColor: Color {
        switch job.status {
        case .draft: return .gray
        case .quoteSent: return .orange
        case .approved: return .blue
        case .inProgress: return .blue
        case .invoiceSent: return .orange
        case .paid: return .green
        case .overdue: return .red
        case .cancelled: return .gray
        }
    }

    private func generateAndSharePDF() {
        let generator = PDFInvoiceGenerator()
        generatedPDFData = generator.generate(job: job, taxRate: job.taxRate)
        showingShareSheet = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
