//
//  CatagoryViewController.swift
//  Todo List
//
//  Created by Rohit sahu on 28/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import UIKit
import CoreData


class CatagoryViewController: UITableViewController{
    
    let context = (UIApplication.shared.delegate  as! AppDelegate).persistentContainer.viewContext
    var catagoryArrey = [ItemCategories]()

    override func viewDidLoad() {
        super.viewDidLoad()
       
    print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! )
     loadData()
    }
    
//MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArrey.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        let selectedItem = catagoryArrey[indexPath.row]
       
        cell.textLabel?.text = selectedItem.categoryTitle
    
        return cell
    }
    
    
    
    
//MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination  as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = catagoryArrey[indexPath.row]
        }
        
    }
    
    
    //MARK: - Add BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Item", message: "new catagory", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "add", style:.destructive) { action  in
        
            let newItem = ItemCategories(context: self.context)
            newItem.categoryTitle = textField.text!
            self.catagoryArrey.append(newItem)
            self.saveData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "" 
            textField  = alertTextField
           }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
        
    }
    
       
    //MARK: - CURD
        
        func saveData() {

            do{
                try context.save()
            }catch {
            
                print("error on saving categories :\(error.localizedDescription)")
            }
            self.tableView.reloadData()
        }

    func loadData(with request: NSFetchRequest<ItemCategories> = ItemCategories.fetchRequest() )  {
            
            do{
                catagoryArrey = try context.fetch(request)
            }catch{
                print("error on loading categories :\(error.localizedDescription)")
            }
            tableView.reloadData()
        }

    
}


//MARK: - SEARCHBAR DELGATE

extension CatagoryViewController: UISearchBarDelegate{
       public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
            let request : NSFetchRequest<ItemCategories> = ItemCategories.fetchRequest()
            
                request.predicate =  NSPredicate(format: "categoryTitle CONTAINS[cd] %@", searchBar.text! )
            
            request.sortDescriptors = [NSSortDescriptor(key: "categoryTitle", ascending: true)]
            
            
            loadData(with: request)
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
