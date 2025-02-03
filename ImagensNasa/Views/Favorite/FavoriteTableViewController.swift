//
//  FavoriteTableViewController.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 31/01/25.
//

import UIKit
import CoreData


class FavoriteTableViewController: UITableViewController {
    
    var fetchResultController: NSFetchedResultsController<Favorite>!
    var favorite: Favorite!
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Você não tem imagens salvas"
        label.textAlignment = .center
        loadFavorite()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "favoriteSegue" {
            let vc = segue.destination as! FavoriteViewController
            
            if let favorites = fetchResultController.fetchedObjects {
                vc.favorite = favorites[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func loadFavorite() {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        do {
           try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteTableViewCell

        guard let favorite = fetchResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: favorite)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let favorite = fetchResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(favorite)
        }
    }

}

extension FavoriteTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
    
}
