import Foundation



/// Response completion handler beautified.
typealias CallResponse<T> = ((ServerResponse<T>) -> Void)?


/// API protocol, The alamofire wrapper
protocol APIRequestHandler: HandleAlamoResponse {
    
    /// Calling network layer via (Alamofire), this implementation can be replaced anytime in one place which is the protocol itsel, applied everywhere.
    ///
    /// - Parameters:
    ///   - decoder: Codable confirmed class/struct, Model.type.
    ///   - requestURL: Server request.
    ///   - completion: Results of the request, general errors cases handled.
    /// - Returns: Void.
    func callServerWith<T: CodableInit>(_ decoder: T.Type, requestURL: URLRequestConvertible, completion: CallResponse<T>) -> Void
}

extension APIRequestHandler  {

    func callServerWith<T: CodableInit>(_ decoder: T.Type, requestURL: URLRequestConvertible, completion: CallResponse<T>) -> Void{
        request(requestURL).validate().responseData {(response) in
            self.handleResponse(response, completion: completion)
        }
    }
}








