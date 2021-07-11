//
//  TodoListTableViewController.swift
//  RealmDatabase_Sample
//
//  Created by Ravikumar on 7/10/21.
//

import UIKit
import RealmSwift
import Realm



class TodoListTableViewController: UITableViewController {

    let realm = try! Realm()
    var itemArray:Results<Item>?
    
    var selectedCategory:Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    @IBAction func add_todoList(_ sender: Any) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.name = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch  {
                    print("Error saving new item , \(error)")
                }
            }
            self.loadItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textfield = alertTextfield
        }
        alert.addAction(action)
        self.present(alert, animated: true) {
        }
    }
    
    func save(category:Category) {
        do {
            try realm.write(){
                realm.add(category)
            }
        } catch  {
            print("error ...........\(error)")
        }
    }
    func loadItems()  {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "name", ascending:true)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todolist", for: indexPath)

        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = itemArray?[indexPath.row].name ?? "No Item added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
            try realm.write{
                //...............To Delete the Items
             //   realm.delete(item)
                item.done = !item.done
            }
            }catch {
                print("Error saving done status \(error)")
            }
        }
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension TodoListTableViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let predicate = NSPredicate(format: "name CONTAINS[cd] %@",searchBar.text!)
//        itemArray = itemArray?.filter(predicate).sorted(byKeyPath: "name", ascending: true)
        
        itemArray = itemArray?.filter("name CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    
}


