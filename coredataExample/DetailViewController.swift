//
//  DetailViewController.swift
//  coredataExample
//
//  Created by Mounika Reddy on 04/10/20.
//  Copyright © 2020 Mounika Reddy. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var fNameTxt: UITextField!
    @IBOutlet weak var lNameTxt: UITextField!
    @IBOutlet weak var DOBTxt: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var numberTxt: UITextField!
    @IBOutlet weak var mailTxt: UITextField!
    var main:ViewController!
    var toolBar:UIToolbar!
    var datePicker:UIDatePicker!
    let allowedNumbers = CharacterSet(charactersIn: " +-0123456789")
    var newData:NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datePicker=UIDatePicker()
        datePicker.datePickerMode = .date
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKey))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        if (newData != nil) {
            
            fNameTxt.text=newData.value(forKey: "firstname") as! String
            lNameTxt.text=newData.value(forKey: "lastname") as! String
            DOBTxt.text=newData.value(forKey: "dob") as! String
            ageLabel.text=newData.value(forKey: "age") as! String
            mailTxt.text=newData.value(forKey: "mail") as! String
            numberTxt.text=newData.value(forKey: "number") as! String
        }
      
        
       
    }
    
    @objc func dismissKey(){
        view.endEditing(true)
    }
    
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        if (fNameTxt.text!.isEmpty || lNameTxt.text!.isEmpty || DOBTxt.text!.isEmpty||mailTxt.text!.isEmpty||numberTxt.text!.isEmpty){
            
            let alert = UIAlertController(title: "Warning", message: "Please Fill All Feilds", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert,animated: true)
            
        }else{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "UsersData",in: managedContext)!
            
            // to update the selected data
            if (newData != nil){
                newData.setValue(self.fNameTxt.text, forKey: "firstname")
                newData.setValue(self.lNameTxt.text, forKey: "lastname")
                newData.setValue(self.DOBTxt.text, forKey: "dob")
                newData.setValue(self.ageLabel.text, forKey: "age")
                newData.setValue(self.mailTxt.text, forKey: "mail")
                newData.setValue(self.numberTxt.text, forKey: "number")
                
            }else{
                let person = NSManagedObject(entity: entity,insertInto: managedContext)
                person.setValue(self.fNameTxt.text, forKey: "firstname")
                person.setValue(self.lNameTxt.text, forKey: "lastname")
                person.setValue(self.DOBTxt.text, forKey: "dob")
                person.setValue(self.ageLabel.text, forKey: "age")
                person.setValue(self.mailTxt.text, forKey: "mail")
                person.setValue(self.numberTxt.text, forKey: "number")
                
            }
            
            do {
                try managedContext.save()
            } catch  {
                print("Could not save")
            }
            
            
            navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
     
    
    // ShouldBeginEditing delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.clearButtonMode = .whileEditing
        
        switch textField {
        case fNameTxt:
            return true
        // if user fill the first textfeild then only able to enter into next textfeild
        case lNameTxt:
            if fNameTxt.text!.count >= 2{
                return true
            }else{return false}
        // if user fill the first two textfeild then only user able to enter into age textfeild
        case DOBTxt:
            if fNameTxt.text!.count >= 2 && lNameTxt.text!.count >= 2{
                return true
            }else{return false}
            
        // if user fill the first three textfeild then only user able to enter into next textfeild
        case mailTxt:
            if fNameTxt.text!.count >= 2 && lNameTxt.text!.count >= 2 && DOBTxt.text!.count >= 1  {
                return true
            }else{return false}
        // if user fill the first four textfeild then only user able to enter into next textfeild
        case numberTxt:
            if fNameTxt.text!.count >= 2 && lNameTxt.text!.count >= 2 && DOBTxt.text!.count >= 1  && mailTxt.text!.count >= 2{
                return true
            }else{return false}
            
        default:
            return true
            
        }
    }
    
    
    var returnValue:Bool!
    // DidBeginEditing delegate once user enter into textfeild if there is any changes user can edit using with this delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case DOBTxt:
            DOBTxt.inputView = datePicker
            DOBTxt.inputAccessoryView = toolBar
            if DOBTxt.isEditing == true{
                ageLabel.text = ""
            }
            returnValue = true
            
        default:
            returnValue = false
        }
        
    }
    
    
    // DidEndEditing delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case DOBTxt:
            ageCalculator()
            return
        case mailTxt:
            //if entered input of mail is according to isValidEmail function rules then its retun true
            if mailTxt.text!.isValidEmail{
                return
            }else{
                // if entered input is wrong then else part will be excuted
                
                let alert = UIAlertController(title: "Alert", message: "Please Enter Valid Email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.mailTxt.text = ""
                }))
                present(alert, animated: true, completion: nil)
                return
            }
            
        case numberTxt:
            //if entered input of number is according to isValidNumber function rules then its retun true
            if numberTxt.text!.isValidNumber{
                return
            }else{
                let alert = UIAlertController(title: "Alert", message: "Please Enter Valid Number", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.numberTxt.text = ""
                }))
                present(alert, animated: true, completion: nil)
                return
            }
        default:
            returnValue = true
        }
        
    }
    
    
    // shouldChangeCharctersIn Range delegate is used to enter particular input as per requirement of textfeilds ex: name feilds consists only alphabets in this cases we can allow only alphabets using this delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case numberTxt:
            let characterSet = CharacterSet(charactersIn: string)
            return allowedNumbers.isSuperset(of: characterSet)
            
        default:
            return true
            
        }
    }
    
    
    @objc func ageCalculator(){
        
        let df=DateFormatter()
        df.dateFormat="dd-MM-yyyy"
        let dateOfBirth = datePicker.date
        let today = Date()
        // - use calendar to get difference between two dates
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateOfBirth, to: today)
        let ageYears = components.year
        let ageMonths = components.month
        let ageDays = components.day
        
        if components.year! >= 18 && components.year! <= 100 {
            
            DOBTxt.text=df.string(from: dateOfBirth)
            ageLabel.text = "\(ageYears!)Years,\(ageMonths!)Months,\(ageDays!)Days"
            
        }else{
            //if  user age is under 18
            //display error and return
            let alert = UIAlertController(title: "Error", message: "Age Should Be Above 18 years and below 100 years", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    
    
    
    
}

// extension created to validate mobile and number with regular expressions
extension  String {
    
    var isValidEmail:Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidNumber: Bool {
        let phoneRegEx = "^(\\+91[\\-\\s]?)?[0]?(91)?[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
}




