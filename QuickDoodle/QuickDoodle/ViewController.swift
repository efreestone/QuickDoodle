//
//  ViewController.swift
//  QuickDoodle
//
//  Created by Elijah Freestone on 11/28/15.
//  Copyright © 2015 Elijah Freestone. All rights reserved.
//

import UIKit

//Conform to Settings Delegate to set line width and opacity
extension ViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        self.lineWidthFloat = settingsViewController.lineWidthFloat
        self.lineOpacityFloat = settingsViewController.lineOpacityFloat
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    //Create and set vars for line
    var lastPoint = CGPoint.zero
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    var lineWidthFloat: CGFloat = 10.0
    var lineOpacityFloat: CGFloat = 1.0
    var hasMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Define RGB Colors
    let rgbColorsArray: [(CGFloat, CGFloat, CGFloat)] = [
        //Black
        (0, 0, 0),
        //Gray
        (105.0/255.0, 105.0/255.0, 105.0/255.0),
        //Red
        (1.0, 0, 0),
        //Blue
        (0, 0, 1.0),
        //Light Blue
        (51.0/255.0, 204.0/255.0, 1.0),
        //Green
        (102.0/255.0, 204.0/255.0, 0),
        //Yellow-green
        (102.0/255.0, 1.0, 0),
        //Brown
        (160.0/255.0, 82.0/255.0, 45.0/255.0),
        //Orange
        (1.0, 102.0/255.0, 0),
        //Yellow
        (1.0, 1.0, 0),
        //White (eraser)
        (1.0, 1.0, 1.0)
    ]
    
    //Start of touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Set has moved to false first
        hasMoved = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    //Touch has moved, draw line
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Set hasMove to true for Drawing in progress
        hasMoved = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFromPoint(lastPoint, toPoint: currentPoint)
            
            //Update lastPoint with current postion
            lastPoint = currentPoint
        }
    }
    
    //Touch has ended, merge temp into main image
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Check if touch is in progress
        if !hasMoved {
            //User only tapped, draw single point
            drawLineFromPoint(lastPoint, toPoint: lastPoint)
        }
        
        //Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: lineOpacityFloat)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        //End context and nil out temp image
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }
    
    //Draw line from one point to the other
    func drawLineFromPoint(startPoint: CGPoint, toPoint: CGPoint) {
        //Get current context and start drawing line in tempImageView
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        //Set drawing parameters
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineWidthFloat)
        CGContextSetRGBStrokeColor(context, redFloat, greenFloat, blueFloat, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        //Draw path
        CGContextStrokePath(context)
        
        //Wrap up context and render line into tempImageView
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = lineOpacityFloat
        UIGraphicsEndImageContext()
    }
    
    //MARK: - IBActions
    
    //Reset touched, clear image
    @IBAction func reset(sender: AnyObject) {
/* ====== TODO - add confrimation dialog ====== */
        //Clear screen
        mainImageView.image = nil
    }
    
    @IBAction func share(sender: AnyObject) {
    }
    
    //Color selected, set line RGB
    @IBAction func pencilPressed(sender: AnyObject) {
        //Get index of color selected
        var colorIndex = sender.tag ?? 0
        //Set to black if colorIndex is out of range of colors available
        if colorIndex < 0 || colorIndex >= rgbColorsArray.count {
            colorIndex = 0
        }
        
        //Set RGB properties
        (redFloat, greenFloat, blueFloat) = rgbColorsArray[colorIndex]
        
        //Set eraser, this is actually white with overridden opacity
        if colorIndex == rgbColorsArray.count - 1 {
            lineOpacityFloat = 1.0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsViewController = segue.destinationViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.lineWidthFloat = lineWidthFloat
        settingsViewController.lineOpacityFloat = lineOpacityFloat
    }
}

