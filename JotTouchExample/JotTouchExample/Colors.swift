//
//  Colors.swift
//  JotWorkshop
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

// Once you dream in HSB instead of RGB the world will be a fantastic place

import UIKit

struct RGBA {
	var r, g, b, a:CGFloat
	
	func toHSBA() -> HSBA {
		//Might be incorrect and need to be replaced with rgbToHsv at http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
		print("RGBA Transf: \(self) to HSBA", terminator: "")
		
		let maxVal = max(r, g, b)
		let minVal = min(r, g, b)
		var h:CGFloat = 0
		var s:CGFloat = 0
		let l = (maxVal + minVal) / 2
		
		if maxVal == minVal {
			h = 0
			s = 0
		} else  {
			let d = maxVal - minVal
			s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal)
			switch maxVal {
			case r:
				h = (g - b) / d + (g < b ? 6 : 0)
			case g:
				h = (b - r) / d + 2
			case b:
				h = (r - g) / d + 4
			default:
				print("Might have messed up hsl conversion", terminator: "")
				h = 0
			}
			
			h =  h / 6
		}
		
		let result = HSBA(h: h, s: s, b: l, a: self.a)
		
		print("HSBA Result: \(result)", terminator: "")
		
		return result
	}
	
	func toColor() -> UIColor {
		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
}

//note, I only call it HSB and not HSL/HSV because that's what apple calls it. :\
struct HSBA {
	var h, s, b, a:CGFloat
    
    func toHex() -> String {
        let color = self.toRGBA()
        let r = Int(Double(color.r) * 255.0)
        let g = Int(Double(color.g) * 255.0)
        let b = Int(Double(color.b) * 255.0)
        return String(format: "%02x%02x%02x", r, g, b)
    }
    
	func toColor() -> UIColor {
		return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
	}
	
	func toRGBA() -> RGBA {
		var r2:CGFloat = 0
		var g2:CGFloat = 0
		var b2:CGFloat = 0
		
		let i = floor(h * 6)
		let f = h * 6 - i
		let p = b * (1 - s)
		let q = b * (1 - f * s)
		let t = b * (1 - (1 - f) * s)
		
		switch i.truncatingRemainder(dividingBy: 6) {
		case 0:
			r2 = b; g2 = t; b2 = p
		case 1:
			r2 = q; g2 = b; b2 = p;
		case 2:
			r2 = p; g2 = b; b2 = t;
		case 3:
			r2 = p; g2 = q; b2 = b;
		case 4:
			r2 = t; g2 = p; b2 = b;
		case 5:
			r2 = b; g2 = p; b2 = q;
		default:
			print("Error converting to RGBA", terminator: "")
		}
		
		return RGBA(r: r2, g: g2, b: b2, a: a)
	}
}

extension UIColor {
	/**
	Doesn't require # prefix.
	Works with 4 lengths:
	#fff = rgb
	#ffff = rgba
	#ffffff = rgb
	#ffffffff = rgba
	*/
	convenience init(hex: String) {
		var r:CGFloat = 0
		var g:CGFloat = 0
		var b:CGFloat = 0
		var a:CGFloat = 1
		
		var val = hex
		
		if let range = hex.range(of: "#") {
			val = hex.substring(from: hex.characters.index(range.lowerBound, offsetBy: 1))
			print("val: \(val)", terminator: "")
		}
		
		let scanner = Scanner(string: val)
		var hexValue: CUnsignedLongLong = 0
		
		if scanner.scanHexInt64(&hexValue) {
			switch val.characters.count {
			case 3:
				r = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
				g = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
				b = CGFloat( hexValue & 0x00F)             / 15.0
			case 4:
				r = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
				g = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
				b = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
				a = CGFloat( hexValue & 0x000F)            / 15.0
			case 6:
				r = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
				g = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
				b = CGFloat( hexValue & 0x0000FF)          / 255.0
			case 8:
				r = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
				g = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
				b = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
				a = CGFloat( hexValue & 0x000000FF)        / 255.0
			default:
				print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
			}
		}
		
		self.init(red: r, green: g, blue: b, alpha: a)
	}
	
	func getRGBA() -> RGBA {
		var r:CGFloat = 0
		var g:CGFloat = 0
		var b:CGFloat = 0
		var a:CGFloat = 0
		
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		
		return RGBA(r: r, g: g, b: b, a: a)
	}
	
	func getHSBA() -> HSBA {
		var h:CGFloat = 0
		var s:CGFloat = 0
		var b:CGFloat = 0
		var a:CGFloat = 0
		
		self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		
		return HSBA(h: h, s: s, b: b, a: a)
	}
}

struct FourWayGradient {
	var topLeft:RGBA
	var topRight:RGBA
	var botLeft:RGBA
	var botRight:RGBA
	
	func getRGBA(xPercentage x:CGFloat, yPercentage y:CGFloat) -> RGBA {
		let r1 = topLeft.r.lerpTo(topRight.r, delta: x)
		let r2 = botLeft.r.lerpTo(botRight.r, delta: x)
		let r = r1.lerpTo(r2, delta: y)
		
		let g1 = topLeft.g.lerpTo(topRight.g, delta: x)
		let g2 = botLeft.g.lerpTo(botRight.g, delta: x)
		let g = g1.lerpTo(g2, delta: y)
		//
		let b1 = topLeft.b.lerpTo(topRight.b, delta: x)
		let b2 = botLeft.b.lerpTo(botRight.b, delta: x)
		let b = b1.lerpTo(b2, delta: y)
		
		return RGBA(r: r, g: g, b: b, a: 1)
	}
}
