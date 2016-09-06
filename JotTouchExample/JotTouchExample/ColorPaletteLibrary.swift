//
//  ColorPaletteLibrary.swift
//  JotWorkshop
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

// Although we support multiple palettes, there's no UI currently that allows you to switch between them

import Foundation

protocol ColorChangeListener: class {
	var colorChangeListenerID:Int? {get set}
	func currentColorDidChange(color:HSBA)
}

class ColorPaletteLibrary: NSObject {
	static let colorsPerPalette = 5
	private var listenerID = -1
	private var listeners = [ColorChangeListener?]()
	
    var palettes = [ColorPalette]()

	private(set) var currentPaletteIndex = 0 {
		didSet {
			assert(currentPaletteIndex < palettes.count && currentPaletteIndex >= 0, "Current Palette Index out of range!")
			tellListeners()
		}
	}
	var currentColorIndex = 0 {
		didSet {
			assert(currentColorIndex < ColorPaletteLibrary.colorsPerPalette && currentColorIndex >= 0, "Current Color Index out of range!")
            NSUserDefaults.standardUserDefaults().setInteger(currentColorIndex, forKey: "currentColorIndex")
            tellListeners()
		}
	}
	
    override init() {
        var hexStringArray = NSUserDefaults.standardUserDefaults().arrayForKey("hexStringArray") as? [String]
        
        if hexStringArray == nil {
            hexStringArray = ["322214", "4C443C", "76949F", "DD6031", "D9DD92"]
        }
        else {
            currentColorIndex = NSUserDefaults.standardUserDefaults().integerForKey("currentColorIndex")
        }
        
        var hsbaColorsArray = [HSBA]()
        for hexString in hexStringArray! {
            hsbaColorsArray.append(UIColor(hex: hexString).getHSBA())
        }
        palettes.append(ColorPalette(colors: hsbaColorsArray))
    }
	
	var currentPalette:ColorPalette {
		return palettes[currentPaletteIndex]
	}
	
    var currentColor:HSBA {
        return currentPalette.colors[currentColorIndex]
    }
	
    func overwriteCurrentColor(hue h:CGFloat, saturation s:CGFloat, brightness b:CGFloat, alpha a:CGFloat) {
        overwriteCurrentColor(HSBA(h: h, s: s, b: b, a: a))
    }
    
	func overwriteCurrentColor(color:HSBA) {
		currentPalette.colors[currentColorIndex] = color
		
		tellListeners()
	}
    
    func saveCurrentColor(color:HSBA) {
        var hexStringArray = [String]()
        
        for hsbaColor in currentPalette.colors {
            hexStringArray.append(hsbaColor.toHex())
        }
        
        NSUserDefaults.standardUserDefaults().setObject(hexStringArray, forKey: "hexStringArray")
    }
	
	/**
	Meant for keeping a hue correct
	*/
	func overwriteCurrentColor(saturation s:CGFloat, brightness b:CGFloat) -> HSBA {
		let color = currentColor
		overwriteCurrentColor(HSBA(h: color.h, s: s, b: b, a: color.a))
		
		return currentColor
	}
	
	func overwriteCurrentColor(hue h:CGFloat) -> HSBA {
		let color = currentColor
		overwriteCurrentColor(HSBA(h: h, s: color.s, b: color.b, a: color.a))
		
		return currentColor
	}
	
	func addListener(listener:ColorChangeListener) {
        listenerID = listenerID + 1
        listener.colorChangeListenerID = listenerID
		listeners.append(listener)
	}
	
	func removeListener(listener:ColorChangeListener) {
		//wow currently impossible in Swift 2.0...
//		listeners -= [listener]
		
		listeners = listeners.filter { $0 != nil && $0!.colorChangeListenerID != listener.colorChangeListenerID }
	}
	
	func refresh() {
		tellListeners()
	}
	
	private func tellListeners() {
		listeners = listeners.filter { $0 != nil } //cull
		listeners.forEach { $0!.currentColorDidChange(self.currentColor) }
	}
    
    func colorForCurrentPalatteAtIndex(index:NSInteger) -> UIColor {
        return currentPalette.colors[index].toColor()
    }
}

class ColorPalette {
	//add color palette special stuff here later
	var colors = [HSBA]()
	
	init(colors:[HSBA]) {
		let amount = ColorPaletteLibrary.colorsPerPalette
		
		assert(colors.count == amount, "Color palettes need \(amount) colors in init!")
		
		self.colors += colors
	}
}