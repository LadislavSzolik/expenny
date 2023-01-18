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
  @State private var editingCategoryName: String = ""
  @State private var newCategoryName: String = ""
  @FocusState private var inputsFocused: Bool
  
  var body: some View {
      List {
        ForEach(categories) { cat in
          CategoryRow(category: cat, inputsFocused: $inputsFocused)
        }.onDelete(perform: deleteCategory)
        TextField("New category name", text: $newCategoryName)
          .autocorrectionDisabled(true)
          .onSubmit{
            saveCategory()
          }.focused($inputsFocused)
      }.navigationTitle("Categories")
      .toolbar{
        if inputsFocused {
          ToolbarItem {
            Button("Done") {
              if !newCategoryName.isEmpty {
                saveCategory()
              }
              inputsFocused = false
            }
          }
        }
      }
  }
  
  private func saveCategory() {
    let newCategory = Category(context: viewContext)
    newCategory.id = UUID()
    newCategory.name = newCategoryName
    do {
      try viewContext.save()
      newCategoryName = ""
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
  
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

struct CategoryRow:View {
  var category: Category
  @State private var editingCategory = "<empty"
  var inputsFocused: FocusState<Bool>.Binding
  @Environment(\.managedObjectContext) private var viewContext
  var body: some View {
    TextField("Name", text: $editingCategory).onAppear{
      editingCategory = category.name ?? "<empty>"
    }.onChange(of: editingCategory) { value in
      category.name = value
      saveCategory()
    }.focused(inputsFocused)
      .autocorrectionDisabled(true)
  }
  
  private func saveCategory() {
    do {
        try viewContext.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationStack {
        CategoryDetailsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      }
    }
}
