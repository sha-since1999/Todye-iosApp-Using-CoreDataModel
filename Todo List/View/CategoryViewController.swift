//
//  CatagoryViewController.swift
//  Todo List
//
//  Created by Rohit sahu on 28/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryViewController: UITableViewController{
    
    var catagoryArrey : Results<Category>!  // this is auto updating Container (geericType)
   
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! )
     
        loadData()
    }
    
//MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArrey?.count ?? 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        let selectedItem = catagoryArrey?[indexPath.row]
       
        cell.textLabel?.text = selectedItem?.name ?? "no categoreis"
    
        return cell
    }
    
    
    
    
//MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination  as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = catagoryArrey?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Add BUTTON PRESSED
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Item", message: "new catagory", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "add", style:.destructive) { action  in
        
            let newItem = Category()
            newItem.name = textField.text!

            self.saveData(newItem)

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "" 
            textField  = alertTextField
           }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
        
    }
    
       
    //MARK: - CURD IN REAlM
 
    func saveData(_ category: Category) {
            do{
                
                try  realm.write{
                realm.add(category)
                }
                
            }catch{
                print("error on loading categories :\(error.localizedDescription)")
            }
            
            self.tableView.reloadData()
        }

    func loadData()  {

        catagoryArrey = realm.objects(Category.self)
        
            tableView.reloadData()
        }


}


//MARK: - SEARCHBAR DELGATE

extension CategoryViewController: UISearchBarDelegate{
       public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        catagoryArrey = catagoryArrey?.filter(NSPredicate(format: "name CONTAINS %@", searchBar.text!)).sorted(byKeyPath: "name", ascending: true)
             
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

//MARK: - Swipe cell Delegate method
extension  CategoryViewController: SwipeTableViewCellDelegate{
      func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
          guard orientation == .right else { return nil }

          let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print(" item has been delted")          }

          // customize the action appearance
          deleteAction.image = UIImage(named: "delete")

          return [deleteAction]
      }
}
