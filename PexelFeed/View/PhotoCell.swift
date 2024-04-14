//
//  PhotoCell.swift
//  PexelFeed
//
//  Created by yibin on 2024/4/14.
//

import UIKit
import SnapKit
import Alamofire

class PhotoCell:UITableViewCell {
    var photo:Photo!
    var photoImageViewContainer:UIView!
    var photoImageView:UIImageView!
    var photographerLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cornerRadius = 10.0
        
        self.photoImageViewContainer = UIView()
        self.photoImageViewContainer.backgroundColor = .white
        self.photoImageViewContainer.layer.cornerRadius = cornerRadius
        self.photoImageViewContainer.layer.shadowColor = UIColor.black.cgColor
        self.photoImageViewContainer.layer.shadowOpacity = 0.5
        self.photoImageViewContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        self.contentView.addSubview(self.photoImageViewContainer)
        
        self.photoImageViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.bottom.equalTo(self.contentView.snp_bottomMargin).offset(-10)
        }
        
        self.photoImageView = UIImageView(frame: CGRectMake(10, 10, contentView.frame.width - 20, 180))
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.cornerRadius = cornerRadius
        
        self.contentView.addSubview(self.photoImageView)
        
        self.photoImageView.snp.remakeConstraints { make in
            make.edges.equalTo(self.photoImageViewContainer)
        }
        
        self.photographerLabel = UILabel(frame: CGRectMake(10, 200, contentView.frame.width - 20, 30))
        self.photographerLabel.textColor = .black
        self.contentView.addSubview(self.photographerLabel)
        
        self.photographerLabel.snp.remakeConstraints { make in
            make.left.equalTo(self.photoImageViewContainer.snp_rightMargin).offset(20)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(30)
        }
    }
    
    
    func configure(with photo:Photo) {
        self.photo = photo
        self.photographerLabel.text = "Author:\(photo.photographer)"
        self.photoImageView.image = nil
        
        if let data = ImageCache.shared.cache[photo.src.small] {
            self.photoImageView.image = UIImage(data: data)
        } else {
            AF.request(photo.src.small).responseData { response in
                if let data = response.data {
                    if photo.src.small == self.photo.src.small {
                        self.photoImageView.image = UIImage(data: data)
                    }
                    
                    ImageCache.shared.cache[photo.src.small] = data
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
