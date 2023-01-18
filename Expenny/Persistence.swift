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
      
      let grocery = Category(context: viewContext)
      grocery.id = UUID()
      grocery.name = "Grocery"
      
      let clothes = Category(context: viewContext)
      clothes.id = UUID()
      clothes.name = "New clothes"
      
      
      let petrol = Category(context: viewContext)
      petrol.id = UUID()
      petrol.name = "Petrol"
      
      let retaurants = Category(context: viewContext)
      retaurants.id = UUID()
      retaurants.name = "Restaurants"
      
      let parking = Category(context: viewContext)
      parking.id = UUID()
      parking.name = "Parking"
                      
      let item1 = Expense(context: viewContext)
      item1.timestamp = getDateForString(for: "01-04-2023")
      item1.amount = 80.0
      
      let item2 = Expense(context: viewContext)
      item2.timestamp = getDateForString(for: "01-11-2023")
      item2.amount = 352.0
      item2.category = grocery
      grocery.addToExpenses(item2)
            
      let item3 = Expense(context: viewContext)
      item3.timestamp = getDateForString(for: "01-11-2023")
      item3.amount = 85.0
      item3.category = petrol
      petrol.addToExpenses(item3)
      
      let item4 = Expense(context: viewContext)
      item4.timestamp = getDateForString(for: "01-11-2023")
      item4.amount = 2.0
      item4.category = parking
      parking.addToExpenses(item4)
      
      let item5 = Expense(context: viewContext)
      item5.timestamp = getDateForString(for: "01-11-2023")
      item5.amount = 4.0
      item5.category = parking
      parking.addToExpenses(item5)
      
      let item6 = Expense(context: viewContext)
      item6.timestamp = getDateForString(for: "01-18-2023")
      item6.amount = 240.0
      item6.category = retaurants
      retaurants.addToExpenses(item5)
      
      
      let item7 = Expense(context: viewContext)
      item7.timestamp = getDateForString(for: "12-27-2022")
      item7.amount = 499
      item7.category = clothes
      clothes.addToExpenses(item7)
      
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

private func getDateForString(for dateString: String ) -> Date {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "MM-dd-yyyy"
  return dateFormatter.date(from: dateString) ?? Date()
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
