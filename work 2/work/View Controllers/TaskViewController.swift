//
//  ViewController.swift
//  work
//
//  Created by Apple on 24/06/2021.
//

import UIKit

class TaskViewController: UIViewController {

    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var allTaskArray : [TaskModelClass] = []
    var taskArray : [TaskModelClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        taskTableView.delegate = self
        taskTableView.dataSource = self
        loadDataFromUserDefault()
    
    }
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            taskArray = allTaskArray.filter { (obj) -> Bool in
                return obj.taskStatus == false
            }
        }
        else if sender.selectedSegmentIndex == 1 {
            taskArray = allTaskArray.filter { (obj) -> Bool in
                return obj.taskStatus == true
            }
        }
        taskTableView.reloadData()
    }
    
    
    func loadDataFromUserDefault(){
        if let data = UserDefaults.standard.value(forKey: "encodedArray") as? Data
            {
                do{
                let obj = try PropertyListDecoder().decode([TaskModelClass].self, from: data)
                    
                    allTaskArray = obj
                    taskArray = allTaskArray.filter { (obj) -> Bool in
                        return obj.taskStatus == false
                    }
                    taskTableView.reloadData()
            }catch{
                print(error)
            }
        }
    }

    @IBAction func goToSecondVC(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "SecondViewController") as! AddTaskViewController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
        override func viewDidDisappear(_ animated: Bool) {
        do{
            let encodedData : Data = try PropertyListEncoder().encode(allTaskArray)
            UserDefaults.standard.set(encodedData, forKey: "encodedArray")
            
        }catch {
            print(error)
        }
    }

}
extension TaskViewController: AddTaskViewControllerDelegate {
    func addTaskViewController(_ secondViewController: AddTaskViewController, sendData taskName: String) {

        allTaskArray.append(TaskModelClass(taskName: taskName ))
        
        if segmentControl.selectedSegmentIndex == 0 {
            taskArray.append(TaskModelClass(taskName: taskName))
        }
        taskTableView.reloadData()
        print(allTaskArray.count)
    }
}

extension TaskViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                       
        let task = taskArray[indexPath.row]
        task.taskStatus.toggle()
        taskArray.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskTableView.beginUpdates()

            let allTaskArrayIndexPath = taskArray[indexPath.row]
            taskArray.remove(at: indexPath.row)
            
            if let index = allTaskArray.firstIndex(of: allTaskArrayIndexPath){
                allTaskArray.remove(at: index)
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
            
            taskTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension TaskViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = taskArray[indexPath.row]
        
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! CustomTableViewCell
        
        cell.CustomCellTaskNameLabel.text = task.taskName
        
        cell.accessoryType =  (task.taskStatus == true) ? .checkmark : .none
        return cell
    }
}

