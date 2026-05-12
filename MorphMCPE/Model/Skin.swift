//
//  Skin.swift
//  MorphMCPE
//
//  Created by son on 6/8/22.
//

import Kanna
import Foundation

class Skin{
    var name : String!
    var iconSkinURL : String!
    var skinURL : String!
    var skin : UIImage?
    var thumb : UIImage?
    
    init(_ name : String,_ iconSkinURL : String,_ skinURL : String){
        self.name = name
        self.iconSkinURL = iconSkinURL
        self.skinURL = skinURL
    }

    func downloadSkin(_ path : String,completion : @escaping (UIImage?) -> ()){
        
        WebUtility.getSource(path) { src in
            if let doc = try? Kanna.HTML(html: src, encoding: .utf8){
                let item = doc.css("form[method=POST] a")[0]
                let link = item["href"]
                
                WebUtility.downloadSkin(link!) { (image) in
                    if let skin = image{
                        self.skin = skin
                        completion(self.skin)
                    }else{
                        completion(nil)
                    }
                }
            }else{
                completion(nil)
            }
        }
    }
    
    func downloadThumb(_ path : String,completion : @escaping (UIImage?) -> ()){
        
        WebUtility.downloadSkin(path) { (image) in
            if let thumb = image{
                self.thumb = thumb
                completion(self.thumb)
            }else{
                completion(nil)
            }
        }
    }
}

class SkinVM{
    
    var pageURL : String!
    
    var skinArr = [Skin]()
    
    var count = 0
    
    init(url : String){
        self.pageURL = url
    }
    
    func refresh(){
        count = 0
        skinArr.removeAll()
    }
    
    func fetchSkins(completion : @escaping () -> ()){
        self.count = self.count + 1
        let url = "\(self.pageURL!)?page=\(self.count)"
        
        var skins : [Skin] = []
        
        WebUtility.getSource(url) { src in
            if let doc = try? Kanna.HTML(html: src, encoding: .utf8){
                var names = [String]()
                var iconSkinURLs = [String]()
                var skinURLs = [String]()
                
                
                
                for item in doc.css("div[class='card-header text-center text-nowrap text-ellipsis small-xs normal-sm p-1']"){
                    if let name = item.text{
                        names.append(name)
                    }
                }

                for item in doc.css("div[class='card-body position-relative text-center checkered p-1'] img"){
                    if let url = item["data-src"]{
                        iconSkinURLs.append(url)
                    }
                }
                
                for item in doc.css("div[class=card mb-2] a"){
                    if let link = item["href"]{
                        skinURLs.append("https://namemc.com\(link)")

                    }
                }
                
                if iconSkinURLs.count * names.count * skinURLs.count == 0{
                    completion()
                    return
                }
                
                if names.count * iconSkinURLs.count * skinURLs.count == 0{
                    completion()
                    return
                }
                
                for i in 0...iconSkinURLs.count - 1{
                    let skin = Skin(names[i],iconSkinURLs[i],skinURLs[i])
                    skins.append(skin)
                }
                
                self.skinArr.append(contentsOf: skins.shuffled())
                
                completion()
            }
        }
    }
    
    
}

