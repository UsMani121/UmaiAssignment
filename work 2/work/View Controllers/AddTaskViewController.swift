//
//  SecondViewController.swift
//  work
//
//  Created by Apple on 24/06/2021.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func addTaskViewController(_ secondViewController: AddTaskViewController, sendData: String)
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var addTextInput: UITextField!
    @IBOutlet weak var addTaskLabel: UILabel!
    
    var delegate : AddTaskViewControllerDelegate!
    var taskString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stringToPass = taskString{
            addTextInput.text = stringToPass
        }
    }
    
    @IBAction func saveTaskButton(_ sender: Any) {

        if addTextInput.text != ""
        {
            let taskname = addTextInput.text ?? ""
            addTaskLabel.text = "New Task Added\n\(taskname)"
            
            delegate?.addTaskViewController(self, sendData: taskname)
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            addTaskLabel.text = "Kindly Add Task First."
        }
    }
}
