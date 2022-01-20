//
//  HomeInteractor.swift
//  PicSumGallary
//
//  Created by sara salem on 19/01/2022.
//

import Foundation


class PhotosInteractor{
    

    
    func listPhotos(page:Int,completionHandler: @escaping([PhotosModel]?, Error?)->()){
        
        APIClient.listPhotos(page:page) { (response:[PhotosModel]?, error:Error?) in
            if let response = response{
                
                completionHandler(response,nil)
            }else{
                completionHandler(nil,error)
            }
        }
    }
}
