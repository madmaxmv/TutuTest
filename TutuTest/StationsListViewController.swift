//
//  StationsListViewController.swift
//  TutuTest
//
//  Created by Максим on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import CoreData

protocol StationsListViewControllerDelegate {
    func stationsListDidSelectStation(station: Station, withDirection direction: String)
}

class StationsListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var stationsListDelegate: StationsListViewControllerDelegate!
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
        
        if directionType == "citiesTo"{
            self.title = "To"
        } else {
            self.title = "From"
        }

        performFetch()
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let station = fetchedResultsController.objectAtIndexPath(indexPath) as! Station
        stationsListDelegate.stationsListDidSelectStation(station, withDirection: directionType)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // возвращение обратно к расписанию:
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let controller = segue.destinationViewController as! StationDetailViewController
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.station = fetchedResultsController.objectAtIndexPath(indexPath) as! Station
            }
        }
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("CoreData Error: \(error)")
        }
    }
}

extension StationsListViewController: NSFetchedResultsControllerDelegate {
    // Так как изменения вносится не будут, то реализовывть функции вызываемые при изменении нет необходимости
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch()
    }
}
