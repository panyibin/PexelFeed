//
//  ViewModel.swift
//  PexelFeed
//
//  Created by yibin on 2024/4/14.
//

import UIKit
import Alamofire

class ViewModel {
    var photos:[Photo] = []
    var currentPage = 0
    var isLoading = false
    
    func loadData(completion:@escaping ()->Void) {
        self.currentPage = 0
        self.isLoading = true
        
        self.loadMoreWith(self.currentPage) {[weak self] photos in
            self?.isLoading = false
            self?.photos = photos
            completion()
        }
    }
    
    func loadMore(completion:@escaping ()->Void) {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        let currentPage = self.currentPage + 1
        
        self.loadMoreWith(currentPage) {[weak self] photos in
            if photos.isEmpty {
                completion()
                return
            }
            
            self?.currentPage += 1            
            self?.isLoading = false
            self?.photos.append(contentsOf: photos)
            completion()
        }
    }
    
    func loadMoreWith(_ page: Int, completion:@escaping (_ photos:[Photo])->Void) {
        let apiKey = "0lvPXAsWNpoBVqRzKAEYBTbHx8XYkKbyakYGIvoRdOZXm6vcxFCU7ged"
        let url = "https://api.pexels.com/v1/curated?page=\(page)&per_page=10"
        let headers:HTTPHeaders = ["Authorization":apiKey]
        
        AF.request(url, headers: headers).responseDecodable(of:PexelsResponse.self) { response in
            
            guard let pexelResponse = response.value else {
                completion([])
                return
            }
            
            let photos = pexelResponse.photos
            
            DispatchQueue.main.async {
                completion(photos)
            }
        }
    }

}
