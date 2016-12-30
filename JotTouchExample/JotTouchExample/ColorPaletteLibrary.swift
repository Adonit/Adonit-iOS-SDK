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
	func currentColorDidChange(_ color:HSBA)
}

class ColorPaletteLibrary: NSObject {
	static let colorsPerPalette = 5
	fileprivate var listenerID = -1
	fileprivate var listeners = [ColorChangeListener?]()
	
    var palettes = [ColorPalette]()

	fileprivate(set) var currentPaletteIndex = 0 {
		didSet {
			assert(currentPaletteIndex < palettes.count && currentPaletteIndex >= 0, "Current Palette Index out of range!")
			tellListeners()
		}
	}
	var currentColorIndex = 0 {
		didSet {
			assert(currentColorIndex < ColorPaletteLibrary.colorsPerPalette && currentColorIndex >= 0, "Current Color Index out of range!")
            UserDefaults.standard.set(currentColorIndex, forKey: "currentColorIndex")
            tellListeners()
		}
	}
	
    override init() {
        var hexStringArray = UserDefaults.standard.array(forKey: "hexStringArray") as? [String]
        
        if hexStringArray == nil {
            hexStringArray = ["322214", "4C443C", "76949F", "DD6031", "D9DD92"]
        }
        else {
            currentColorIndex = UserDefaults.standard.integer(forKey: "currentColorIndex")
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
    
	func overwriteCurrentColor(_ color:HSBA) {
		currentPalette.colors[currentColorIndex] = color
		
		tellListeners()
	}
    
    func saveCurrentColor(_ color:HSBA) {
        var hexStringArray = [String]()
        
        for hsbaColor in currentPalette.colors {
            hexStringArray.append(hsbaColor.toHex())
        }
        
        UserDefaults.standard.set(hexStringArray, forKey: "hexStringArray")
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
	
	func addListener(_ listener:ColorChangeListener) {
        listenerID = listenerID + 1
        listener.colorChangeListenerID = listenerID
		listeners.append(listener)
	}
	
	func removeListener(_ listener:ColorChangeListener) {
		//wow currently impossible in Swift 2.0...
//		listeners -= [listener]
		
		listeners = listeners.filter { $0 != nil && $0!.colorChangeListenerID != listener.colorChangeListenerID }
	}
	
	func refresh() {
		tellListeners()
	}
	
	fileprivate func tellListeners() {
		listeners = listeners.filter { $0 != nil } //cull
		listeners.forEach { $0!.currentColorDidChange(self.currentColor) }
	}
    
    func colorForCurrentPalatteAtIndex(_ index:NSInteger) -> UIColor {
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
