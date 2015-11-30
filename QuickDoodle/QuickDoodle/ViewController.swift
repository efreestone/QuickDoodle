//
//  ViewController.swift
//  QuickDoodle
//
//  Created by Elijah Freestone on 11/28/15.
//  Copyright © 2015 Elijah Freestone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    //Create and set vars for line
    var lastPoint = CGPoint.zero
    var redFloat: CGFloat = 0.0
    var greenFloat: CGFloat = 0.0
    var blueFloat: CGFloat = 0.0
    var lineWidth: CGFloat = 10.0
    var lineOpacity: CGFloat = 1.0
    var hasMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Start of touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Set has moved to false first
        hasMoved = false
        if let touch = touches.first as UITouch! {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    //Touch has moved, draw line
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //6
        hasMoved = true
        if let touch = touches.first as UITouch! {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            //7
            lastPoint = currentPoint
        }
    }
    
    //Draw line from one point to the other
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        //1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        //2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        //3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetRGBStrokeColor(context, redFloat, greenFloat, blueFloat, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        //4
        CGContextStrokePath(context)
        
        //5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = lineOpacity 
        UIGraphicsEndImageContext()
    }
    
    //MARK: - IBActions
    
    @IBAction func reset(sender: AnyObject) {
    }
    
    @IBAction func share(sender: AnyObject) {
    }
    
    @IBAction func pencilPressed(sender: AnyObject) {
    }
}

