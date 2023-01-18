//
//  Persistence.swift
//  Expenny
//
//  Created by Ladislav Szolik on 15.01.23.
//

import CoreData

struct PersistenceController {
  static let shared:PersistenceController = PersistenceController()


    static var preview: PersistenceController = {
                  
      let result = PersistenceController(inMemory: true)
      let viewContext = result.container.viewContext
      
      //let cat0 = Category(context: viewContext)
      //cat0.id = UUID()
      //cat0.name = "None"
      
      let cat1 = Category(context: viewContext)
      cat1.id = UUID()
      cat1.name = "Food delivery"
      
      let cat2 = Category(context: viewContext)
      cat2.id = UUID()
      cat2.name = "Clothes"
      
      
      let cat3 = Category(context: viewContext)
      cat3.id = UUID()
      cat3.name = "Petrol"
      
      
      let item1 = Expense(context: viewContext)
      item1.timestamp = Date().addingTimeInterval(24000)
      item1.amount = 322.0
      //item1.category = cat1
      //cat1.addToExpenses(item1)
      
      
      let item2 = Expense(context: viewContext)
      item2.timestamp = Date().addingTimeInterval(20004000)
      item2.amount = 352.0
      item2.category = cat1
      cat1.addToExpenses(item2)
      
      
      let item3 = Expense(context: viewContext)
      item3.timestamp = Date().addingTimeInterval(20004000)
      item3.amount = 352.0
      item3.category = cat2
      cat2.addToExpenses(item3)
      
      /*
      for t in 0..<10 {
        let item = Expense(context: viewContext)
        item.timestamp = Calendar.current.date(byAdding: DateComponents(month: -t), to: Date())
        item.amount = 352.0
        item.category = cat2
        cat2.addToExpenses(item)
      }*/
    
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
      
      container = NSPersistentContainer(name: "Expenny")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
      
    }
}

/*
 static let shared:PersistenceController = {
   let persistenceController = PersistenceController()
   
   let preloadedKey = "didPrealoadData"
   
   let userDefaults = UserDefaults.standard
   
   if userDefaults.bool(forKey: preloadedKey) == false {
     
     let backgroundContext = persistenceController.container.newBackgroundContext()
     
     backgroundContext.perform {
       let cat1 = Category(context: backgroundContext)
       cat1.id = UUID()
       cat1.name = "None"
       do {
         try backgroundContext.save()
         userDefaults.set(true, forKey: preloadedKey)
       } catch {
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
       }
     }
   }
   return persistenceController
 }()
 */
