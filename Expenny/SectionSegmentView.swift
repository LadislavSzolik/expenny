//
//  SectionSegmentView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI

struct SectionSegmentView: View {
  var month: Date
  var sum: Double
    var body: some View {
      HStack {
        Text(month, formatter: expenseDateFormatter)
        Spacer()
        Text("CHF \(String(format: "%.2f", sum))").bold()
      }
    }
}

private let expenseDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMM yyyy")
    return formatter
}()


struct SectionSegmentView_Previews: PreviewProvider {
    static var previews: some View {
      SectionSegmentView(month: Date(), sum: 600.00)
    }
}
