//
//  CategoryDetailsView.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import SwiftUI

struct CategoryDetailsView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
  @State private var showAddCategory: Bool = false
  
  @State private var newCategoryName = String()
    var body: some View {
    
        List {
          ForEach(categories) { cat in
            Text(cat.name!)
          }.onDelete(perform: deleteCategory)
        }.navigationTitle("Categories").navigationBarTitleDisplayMode(.inline)
        HStack {
          Button("Add category") {
            showAddCategory.toggle()
          }.bold().sheet(isPresented: $showAddCategory) {
            NavigationStack {
              Form {
                Section {
                  TextField("Category name", text: $newCategoryName).autocorrectionDisabled(true)
                }.navigationBarTitle("New category", displayMode: .inline ).toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                      showAddCategory.toggle()
                    }
                  }
                  ToolbarItem {
                    Button("Save"){
                      saveCategory()
                      showAddCategory.toggle()
                    }.disabled(newCategoryName.isEmpty)
                  }
                }
              }
            }
          }
          Spacer()
        }.padding()
      
    }
  
  private func saveCategory() {
    let newCategory = Category(context: viewContext)
    newCategory.id = UUID()
    newCategory.name = newCategoryName
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

// MARK: Delete category

extension CategoryDetailsView {
  private func deleteCategory(offsets: IndexSet) {
      withAnimation {
          offsets.map { categories[$0] }.forEach(viewContext.delete)
          do {
              try viewContext.save()
          } catch {
              let nsError = error as NSError
              print("Error in DeleteItem: \(nsError), \(nsError.userInfo)")
          }
      }
  }
}


struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      CategoryDetailsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
