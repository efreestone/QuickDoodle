//
//  RGBInfoViewController.swift
//  QuickDoodle
//
//  Created by Elijah Freestone on 3/22/16.
//  Copyright © 2016 Elijah Freestone. All rights reserved.
//

import UIKit

//Protocol for RGBInfo Delegate to set color floats
protocol RGBInfoViewControllerDelegate: class {
    func rgbInfoViewControllerFinished(rgbInfoViewController: RGBInfoViewController)
}

class RGBInfoViewController: UIViewController {
    
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    
    weak var delegate: RGBInfoViewControllerDelegate?
    
    //var settingsViewController: SettingsViewController = UIApplication.sharedApplication().windows[0].rootViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        redFloat = 150.0 / 255
        
        print("Red = \(redFloat * 255),\nGreen = \(greenFloat * 255),\nBlue = \(blueFloat * 255)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Close button clicked, dismiss view and notify delegate
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.rgbInfoViewControllerFinished(self)
    }
    
}
