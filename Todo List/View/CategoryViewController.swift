//
//  CatagoryViewController.swift
//  Todo List
//
//  Created by Rohit sahu on 28/07/20.
//  Copyright © 2020 sha_since1999. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    var catagoryArrey : Results<Category>!  // this is auto updating Container (geericType)
   
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
           print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! )
            tableView.rowHeight = 80.0
            tableView.separatorStyle = .none
            loadData()
            
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
            }
            navBar.backgroundColor = UIColor.flatGray()
            
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf( UIColor.flatGray(), returnFlat: true )  ]
//                      
        }
        
        
    //MARK: - Table View Data Source
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return catagoryArrey?.count ?? 1
            
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            let selectedItem = catagoryArrey?[indexPath.row]
            cell.textLabel?.text = selectedItem?.name ?? "no categoreis"
            cell.backgroundColor = FlatWhite().darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(catagoryArrey!.count)))
            cell.textLabel?.textColor = ContrastColorOf(HexColor(selectedItem!.color)!, returnFlat: true)
         
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
            newItem.color = (UIColor.randomFlat()).hexValue()

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
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
                do{ try self.realm.write{
                    self.realm.delete(self.catagoryArrey[indexPath.row])
                    }}catch {
                        print("Error in deletin :\(error)" )
                }
              
        
    }


}




//MARK: - SEARCHBAR DELGATE

extension CategoryViewController: UISearchBarDelegate{
       public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        catagoryArrey = catagoryArrey.filter(NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "name", ascending: true)
             
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
