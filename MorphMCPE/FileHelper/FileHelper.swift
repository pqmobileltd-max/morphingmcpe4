//
//  FileHelper.swift
//  MorphMCPE
//
//  Created by son on 6/9/22.
//

import ZIPFoundation
import Foundation
//import FileProvider

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

let fileManager = FileManager.default

class FileHelper{

    class func createFolder(name : String) -> URL{
        let folder = documentsDirectory.appendingPathComponent(name)
        
        var isDir : ObjCBool = false
        
        func create(){
            try? fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        if fileManager.fileExists(atPath: folder.path,isDirectory: &isDir){
            if isDir.boolValue{
                
            }else{
                print("file exist but is not a directory")
                create()
            }
        }else{
            print("file does not a directory")
            create()
        }
        return folder.absoluteURL
    }
    
    class func copyDefaultPack(name : String){
        
        let defaultFolder = Bundle.main.resourceURL!.appendingPathComponent(name).path

        let destFolder = documentsDirectory.appendingPathComponent(name).path
        
        if fileManager.fileExists(atPath: destFolder){
            do{
                try fileManager.removeItem(atPath: destFolder)
            }catch(let error){
                print("delete file error.......\(error.localizedDescription)")
            }
        }
        
        copyFiles(from: defaultFolder, dest: destFolder)
    }
    

    
    class func copyFiles(from : String,dest : String){
        do{
            let list = try fileManager.contentsOfDirectory(atPath: from)
            
            try? fileManager.copyItem(atPath: from, toPath: dest)
            
            for file in list {
                try? fileManager.copyItem(atPath: "\(from)/\(file))", toPath: "\(dest)/\(file)")
                
                print(file)
            }
        }catch(let error){
            print("copyFiles error.......\(error.localizedDescription)")
        }
    }
    
    class func createCapeSkin(cape : UIImage){
        let dest = documentsDirectory.appendingPathComponent("cape").appendingPathComponent("textures").appendingPathComponent("entity").appendingPathComponent("custom.png")
        
        if fileManager.fileExists(atPath: dest.path){
            do{
                try fileManager.removeItem(atPath: dest.path)
            }catch(let error){
                print("delete file error.......\(error.localizedDescription)")
            }
        }
        
        do{
            try cape.pngData()?.write(to: dest)
        }catch(let error){
            print("write file error.......\(error.localizedDescription)")
        }
    }
    
    class func creatPackIcon(icon : UIImage,folder : String){
        let dest = documentsDirectory.appendingPathComponent(folder).appendingPathComponent("pack_icon.png")
        
        if fileManager.fileExists(atPath: dest.path){
            do{
                try fileManager.removeItem(atPath: dest.path)
            }catch(let error){
                print("delete file error.......\(error.localizedDescription)")
            }
        }
        
        do{
            try icon.pngData()?.write(to: dest)
        }catch(let error){
            print("write file error.......\(error.localizedDescription)")
        }
    }
    
    class func zip(mod_name : String,folder : String,progress : Progress?) -> URL?{
        
        let premiumFolder = documentsDirectory.appendingPathComponent(folder)
        
        let destURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(mod_name).mcpack")!
        
        if fileManager.fileExists(atPath: destURL.path){
            do{
                try fileManager.removeItem(atPath: destURL.path)
            }catch(let error){
                print("delete file error.......\(error.localizedDescription)")
            }
        }
        
        do{
            try fileManager.zipItem(at: premiumFolder, to: destURL, shouldKeepParent: false, compressionMethod: .none, progress: progress)
            return destURL
        }catch(let error){
            print("zip error.......\(error.localizedDescription)")
            return nil
        }
    }
    

    
    class func createCapeManifestFile(name : String){

        let json = "{\"format_version\":2,\"header\":{\"description\":\"CustomcapesforMinecraftBedrock\",\"name\":\"\(name)\",\"uuid\":\"\(UUID().uuidString)\",\"version\":[1,0,3],\"min_engine_version\":[1,13,0]},\"modules\":[{\"description\":\"\",\"type\":\"resources\",\"uuid\":\"\(UUID().uuidString)\",\"version\":[1,0,3]}],\"subpacks\":[{\"folder_name\":\"normal\",\"name\":\"Normalcape\",\"memory_tier\":1},{\"folder_name\":\"realistic\",\"name\":\"Realisticcape\",\"memory_tier\":1}]}"
        
        let manifestFile = documentsDirectory.appendingPathComponent("cape/manifest.json")
        
        if fileManager.fileExists(atPath: manifestFile.path){
            do{
                try fileManager.removeItem(atPath: manifestFile.path)
            }catch(let error){
                print("delete file error.......\(error.localizedDescription)")
            }
        }
        
        do{
            try json.write(to: manifestFile, atomically: true, encoding: .utf8)
        }catch(let error){
            print("write file error.......\(error.localizedDescription)")
        }
        
    }
}

