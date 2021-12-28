//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Douglas Frari on 4/29/21.
//

import UIKit

import CoreData

class ConsolesManager {
 
    static let shared = ConsolesManager()
    var consoles: [Console] = []
 
    func loadConsoles(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
     
        do {
            consoles = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
 
 
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
     
        do {
            try context.save()
            // tirar da lista local de consoles para manter a estrutura dos dados atualizados
            consoles.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
 
    func saveConsole(in context: NSManagedObjectContext, withName name: String, andLogo logo: UIImage = UIImage(named: "console")!){
        let console = Console(context: context)
        console.name = name
        console.logo = logo
       
        do {
            try context.save()

        } catch {
            print(error.localizedDescription)
        }
    }
    
    private init() {
     
    }
}
