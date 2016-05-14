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
        
        title = "Station"
        if let station = station {
            stationTitleLabel.text = station.stationTitle
            latitudeLabel.text = station.latitude?.stringValue
            longitudeLabel.text = station.longitude?.stringValue
            cityLabel.text = station.city.cityTitle
            countryLabel.text = station.city.countryTitle
            districtLabel.text = station.city.districtTitle
            regionLabel.text = station.city.regionTitle
        }
    }
    
    // так как значения некоторых полей могут превысить ширину экрана
    // корректируем высоту ячеек таблицы для того, что бы поместился весь контент
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0) {
            let text = stationTitleLabel.text! as NSString
            let constrain = CGSizeMake(UIScreen.mainScreen().bounds.width - 10, 20000)
            let size = text.boundingRectWithSize(constrain, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)], context: nil)
            return max(size.height + 10, 44)
        } else if indexPath.section == 1 {
            var text: String
            switch indexPath.row {
                case 0: text = cityLabel.text!
                case 1: text = countryLabel.text!
                case 2: text = districtLabel.text!
                case 3: text = regionLabel.text!
                default: text = ""
            }
            let constrain = CGSizeMake(UIScreen.mainScreen().bounds.width - 90, 20000)
            let size = text.boundingRectWithSize(constrain, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)], context: nil)
            return max(size.height + 10, 44)
        }
        return 44
    }
}
