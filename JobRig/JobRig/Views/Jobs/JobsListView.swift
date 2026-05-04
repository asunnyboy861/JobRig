import SwiftUI
import SwiftData

struct JobsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Job.updatedAt, order: .reverse) private var jobs: [Job]
    @State private var searchText = ""
    @State private var filterStatus: JobStatus?
    @State private var showingNewJob = false

    var filteredJobs: [Job] {
        var result = jobs
        if let filterStatus = filterStatus {
            result = result.filter { $0.status == filterStatus }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.client?.name ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        Group {
            if jobs.isEmpty {
                ContentUnavailableView(
                    "No Jobs Yet",
                    systemImage: "clipboard",
                    description: Text("Tap the + tab to create your first quote or invoice")
                )
            } else {
                List {
                    Section {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(label: "All", isSelected: filterStatus == nil) {
                                    filterStatus = nil
                                }
                                ForEach(JobStatus.allCases, id: \.self) { status in
                                    FilterChip(
                                        label: status.rawValue,
                                        isSelected: filterStatus == status,
                                        color: statusColor(status)
                                    ) {
                                        filterStatus = filterStatus == status ? nil : status
                                    }
                                }
                            }
                        }
                    }

                    ForEach(filteredJobs) { job in
                        NavigationLink(value: job) {
                            JobCardView(job: job)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search jobs or clients")
            }
        }
        .navigationTitle("Jobs")
        .navigationDestination(for: Job.self) { job in
            JobDetailView(job: job)
        }
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

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    var color: Color = .blue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color.opacity(0.2) : Color(.systemGray6))
                .foregroundColor(isSelected ? color : .secondary)
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}
