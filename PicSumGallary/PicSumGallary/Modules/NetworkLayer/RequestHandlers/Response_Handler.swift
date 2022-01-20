import Foundation
import UIKit
class Response_Handler{
    public func handleResponse<T:Codable>(response:Server_Response<T>?,error:Error?)->(data:T?,success:Bool){
        if let error = error{
            self.showError(error: error.localizedDescription)
            return (nil,false)
        }
        else  if let response = response{
            if let code = response.code{
                if code == 402{
                    return(nil,false)
                }
                else if let status = response.status{
                    if status == 1{
                        if let data = response.data{
                            return (data,true)
                        }
                        else{
                            return (nil,true)
                        }
                    }
                    else{
                        if let message = response.message{
                           self.showError(error: message)
                        }
                        return (nil,false)
                    }
                }

            }
        }
        return (nil,false)
    }
    
    private func showError(error:String){
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        var alert = UIAlertController()
        let ok = UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .default) { (action) in
        }
        alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(ok)
        keyWindow.rootViewController!.present(alert,animated: true)
    }
 
}
