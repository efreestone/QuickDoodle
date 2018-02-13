//
//  SettingsViewController.swift
//  QuickDoodle
//
//  Created by Elijah Freestone on 11/28/15.
//  Copyright © 2015 Elijah Freestone. All rights reserved.
//

import UIKit

//Conform to RGBInfo Delegate to set color floats
extension SettingsViewController: RGBInfoViewControllerDelegate {
    func rgbInfoViewControllerFinished(_ rgbInfoViewController: RGBInfoViewController) {
        //Set RGB color
        redFloat = rgbInfoViewController.redFloat
        greenFloat = rgbInfoViewController.greenFloat
        blueFloat = rgbInfoViewController.blueFloat
    }
}

//Protocol for Settings Delegate to set sample colors
protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController)
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
    
    @IBOutlet weak var rgbInfoButton: UIButton!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    //Set default line width and opacity
    var lineWidthFloat: CGFloat = 10.0
    var lineOpacityFloat: CGFloat = 1.0
    
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print("Red = \(redFloat * 255),\nGreen = \(greenFloat * 255),\nBlue = \(blueFloat * 255)")
        
        //Set sliders
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
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    @IBAction func colorChanged(_ sender: UISlider) {
        redFloat = CGFloat(redSlider.value / 255)
        redLabel.text = NSString(format: "R %d", Int(redSlider.value)) as String
        greenFloat = CGFloat(greenSlider.value / 255)
        greenLabel.text = NSString(format: "G %d", Int(greenSlider.value)) as String
        blueFloat = CGFloat(blueSlider.value / 255)
        blueLabel.text = NSString(format: "B %d", Int(blueSlider.value)) as String
        
        drawLinePreview()
    }
    
    //Slider moved, grab value
    @IBAction func sliderChanged(_ sender: UISlider) {
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
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(lineWidthFloat)
        
        //Set stroke (brush) image view circle
        context?.setStrokeColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: 1.0)
        context?.move(to: CGPoint(x: 45.0, y: 45.0))
        context?.addLine(to: CGPoint(x: 45.0, y: 45.0))
        context?.strokePath()
        
        let lightLightGray = UIColor (red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)
        
        //Check if selected color is white, change background to light light gray if true
        if (rgbIsWhite(redFloat, greenFlt: greenFloat, blueFlt: blueFloat)) {
            view.backgroundColor = lightLightGray
            //Apply gray to Opacity slider BG if color is white. Unsure why this is the only slider impacted when the background is changed
            lineOpacitySlider.backgroundColor = lightLightGray
        } else {
            view.backgroundColor = UIColor.white
            lineOpacitySlider.backgroundColor = UIColor.white
        }
        
        lineWidthImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(lineWidthImageView.frame.size)
        context = UIGraphicsGetCurrentContext()
        
        //Create opacity image view circle
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(50)
        context?.move(to: CGPoint(x: 45.0, y: 45.0))
        context?.addLine(to: CGPoint(x: 45.0, y: 45.0))
        
        context?.setStrokeColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: lineOpacityFloat)
        context?.strokePath()
        lineOpacityImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    //Check if color is white (eraser) and return bool. Used to change background to light light gray if true
    func rgbIsWhite(_ redFlt: CGFloat, greenFlt: CGFloat, blueFlt: CGFloat) -> Bool {
        if (redFlt == 1.0 && greenFlt == 1.0 && blueFlt == 1.0) {
            print("Color is white")
            return true
        } else {
            //print("Color NOT white")
            return false
        }
    }
    
    
    // MARK: - Navigation
    
    // Do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue to rgb info screen. Used to set the delegate
        let infoViewController = segue.destination as! RGBInfoViewController
        infoViewController.delegate = self
        infoViewController.redFloat = redFloat
        infoViewController.greenFloat = greenFloat
        infoViewController.blueFloat = blueFloat
    }
    
}
