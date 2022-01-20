//
//  HomeRouter.swift
//  PicSumGallary
//
//  Created by sara salem on 19/01/2022.
//

import UIKit

class PhotosRouter{
    
    
    var MainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func goToPhotoDetails(photo:PhotosModel?,from view: UIViewController?){
        
        let vc = MainStoryboard.instantiateViewController(withIdentifier: "PhotoDetailsViewController") as! PhotoDetailsViewController
        vc.photo = photo
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
