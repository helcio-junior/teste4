//
//  ViewController.swift
//  MyList1
//
//  Created by Helcio Junior on 06/01/21.
//
import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: UITableViewController {

    var itemContatos: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 80.0
        
    }

    // datasources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemContatos?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! SwipeTableViewCell
        
        if let item = itemContatos?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none

        } else {
            cell.textLabel?.text = "No Items"
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemContatos?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Erro")
            }
            }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //adicionar novo item
    
    
    @IBAction func addBotao(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Adicionar novo numero", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Adicionar", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Erro")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Adicionar numero"
            textField = alertTextField
            textField.keyboardType = .numberPad        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style:.default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
     //botaoEmail

    
    
    @IBAction func addEmail(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Adicionar novo E-mail", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Adicionar", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Erro")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Adicionar E-mail"
            textField = alertTextField
            textField.keyboardType = .emailAddress        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style:.default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)    }
    
    
    //manipulacao
    

   func loadItems() {
        
        itemContatos = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
    tableView.reloadData()
    
    }
    

}

// - barra de pesquisa


//extension TodoListViewController: UISearchBarDelegate{
//
//
//
//     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//         itemContatos = itemContatos?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//
//        tableView.reloadData()
//
//     }
//
//     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//         if searchBar.text?.count == 0 {
//             loadItems()
//
//             DispatchQueue.main.async {
//                 searchBar.resignFirstResponder()
//             }
//         }
//     }
//
//}

extension TodoListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Deletar") { action, indexPath in
            // handle action by updating model with deletion
            
            if let categoryForDeletion = self.itemContatos?[indexPath.row]{
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Erro")
                }
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash Icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

 
