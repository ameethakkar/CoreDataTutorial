//
//  ViewController.swift
//  CoreDataTutorial
//
//  Created by appkoder on 18/03/2017.
//  Copyright © 2017 appkoder. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //var names: [String] = []
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    
    func getData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do{
            people = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
            
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Details", message: "Add a new name and year of birth",preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",style: .default) {[unowned self] action in
            
            guard let textField = alert.textFields?.first, let textField2 = alert.textFields?[1],
                let nameToSave = textField.text, let dobToSave =  textField2.text else {
                    return
            }
            
            //self.names.append(nameToSave)
            self.save(name: nameToSave, dob: dobToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",style: .default)
        
        alert.addTextField()
        alert.addTextField()
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String, dob: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(dob, forKey: "dob")
        
        do{
            
            try managedContext.save()
            
            people.append(person)
            
        }catch let error as NSError{
        
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = people[indexPath.row]
        
        person.setValue("2015", forKey: "dob")
        
        do {
            try person.managedObjectContext?.save()
            self.getData()
            
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return people.count
        //return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Trying to reuse a cell
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String ?? "" //names[indexPath.row]
        
        cell.detailTextLabel?.text = "Year of birth: \(person.value(forKey: "dob") as? String ?? "")"
        
        cell.textLabel?.font = UIFont(name: "Futura", size: 21)
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Next", size: 11)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .orange
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
}

