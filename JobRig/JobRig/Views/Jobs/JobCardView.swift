import SwiftUI

struct JobCardView: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(job.status.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(statusColor)
                Spacer()
                Text(job.jobType.rawValue)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray6))
                    .cornerRadius(4)
            }

            Text(job.title)
                .font(.headline)
                .lineLimit(1)

            if let client = job.client {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.caption2)
                    Text(client.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            if let dueDate = job.dueDate {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(job.status == .overdue ? .red : .secondary)
                }
            }

            HStack {
                Spacer()
                Text(job.totalAmount, format: .currency(code: "USD"))
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 4)
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
}
