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
	var pinchDuration:TimeInterval = 0
	var pinchTimer:Timer?
	var panOffset = CGPoint(x: 0, y: 0)
	var panPosition = CGPoint(x: 0, y: 0)
	var rotation:CGFloat = 0
	var panning = false
	var pinching = false
	var rotating = false
	
	let acceptableFingerGestureTypes = [AdonitTouchIdentificationType.unknown, AdonitTouchIdentificationType.notDevice, AdonitTouchIdentificationType.potentialDevice]
	
	@IBOutlet weak var drawingView: UIView!
	var drawingToolbar: DrawingToolbarViewController!

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let jotManager = JotStylusManager.sharedInstance()
		
		jotManager?.lineSmoothingAmount = 0.5
		jotManager?.unconnectedPressure = 1024
		jotManager?.register(self.drawingView)
		jotManager?.jotStrokeDelegate = self
		
		jotManager?.addShortcutOptionButton2Default(JotShortcut(descriptiveText: "Redo", key: "redo", target: self, selector: #selector(DrawingViewController.redo)))
		jotManager?.addShortcutOptionButton1Default(JotShortcut(descriptiveText: "Undo", key: "undo", target: self, selector: #selector(DrawingViewController.undo)))
		
		NotificationCenter.default.addObserver(self, selector: #selector(DrawingViewController.jotStylusConnectionChanged(_:)), name: NSNotification.Name(rawValue: JotStylusManagerDidChangeConnectionStatus), object: nil)
		
		jotManager?.enable()
	}
	
	func clearCanvas() {
	}
		
	func jotStylusConnectionChanged(_ note: Notification) {
		guard let item = note.userInfo?[JotStylusManagerDidChangeConnectionStatusStatusKey] as? NSNumber,
			let _ = JotConnectionStatus(rawValue: item.uintValue) else {
			print("Problem parsing jot connection notification!")
            return
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
	
    func jotStylusStrokeBegan(_ stylusStroke: JotStroke) {
        NSLog("jotStylusStrokeBegan");
    }

    func jotStylusStrokeMoved(_ stylusStroke: JotStroke) {
    }

    func jotStylusStrokeEnded(_ stylusStroke: JotStroke) {
        NSLog("jotStylusStrokeEnded");
    }
	
    func jotStylusStrokeCancelled(_ stylusStroke: JotStroke) {
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		//check for touch radius and identifiers
		return acceptableFingerGestureTypes.contains(touch.adonitTouchIdentification)
	}
	

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
}
