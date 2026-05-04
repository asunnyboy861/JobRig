import SwiftData
import Foundation

enum JobStatus: String, Codable, CaseIterable {
    case draft = "Draft"
    case quoteSent = "Quote Sent"
    case approved = "Approved"
    case inProgress = "In Progress"
    case invoiceSent = "Invoice Sent"
    case paid = "Paid"
    case overdue = "Overdue"
    case cancelled = "Cancelled"

    var color: String {
        switch self {
        case .draft: return "gray"
        case .quoteSent: return "orange"
        case .approved: return "blue"
        case .inProgress: return "blue"
        case .invoiceSent: return "orange"
        case .paid: return "green"
        case .overdue: return "red"
        case .cancelled: return "gray"
        }
    }
}

enum JobType: String, Codable, CaseIterable {
    case quote = "Quote"
    case invoice = "Invoice"
    case workOrder = "Work Order"
}

@Model
final class Job {
    @Attribute(.unique) var id: UUID
    var title: String
    var jobDescription: String
    var status: JobStatus
    var jobType: JobType
    var totalAmount: Decimal
    var taxRate: Decimal
    var dueDate: Date?
    var completedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade) var lineItems: [LineItem] = []
    @Relationship(deleteRule: .cascade) var photos: [JobPhoto] = []
    @Relationship(deleteRule: .cascade) var reminders: [Reminder] = []

    var client: Client?
    var location: JobLocation?

    init(title: String, jobDescription: String = "", jobType: JobType = .quote, client: Client? = nil) {
        self.id = UUID()
        self.title = title
        self.jobDescription = jobDescription
        self.jobType = jobType
        self.status = .draft
        self.totalAmount = 0
        self.taxRate = 0
        self.createdAt = Date()
        self.updatedAt = Date()
        self.client = client
    }

    func convertToInvoice(in context: ModelContext) -> Job {
        let invoice = Job(title: self.title, jobDescription: self.jobDescription, jobType: .invoice, client: self.client)
        invoice.totalAmount = self.totalAmount
        invoice.taxRate = self.taxRate
        invoice.status = .invoiceSent
        invoice.dueDate = self.dueDate

        for item in self.lineItems {
            let invoiceItem = LineItem(
                itemDescription: item.itemDescription,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
                taxable: item.taxable
            )
            invoiceItem.sortOrder = item.sortOrder
            invoiceItem.job = invoice
            context.insert(invoiceItem)
        }

        for photo in self.photos {
            let invoicePhoto = JobPhoto(imageData: photo.imageData, caption: photo.caption)
            invoicePhoto.job = invoice
            context.insert(invoicePhoto)
        }

        context.insert(invoice)
        return invoice
    }
}
