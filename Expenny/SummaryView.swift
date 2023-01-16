//
//  SummaryView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI

struct SummaryView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
    var body: some View {
      NavigationStack {
        List{
          ForEach(categories) { category in
            Section(category.name!) {
              ChartByCategoryView(category: category.name!)
            }
          }
        }
      }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
