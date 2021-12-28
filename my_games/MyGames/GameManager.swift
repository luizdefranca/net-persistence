//
//  GameManager.swift
//  MyGames
//
//  Created by Luiz Carlos F Ramos on 17/05/21.
//

import Foundation
import CoreData

class GameManager {
    
    static let shared = GameManager()
    var games: [Game] = []
    var fetchedResultController: NSFetchedResultsController<Game> = NSFetchedResultsController()
    
    
    func loadGames(withContext context: NSManagedObjectContext,filtering: String = "") {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            // usando predicate: conjunto de regras para pesquisas
            // contains [c] = search insensitive (nao considera letras identicas)
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        // possui
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
//        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let game = games[index]
        context.delete(game)
        
        do {
            try context.save()
            // tirar da lista local de consoles para manter a estrutura dos dados atualizados
            games.remove(at: index)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}
