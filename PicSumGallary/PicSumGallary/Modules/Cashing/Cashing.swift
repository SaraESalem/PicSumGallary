//
//  Cashing.swift
//  PicSumGallary
//
//  Created by SARA on 19/01/2022.
//

import UIKit


class PhotoDataCaching{
 
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    public class func setPhotosData(response:[PhotosModel]){
        let placesData = try! JSONEncoder().encode(response)
        UserDefaults.standard.set(placesData, forKey: "first20items")
       
    }
    
    public class func getPhotosData()->[PhotosModel]{
        if let placeData = UserDefaults.standard.data(forKey: "first20items"){
            let placeArray = try! JSONDecoder().decode([PhotosModel].self, from: placeData)
            return placeArray
        }
        return []
    }
    
    public class func setImageData(imageToCache:UIImage,url: String){
        imageCache.setObject(imageToCache, forKey: url as AnyObject)
       
    }
    
    public class func getImageData(url:String)->UIImage?{
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            return imageFromCache
        }
        return nil
    }
    
    
}
