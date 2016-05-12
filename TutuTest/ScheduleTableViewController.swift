//
//  ScheduleTableViewController.swift
//  TutuTest
//
//  Created by Максим on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController {

    @IBOutlet weak var dispatchStationLabel: UILabel!
    @IBOutlet weak var destinationStationLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var managedContext: NSManagedObjectContext!
    
    var dispatchStation: Station?
    var destinationStation: Station?
    var departureDate: NSDate?
    
    var datePickerIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = .Date
        
        if let dispSt = dispatchStation {
            dispatchStationLabel.text = dispSt.stationTitle
        }
        if let destSt = destinationStation {
            destinationStationLabel.text = destSt.stationTitle
        }
        updateDueDateLabel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions 
    
    @IBAction func dateChange(datePicker: UIDatePicker) {
        // событие, вызываемое при изменении даты 
        
        departureDate = datePicker.date
        updateDueDateLabel()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && datePickerIsVisible {
            return 2
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            return 217;
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
            case (0,_) :
                self.performSegueWithIdentifier("ShowStations", sender: "citiesFrom")
            case (1,_):
                self.performSegueWithIdentifier("ShowStations", sender: "citiesTo")
            case (2,0):
                if datePickerIsVisible {
                    hideDatePickerView()
                } else {
                    showDatePickerView()
                }
            default: break
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 2 && indexPath.row == 1) {
            return datePickerCell!
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 2 && indexPath.row == 1 {
            indexPath = NSIndexPath(forRow: 0, inSection: 2)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowStations" {
            let controller = segue.destinationViewController as! StationsListViewController
            controller.directionType = sender as! String
            controller.managedContext = managedContext
        }
    }
    
    
    // MARK: - Date Picker view 
    
    func updateDueDateLabel() {
        // Функция позволяет обновить Label со значением даты отправления 
        // Так как достаточно знать только дату, применяем NSDateFormatter
        let formater = NSDateFormatter()
        formater.dateStyle = .MediumStyle
        formater.timeStyle = .NoStyle
        
        if let date = departureDate {
            departureDateLabel.text = formater.stringFromDate(date)
        } else {
            departureDateLabel.text = formater.stringFromDate(NSDate())
        }
    }
    
    func showDatePickerView() {
        datePickerIsVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 2)
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 2)
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.endUpdates()
        
        if let date = departureDate {
            datePicker.setDate(date, animated: false)
        } else {
            datePicker.setDate(NSDate(), animated: false)
        }
    }

    func hideDatePickerView() {
         datePickerIsVisible = false
        
        let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 2)
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 2)
        
        tableView.beginUpdates()
        
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        tableView.endUpdates()
    }
}
