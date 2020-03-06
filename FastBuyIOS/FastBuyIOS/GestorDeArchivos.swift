//
//  GestorDeArchivos.swift
//  Fast_Buy_iOS
//
//  Created by null on 3/14/19.
//  Copyright © 2019 chinchilla. All rights reserved.
//

import Foundation
import UIKit

public class GestorDeArchivos
{
    let dstr = "Gestor de archivos: "
    let fm = FileManager.default
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).strings(byAppendingPaths: ["Fast Buy"])[0]
    private var status: Bool = false
    private var fileDateModified: [String:String] = [:]
    
    func initAppDir()
    {
        if fm.fileExists(atPath: path)
        {
            print(dstr,"el directorio de la aplicacion ya existe")
            status = true
            readInfo()
        }
        else
        {
            do
            {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print(dstr,"directorio de la aplicacion creado")
                status = true
            }
            catch
            {
                print(dstr,"no se puede crear el directorio de la aplicacion")
            }
        }
        
        print("FileManager: status < \(status) >")
    }
    
    private func readInfo()
    {
        guard let list = UserDefaults.standard.dictionary(forKey: "file-manager-info") else
        {
            saveInfo()
            return
        }
        
        fileDateModified = list as! [String:String]
        
        status = true
    }
    
    private func saveInfo()
    {
        UserDefaults.standard.set(fileDateModified, forKey: "file-manager-info")
    }
    
    func isOk() -> Bool
    {
        return status
    }
    
    func filePath(fileName:String) -> String
    {
        return path + "/" + fileName
    }
    
    func saveFile(fileName: String, buffer: Data)
    {
        fm.createFile(atPath: filePath(fileName: fileName), contents: buffer, attributes: nil)
    }
    
    func existsFile(fileName:String) -> Bool
    {
        return fm.fileExists(atPath: filePath(fileName: fileName))
    }
    
    func fileLastModified(fileName:String) -> String
    {
        guard let date = fileDateModified[fileName] else
        {
            return ""
        }
        
        return date
    }
    
    func setfileLastModified(fileName:String,strDate:String)
    {
        fileDateModified[fileName] = strDate
        
        saveInfo()
    }
}
