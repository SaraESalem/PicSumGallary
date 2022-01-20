//
//  PhotosTableViewCell.swift
//  PicSumGallary
//
//  Created by SARA on 19/01/2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var imageName: UIImageView!{
        didSet{
            imageName.layer.cornerRadius = 8
            imageName.clipsToBounds = true
        }
    }
    
    
}
