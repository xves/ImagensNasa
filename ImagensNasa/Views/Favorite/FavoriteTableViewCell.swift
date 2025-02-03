//
//  FavoriteTableViewCell.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 31/01/25.
//

import UIKit
import WebKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var viVideo: UIView!
    var webView: WKWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with favorite: Favorite) {
        lbTitle.text = favorite.title ?? ""
        lbDate.text = favorite.date ?? ""
        lbDescription.text = favorite.explanation ?? ""
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        webView = WKWebView(frame: viVideo.bounds, configuration: webConfiguration)
        viVideo.addSubview(webView)
        
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
