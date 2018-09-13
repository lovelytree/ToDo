//
//  DataModule.swift
//  ToDo
//
//  Created by yolanda on 8/31/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import Foundation


class ToDoDataModule: NSObject, NSCoding {
    var item: String
    var dueDate: Date
    var isCompleted: String
    
    //
    init(item: String, dueDate: Date, isCompleted: String) {
        self.item = item
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
    
    // nsobject decode
    required init?(coder aDecoder: NSCoder) {
        if let item = aDecoder.decodeObject(forKey: "item") as? String {
            self.item = item
        }else{
            print("ToDoDataModule item is null")
            return nil
        }
        
        if let dueDate = aDecoder.decodeObject(forKey: "dueDate") as? Date{
            self.dueDate = dueDate
        }else{
            print("ToDoDataModule dueDate is null")
            return nil
        }
        
        if let isCompleted = aDecoder.decodeObject(forKey: "isCompleted") as? String {
            self.isCompleted = isCompleted
        }else{
            print("ToDoDataModule isCompleted is null")
            return nil
        }
        
       // self.item =  aDecoder.decodeObject(forKey: "item") as! String
       // self.dueDate = aDecoder.decodeObject(forKey: "dueDate") as! NSDate
       // self.isCompleted = aDecoder.decodeObject(forKey: "isCompleted") as! Bool
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.item, forKey: "item")
        aCoder.encode(self.dueDate, forKey: "dueDate")
        aCoder.encode(self.isCompleted, forKey: "isCompleted")
    }
    
}

