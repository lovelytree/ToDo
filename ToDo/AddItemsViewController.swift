//
//  AddItemsViewController.swift
//  ToDo
//
//  Created by yolanda on 8/29/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController {
    
    var type = "Add"
    var toDo = ToDoDataModule(item: "go to shop", dueDate: Date(), isCompleted: "0" )

    @IBOutlet var toDoItemTextView: UITextView!
    @IBOutlet var toDoDate: UIDatePicker!

    @IBAction func cancelAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelEdit(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
 
    @IBAction func addToDoItem(_ sender: Any) {
        if let textField = toDoItemTextView.text {
            let toDoItem = ToDoDataModule(item: textField, dueDate: toDoDate.date, isCompleted: "0" )
            
            let dataController = DataController()
            var toDos = dataController.loadData()
            if type == "Edit" {
                if let index = toDos.index(where: { (tmpToDo:ToDoDataModule) -> Bool in
                    return (tmpToDo.item == toDo.item && tmpToDo.dueDate == toDo.dueDate && tmpToDo.isCompleted == toDo.isCompleted)
                }) {
                    print("edit item = ", toDo.item)
                    toDos.remove(at: index)
                }
            }
            toDos.append(toDoItem)
            toDos.sort { (toDo1, toDo2) -> Bool in
                return toDo1.dueDate.compare(toDo2.dueDate).rawValue < 0
            }
            
            dataController.saveData(toDos: toDos)
            
            print("Add item: todo item count  = ", toDos.count)

            if type == "Add" {
                self.dismiss(animated: true, completion: nil)
            }else if type == "Edit" {
                // return to root view
                self.navigationController?.popToRootViewController(animated: true)
            }
        

        }
        toDoItemTextView.text = ""
    }
    
    
    func disPlayToDo(){
        toDoItemTextView.text = toDo.item
        toDoDate.setDate(toDo.dueDate, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "Edit" {
            disPlayToDo()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
