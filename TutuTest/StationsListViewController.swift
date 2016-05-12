//
//  StationsListViewController.swift
//  TutuTest
//
//  Created by Максим on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import CoreData

class StationsListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var managedContext: NSManagedObjectContext!
    var directionType: String!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchReqest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Station", inManagedObjectContext: self.managedContext)
        fetchReqest.entity = entity
        
        fetchReqest.predicate = NSPredicate(format: "city.directionType == %@", self.directionType)
        
        let sortDescriptorByCountryTitle = NSSortDescriptor(key: "city.countryTitle", ascending: true)
        let sortDescriptorByCityTitle = NSSortDescriptor(key: "city.cityTitle", ascending: true)
        fetchReqest.sortDescriptors = [sortDescriptorByCountryTitle, sortDescriptorByCityTitle]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchReqest,
            managedObjectContext: self.managedContext,
            sectionNameKeyPath: "city.countryTitle",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetch()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath)
       
        let station = fetchedResultsController.objectAtIndexPath(indexPath) as! Station
        
        cell.textLabel?.text = station.stationTitle
        cell.detailTextLabel?.text = station.city.cityTitle
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("CoreData Error: \(error)")
        }
    }

}

extension StationsListViewController: NSFetchedResultsControllerDelegate {
    // Так как изменения вносится не будут, реализовывть функции вызываемые при изменении нет необходимости
}

extension StationsListViewController: UISearchBarDelegate {
    func performSearch() {
        if searchBar.text! != ""{
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(city.directionType == %@) AND (stationTitle contains[cd] %@)", self.directionType, searchBar.text!)
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "city.directionType == %@", self.directionType)
        }
        performFetch()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
