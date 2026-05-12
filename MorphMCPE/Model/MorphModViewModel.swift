//
//  MorphModViewModel.swift
//  MorphMCPE
//
//  Created by son on 03/01/2024.
//

import Foundation
import SwiftyJSON

let API_Token = "75fc7410fc4ebcab38d2ac379e1ed4d05780861270681123082ec376d364e3a5"
let CloudID = "iCloud.com.jalistudio2020.ModsMinecraft"

class MorphModViewModel{
    
    static var shared = MorphModViewModel()
    
    func getDownloadLink(namePack : String!,completion : @escaping (String?) -> ()){
        
        var downloadLink : String?
        
        let body = "{\"query\":{\"recordType\":\"MorphMod\",\"filterBy\": [{\"fieldName\":\"name\",\"comparator\":\"EQUALS\",\"fieldValue\": {\"value\": \"\(namePack!)\"},\"type\": \"STRING\"}]},\"resultsLimit\":1}"
        
        let urlString = "https://api.apple-cloudkit.com/database/1/" + CloudID + "/production/public/records/query?ckAPIToken=" + API_Token
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(body.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do{
                let json = try JSON.init(data: data)
                
                let object = json["records"][0]
                
                if let link = object["fields"]["file"]["value"]["downloadURL"].rawValue as? String{
                    
                    downloadLink = link.replacingOccurrences(of: "${f}", with: "MorphMod.mcaddon")
                }
                
            }catch{
                
            }
            
            completion(downloadLink)

        }

        task.resume()

    }
    
    func getTutorial(completion : @escaping (String?,String?) -> ()){
        
        var htmlString : String?
        var youtubeID : String?
        
        let body = "{\"query\":{\"recordType\":\"Tutorial\"},\"resultsLimit\":1}"
        
        let urlString = "https://api.apple-cloudkit.com/database/1/" + CloudID + "/production/public/records/query?ckAPIToken=" + API_Token
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(body.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil,nil)
                return
            }
            
            do{
                let json = try JSON.init(data: data)
                
                let object = json["records"][0]
                
                htmlString = object["fields"]["html"]["value"].rawValue as? String
                youtubeID = object["fields"]["youtubeID"]["value"].rawValue as? String
                
            }catch{
                
            }
            
            completion(htmlString,youtubeID)

        }

        task.resume()
    }
}
