//
//  ChartByCategoryView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI
import Charts

struct ChartByCategoryView: View {
  
  var category:String = ""
    
  let sixMonthsAgo = Calendar.current.date(byAdding: DateComponents(month: -6), to: Date())
  
  @SectionedFetchRequest<Date, Expense>(
    sectionIdentifier: \.monthAndYear,
    sortDescriptors: [NSSortDescriptor(keyPath: \Expense.timestamp, ascending: true) ],
    predicate: NSPredicate(format: "category.name == ''")
  )
  private var expensesByMonth: SectionedFetchResults<Date, Expense>
  
    var body: some View {
      VStack {
          Chart(expensesByMonth) { exp in
            BarMark(
              x: .value("Month", exp.id),
              y: .value("Value", exp.reduce(0.0) {$0 + $1.amount})
            )
          }.padding().onAppear(perform: {
            expensesByMonth.nsPredicate = category.isEmpty
            ? nil
            : NSPredicate(format: "(category.name == %@) && (timestamp >= %@)", argumentArray: [category, sixMonthsAgo!])
          })
        }
    }
}

struct ChartByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
      ChartByCategoryView(category: "Food delivery" ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
     ChartByCategoryView(category: "Clothes" ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
