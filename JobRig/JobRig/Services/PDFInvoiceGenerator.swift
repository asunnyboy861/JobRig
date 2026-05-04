import UIKit
import PDFKit

final class PDFInvoiceGenerator {
    func generate(job: Job, taxRate: Decimal) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50

        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        let businessName = UserDefaults.standard.string(forKey: "businessName") ?? ""
        let businessEmail = UserDefaults.standard.string(forKey: "businessEmail") ?? ""
        let businessPhone = UserDefaults.standard.string(forKey: "businessPhone") ?? ""
        let businessAddress = UserDefaults.standard.string(forKey: "businessAddress") ?? ""

        let data = renderer.pdfData { context in
            context.beginPage()

            var y: CGFloat = margin

            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.systemBlue
            ]
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: UIColor.darkGray
            ]
            let bodyAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
            let smallAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.gray
            ]

            let docTitle = job.jobType == .invoice ? "INVOICE" : "QUOTE"
            (docTitle as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: headerAttrs)
            y += 40

            if !businessName.isEmpty {
                (businessName as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
                y += 18
            }
            if !businessAddress.isEmpty {
                (businessAddress as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: smallAttrs)
                y += 14
            }
            if !businessPhone.isEmpty {
                ("Phone: \(businessPhone)" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: smallAttrs)
                y += 14
            }
            if !businessEmail.isEmpty {
                ("Email: \(businessEmail)" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: smallAttrs)
                y += 14
            }
            y += 10

            ("Job: \(job.title)" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
            y += 20
            ("Date: \(job.createdAt.formatted(date: .abbreviated, time: .omitted))" as NSString)
                .draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
            y += 20

            if let client = job.client {
                ("Bill To: \(client.name)" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
                if let email = client.email {
                    y += 18
                    ("Email: \(email)" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
                }
                if let phone = client.phone {
                    y += 18
                    ("Phone: \(phone)" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
                }
            }
            y += 30

            let tableX: CGFloat = margin
            let colWidths: [CGFloat] = [250, 80, 100, 100]
            let rowHeight: CGFloat = 25
            let headers = ["Description", "Qty", "Unit Price", "Total"]

            var x = tableX
            for (i, header) in headers.enumerated() {
                let rect = CGRect(x: x, y: y, width: colWidths[i], height: rowHeight)
                let headerBg = UIBezierPath(rect: rect)
                UIColor.systemBlue.setFill()
                headerBg.fill()
                (header as NSString).draw(in: rect.insetBy(dx: 5, dy: 4), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 11, weight: .bold),
                    .foregroundColor: UIColor.white
                ])
                x += colWidths[i]
            }
            y += rowHeight

            let sortedItems = job.lineItems.sorted { $0.sortOrder < $1.sortOrder }
            for item in sortedItems {
                x = tableX
                let values = [
                    item.itemDescription,
                    "\(item.quantity)",
                    item.unitPrice.formatted(.currency(code: "USD")),
                    item.total.formatted(.currency(code: "USD"))
                ]
                for (i, value) in values.enumerated() {
                    let rect = CGRect(x: x, y: y, width: colWidths[i], height: rowHeight)
                    (value as NSString).draw(in: rect.insetBy(dx: 5, dy: 4), withAttributes: bodyAttrs)
                    x += colWidths[i]
                }
                y += rowHeight
            }

            y += 10
            let subtotal = sortedItems.reduce(Decimal(0)) { $0 + $1.total }
            let taxableTotal = sortedItems.filter(\.taxable).reduce(Decimal(0)) { $0 + $1.total }
            let tax = taxableTotal * (taxRate / 100)
            let total = subtotal + tax

            let totals: [(String, String)] = [
                ("Subtotal", subtotal.formatted(.currency(code: "USD"))),
                ("Tax (\(taxRate)%)", tax.formatted(.currency(code: "USD"))),
                ("TOTAL", total.formatted(.currency(code: "USD")))
            ]

            for (label, value) in totals {
                let labelRect = CGRect(x: pageWidth - margin - 250, y: y, width: 150, height: rowHeight)
                let valueRect = CGRect(x: pageWidth - margin - 100, y: y, width: 100, height: rowHeight)
                let attrs: [NSAttributedString.Key: Any] = label == "TOTAL" ? [
                    .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                    .foregroundColor: UIColor.black
                ] : bodyAttrs
                (label as NSString).draw(in: labelRect.insetBy(dx: 5, dy: 4), withAttributes: attrs)
                (value as NSString).draw(in: valueRect.insetBy(dx: 5, dy: 4), withAttributes: attrs)
                y += rowHeight
            }

            let bankInfo = UserDefaults.standard.string(forKey: "bankInfo") ?? ""
            if !bankInfo.isEmpty {
                y += 20
                ("Payment Info:" as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
                y += 18
                (bankInfo as NSString).draw(at: CGPoint(x: margin, y: y), withAttributes: smallAttrs)
            }

            ("Generated by JobRig — Quote · Invoice · Get Paid" as NSString)
                .draw(at: CGPoint(x: margin, y: pageHeight - margin), withAttributes: smallAttrs)
        }

        return data
    }
}
