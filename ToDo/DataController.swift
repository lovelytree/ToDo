//
//  DataController.swift
//  ToDo
//
//  Created by yolanda on 8/31/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import Foundation


class DataController {
   
    func saveData(toDos:[ToDoDataModule]){
        let isSuccessSave = NSKeyedArchiver.archiveRootObject(toDos, toFile: self.getDataFilePath())
        
        if isSuccessSave {
            print("DataController: save data successfully")
        }else{
            print("DataController: save data unsuccessfully")
        }
    }
    
    func loadData() ->[ToDoDataModule] {
        var toDos = [ToDoDataModule]()
        let toDoFile = self.getDataFilePath()
        let defaultManager = FileManager()
        if defaultManager.fileExists(atPath: toDoFile){
            print("DataController: file path: " + toDoFile)
            if let toDoData = NSKeyedUnarchiver.unarchiveObject(withFile: toDoFile) as? [ToDoDataModule]{
                toDos = toDoData
            }
            print("DataController: toDos count=",  toDos.count)
        }
        return toDos
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
    
    func getDataFilePath() -> String {
        return self.getDocumentsDirectory().appendingFormat("/todo.txt")
    }
}
