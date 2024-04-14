//
//  DetailViewController.swift
//  PexelFeed
//
//  Created by yibin on 2024/4/14.
//

import UIKit
import SnapKit
import Alamofire

class DetailViewController: UIViewController {
    var photo:Photo?
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var photographerLabel:UILabel = {
        let label = UILabel(frame: CGRectZero)
        return label
    }()

    lazy var photoDetailLabel:UILabel = {
        let label = UILabel(frame: CGRectZero)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Image Detail"

        self.view.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(400)
        }

        self.view.addSubview(self.photoDetailLabel)
        self.photoDetailLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.imageView.snp_bottomMargin).offset(20)
        }
        
        self.view.addSubview(self.photographerLabel)
        self.photographerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.photoDetailLabel.snp_bottomMargin).offset(10)
        }
        
        if let photo = self.photo {
            self.photographerLabel.text = "Author:\(photo.photographer)"
            self.photoDetailLabel.text = photo.alt
        }

        self.loadImage()
    }
    
    func loadImage() {
        guard let photo = self.photo else {
            return
        }
        
        let imageUrl = photo.src.large

        if let data = ImageCache.shared.cache[imageUrl] {
            self.imageView.image = UIImage(data: data)
        } else {
            AF.request(imageUrl).responseData { response in
                if let data = response.data {
                    ImageCache.shared.cache[imageUrl] = data
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        
    }

}
