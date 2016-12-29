//
//  Numbers.swift
//  JotWorkshop
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

// Note, this stuff could be written much more beautifully in Swift 2
// by extending protocols and conforming numbers to those protocols

extension Int {
	func toCGFloat() -> CGFloat {
		return CGFloat(self)
	}
}

extension Float {
	/// Returns a new float from 0 to 1
	public static func random() -> Float {
		return Float(arc4random()) / 0xFFFFFFFF
	}
	
	/// Returns a random float from min to max
	public static func randomWithin(min: Float, max: Float) -> Float {
		return Float.random() * (max - min) + min
	}
	
	func withinRangeOf(other:Float, range:Float) -> Bool {
		return fabs(self - other) <= range
	}
	
	/// Assuming this number is from 0 to 1, linearly interpolate from and to
	func lerpAsDelta(from:Float, to:Float) -> Float {
		return from + (to - from) * self
	}
	
	/// Linear interpolate to the other number via a delta from 0 to 1
	func lerpTo(other:Float, delta:Float) -> Float {
		return self + (other - self) * delta
	}
	
	/// Transform this value as percentage of an old range to a new range
	func mapFrom(_ mapFromStart:Float, _ mapFromEnd:Float, to mapToStart:Float, _ mapToEnd:Float, clamped:Bool = false) -> Float {
		var from = (self - mapFromStart) / (mapFromEnd - mapFromStart)
		if clamped {
			from = from.clamp(min: mapFromStart, max: mapFromEnd)
		}
		
        var to = from.lerpAsDelta(from: mapToStart, to: mapToEnd)
		if clamped {
			to = to.clamp(min: mapToStart, max: mapToEnd)
		}
		
		return to
	}
	
	/// Similar to lerpAsDelta
	func mapAsDeltaTo(_ mapToStart:Float, _ mapToEnd:Float) -> Float {
		return self.mapFrom(0, 1, to: mapToStart, mapToEnd)
	}
	
	func clamp(min:Float, max:Float) -> Float {
		let from = min < max ? min : max
		let to = min > max ? min : max
		return self < from ? from : (self > to ? to : self)
	}
	
	func toCGFloat() -> CGFloat {
		return CGFloat(self)
	}
}

extension CGPoint {
	@inline(__always) func distanceTo(_ other:CGPoint) -> CGFloat {
		let dx = other.x - self.x
		let dy = other.y - self.y
		return sqrt(dx * dx + dy * dy)
	}
	
	func mapFrom(_ mapFrom:CGRect, to mapTo:CGRect, clamped:Bool = false) -> CGPoint {
		let dx = self.x.mapFrom(mapFrom.minX, mapFrom.maxX, to: mapTo.minX, mapTo.maxX, clamped: clamped)
		let dy = self.y.mapFrom(mapFrom.minY, mapFrom.maxY, to: mapTo.minY, mapTo.maxY, clamped: clamped)
		
		return CGPoint(x: dx, y: dy)
	}
	
	func mapAsDeltaTo(_ mapTo:CGRect, clamped:Bool = false) -> CGPoint {
		return self.mapFrom(CGRect(x: 0, y: 0, width: 1, height: 1), to: mapTo, clamped: clamped)
	}
	
	func clamp(bounds:CGRect) -> CGPoint {
		let dx = self.x.clamp(min: bounds.minX, max: bounds.maxX)
		let dy = self.y.clamp(min: bounds.minY, max: bounds.maxY)
		
		return CGPoint(x: dx, y: dy)
	}
	
	func withinRangeOf(_ other:CGPoint, range:CGFloat) -> Bool {
		return self.distanceTo(other) <= range
	}
	
	func lerpTo(_ other:CGPoint, delta:CGFloat) -> CGPoint {
		let x = self.x.lerpTo(other.x, delta: delta)
		let y = self.y.lerpTo(other.y, delta: delta)
		
		return CGPoint(x: x, y: y)
	}
	
	/// Add x and y of other to our x and y
	func offset(_ other:CGPoint) -> CGPoint {
		return CGPoint(x: x + other.x, y: y + other.y)
	}
	
	/// Multiply our x and y by this new value
	func multiply(_ value:CGFloat) -> CGPoint {
		return CGPoint(x: x * value, y: y * value)
	}
}

extension CGSize {
	func toPoint() -> CGPoint {
		return CGPoint(x: self.width, y: self.height)
	}
}

extension CGFloat {
	/// Returns a new float from 0 to 1.
	public static func random() -> CGFloat {
		return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
	}
	
	public static func randomWithin(min: Float, max: Float) -> CGFloat {
		return CGFloat(Float.random() * (max - min) + min)
	}
	
	func withinRangeOf(_ other:CGFloat, range:CGFloat) -> Bool {
		return fabs(self - other) <= range
	}
	
	func lerpAsDelta(from:CGFloat, to:CGFloat) -> CGFloat {
		return from + (to - from) * self
	}
	
	func lerpAsDelta(from:CGPoint, to:CGPoint) -> CGPoint {
		return from.lerpTo(to, delta: self)
	}
	
	func lerpTo(_ other:CGFloat, delta:CGFloat) -> CGFloat {
		return self + (other - self) * delta
	}
	
	func mapFrom(_ mapFromStart:CGFloat, _ mapFromEnd:CGFloat, to mapToStart:CGFloat, _ mapToEnd:CGFloat, clamped:Bool = false) -> CGFloat {
        var from: CGFloat = (self - mapFromStart) / (mapFromEnd - mapFromStart)
		if clamped {
			from = from.clamp(min: mapFromStart, max: mapFromEnd)
		}
		
		var to = from.lerpAsDelta(from: mapToStart, to: mapToEnd)
		if clamped {
			to = to.clamp(min: mapToStart, max: mapToEnd)
		}
		
		return to
	}
	
	func mapAsDeltaTo(_ mapToStart:CGFloat, _ mapToEnd:CGFloat) -> CGFloat {
		return self.mapFrom(0, 1, to: mapToStart, mapToEnd)
	}
	
	func clamp(min:CGFloat, max:CGFloat) -> CGFloat {
		let from = min < max ? min : max
		let to = min > max ? min : max
		return self < from ? from : (self > to ? to : self)
	}
	
	func toFloat() -> Float {
		return Float(self)
	}
	
	func toInt() -> Int {
		return Int(self)
	}
}

extension CGRect {
	/// Get midpoint of X and Y in rect
	func getCenter() -> CGPoint {
		return CGPoint(x: self.midX, y: self.midY)
	}
    
    /// Returns a point within the frame of the rectangle
    func randomInclusivePoint() -> CGPoint {
        return CGPoint(x: CGFloat.random().lerpAsDelta(from: self.minX, to: self.maxX), y: CGFloat.random().lerpAsDelta(from: self.minY, to: self.maxY))
    }
}

extension CGSize {
	/// Returns a rect at 0,0 with this size and height
	func makeRect() -> CGRect {
		return CGRect(x: 0, y: 0, width: self.width, height: self.height)
	}
	
	func multiply(_ num:CGFloat) -> CGSize {
		return CGSize(width: self.width * num, height: self.height * num)
	}
}
