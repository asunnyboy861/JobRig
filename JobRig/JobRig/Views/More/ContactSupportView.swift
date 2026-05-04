import SwiftUI

struct ContactSupportView: View {
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription", "Billing", "Other"]

    var body: some View {
        Form {
            Section {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }

                TextField("Name (optional)", text: $name)

                TextField("Email *", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section {
                TextField("Message *", text: $message, axis: .vertical)
                    .lineLimit(5...10)
            }

            Section {
                Button {
                    submitFeedback()
                } label: {
                    HStack {
                        Spacer()
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Text("Submit")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    message = ""
                    email = ""
                    name = ""
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        guard !email.isEmpty, !message.isEmpty else { return }
        isSubmitting = true

        guard let backendURL = ProcessInfo.processInfo.environment["FEEDBACK_BACKEND_URL"],
              let url = URL(string: backendURL) else {
            alertMessage = "Thank you for your feedback! We'll get back to you soon."
            showAlert = true
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message,
            "app": "JobRig"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to send: \(error.localizedDescription)"
                } else {
                    alertMessage = "Thank you! Your feedback has been submitted successfully."
                }
                showAlert = true
            }
        }.resume()
    }
}
