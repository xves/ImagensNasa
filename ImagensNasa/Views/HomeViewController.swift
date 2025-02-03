//
//  HomeViewController.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 30/01/25.
//

import UIKit
import Kingfisher
import AVKit
import WebKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var dpDate: UIDatePicker!
    @IBOutlet weak var viVideo: UIView!
    @IBOutlet weak var bbiStar: UIBarButtonItem!
    @IBOutlet weak var stvInfo: UIStackView!
    @IBOutlet weak var stvDatePicker: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var fetchResultController: NSFetchedResultsController<Favorite>!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    var date: String = ""
    var url: String = ""
    var titulo: String = ""
    var mediaType: String = ""
    var webView: WKWebView!
    var favorite: Favorite!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dpDate.datePickerMode = .date
        let initialDate = Date()
        dpDate.setDate(initialDate, animated: false)
        updateDateLabel(date: dpDate.date)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        webView = WKWebView(frame: viVideo.bounds, configuration: webConfiguration)
        viVideo.addSubview(webView)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() 
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    
    func isFavorite(title: String) -> Bool {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "title ==[c] %@", title)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Erro ao buscar favorito: \(error.localizedDescription)")
            return false
        }
    }
    
    
    @IBAction func saveFavorite(_ sender: Any) {
        
        if self.isFavorite(title: self.titulo) {
            //REMOVE
            let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title ==[c] %@", titulo)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for object in results {
                    context.delete(object)  // Remove do Core Data
                }
                
                try context.save()  // Salva as alterações
                print("\(titulo) removido dos favoritos.")
                self.bbiStar.image = UIImage(systemName: "star")
                
            } catch {
                print("Erro ao remover dos favoritos: \(error.localizedDescription)")
            }
            
        } else {
            //ADD
            bbiStar.image = UIImage(systemName: "star.fill")
            
            if favorite == nil {
                favorite = Favorite(context: context)
            }
            favorite.title = lbTitle.text
            favorite.date = lbData.text
            favorite.explanation = lbDescription.text
            favorite.mediatype = mediaType
            favorite.url = url
            
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func requestImage(formattedDateForRequest: String) {
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        let authService = AuthService()
        authService.getImage(date: formattedDateForRequest) { result in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.stvInfo.isHidden = false
                self.stvDatePicker.isHidden = false
                self.ivImage.isHidden = false
                self.lbData.isHidden = false
            }
            switch result {
            case .success(let dados):
                
                self.titulo = dados.title
                if self.isFavorite(title: dados.title) {
                    self.bbiStar.image = UIImage(systemName: "star.fill")
                } else {
                    self.bbiStar.image = UIImage(systemName: "star")
                }
                
                self.lbTitle.text = dados.title
                self.lbDescription.text = dados.explanation
                self.url = dados.url
                self.mediaType = dados.mediaType
                
                if (dados.mediaType == "video") {
                    self.viVideo.isHidden = false
                    let videoLoader = VideoLoader(webView: self.webView)
                    videoLoader.loadVideo(from: dados.url)
                } else {
                    self.viVideo.isHidden = true
                    if let url = URL(string: dados.url) {
                        self.ivImage.kf.indicatorType = .activity
                        self.ivImage.kf.setImage(with: url)
                    } else {
                        self.ivImage.image = nil
                    }
                }
                
            case .failure(_):
                self.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: nil, message: "Erro ao recuperar dados do servidor", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: sender.date)
    }
    
    func updateDateLabel(date: Date) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy"
        self.lbData.text = displayFormatter.string(from: date)
        self.date = displayFormatter.string(from: date)
        
        let requestFormatter = DateFormatter()
        requestFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateForRequest = requestFormatter.string(from: date)
        requestImage(formattedDateForRequest: formattedDateForRequest)
        
    }
    
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
}

