import Foundation



protocol HandleAlamoResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponse<T: CodableInit>(_ response: DataResponse<Data>, completion: CallResponse<T>)
}

extension HandleAlamoResponse {
    
    func handleResponse<T: CodableInit>(_ response: DataResponse<Data>, completion: CallResponse<T>) {
        switch response.result {
        case .failure(let error):
            completion?(ServerResponse<T>.failure(error as? LocalizedError))
        case .success(let value):
            do {
                let modules = try T(data: value)
                completion?(ServerResponse<T>.success(modules))
            }catch {
                completion?(ServerResponse<T>.failure(error as? LocalizedError))
            }
        }
    }
    
}
