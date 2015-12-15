//
//  SettingsViewController.swift
//  QuickDoodle
//
//  Created by Elijah Freestone on 11/28/15.
//  Copyright © 2015 Elijah Freestone. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var lineWidthSlider: UISlider!
    @IBOutlet weak var lineOpacitySlider: UISlider!
    
    @IBOutlet weak var lineWidthImageView: UIImageView!
    @IBOutlet weak var lineOpacityImageView: UIImageView!
    
    @IBOutlet weak var lineWidthLabel: UILabel!
    @IBOutlet weak var lineOpacityLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    //Set default line width and opacity
    var lineWidthFloat: CGFloat = 10.0
    var lineOpacityFloat: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call line preview to show default width and opacity on load
        drawLinePreview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Close button clicked, dismiss view and notify delegate
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    @IBAction func colorChanged(sender: UISlider) {
    }
    
    //Slider moved, grab value
    @IBAction func sliderChanged(sender: UISlider) {
        if sender == lineWidthSlider {
            lineWidthFloat = CGFloat(sender.value)
            lineWidthLabel.text = NSString(format: "%.1f", lineWidthFloat.native) as String
        } else {
            lineOpacityFloat = CGFloat(sender.value)
            lineOpacityLabel.text = NSString(format: "%.2f", lineOpacityFloat.native) as String
        }
        //Update line preview ImageViews
        drawLinePreview()
    }
    
    //Draw preview of line width and opacity
    func drawLinePreview() {
        UIGraphicsBeginImageContext(lineWidthImageView.frame.size)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineWidthFloat)
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        lineWidthImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(lineWidthImageView.frame.size)
        context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, 20)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, lineOpacityFloat)
        CGContextStrokePath(context)
        lineOpacityImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
