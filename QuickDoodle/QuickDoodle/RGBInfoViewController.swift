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
    func rgbInfoViewControllerFinished(_ rgbInfoViewController: RGBInfoViewController)
}

class RGBInfoViewController: UIViewController {
    
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    
    weak var delegate: RGBInfoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Color example button clicked, set RGB floats accordingly
    @IBAction func colorButtonClicked(_ sender: UIButton) {
        //Brown selected
        if sender.tag == 1 {
            redFloat = 160.0 / 255
            greenFloat = 82.0 / 255
            blueFloat = 45.0 / 255
            //print("Brown clicked")
        }
        
        //Sand selected
        if sender.tag == 2 {
            redFloat = 222.0 / 255
            greenFloat = 217.0 / 255
            blueFloat = 184.0 / 255
            //print("Sand clicked")
        }
        
        //Hot Pink selected
        if sender.tag == 3 {
            redFloat = 1.0
            greenFloat = 50.0 / 255
            blueFloat = 1.0
            //print("Hot Pink clicked")
        }
        
        //Dark Blue selected
        if sender.tag == 4 {
            redFloat = 0.0
            greenFloat = 0.0
            blueFloat = 140.0 / 255
            //print("Dark Blue clicked")
        }
        
        //Gold selected
        if sender.tag == 5 {
            redFloat = 1.0
            greenFloat = 215.0 / 255
            blueFloat = 0.0
            //print("Gold clicked")
        }
        
        //Gold selected
        if sender.tag == 6 {
            redFloat = 140.0 / 255
            greenFloat = 0.0
            blueFloat = 26.0 / 255
            //print("Burgundy clicked")
        }
        
        //Close info window
        close(sender)
        
        //print("Red = \(redFloat * 255),\nGreen = \(greenFloat * 255),\nBlue = \(blueFloat * 255)")
    }
    
    //Close button clicked, dismiss view and notify delegate
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        self.delegate?.rgbInfoViewControllerFinished(self)
    }
    
}
