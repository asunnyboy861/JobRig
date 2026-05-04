import SwiftData
import Foundation

@Model
final class JobLocation {
    @Attribute(.unique) var id: UUID
    var latitude: Double
    var longitude: Double
    var address: String

    init(latitude: Double, longitude: Double, address: String) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}
