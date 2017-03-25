//
//  RunsTableViewController.swift
//  mHealth
//
//  Created by Loaner on 3/24/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit

class RunsTableViewController : UITableViewController{
    
    var runs = [Runs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleRun()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RunsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RunsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RunsTableViewCell.")
        }
        
        // Fetches the appropriate run for the data source layout.
        let run = runs[indexPath.row]
        
        
        cell.dateLabel.text = run.date
        cell.timeLabel.text = run.time
        
        return cell
    }
    
    private func loadSampleRun() {
        
        guard let run1 = Runs(date: "3/23/4", time: "3.4hrs") else {
            fatalError("Unable to instantiate run1")
        }
        
        
        runs += [run1]
    }


    
}
