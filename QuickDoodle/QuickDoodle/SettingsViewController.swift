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
    
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        lineWidthSlider.value = Float(lineWidthFloat)
        lineWidthLabel.text = NSString(format: "%.1f", lineWidthFloat.native) as String
        lineOpacitySlider.value = Float(lineOpacityFloat)
        lineOpacityLabel.text = NSString(format: "%.1f", lineOpacityFloat.native) as String
        redSlider.value = Float(redFloat * 255.0)
        redLabel.text = NSString(format: "R %d", Int(redSlider.value)) as String
        greenSlider.value = Float(greenFloat * 255.0)
        greenLabel.text = NSString(format: "G %d", Int(greenSlider.value)) as String
        blueSlider.value = Float(blueFloat * 255.0)
        blueLabel.text = NSString(format: "B %d", Int(blueSlider.value)) as String
        
        drawLinePreview()
    }
    
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
        redFloat = CGFloat(redSlider.value / 255)
        redLabel.text = NSString(format: "R %d", Int(redSlider.value)) as String
        greenFloat = CGFloat(greenSlider.value / 255)
        greenLabel.text = NSString(format: "G %d", Int(greenSlider.value)) as String
        blueFloat = CGFloat(blueSlider.value / 255)
        blueLabel.text = NSString(format: "B %d", Int(blueSlider.value)) as String
        
        drawLinePreview()
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
        
        CGContextSetRGBStrokeColor(context, redFloat, greenFloat, blueFloat, 1.0)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        
        let lightLightGray = UIColor (red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)
//        let size = CGSize(width: 30, height: 30)
        
        if (rgbIsWhite(redFloat, greenFlt: greenFloat, blueFlt: blueFloat)) {
//            CGContextSetShadow(context, CGSizeMake(0.0, 5.0), 2.0);
            view.backgroundColor = lightLightGray
        
        } else {
            view.backgroundColor = UIColor .whiteColor()
        }
        
        lineWidthImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(lineWidthImageView.frame.size)
        context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, 20)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        
        CGContextSetRGBStrokeColor(context, redFloat, greenFloat, blueFloat, lineOpacityFloat)
        CGContextStrokePath(context)
        lineOpacityImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    //Check if color is white (eraser) and return bool. Used to change background to light light gray if true
    func rgbIsWhite(redFlt: CGFloat, greenFlt: CGFloat, blueFlt: CGFloat) -> Bool {
        if (redFlt == 1.0 && greenFlt == 1.0 && blueFlt == 1.0) {
            print("Color is white")
            return true
        } else {
            //print("Color NOT white")
            return false
        }
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
