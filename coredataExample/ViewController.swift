//
//  ViewController.swift
//  coredataExample
//
//  Created by Mounika Reddy on 04/10/20.
//  Copyright © 2020 Mounika Reddy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data:[NSManagedObject]=[]

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                   return
               }

               let managedContext = appDelegate.persistentContainer.viewContext

               //2
               let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UsersData")

               //3
               do {
                  data = try managedContext.fetch(fetchRequest)
                  tableView.reloadData()
               } catch let error as NSError {
                 print("Could not fetch. \(error), \(error.userInfo)")
               }
        
    }
   
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let fullName="\(person.value(forKey: "firstname") as! String)\t\(person.value(forKeyPath: "lastname") as! String)"
        let dob=(person.value(forKey: "dob") as! String)
        let age=(person.value(forKey: "age")  as! String)
        let number=(person.value(forKey: "number") as! String)
        let mail=(person.value(forKey: "mail") as! String)
        
        cell.textLabel?.font=UIFont(name: "Times New Roman", size: 20)
        cell.detailTextLabel?.numberOfLines=0
        cell.textLabel?.text = "FullName:\(fullName) "
        cell.detailTextLabel?.text="DOB:\(dob) \nAge:\(age) \nNumber:\(number) \nMailId:\(mail)"
             return cell
            }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let action = UIContextualAction(style: .normal,title: "Delete",handler: { (action, view, completion) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                //remove object from core data
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(self.data[indexPath.row] as NSManagedObject)
                do{
                 try managedContext.save()
                }catch{
                    print("error")
                }
                //update UI methods
                tableView.beginUpdates()
                self.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                appDelegate.saveContext()
                completion(true)
        })

        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration


    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedData=data[indexPath.row]
        let second = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        second.newData=selectedData
        navigationController?.pushViewController(second, animated: true)
    }
    
}


