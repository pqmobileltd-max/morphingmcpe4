//
//  Addon.swift
//  MorphMCPE
//
//  Created by son on 22/7/25.
//

import Foundation
import SwiftyJSON
import FirebaseFunctions

class Addon {
    var title : String?
    var thumbnailURL : String?
    var detail : String?
    var fileURL : String?
    var fileExtension = "mcaddon"
    var modType : String!
    
    init(_ record : JSON,fileExtension : String){
        
        self.fileExtension = fileExtension
        
        if let name = record["fields"]["name"]["value"].rawValue as? String{
            self.title = name
        }
        
        if let modType = record["fields"]["modType"]["value"].rawValue as? String{
            self.modType = modType
        }
        
        if let detail = record["fields"]["description"]["value"].rawValue as? String{
            self.detail = detail
        }
        
        if let thumbnailURL = record["fields"]["image"]["value"]["downloadURL"].rawValue as? String{
            self.thumbnailURL = thumbnailURL.replacingOccurrences(of: "${f}", with: "thumbnail.png")
        }
        
        if let fileURL = record["fields"]["file"]["value"]["downloadURL"].rawValue as? String{
            self.fileURL = fileURL.replacingOccurrences(of: "${f}", with: "mod.\(self.fileExtension)")
        }

    }

}

class AddonViewModel{
    var modArray : [Addon] = []
    
    var searchResult : [Addon] = []
    
    var modType : String!
    
    var fileExtension = "mcaddon"
    
    var reachingLast = false
    
    var continueMarker : String?
    
    init(modType : String) {
        self.modType = modType
    }
    
    func refresh(){
        reachingLast = false
        continueMarker = nil
        modArray.removeAll()
    }
    
    func search(_ name : String){
        self.searchResult.removeAll()
        self.searchResult = self.modArray.filter({$0.title!.lowercased().contains(name.lowercased())})
    }

}



extension AddonViewModel{
    
    
    func fetchingData(_ limit : Int = 21,finish : @escaping () -> ()){
        
//        var modType = "ADDON"
//        
//        if self.modType == "ADDONS"{
//            modType = "ADDON"
//        }
//        
//        if self.modType == "VIP"{
//            modType = "PREMIUM"
//        }
//       
//        if reachingLast{
//            finish()
//            return
//        }
        
        var dataArr : [Addon] = []
        
        let functions = Functions.functions()
        
        let data : [String : Any] = [
            "modType" : modType,
            "continueMarker" : self.continueMarker,
            "resultsLimit" : limit
        ]
        
        functions.httpsCallable("fetchRecordsCloudKit").call(data) { (result, error) in
            
            if let error = error as NSError? {
                print("Error calling Cloud Function: \(error.localizedDescription)")
                finish()
                return
            }
            
            // Check if result is a dictionary (JSON-like structure)
            if let resultData = result?.data as? [String: Any] {
                // Convert the result dictionary to JSON data
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: resultData, options: [])
                    
                    let json = try JSON.init(data: jsonData)["response"]
                    
                    self.continueMarker = json["continuationMarker"].string
                    
                    let records = json["records"]
                    
                    if records.count < 21{
                        self.reachingLast = true
                    }
                    
                    for record in records{
                        let mod = Addon(record.1,fileExtension: self.fileExtension)
                        dataArr.append(mod)
                    }
                    self.modArray.append(contentsOf: dataArr.shuffled())
                    
                    
                    finish()
                    
                } catch {
                    print("Error converting result to JSON: \(error.localizedDescription)")
                    finish()
                }
            } else {
                print("The result is not in the expected format.")
                finish()
            }

        }

    }
}

let PremiumAddonsViewModel = AddonViewModel(modType: "PREMIUM")
let FreeAddonsViewModel = AddonViewModel(modType: "ADDON")
//let AddonsViewModel = CloudModViewModel(modType: ADDONS_RECORD_TYPE,fileExtension: "mcaddon")
//let MapsViewModel = CloudModViewModel(modType: MAPS_RECORD_TYPE,fileExtension: "mcworld")
//let TextureViewModel = ModViewModel(modType: TEXTURES_RECORD_TYPE,fileExtension: "mcpack")
//let SkinsViewModel = ModViewModel(modType: SKINS_RECORD_TYPE,fileExtension: "mcpack")
