//
//  FavoriteViewController.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 01/02/25.
//

import UIKit
import Kingfisher
import AVKit
import WebKit
import CoreData

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbData: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var viVideo: UIView!
    
    var fetchResultController: NSFetchedResultsController<Favorite>!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    var date: String = ""
    var webView: WKWebView!
    var favorite: Favorite!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        webView = WKWebView(frame: viVideo.bounds, configuration: webConfiguration)
        viVideo.addSubview(webView)

        lbTitle.text = favorite.title
        lbData.text = favorite.date
        lbDescription.text = favorite.explanation
        
        if (favorite.mediatype == "video") {
            self.viVideo.isHidden = false
            let videoLoader = VideoLoader(webView: webView)
            videoLoader.loadVideo(from: favorite.url!)
        } else {
            self.viVideo.isHidden = true
            if let url = URL(string: favorite.url!) {
                self.ivImage.kf.indicatorType = .activity
                self.ivImage.kf.setImage(with: url)
            } else {
                self.ivImage.image = nil
            }
        }
    }

}
