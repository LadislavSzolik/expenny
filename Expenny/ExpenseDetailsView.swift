//
//  ExpenseDetailsView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI
import CoreData

struct ExpenseDetailsView: View {
  var expense: Expense
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext
  @State private var expenseDate: Date = Date()
  @State private var expenseAmount: Double?
  @State private var expenseCategory: Category?
  @FocusState private var amountFocused:Bool
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>  //TODO: optimize fetching categories
  
  var body: some View {
      Form {
        Section {
          DatePicker("Date", selection: $expenseDate, displayedComponents: [.date])
          TextField("Amount", value: $expenseAmount, format: .number).keyboardType(.decimalPad).focused($amountFocused)
          Picker("Category", selection: $expenseCategory) {
            Text("None").tag(nil as Category?)
            ForEach(categories) { category in
              Text(category.name!).tag(Optional(category))
            }
          }
        }
        Section {
          Button("Delete expense", role: .destructive) {
            viewContext.delete(expense)
            dismiss()
          }
        }
      }.scrollDismissesKeyboard(.interactively)
      .onChange(of: expenseDate) { value in
        expense.timestamp = value
        updateExpense()
      }
      .onChange(of: expenseAmount) { value in
        expense.amount = value ?? 0.0
        updateExpense()
      }
      .onChange(of: expenseCategory) { value in
        //TODO: check if there is a bug
        expense.category?.removeFromExpenses(expense)
        expense.category = value
        expenseCategory?.addToExpenses(expense)
        updateExpense()
      }
      .onAppear{
        expenseDate = expense.timestamp ?? Date()
        expenseAmount = expense.amount
        expenseCategory = expense.category ?? nil
        amountFocused = true
      }
      .navigationBarTitle("Expense",displayMode: .inline)
    
  }
  private func updateExpense() {
    do {
        try viewContext.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}


struct ExpenseDetailsView_Previews: PreviewProvider {
  
    static var previews: some View {      
      let viewContext = PersistenceController.preview.container.viewContext
                
      let expense = Expense(context: viewContext)
      expense.timestamp = Date()
      
      do {
          try viewContext.save()
      } catch {
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      
      return ExpenseDetailsView(expense: expense ).environment(\.managedObjectContext, viewContext)
    }
}
