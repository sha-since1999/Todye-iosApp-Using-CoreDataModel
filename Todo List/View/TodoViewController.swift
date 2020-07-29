//
//  ViewController.swift
//  Todo List
//
//  Created by Rohit sahu on 27/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: SwipeTableViewController{
    var ToDoItems : Results<Item>?  // array of object
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
             loadData()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
    }
    
    //MARK: - table Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  let item  = ToDoItems?[indexPath.row] {
            
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none
            
        } else {
             cell.textLabel?.text = "No Todo Items"
        }
        return cell
    }
    

    
  

//MARK: -TableViewDelegate


override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = ToDoItems?[indexPath.row] {
        do {
            try realm.write{
               // realm.delete(item)       //deletion of todo
                item.done = !item.done
            }
        }catch{
            print(" error in updating data\(error)")
        }
    }
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
//MARK: - Add new item
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item ", message:"", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { action in
            // this define what should happen when user press the addd buttonssss
            if let currentCategory = self.selectedCategory{
                    do{
                       
                        try self.realm.write{
                            let item = Item()
                            item.title = textField.text!
                            item.done = false
                            item.dateCreated = Date()
                            currentCategory.items.append(item)
                           }
                       }catch {
                        print("error on saving data :\(error.localizedDescription)")
                                   }
            }
           
            
                    self.tableView.reloadData()
        
               
        }
        
    alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "write Something "
            textField = alertTextField
    // see here this majar step have to do to save the alert testfield item  bec on click action button this this instantally call the action button and flash everything
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
//MARK: - CURD
    
    func loadData(){
        ToDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
              super.updateModel(at: indexPath)
                do{ try self.realm.write{
                    self.realm.delete((self.ToDoItems![indexPath.row]))
                    }}catch {
                        print("Error in deletin :\(error)" )
                }
                print("item has been deleted")
        
    }


}

extension TodoViewController : UISearchBarDelegate {
   
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ToDoItems = ToDoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        }
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
       
    
}
