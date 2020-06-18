//
//  PopUp.swift
//  HeartRateApp
//
//  PopUp.swift is a pop up window that user sees when finishes the measurement process
//
//  Created by Final Year Project Account on 2020/2/25.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import UIKit
import Charts

class PopUp: UIViewController,UITextFieldDelegate {
    
    // MARK: - Configurations
    var time        : Int = 0                                   //passed time value
    var maximumHR   : Int = 0                                   //passed maximum HR value
    var chartData   : ChartData!
    var set         : LineChartDataSet!
    var name        : String = ""
    var age         : String = ""
    var phobia      : String = ""
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var phobiaField: UITextField!
    
    // MARK: - Button Creator
    
    func createButton(color: UIColor, text: String) -> UIButton{
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        btn.setTitle("\(text)", for: .normal)
        btn.backgroundColor = color.withAlphaComponent(0.5)
        btn.isOpaque = false
        btn.titleLabel?.adjustsFontSizeToFitWidth = true;
        btn.titleLabel?.minimumScaleFactor = 0.5;
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }
    
    //MARK: - TextField Congiuration
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        nameField.delegate      = self
        ageField.delegate       = self
        phobiaField.delegate    = self
        
        nameField.attributedPlaceholder = NSAttributedString(string: "John Smith",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.myGrey])
        ageField.attributedPlaceholder = NSAttributedString(string: "30",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.myGrey])
        phobiaField.attributedPlaceholder = NSAttributedString(string: "Acrophobia",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.myGrey])
        
        setUpButtons()
    }
    
    // MARK: - Buttons Set Up
    private func setUpButtons(){
        let btnRestart = createButton(color: UIColor.btnRestart, text: "RESTART")
        view.addSubview(btnRestart)
        
        
        btnRestart.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 0).isActive = true
        btnRestart.heightAnchor.constraint(equalToConstant: 60).isActive = true
        btnRestart.rightAnchor.constraint(equalTo: popUpView.centerXAnchor, constant: 0).isActive = true
        btnRestart.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: 0).isActive = true
        btnRestart.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btnRestart.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        let btnContinue = createButton(color: UIColor.btnContinue, text: "CONTINUE")
        view.addSubview(btnContinue)
        btnContinue.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: 0).isActive = true
        btnContinue.heightAnchor.constraint(equalToConstant: 60).isActive = true
        btnContinue.leftAnchor.constraint(equalTo: popUpView.centerXAnchor, constant: 0).isActive = true
        btnContinue.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: 0).isActive = true
        btnContinue.addTarget(self, action: #selector(`continue`), for: .touchUpInside)
        btnContinue.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    // MARK: - Go Back Button Action
    @IBAction func goBack(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Continue Button Action
    @IBAction func `continue`(_ sender: Any) {
        if(validateName(name:(nameField.text!)) && validateAge(age:(ageField.text!)) && validatePhobia(phobia:(phobiaField.text!))){
            name = nameField.text!
            age = ageField.text!
            phobia = phobiaField.text!
            performSegue(withIdentifier: "passData", sender: self)
        }
    }
    
    // MARK: - Name Validation
    func validateName(name : String) -> Bool{
        if name.isEmpty {
            let alertController = UIAlertController(title: "Empty Name", message:
                "Name cannot be empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if name.count <= 2 || name.count >= 40 {
            let alertController = UIAlertController(title: "Invalid Name Length", message:
                "Name has to be between 3 and 40 characters long", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if name.prefix(1) == " "{
            let alertController = UIAlertController(title: "Invalid Name", message:
                "Name cannot start with a whitespace", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if !isValidInput(input:(name)){
            let alertController = UIAlertController(title: "Invalid Name", message:
                "Name can only contain uppercase and lowercase letters with whitespaces", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

    
    // MARK: - Age Validation
    func validateAge(age: String) -> Bool{
        if age.isEmpty{
            let alertController = UIAlertController(title: "Empty Age", message:
                "Age cannot be empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }else if Int(age)! >= 120 || Int(age)! <= 0{
            let alertController = UIAlertController(title: "Invalid Age", message:
                "Please enter a valid age number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    // MARK: - Phobia Validation
    func validatePhobia(phobia: String) -> Bool{
        if phobia.isEmpty {
            let alertController = UIAlertController(title: "Empty Phobia Name", message:
                "Phobia Name cannot be empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if phobia.count <= 4 || phobia.count >= 40 {
            let alertController = UIAlertController(title: "Invalid Phobia Name Length", message:
                "Phobia name has to be between 5 and 40 characters long", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if phobia.prefix(1) == " "{
            let alertController = UIAlertController(title: "Invalid Phobia Name", message:
                "Phobia name cannot start with a whitespace", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if !isValidInput(input:(phobia)){
            let alertController = UIAlertController(title: "Invalid Phobia Name", message:
                "Phobia name can only contain uppercase and lowercase letters with whitespaces", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    // MARK: - Input REGEX Validation
    func isValidInput(input:String) -> Bool {
        let RegEx = "([A-Za-z ]+)"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: input)
    }
    
    // MARK: - Segue Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DataResults
        vc.name = name
        vc.age = age
        vc.phobia = phobia
        vc.totalTime = time
        vc.maximumHR = maximumHR
        vc.chartData = chartData
        vc.set = set
    }
}

