//
//  ContentView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI
import CoreData
import Charts

extension Expense {
  @objc
  var monthAndYear: Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month], from: self.timestamp!)
    components.day = 1
    return calendar.date(from: components) ?? Date()
  }
}

struct ContentView: View {
    
  var body: some View {
        ExpensesView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


/*
 enum Page: String, CaseIterable, Identifiable {
     case expenses, summary
     var id: Self { self }
 }
 
 @State private var currentView:Page = .expenses
 
 
 VStack {
   if currentView == .expenses {
     ExpensesView()
   } else {
     SummaryView()
   }
 }
 
 .toolbar {
   ToolbarItem(placement: .principal) {
     HStack {
       Picker("Page", selection: $currentView) {
         ForEach(Page.allCases) { page in
           Text(page.rawValue.capitalized).tag(page)
         }
       }.pickerStyle(.segmented)
     }
   }
 }
 */
