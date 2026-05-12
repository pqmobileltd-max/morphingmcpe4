//
//  AppViewModel.swift
//  MorphMCPE
//
//  Created by son on 30/5/24.
//

import Foundation
import SwiftyJSON

class AppViewModel{
    
    static var shared = AppViewModel()
    
    var app_ctrl = true//false
    
    public var isMoreThanOneHour = false
    
    init(){
        isMoreThanOneHour = isMoreThanOneHourSinceSaved()
    }
    
    func getAppValue(completion : @escaping (Bool) -> ()){
        
        
        let body = "{\"query\":{\"recordType\":\"App\"},\"resultsLimit\":1}"
        
        let urlString = "https://api.apple-cloudkit.com/database/1/" + CloudID + "/production/public/records/query?ckAPIToken=" + API_Token
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(body.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                
                completion(false)
                return
            }
            
            do{
                let json = try JSON.init(data: data)
                
                
                
                let object = json["records"][0]
                
                if let value = object["fields"]["ctrl"]["value"].rawValue as? Int64{
                    
                    if value == 1{
                        self.app_ctrl = true
                    }
                }
                
            }catch{
                
            }
            
            completion(self.app_ctrl)

        }

        task.resume()

    }
    
    func isMoreThanOneHourSinceSaved() -> Bool {
        let defaults = UserDefaults.standard
        let key = "savedDate"
        
        if let savedDate = defaults.object(forKey: key) as? Date {
            return Date().timeIntervalSince(savedDate) >= 3600 // 3600 giây = 1 giờ
        } else {
            defaults.set(Date(), forKey: key) // lần đầu lưu thời gian
            return false
        }
    }


}
