//
//  ExpenseDetailsView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI
import CoreData

struct ExpenseDetailsView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  var expense: Expense
  @Binding var expenseDate: Date
  @Binding var expenseAmount: Double
  @Binding var expenseCategory: Category
  
  //TODO: optimize fetching categories
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
  var body: some View {
      Form {
        Section {
          DatePicker("Date", selection: $expenseDate, displayedComponents: [.date])
          TextField("Amount", value: $expenseAmount, format: .number).keyboardType(.decimalPad)
          Picker("Category", selection: $expenseCategory) {
            ForEach(categories) { category in
              Text(category.name!).tag(category)
            }
          }
        }
        Section {
          Button("Delete expense", role: .destructive) {
            
          }
        }
      }.scrollDismissesKeyboard(.interactively)
        .navigationBarTitle("Expense",displayMode: .inline)
  }
  
  private func deleteExpense() {
      viewContext.delete(expense)
  }
}


struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
                  let viewContext = PersistenceController.shared.container.viewContext
      let cat = Category(context: viewContext)
      cat.id = UUID()
      cat.name = "Food"
      do {
          try viewContext.save()
      } catch {
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      let expense = Expense(context: viewContext)
      expense.timestamp = Date()
      let expDate = Binding.constant(Date())
      let expAmount = Binding.constant(100.00)
      let expCategory = Binding.constant(cat)
      return ExpenseDetailsView(expense: expense, expenseDate:expDate, expenseAmount: expAmount, expenseCategory: expCategory ).environment(\.managedObjectContext, viewContext)
    }
}
