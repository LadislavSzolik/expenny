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
      
  var body: some View {
    HStack {
      Text(expense.timestamp ?? Date(), formatter: expenseDateFormatter ).foregroundColor(.gray)
      Spacer()
      VStack(alignment:.trailing) {
        HStack{
          Text("CHF")
          Text(expense.amount.formatted())
        }
        if let category = expense.category {
          Text(category.name ?? "").foregroundColor(.gray).font(.subheadline)
        }
      }
    }
  }
}

private let expenseDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
  formatter.setLocalizedDateFormatFromTemplate("dd MMM")
    return formatter
}()

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

