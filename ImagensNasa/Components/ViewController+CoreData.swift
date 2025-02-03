//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Ivan Chaves on 31/03/20.
//  Copyright © 2020 Ivan Chaves. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    //RECUPERA O CONTEXTO
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
}
