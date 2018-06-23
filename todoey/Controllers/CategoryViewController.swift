//
//  CategoryViewController.swift
//  todoey
//
//  Created by Ahmed on 6/11/18.
//  Copyright © 2018 Ahmed sobhi. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var Categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
}
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = Categories[indexPath.row].name
        
        return cell
        
    }
    
    
    //MARK - Tbleview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewControllerViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = Categories[indexpath.row]
        }
    }
    
    
    //MARK - Data Manuplation Methods
    
    func saveCategories(){
        do{
        try context.save()
        } catch {
            print("error cant save data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(){
        
       let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
       Categories = try context.fetch(request)
        } catch {
            print("cannot load data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //MARK - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new category ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add", style: .default) { (action) in
          
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.Categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "add new category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
