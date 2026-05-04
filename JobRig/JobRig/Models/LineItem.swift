import SwiftData
import Foundation

@Model
final class LineItem {
    @Attribute(.unique) var id: UUID
    var itemDescription: String
    var quantity: Decimal
    var unitPrice: Decimal
    var taxable: Bool
    var sortOrder: Int

    var job: Job?

    var total: Decimal { quantity * unitPrice }

    init(itemDescription: String, quantity: Decimal = 1, unitPrice: Decimal = 0, taxable: Bool = true) {
        self.id = UUID()
        self.itemDescription = itemDescription
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.taxable = taxable
        self.sortOrder = 0
    }
}
