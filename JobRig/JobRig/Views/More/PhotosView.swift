import SwiftUI
import SwiftData

struct PhotosView: View {
    @Query private var jobs: [Job]
    @State private var selectedJob: Job?

    var jobsWithPhotos: [Job] {
        jobs.filter { !$0.photos.isEmpty }
    }

    var body: some View {
        List {
            ForEach(jobsWithPhotos) { job in
                Section(job.title) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(job.photos) { photo in
                                if let uiImage = UIImage(data: photo.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Photos")
        .overlay {
            if jobsWithPhotos.isEmpty {
                ContentUnavailableView(
                    "No Photos",
                    systemImage: "photo.on.rectangle",
                    description: Text("Add photos to your jobs from the job detail screen")
                )
            }
        }
    }
}
