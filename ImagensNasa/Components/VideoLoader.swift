//
//  VideoLoader.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 02/02/25.
//

import WebKit

class VideoLoader {
    private var webView: WKWebView
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    func loadVideo(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        if let youtubeID = extractYouTubeVideoID(from: urlString) {
            let embedURL = "https://www.youtube.com/embed/\(youtubeID)?rel=0&playsinline=1"
            loadWebView(urlString: embedURL)
        } else if let vimeoID = extractVimeoVideoID(from: urlString) {
            let embedURL = "https://player.vimeo.com/video/\(vimeoID)?portrait=0&color=c8b3df"
            loadWebView(urlString: embedURL)
        } else {
            print("Formato de vídeo não suportado")
        }
    }
    
    private func loadWebView(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func extractYouTubeVideoID(from url: String) -> String? {
        let pattern = "(?<=v=|v\\/|embed\\/|youtu\\.be\\/|\\/v\\/)([a-zA-Z0-9_-]{11})"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(url.startIndex..., in: url)
        
        if let match = regex?.firstMatch(in: url, options: [], range: range) {
            return (url as NSString).substring(with: match.range)
        }
        return nil
    }
    
    func extractVimeoVideoID(from url: String) -> String? {
        let pattern = "vimeo\\.com/(?:video/)?(\\d+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(url.startIndex..., in: url)
        
        if let match = regex?.firstMatch(in: url, options: [], range: range) {
            return (url as NSString).substring(with: match.range(at: 1))
        }
        return nil
    }
}
