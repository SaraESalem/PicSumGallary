import Foundation
import UIKit


class APIClient {
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(),show_loading_indicator:Bool = true, completion:@escaping (T?, Error?)->Void) -> DataRequest {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = show_loading_indicator
        let ActivityIndicator = CActivityIndicator()
        if show_loading_indicator{
            if route.showIndicator{
                ActivityIndicator.start()
            }
        }
        return request(route).responseData(completionHandler: { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            ActivityIndicator.stop()
            
            guard let requestResponse = response.response else{return}
            if requestResponse.statusCode == 401{
                
                completion(nil,nil)
            }
            else{
                switch response.result{
                case .success(let value):
                   // print(String(data: value, encoding: .utf8))
                    do{
                        let DataResponsed = try JSONDecoder().decode(T.self, from: value)
                        completion(DataResponsed,nil)
                    }
                    catch{
                        print("ERROR -> IN DECODE")
                        print(error)
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil,  error)
                }
            }
        }
        )
    }
    
    
    static func listPhotos<T:Decodable>(page:Int,completion:@escaping (T?,Error?)->Void) {
        performRequest(route: APIRouter.listPhotos(page: page), completion: completion)
    }
    
}


