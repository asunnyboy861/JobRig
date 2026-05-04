import SwiftData
import Foundation

@Model
final class Client {
    @Attribute(.unique) var id: UUID
    var name: String
    var company: String?
    var email: String?
    var phone: String?
    var address: String?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Job.client)
    var jobs: [Job] = []

    init(name: String, company: String? = nil, email: String? = nil, phone: String? = nil, address: String? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.company = company
        self.email = email
        self.phone = phone
        self.address = address
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
