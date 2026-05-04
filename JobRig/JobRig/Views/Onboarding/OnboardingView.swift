import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentStep = 0

    private let steps = [
        OnboardingStep(icon: "doc.text.fill", title: "Create Quotes Fast", description: "Send professional quotes from the job site in 30 seconds"),
        OnboardingStep(icon: "doc.on.doc.fill", title: "One-Tap Invoices", description: "Convert any quote to an invoice with a single tap"),
        OnboardingStep(icon: "wifi.slash", title: "Works Offline", description: "Full functionality even without cell signal"),
        OnboardingStep(icon: "dollarsign.circle.fill", title: "Get Paid Faster", description: "Track payments, send reminders, and close deals")
    ]

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: steps[currentStep].icon)
                .font(.system(size: 72))
                .foregroundStyle(.blue)
                .symbolEffect(.bounce, value: currentStep)

            Text(steps[currentStep].title)
                .font(.title)
                .fontWeight(.bold)

            Text(steps[currentStep].description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            HStack(spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }

            HStack(spacing: 16) {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation { currentStep -= 1 }
                    }
                }

                Button {
                    if currentStep < steps.count - 1 {
                        withAnimation { currentStep += 1 }
                    } else {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text(currentStep == steps.count - 1 ? "Get Started" : "Next")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}

struct OnboardingStep {
    let icon: String
    let title: String
    let description: String
}
