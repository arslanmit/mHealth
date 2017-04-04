//
//  RunsTableViewController.swift
//  mHealth
//
//  Created by Loaner on 3/24/17.
//  Copyright © 2017 JTMax. All rights reserved.
//

import UIKit
import Firebase

class RunsTableViewController : UITableViewController{

    //MARK: FIREBASE
    let user = FIRAuth.auth()?.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    //MARK: Array of Runs
    var runs = [FirebaseRun]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id: String = Util.removePeriod(s: (user?.email)!)
        let runRef = FIRDatabase.database().reference(withPath: "users//\(id)/")
        
        runRef.observe(.value, with: { snapshot in
            self.load()
            self.tableView.reloadData()
        })
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
        
        
        cell.dateLabel.text = Util.dateFirebaseTitle(date: Util.stringToDate(date: run.timestamp))
        cell.timeLabel.text = Util.dateToPinString(date: Util.stringToDate(date: run.timestamps.last!))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "cellToMap", sender: indexPath);
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToMap" {
            let nextView = segue.destination as! FirebaseRunsViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let displayRun = runs[indexPath.row]
                nextView.myFirebaseRun = displayRun
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let run = runs[indexPath.row]
            run.ref?.removeValue()
            self.tableView.reloadData()
        }
    }
    private func load(){
        let id: String = Util.removePeriod(s: (user?.email)!)
        let runRef = FIRDatabase.database().reference(withPath: "users//\(id)/Runs/")
        // var oldRun: FirebaseRun?
/*
        runRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for run in snapshot.children{
                let oldRun = FirebaseRun(snapshot: run as! FIRDataSnapshot)
                self.runs.append(oldRun)
            }
            self.tableView.reloadData()
        }) */
        
        
        runRef.observe(.value, with: { snapshot in
            var currentRuns = [FirebaseRun]()
            for run in snapshot.children{
                let oldRun = FirebaseRun(snapshot: run as! FIRDataSnapshot)
                currentRuns.append(oldRun)
            }
            self.runs = currentRuns;
            self.tableView.reloadData()
        })
    }

    
}
