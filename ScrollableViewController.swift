//
//  ScrollableViewController.swift
//  DismissKeyboard
//
//  Created by Victor Tavares on 3/12/15.
//  Copyright (c) 2015 Private. All rights reserved.
//

import UIKit

class ScrollableViewController: UIViewController {

        var activeTextField:UITextField!
        var scrollAmount:CGFloat = 0.0
        var moveViewUp = false
        var textFieldOffSet:CGFloat = 60
    
    
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            registerForKeyBoardNotifications()
        }
    
        override func viewDidDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
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
    
    
            var bottom = activeTextField.frame.origin.y + activeTextField.frame.height + textFieldOffSet
            scrollAmount = keyboardSize.height - (view.frame.height - bottom)
    
    
            if scrollAmount > 0 {
                moveViewUp = true
                scrollView(true)
            } else {
                moveViewUp = false
            }
        }
    
    
        func keyboardWillBeHidden(aNotification: NSNotification) {
            //println("Keyboard will be hidden")
            if moveViewUp {
                scrollView(false)
            }
        }
    
        func scrollView(move:Bool) {
            println("Before:\(scrollAmount)")
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
    
            if move {
                self.view.frame.origin.y -= self.scrollAmount
            } else {
                self.view.frame.origin.y += self.scrollAmount
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
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            if (activeTextField != nil) {
                activeTextField.resignFirstResponder();
            }
        }


}
