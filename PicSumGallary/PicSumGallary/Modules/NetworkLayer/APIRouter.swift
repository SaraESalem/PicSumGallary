import UIKit


enum APIRouter: URLRequestConvertible{
    
    case listPhotos(page:Int)
   
    
    //MARK:- HTTPMETHOD
    private var method : HTTPMethod{
        switch self {
            
        case .listPhotos:
            return .get
            
        }
    }
    
    //MARK:- PATH
    private var path:String{
        switch self {
        //MARK:- SESSION
        
        case .listPhotos(let page):
            return "list?page=\(page)&limit=10"
        }
    }
    //MARK:- ENCODING
    internal var encoding : ParameterEncoding{
        switch method {
        case .post,.put:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    internal var Auth : Bool{
        switch self {
        case .listPhotos:
            return false
        default:
            return true
        }
    }
    internal var showIndicator : Bool{
        switch self {
        case .listPhotos:
            return true
        default:
            return false
        }
    }
    //MARK:- ENCODING
    private var parameters:[String:Any]?{
        switch self {
        
        
        default:
            return nil
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.Server.baseURL.asURL()
        print(path)
        var urlRequest = URLRequest(url: URL(string:"\(url)\(path)")!)
        //HTTP METHOD
        urlRequest.httpMethod = method.rawValue
        
        //HEADER
        
        //PARAMETERS
        if let parameters = parameters{
            do{
                print("Parameters \(parameters)")
                
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch{
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        //DEBUG DESCRIPTION
        print("Headers \(urlRequest.allHTTPHeaderFields)")
        print("Request URL \(urlRequest.url)")
        print("Parameters \(urlRequest.httpBody)")
        print("Method \(urlRequest.httpMethod)")
        
        return try! encoding.encode(urlRequest, with: parameters)
    }
}
