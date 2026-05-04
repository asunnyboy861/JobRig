import SwiftData
import Foundation

@Model
final class JobPhoto {
    @Attribute(.unique) var id: UUID
    var imageData: Data
    var caption: String?
    var takenAt: Date

    var job: Job?

    init(imageData: Data, caption: String? = nil) {
        self.id = UUID()
        self.imageData = imageData
        self.caption = caption
        self.takenAt = Date()
    }
}
