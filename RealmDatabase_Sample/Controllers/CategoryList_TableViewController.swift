//
//  CategoryList_TableViewController.swift
//  RealmDatabase_Sample
//
//  Created by Ravikumar on 7/10/21.
//

import UIKit

import RealmSwift
import Realm

class CategoryList_TableViewController: UITableViewController {

    //.............. Relam
    let realm = try! Realm()
    var arr_categories:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorues()
    }

    @IBAction func add_catList(_ sender: Any) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textfield.text!
            self.save(category: newCat)
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
            print("error ....\(error)")
        }
        tableView.reloadData()
    }
    func loadCategorues() {
        arr_categories = realm.objects(Category.self)
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_categories?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catlist", for: indexPath)
        cell.textLabel?.text = arr_categories?[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // performSegue(withIdentifier: "gotoitems", sender: self)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = arr_categories?[indexpath.row]
        }
    }
}
