//
//  DrawingViewController.swift
//  JotWorkshop
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

// The good ol' overworked main ViewController of the app

import UIKit

protocol ListensToJotSuggestions {
	func jotSuggestsToDisableGestures()
	func jotSuggestsToEnableGestures()
}

class DrawingViewController: UIViewController, JotStrokeDelegate, ListensToJotSuggestions, UIGestureRecognizerDelegate {
	var lastPressure:CGFloat = 0
	var scale:CGFloat = 1
	var pinchDuration:NSTimeInterval = 0
	var pinchTimer:NSTimer?
	var panOffset = CGPoint(x: 0, y: 0)
	var panPosition = CGPoint(x: 0, y: 0)
	var rotation:CGFloat = 0
	var panning = false
	var pinching = false
	var rotating = false
	
	let acceptableFingerGestureTypes = [AdonitTouchIdentificationType.Unknown, AdonitTouchIdentificationType.NotDevice, AdonitTouchIdentificationType.PotentialDevice]
	
	@IBOutlet weak var drawingView: UIView!
	var drawingToolbar: DrawingToolbarViewController!

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let jotManager = JotStylusManager.sharedInstance()
		
		jotManager.lineSmoothingAmount = 0.5
		jotManager.unconnectedPressure = 1024
		jotManager.registerView(self.drawingView)
		jotManager.jotStrokeDelegate = self
		
		jotManager.addShortcutOptionButton2Default(JotShortcut(descriptiveText: "Redo", key: "redo", target: self, selector: Selector("redo")))
		jotManager.addShortcutOptionButton1Default(JotShortcut(descriptiveText: "Undo", key: "undo", target: self, selector: Selector("undo")))
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("jotStylusConnectionChanged:"), name: JotStylusManagerDidChangeConnectionStatus, object: nil)
		
		jotManager.enable()
	}
	
	func clearCanvas() {
	}
	
	
	
	
	func jotStylusConnectionChanged(note: NSNotification) {
		if let item = note.userInfo?[JotStylusManagerDidChangeConnectionStatusStatusKey] as? NSNumber,
			let status = JotConnectionStatus(rawValue: item.unsignedLongValue) {
				
		} else {
			print("Problem parsing jot connection notification!")
		}
	}
	
	func undo() {
	}
	
	func redo() {
	}
	
	
	/// Check if we should start or continue drawing with this item (be it a JotStroke or UITouch)
	
	func jotSuggestsToDisableGestures() {
		
	}
	
	func disableGestures() {
		
	}
	
	func jotSuggestsToEnableGestures() {
		
	}
	
    func jotStylusStrokeBegan(stylusStroke: JotStroke) {
        NSLog("jotStylusStrokeBegan");
    }

    func jotStylusStrokeMoved(stylusStroke: JotStroke) {
    }

    func jotStylusStrokeEnded(stylusStroke: JotStroke) {
        NSLog("jotStylusStrokeEnded");
    }
	
    func jotStylusStrokeCancelled(stylusStroke: JotStroke) {
    }
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		//check for touch radius and identifiers
		return acceptableFingerGestureTypes.contains(touch.adonitTouchIdentification)
	}
	

	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}
