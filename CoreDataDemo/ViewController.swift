//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Sherif Hamdy on 11/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var persons:[Person] = []
    private let personCellIdentifier = "PersonCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTap(_ sender:UIBarButtonItem){
        let alertController = UIAlertController(title: "Add New Person", message: "Enter Your Name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Your Name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            let textField = alertController.textFields?[0]
            let person = Person(context: AppDelegate.context)
            person.name = textField?.text ?? ""
            person.age = 20
            person.gender = true
            do{
                try person.managedObjectContext?.save()
                self?.fetchData()
            }catch{
                print("Failed to Insert new person")
            }
        }
        alertController.addAction(addAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func fetchData(){
        do{
            let data = try AppDelegate.context.fetch(Person.fetchRequest())
            self.persons = data
            self.refreshTable()
        }catch{
            print("Failed to fetch persons")
        }
    }


}

extension ViewController{
    private func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: personCellIdentifier)
    }
    
    private func refreshTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: personCellIdentifier, for: indexPath)
        cell.textLabel?.text = persons[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Person", message: "Enter Your Name", preferredStyle: .alert)
        let person = persons[indexPath.row]
        alertController.addTextField { textField in
            textField.text = person.name
        }
        let addAction = UIAlertAction(title: "Edit", style: .default) { [weak self] action in
            let textField = alertController.textFields?[0]
            person.name = textField?.text ?? ""
            do{
                try person.managedObjectContext?.save()
                self?.fetchData()
            }catch{
                print("Failed to Edit person")
            }
        }
        alertController.addAction(addAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self]_,_,_ in
            guard let personToDelete = self?.persons[indexPath.row] else{return}
            AppDelegate.context.delete(personToDelete)
            do{
                try AppDelegate.context.save()
            }catch{
                print("Failed to Save")
            }
            self?.fetchData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
