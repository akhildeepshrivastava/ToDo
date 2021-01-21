//
//  TaskListViewController.swift
//  ToDo
//
//  Created by Shweta Shrivastava on 1/20/21.
//

import UIKit
import RxSwift
import RxCocoa


class TaskListViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay(value: [Task]())
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController, let addTaskVc = navVC.viewControllers.first as? AddTaskViewController else {
            return
        }
        
        
        
        addTaskVc.taskSubjectObservable.subscribe(onNext: { [unowned self] (task) in
            
            let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex-1)
            
            var existingTask = self.tasks.value
            existingTask.append(task)
            self.tasks.accept(existingTask)
            self.filterTasks(by: priority)
        }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            self.tasks.map { (tasks) in
                return tasks.filter { $0.priority == priority }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func changePriority(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex-1)
        self.filterTasks(by: priority)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    
}
