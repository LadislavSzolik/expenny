//
//  NewExpenseView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI

struct NewExpenseView: View {
  @Binding var isShown: Bool
  @Environment(\.managedObjectContext) private var viewContext
  @State private var amount: Double?
  @State private var dateSelection = Date()
  @State private var selectedCategory: Category?
  @FocusState private var amountFocused:Bool
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
    var body: some View {
        Form {
          Section(footer: categories.isEmpty ? Text("You haven't created any categories yet.") : nil) {
            DatePicker("Date", selection: $dateSelection, displayedComponents: [.date])
            TextField("Amount", value: $amount, format: .number).keyboardType(.decimalPad).focused($amountFocused)
            Picker("Category", selection: $selectedCategory) {
              Text("None").tag(nil as Category?)
              ForEach(categories) { category in
                Text(category.name ?? "").tag(Optional(category))
              }
            }
          }
        }.onAppear{
          amountFocused = true
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("New")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
              isShown = false
            }
          }
          ToolbarItem {
            Button("Save") {
              saveExpense()
              isShown = false
            }.disabled(amount == nil)
          }
        }
    }
  
  
  private func saveExpense() {
    let newExpense = Expense(context: viewContext)
    newExpense.timestamp = dateSelection
    newExpense.amount = amount ?? 0.0
    newExpense.category = selectedCategory
    selectedCategory?.addToExpenses(newExpense)
    do {
        try viewContext.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationStack {
        NewExpenseView(isShown: Binding.constant(true)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      }
    }
}
