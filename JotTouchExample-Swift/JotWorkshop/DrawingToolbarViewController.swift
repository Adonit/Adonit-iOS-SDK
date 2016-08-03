//
//  DrawingToolbarViewController.swift
//  JotWorkshop
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

// Alright this is a little weird, this toolbar used to be on the top but now it's on the side.
// If you see values animating a Y property, it's aaaactually just the X property.

import UIKit

/**
Depending on the toolbar state, things like a wink view might be positioned differently.
The .Freestyle case is a couresy state if needed, and is safe to be treated as the .Presenting state
*/
enum ToolbarPresentationState {
	case Presenting
	case Hidden
	case Freestyle
}

class DrawingToolbarViewController: UIViewController, UIGestureRecognizerDelegate, ListensToJotSuggestions, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {

	//contains the whole toolbar, move this boy up and down
	@IBOutlet weak var containerView: UIView!
	
	//this is the container for the toolbar, and expands on smaller screens
	@IBOutlet weak var toolbarContainerView: UIView!
	
	//this contains all the content for the toolbar, add views here
	@IBOutlet weak var toolbarContentView: UIView!
	

	
	//change this constraint to move the toolbar up and down
	@IBOutlet weak var containerTopOffset: NSLayoutConstraint!
	
	//update this to include the width of all brushes
	
	@IBOutlet weak var jotSettingsView: UIView!

		
	let acceptableFingerGestureTypes = [AdonitTouchIdentificationType.Unknown, AdonitTouchIdentificationType.NotDevice]
	var drawingView:DrawingViewController!
	
	private let cornerRadius:CGFloat = 4;
	
	private(set) var presentationState:ToolbarPresentationState = .Presenting
	
	private var offscreenPanStartState:ToolbarPresentationState!
	private var lastOffscreenPanPosition:CGPoint!
	private var presentedPositionY:CGFloat!
	private var hiddenPositionY:CGFloat!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		presentedPositionY = -cornerRadius
		hiddenPositionY = presentedPositionY - containerView.frame.size.width + 12
		
		toolbarContainerView.layer.cornerRadius = cornerRadius
		toolbarContainerView.clipsToBounds = true
		
		animateToolbarTo(presentedPositionY, animate: false)
		
		let statusViewController = UIStoryboard.instantiateInitialJotViewController();
		statusViewController.view.frame = jotSettingsView.bounds;
		jotSettingsView.backgroundColor = UIColor.clearColor()
		jotSettingsView.addSubview(statusViewController.view);
		addChildViewController(statusViewController);
		
		
		JotStylusManager.sharedInstance().registerView(self.view)
		
    }
	
	
	func presentToolbar() {
		//animate to presented
	}
	
	func hideToolbar() {
		//animage to hidden
	}
	
	private func animateToolbarTo(posY:CGFloat, animate:Bool = true) {
		containerTopOffset.constant = posY
		
		if animate {
			UIView.animateWithDuration(0.25, delay: 0, options: .BeginFromCurrentState, animations: {
				self.containerView.layoutIfNeeded()
				}, completion: nil)
		} else {
			self.containerView.layoutIfNeeded()
		}
	}
	
	func jotSuggestsToDisableGestures() {
	}
	
	func jotSuggestsToEnableGestures() {
	}
	
	
	
	func refreshColorPalette() {
		
	}
	
	func deselectAll(colors:Bool = true, brushes:Bool = true) {
		
	}
	
	//
	// TODO: Deselect everything then select the correct things if necessary
	//
	
	func checkEraser() {
		deselectAll()
		
	}
	
	func checkColors() {
		
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0;
	}
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return false;
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
	}
}
