//
//  ViewController.swift
//  Todo List
//
//  Created by Rohit sahu on 27/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController{
    var itemArray = [Todo]()      // array of object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : ItemCategories? {
        didSet{
            loadData()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - table Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)

        let item  = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isdone ? .checkmark: .none


        return cell
    }
    

    
  

//MARK: -TableViewDelegate


override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    itemArray[indexPath.row].isdone = !itemArray[indexPath.row].isdone
//    context.delete(itemArray[indexPath.row])
//    itemArray.remove(at: indexPath.row)
    
    saveData()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
//MARK: - Add new item
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item ", message:"", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { action in
            // this define what should happen when user press the addd buttonssss
                
            let item = Todo(context: self.context)
                item.title = textField.text!
                item.isdone = false
                item.parentCategory = self.selectedCategory

                self.itemArray.append(item)
                self.saveData()
        
               
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
    
    func saveData() {

        do{
            try context.save()
        }catch {
        
            print("error on saving data :\(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }

    func loadData(with request: NSFetchRequest<Todo> = Todo.fetchRequest() ,predicate : NSPredicate? = nil )  {
        
        let categoryPredicte = NSPredicate(format: "parentCategory.categoryTitle MATCHES %@", selectedCategory!.categoryTitle! )
        
        
        if let additionaPredicate = predicate {
              request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicte,additionaPredicate])
        }else{
            request.predicate = categoryPredicte
        }
  
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error on loading data :\(error.localizedDescription)")
        }
        tableView.reloadData()
    }


}

extension TodoViewController : UISearchBarDelegate {
   
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request : NSFetchRequest<Todo> = Todo.fetchRequest()
        
        let predicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text! )
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadData(with: request ,predicate: predicate)
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
