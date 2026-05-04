import SwiftUI

struct BusinessSettingsView: View {
    @AppStorage("businessName") private var businessName = ""
    @AppStorage("businessEmail") private var businessEmail = ""
    @AppStorage("businessPhone") private var businessPhone = ""
    @AppStorage("businessAddress") private var businessAddress = ""
    @AppStorage("defaultTaxRate") private var defaultTaxRate = ""
    @AppStorage("bankInfo") private var bankInfo = ""

    var body: some View {
        Form {
            Section("Business Info") {
                TextField("Business Name", text: $businessName)
                TextField("Email", text: $businessEmail)
                    .keyboardType(.emailAddress)
                TextField("Phone", text: $businessPhone)
                    .keyboardType(.phonePad)
                TextField("Address", text: $businessAddress, axis: .vertical)
                    .lineLimit(2...4)
            }

            Section("Defaults") {
                TextField("Default Tax Rate (%)", text: $defaultTaxRate)
                    .keyboardType(.decimalPad)
            }

            Section("Payment Info") {
                TextField("Bank / Payment Info", text: $bankInfo, axis: .vertical)
                    .lineLimit(2...4)
            }
        }
        .navigationTitle("Business Settings")
    }
}
