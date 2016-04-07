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
        
//        redFloat = 150.0 / 255
        
//        print("Red = \(redFloat * 255),\nGreen = \(greenFloat * 255),\nBlue = \(blueFloat * 255)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Color example button clicked, set RGB floats accordingly
    @IBAction func colorButtonClicked(sender: UIButton) {
        let buttonClicked = sender
        
        //Brown selected
        if buttonClicked.tag == 1 {
            redFloat = 160.0 / 255
            greenFloat = 82.0 / 255
            blueFloat = 45.0 / 255
            print("Brown clicked")
        }
        
        //Sand selected
        if buttonClicked.tag == 2 {
            redFloat = 222.0 / 255
            greenFloat = 217.0 / 255
            blueFloat = 184.0 / 255
            print("Sand clicked")
        }
        
        //Hot Pink selected
        if buttonClicked.tag == 3 {
            redFloat = 1.0
            greenFloat = 50.0 / 255
            blueFloat = 1.0
            print("Hot Pink clicked")
        }
        
        //Dark Blue selected
        if buttonClicked.tag == 4 {
            redFloat = 0.0
            greenFloat = 0.0
            blueFloat = 140.0 / 255
            print("Dark Blue clicked")
        }
        print("Red = \(redFloat * 255),\nGreen = \(greenFloat * 255),\nBlue = \(blueFloat * 255)")
    }
    
    //Close button clicked, dismiss view and notify delegate
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.rgbInfoViewControllerFinished(self)
    }
    
}
