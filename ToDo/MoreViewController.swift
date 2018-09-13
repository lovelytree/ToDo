//
//  MoreViewController.swift
//  ToDo
//
//  Created by yolanda on 9/6/18.
//  Copyright © 2018 yolanda. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    let dataController = DataController()
    var searchActive : Bool = false
    
    var toDos = [ToDoDataModule]()
    var filteredToDos = [ToDoDataModule]()
    var openToDos = [ToDoDataModule]()
    var closedToDos = [ToDoDataModule]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segment: UISegmentedControl!
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        searchActive = false
        if segment.selectedSegmentIndex == 1 {
            // open to do list
            openToDos = toDos.filter({ (todo : ToDoDataModule) -> Bool in
                return todo.isCompleted == "0"
            })
        }else{
            // completed to do list
            closedToDos = toDos.filter({ (todo : ToDoDataModule) -> Bool in
                return todo.isCompleted == "1"
            })
        }
        self.tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        segment.isHidden = true
        filteredToDos = toDos.filter({ (toDo:ToDoDataModule) -> Bool in
            return toDo.item.lowercased().contains(searchText.lowercased())
        })
        searchActive = true
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        segment.isHidden = false
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (searchActive) {
            return filteredToDos.count
        }else if segment.selectedSegmentIndex == 0{
            return toDos.count
        }else if segment.selectedSegmentIndex == 1{
            return openToDos.count
        }else{
            return closedToDos.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : ToDosTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDosTableViewCell
        
        var todo : ToDoDataModule

        if (searchActive) {
         //   print("search")
            todo = filteredToDos[indexPath.row] as ToDoDataModule
        }else if segment.selectedSegmentIndex == 0{
            // All
            todo = toDos[indexPath.row] as ToDoDataModule
        }else if segment.selectedSegmentIndex == 1{
           // print("Open")
            todo = openToDos[indexPath.row] as ToDoDataModule
        }else{
           // print("Closed")
            todo = closedToDos[indexPath.row] as ToDoDataModule
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // delete, trailing swip
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            var todo : ToDoDataModule
            
            if (searchActive) {
                todo = filteredToDos[indexPath.row]
                filteredToDos.remove(at: indexPath.row)
            }else if segment.selectedSegmentIndex == 0 {
                todo = toDos[indexPath.row]
            }else if segment.selectedSegmentIndex == 1{
                todo = openToDos[indexPath.row]
                openToDos.remove(at: indexPath.row)
            }else{
                todo = closedToDos[indexPath.row]
                closedToDos.remove(at: indexPath.row)
            }
            
            
            if let index = toDos.index(of: todo){
                toDos.remove(at: index)
            }
    
            tableView.reloadData()
            dataController.saveData(toDos: toDos)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchActive = false
        segment.selectedSegmentIndex = 0
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "toDoCell")
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        toDos = dataController.loadData()
        if (searchActive) {
            filteredToDos = toDos.filter({ (toDo:ToDoDataModule) -> Bool in
                return toDo.item.lowercased().contains(searchBar.text!.lowercased())
            })
        }else if segment.selectedSegmentIndex == 1{
            openToDos = toDos.filter({ (todo : ToDoDataModule) -> Bool in
                return todo.isCompleted == "0"
            })
        }else if segment.selectedSegmentIndex == 2{
            closedToDos = toDos.filter({ (todo : ToDoDataModule) -> Bool in
                return todo.isCompleted == "1"
            })
        }

        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moreDetailedSegue", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let detailedViewController = segue.destination as! DetailedViewController
        if (searchActive) {
            detailedViewController.toDo = filteredToDos[self.tableView.indexPathForSelectedRow!.row]
        }else if segment.selectedSegmentIndex == 0{
            detailedViewController.toDo = toDos[self.tableView.indexPathForSelectedRow!.row]
        }else if segment.selectedSegmentIndex == 1{
            detailedViewController.toDo = openToDos[self.tableView.indexPathForSelectedRow!.row]
        }else{
            detailedViewController.toDo = closedToDos[self.tableView.indexPathForSelectedRow!.row]
        }
      
    }
    

}
