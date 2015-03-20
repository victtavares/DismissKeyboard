//
//  ScrollableViewController.swift
//  OpinionsApp
//
//  Created by eCGlobal App 02 on 13/03/15.
//  Copyright (c) 2015 eCGlobalSolutions. All rights reserved.
//

import UIKit

class ScrollableViewController: UIViewController {
    
    var activeTextField:UITextField!
    var scrollAmount:CGFloat = 0.0
    var textFieldOffSet:CGFloat = 60
    private var initialFrame: CGRect!
    
    override func viewDidLoad() {
        initialFrame = self.view.frame
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyBoardNotifications()
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        //Removing the selector when the user go to another screen
        for myView in self.view.subviews {
            if myView.isFirstResponder() && myView.isKindOfClass(UITextField){
                myView.resignFirstResponder()
                //println("Resign keyboard")
            }
        }
        
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //Register Keyboard Notifications
    func registerForKeyBoardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWasShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func keyboardWasShow(aNotification:NSNotification) {
        //println("Keyboard will show up")
        let info:NSDictionary = aNotification.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        

        if (activeTextField != nil) {
            //var bottom = activeTextField.frame.origin.y + activeTextField.frame.height + textFieldOffSet + view.frame.origin.y
            let superViewFrame = activeTextField.superview?.frame
            var bottom = activeTextField.frame.origin.y + activeTextField.frame.height + textFieldOffSet + superViewFrame!.origin.y
            scrollAmount = keyboardSize.height - (view.frame.height - bottom)
            //println(scrollAmount)
            if scrollAmount > 0 {
                scrollView(true)
            }
        }
    }
    
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        //println("Keyboard will be hidden")
        scrollView(false)
        
    }
    
    func scrollView(move:Bool) {
        //println("Before:\(scrollAmount)")
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        
        if move {
            self.view.frame.origin.y -= self.scrollAmount
        } else {
            self.view.frame.origin.y = self.initialFrame.origin.y
        }
        
        UIView.commitAnimations()
    }
    
    
    //MARK: - UITextField Delegate Methods
    func textFieldDidBeginEditing(textField: UITextField!) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        activeTextField = nil
    }
    

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (activeTextField != nil) {
            activeTextField.resignFirstResponder();
        }
    }
    
    
}
