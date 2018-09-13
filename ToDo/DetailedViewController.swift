//
//  DetailedViewController.swift
//  ToDo
//
//  Created by yolanda on 9/7/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var toDo : ToDoDataModule = ToDoDataModule(item: "go to shop",dueDate: Date(),isCompleted: "0")
    
    @IBOutlet var item: UITextView!
    @IBOutlet var date: UILabel!
    @IBOutlet var status: UIImageView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func editToDoItem(_ sender: Any) {
        self.performSegue(withIdentifier: "editToDoItemSegue", sender: nil)
    }
    
    func displayToDo() {
        item.text = toDo.item
        item.isEditable = false
        
        let myDateFormat = DateFormatter.dateFormat(fromTemplate: "MM/dd hh:mm", options:0, locale: NSLocale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = myDateFormat
        date.text = dateFormatter.string(from: toDo.dueDate)
        
        if toDo.isCompleted == "0" {
            status.image = UIImage(named: "open")
        }else{
            status.image = UIImage(named: "done")
            editButton.isEnabled = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayToDo()
        print("DetailedViewController: toDo =", toDo.item)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editToDoItemSegue", let editItemViewController = segue.destination as? AddItemsViewController{
            print("go to edit")
            editItemViewController.type = "Edit"
            editItemViewController.toDo = self.toDo
            
        }
    }
    

}
