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
        //Set line width and opacity
        self.lineWidthFloat = settingsViewController.lineWidthFloat
        self.lineOpacityFloat = settingsViewController.lineOpacityFloat
        
        //Set RGB color
        self.redFloat = settingsViewController.redFloat
        self.greenFloat = settingsViewController.greenFloat
        self.blueFloat = settingsViewController.blueFloat
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    //Create and set vars for line
    var lastPoint = CGPoint.zero
    var pointsArray = [CGPoint]()
    var drawnPath = UIBezierPath()
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    var lineWidthFloat: CGFloat = 10.0
    var lineOpacityFloat: CGFloat = 1.0
    var hasMoved = false
    var isPalm = false
    var touchRadius: CGFloat?
    
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
        //Orange
        (1.0, 102.0/255.0, 0),
        //Yellow
        (1.0, 1.0, 0),
        //Yellow-green
        (102.0/255.0, 1.0, 0),
        //Green
        (0, 150.0/255.0, 0),
        //Light Blue
        (51.0/255.0, 204.0/255.0, 1.0),
        //Blue
        (0, 0, 1.0),
        //Purple
        (145.0/255.0, 0, 1.0),
        //White (eraser)
        (1.0, 1.0, 1.0)
    ]
    
    //Start of touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Set has moved to false first
        hasMoved = false
        
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.view)
            pointsArray.append(lastPoint)
        }
    }
    
    //Touch has moved, draw line
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Set hasMove to true for Drawing in progress
        hasMoved = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            pointsArray.append(currentPoint)
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
        pointsArray.removeAll()
    }
    
    //Get center point for bezier curve
    func getMidPointFromA(a: CGPoint, andB b: CGPoint) -> CGPoint {
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
    
    //Draw line from one point to the other
    func drawLineFromPoint(startPoint: CGPoint, toPoint: CGPoint) {
        //Get current context and start drawing line in tempImageView
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        //Set anti-aliasing
//        CGContextSetAllowsAntialiasing(context, true)
//        CGContextSetShouldAntialias(context, true)
        
        //Clear out drawn path
        drawnPath.removeAllPoints()
        
//        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
//        CGContextMoveToPoint(context, startPoint.x, startPoint.y)
//        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        //Set drawing parameters
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineWidthFloat)
        CGContextSetRGBStrokeColor(context, redFloat, greenFloat, blueFloat, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        //Draw path
        //CGContextStrokePath(context)
        
        drawnPath.lineCapStyle = CGLineCap.Round
        drawnPath.lineJoinStyle = CGLineJoin.Round
        drawnPath.lineWidth = lineWidthFloat
        
        if !pointsArray.isEmpty && pointsArray.count != 1 {
            drawnPath.moveToPoint(pointsArray.first!)
            drawnPath.addLineToPoint(getMidPointFromA(pointsArray.first!, andB: pointsArray[1]))
            
            // Iterate through the remaining touch points except last
            for idx in 1..<pointsArray.count - 1 {
                let midPoint = getMidPointFromA(pointsArray[idx], andB: pointsArray[idx + 1])
                drawnPath.addQuadCurveToPoint(midPoint, controlPoint: pointsArray[idx])
            }
            //Add final point to finish line
            drawnPath.addLineToPoint(pointsArray.last!)
            //Draw path
            drawnPath.stroke()
        } else {
            //Array equals 1, meaning user only tapped. Draw a single point
            CGContextMoveToPoint(context, startPoint.x, startPoint.y)
            CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
            CGContextStrokePath(context)
        }
        
        //Wrap up context and render line into tempImageView
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = lineOpacityFloat
        UIGraphicsEndImageContext()
    }
    
    //MARK: - IBActions
    
    //Reset touched, clear image
    @IBAction func reset(sender: AnyObject) {
/* ====== TODO - add confirmation dialog ====== */
        //Clear screen
        mainImageView.image = nil
    }
    
    //Share image via any applicable app on device (facebook, email, etc). Also can save to device
    @IBAction func share(sender: AnyObject) {
        //Grab context and main image view
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        
        //Grab image and end context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Share
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        //if iPhone
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            self.presentViewController(activity, animated: true, completion: nil)
        } else {
            //is iPad, create popover
            let popOver: UIPopoverController = UIPopoverController(contentViewController: activity)
            popOver.presentPopoverFromRect(CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
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
    
    //Pass current settings (color, line width, and opacity) to settings
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsViewController = segue.destinationViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.lineWidthFloat = lineWidthFloat
        settingsViewController.lineOpacityFloat = lineOpacityFloat
        settingsViewController.redFloat = redFloat
        settingsViewController.greenFloat = greenFloat
        settingsViewController.blueFloat = blueFloat
    }
}

