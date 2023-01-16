//
//  ExpenseRowView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI

struct ExpenseRowView: View {
  
  @ObservedObject
  var expense:Expense
  
  private let expenseDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("dd MMM")
      return formatter
  }()
  
  
    var body: some View {
      HStack {
        Text(expense.timestamp ?? Date(), formatter: expenseDateFormatter ).foregroundColor(.gray)
        Spacer()
        VStack(alignment:.trailing) {
          HStack{
            Text("CHF")
            Text(expense.amount.formatted())
          }
          Text(expense.category?.name ?? "").foregroundColor(.gray).font(.subheadline)
        }
      }
    }
}

struct ExpenseRowView_Previews: PreviewProvider {
    static var previews: some View {
      let viewContext =  PersistenceController.shared.container.viewContext
      let exp = Expense(context: viewContext)
      exp.amount = 33.0
      exp.timestamp = Date()
      try! viewContext.save()
      
      return ExpenseRowView(expense: exp).environment(\.managedObjectContext, viewContext)
    }
}

