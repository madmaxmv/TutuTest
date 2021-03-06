//
//  AboutViewController.swift
//  TutuTest
//
//  Created by Максим on 13.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var readmeTextView: UITextView!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    var appName: String {
        let key = String(kCFBundleNameKey)
        let value = NSBundle.mainBundle().objectForInfoDictionaryKey(key) as? String
        return value ?? ""
    }
    var appVersion: String {
        let key = String(kCFBundleVersionKey)
        let value = NSBundle.mainBundle().objectForInfoDictionaryKey(key) as? String
        return value ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = appName
        appVersionLabel.text = "Версия \(appVersion)"
        readmeTextView.font = UIFont.systemFontOfSize(14)
        if let readmeFile = NSBundle.mainBundle().pathForResource("README", ofType: "") {
            do {
                let data = try String(contentsOfFile: readmeFile, encoding: NSUTF8StringEncoding)
                readmeTextView.text = data
            } catch {
                 print("Error \(error)")
            }
        }
        copyrightLabel.text = "Copyright © 2016 Maxim. All rights reserved."
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        readmeTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
}