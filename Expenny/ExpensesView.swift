//
//  ExpensesView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI

struct ExpensesView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @SectionedFetchRequest<Date, Expense>(
    sectionIdentifier: \.monthAndYear,
      sortDescriptors: [NSSortDescriptor(keyPath: \Expense.timestamp, ascending: false) ])
  private var expensesByMonth: SectionedFetchResults<Date, Expense>
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
  @State private var isNewExpenseShown = false
  
  @State private var selectedCategory:String = "All"
  @State private var selectedExpense: Expense = Expense()
  
    var body: some View {
      NavigationStack {
          VStack {
            List {
              ForEach(expensesByMonth) { month in
                Section(header: SectionSegmentView(month: month.id, sum: month.reduce(0.0) {$0 + $1.amount})) {
                  ForEach(month) { expense in
                    NavigationLink {
                      ExpenseDetailsView(expense: expense)
                    } label: {
                      ExpenseRowView(expense: expense)
                    }
                  }.onDelete{deleteItems(at: $0, in: month.id)}
                }
              }
            }
            HStack {
              Button("Add expense") {
                isNewExpenseShown.toggle()
              }.sheet(isPresented: $isNewExpenseShown) {
                NewExpenseView( isShown: $isNewExpenseShown)
              }.bold().padding()
            }
          }.navigationTitle("Expenses")
          .toolbar{
            ToolbarItem(placement: .primaryAction) {
              Menu {
              
                Picker("Category", selection: $selectedCategory) {
                  Text("All").tag("All")
                  ForEach(categories) { category in
                    Text(category.name!).tag(category.name!)
                  }
                }.onChange(of:selectedCategory) { value in
                  expensesByMonth.nsPredicate = value == "All"
                  ? nil
                  : NSPredicate(format: "category.name == %@", selectedCategory)
                }
                NavigationLink ("Categories...") {
                  CategoryDetailsView()
                }
              } label: {
                Label("Categories", systemImage: "ellipsis.circle")
              }
            }
          }
        }
      }
}



extension ExpensesView {
  private func deleteItems(at offsets: IndexSet, in section: Date) {
    
    //TODO: find a better way to get index    
    let segmentIndex = expensesByMonth.firstIndex { sec in
      sec.id == section
    }
    
    withAnimation {
        offsets.map { expensesByMonth[segmentIndex!][$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error in DeleteItem: \(nsError), \(nsError.userInfo)")
        }
    }
  }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

/*ExpenseDetailsView(
  expense: expense,
  expenseDate: Binding<Date>(get:{expense.timestamp ?? Date()}, set: {expense.timestamp = $0}),
  expenseAmount: Binding<Double>(get:{expense.amount}, set: {expense.amount = $0}),
  expenseCategory: Binding<Category>(get:{expense.category!}, set:{expense.category = $0})
)*/


/*
 struct TesterView: View {
   @Environment(\.dismiss) private var dismiss
   @Environment(\.managedObjectContext) private var viewContext
   var expense:Expense
   @State private var expenseAmount:Double?
   @State private var expenseDate:Date = Date()
   var body: some View {
     VStack {
       DatePicker("Date", selection: $expenseDate, displayedComponents: [.date])
       TextField("Amount", value: $expenseAmount, format: .number).keyboardType(.decimalPad).onAppear{
         expenseAmount = expense.amount
         expenseDate = expense.timestamp ?? Date()
       }.onChange(of: expenseAmount) { newValue in
         expense.amount = newValue ?? 0.0;
         saveCoreDate()
       }.onChange(of: expenseDate) { newValue in
         expense.timestamp = newValue
         saveCoreDate()
       }
       Button("Delete") {
         deleteExpense()
         dismiss()
       }
     }
   }
   
   private func deleteExpense() {
     viewContext.delete(expense)
   }

   private func saveCoreDate() {
     do {
         try viewContext.save()
     } catch {
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
     }
   }
 }
 */
