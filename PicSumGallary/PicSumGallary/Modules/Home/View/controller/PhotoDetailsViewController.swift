//
//  PhotoDetailsViewController.swift
//  PicSumGallary
//
//  Created by SARA on 19/01/2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    var photo:PhotosModel?
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var imageName: UIImageView!{
        didSet{
            imageName.layer.cornerRadius = 8
            imageName.clipsToBounds = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "photo in details"
        
        if let _photo = photo{
            authorName.text = _photo.author ?? ""
            widthLabel.text =  "\(_photo.width ?? 0)"
            heightLabel.text = "\(_photo.height ?? 0)"
            urlLabel.text = _photo.url ?? ""
            imageName.setImageWithUrlString(urlStr: _photo.download_url  ?? "", placholder: UIImage(named: "loading"))
            self.view.backgroundColor = imageName.image?.averageColor()
        }
    }
    
    

}

