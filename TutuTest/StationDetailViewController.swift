//
//  StationDetailViewController.swift
//  TutuTest
//
//  Created by Максим on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class StationDetailViewController: UITableViewController {
    
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    var station: Station!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let station = station {
            stationTitleLabel.text = station.stationTitle
            
            // для отображения названия станции в две строки
            stationTitleLabel.lineBreakMode = .ByWordWrapping
            stationTitleLabel.numberOfLines = 2
            stationTitleLabel.sizeToFit()
            
            latitudeLabel.text = station.latitude?.stringValue
            longitudeLabel.text = station.longitude?.stringValue
            cityLabel.text = station.city.cityTitle
            countryLabel.text = station.city.countryTitle
            districtLabel.text = station.city.districtTitle
            regionLabel.text = station.city.regionTitle
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return stationTitleLabel.frame.size.height + 5
        }
        return 44
    }
}
