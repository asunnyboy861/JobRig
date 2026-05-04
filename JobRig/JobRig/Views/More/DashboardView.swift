import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var jobs: [Job]
    @Query private var clients: [Client]

    var totalRevenue: Decimal {
        jobs.filter { $0.status == .paid }.reduce(0) { $0 + $1.totalAmount }
    }

    var outstandingAmount: Decimal {
        jobs.filter { $0.status == .invoiceSent || $0.status == .overdue }.reduce(0) { $0 + $1.totalAmount }
    }

    var overdueCount: Int {
        jobs.filter { $0.status == .overdue }.count
    }

    var paidThisMonth: Decimal {
        let calendar = Calendar.current
        let now = Date()
        return jobs.filter { job in
            guard job.status == .paid, let completedAt = job.completedAt else { return false }
            return calendar.isDate(completedAt, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.totalAmount }
    }

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Total Revenue", value: totalRevenue, format: .currency(code: "USD"))
                LabeledContent("Outstanding", value: outstandingAmount, format: .currency(code: "USD"))
                    .foregroundColor(outstandingAmount > 0 ? .orange : .primary)
                LabeledContent("Paid This Month", value: paidThisMonth, format: .currency(code: "USD"))
                    .foregroundColor(.green)
            }

            Section("Jobs") {
                LabeledContent("Total Jobs", value: jobs.count, format: .number)
                LabeledContent("Overdue", value: overdueCount, format: .number)
                    .foregroundColor(overdueCount > 0 ? .red : .primary)
                LabeledContent("Clients", value: clients.count, format: .number)
            }

            Section("By Status") {
                ForEach(JobStatus.allCases, id: \.self) { status in
                    let count = jobs.filter { $0.status == status }.count
                    if count > 0 {
                        HStack {
                            Circle()
                                .fill(statusColor(status))
                                .frame(width: 10, height: 10)
                            Text(status.rawValue)
                            Spacer()
                            Text("\(count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
    }

    private func statusColor(_ status: JobStatus) -> Color {
        switch status {
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
}
