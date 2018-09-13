//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by yolanda on 8/29/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    private var toDoItems = [ToDoDataModule]()
    private var currentToDo = [ToDoDataModule]()
    private var futureToDo = [ToDoDataModule]()
    let dataController = DataController()
    
    @IBOutlet var table: UITableView!
    @IBAction func AddItem(_ sender: Any) {
        self.performSegue(withIdentifier: "addItemSegue", sender: nil)
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        if section == 0 {
            viewLabel.text = "Today"
        }else{
            viewLabel.text = "Future"
        }
        viewLabel.textColor = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
        view.addSubview(viewLabel)
        tableView.addSubview(view)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return currentToDo.count
        }
        return futureToDo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:ToDosTableViewCell = self.table.dequeueReusableCell(withIdentifier:"toDoCell" , for: indexPath ) as! ToDosTableViewCell
        
        var todo : ToDoDataModule
        if indexPath.section == 0 {
            todo = currentToDo[indexPath.row] as ToDoDataModule
        }else{
            todo = futureToDo[indexPath.row] as ToDoDataModule
        }
        
        // itme display in table
        cell.item.text = todo.item
        
        // dueDate display in table
        let myDateFormat = DateFormatter.dateFormat(fromTemplate: "MM/dd hh:mm", options:0, locale: NSLocale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = myDateFormat
        cell.date.text = dateFormatter.string(from: todo.dueDate)
        
        // is Completed display in table
        if todo.isCompleted == "0" {
            cell.status_image.image = UIImage(named: "open")
        }else{
            // todo.isCompleted == "1"
            cell.status_image.image = UIImage(named: "done")
        }
        
        return cell
    }
 

    // delete, trailing swip
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            var toDo : ToDoDataModule
            if indexPath.section == 0 {
                toDo = self.currentToDo[indexPath.row]
            }else{
                toDo = self.futureToDo[indexPath.row]
            }
            
            if let index = toDoItems.index(of: toDo){
                if indexPath.section == 0{
                    currentToDo.remove(at: indexPath.row)
                }else{
                    futureToDo.remove(at: indexPath.row)
                }
                toDoItems.remove(at: index)
            }
            table.reloadData()
            dataController.saveData(toDos: toDoItems)
        }
        
    }
    
    // mark it to completed, leading swipe
    func tableView(_ tableView: UITableView,leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // style: .normal
        // style: .destructive
        let closeAction = UIContextualAction(style: .normal, title: "Mark as Done") { (action, view, boolValue) in
            var toDo : ToDoDataModule
            if indexPath.section == 0 {
                toDo = self.currentToDo[indexPath.row]
            }else{
                toDo = self.futureToDo[indexPath.row]
            }
            
            if let index = self.toDoItems.index(of: toDo){
                if indexPath.section == 0 {
                    self.currentToDo[indexPath.row].isCompleted = "1"
                }else{
                    self.futureToDo[indexPath.row].isCompleted = "1"
                }
                self.toDoItems[index].isCompleted = "1"
            }
            self.table.reloadData()
            self.dataController.saveData(toDos: self.toDoItems)
        }
        
        closeAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [closeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toDoItems = dataController.loadData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYY-MM-dd"
        
        currentToDo = toDoItems.filter { (todo : ToDoDataModule) -> Bool in
            let todoDate = dateFormatter.string(from: todo.dueDate)
            let now = dateFormatter.string(from: Date())
            return todoDate.compare(now).rawValue == 0
        }
        
        futureToDo = toDoItems.filter { (todo : ToDoDataModule) -> Bool in
            let todoDate = dateFormatter.string(from: todo.dueDate)
            let now = dateFormatter.string(from: Date())
            return todoDate.compare(now).rawValue > 0
        }
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.separatorStyle = .none
        self.table.isScrollEnabled = true
        
        self.table.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "toDoCell")
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDoDetailedSegue", sender: nil)
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDoDetailedSegue", let detailedViewController = segue.destination as? DetailedViewController, let rowIndex = self.table.indexPathForSelectedRow?.row{
            let selectedSection = self.table.indexPathForSelectedRow?.section
            if selectedSection == 0 {
                detailedViewController.toDo = self.currentToDo[rowIndex]
            }else{
                detailedViewController.toDo = self.futureToDo[rowIndex]
            }
        }else if segue.identifier == "addItemSegue" {
            if let addItemsViewController = segue.destination as? AddItemsViewController {
                addItemsViewController.type = "Add"
            }
        }
        
    }
 

}
