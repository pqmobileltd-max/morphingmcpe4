//
//  WebUtility.swift
//  MorphMCPE
//
//  Created by son on 6/8/22.
//

import Foundation
import UIKit
import Foundation
import Alamofire
import AlamofireImage

class WebUtility{
    class func getSource(_ link : String,completion : @escaping (String)->()){
        AF.request(link, method: .get).responseString { (response) in
            let data = response.data
            let pageSource = String(decoding: data!, as: UTF8.self)
            completion(pageSource)
        }
    }
    
    class func downloadSkin(_ link : String,completion : @escaping (UIImage?) -> ()){
        AF.request(link).responseImage { response in
            debugPrint(response)
            if case .success(let image) = response.result {
                completion(image)
            }else{
                completion(nil)
            }
        }
    }
}
