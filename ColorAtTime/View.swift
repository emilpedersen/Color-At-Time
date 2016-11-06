//
//  ColorAtTime.swift
//  ColorAtTime
//
//  Created by Emil Pedersen on 06/11/2016.
//  Copyright © 2016 Ambisapp. All rights reserved.
//

import AppKit
import ScreenSaver

/// Color at time screen saver.
public class View: ScreenSaverView {
    
    // MARK: - Properties
    
    /// The text font
    private var font: NSFont!
    
    
    // MARK: - NSView
    
    // This is where the drawing happens. It gets called indirectly from 'animateOneFrame'.
    public override func draw(_ rect: NSRect) {
        
        // Get the current time as a color
        let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        if let hour = comps.hour, let minute = comps.minute, let second = comps.second {
            let red = pad(integer: hour)
            let green = pad(integer: minute)
            let blue = pad(integer: second)
            let color = NSColor(srgbRed: hexValue(string: red), green: hexValue(string: green), blue: hexValue(string: blue), alpha: 1)
            
            // Draw that color as the background
            color.setFill()
            NSBezierPath.fill(rect)
            
            // Get the color as text so we can display it
            let string = "#\(red)\(green)\(blue)" as NSString
            let attributes = [
                NSForegroundColorAttributeName: NSColor.white,
                NSFontAttributeName: font
            ]
            
            // Calculate where the text will be drawn
            let stringSize = string.size(withAttributes: attributes)
            let stringRect = CGRect(
                x: round((bounds.width - stringSize.width) / 2),
                y: round((bounds.height - stringSize.height) / 2),
                width: stringSize.width,
                height: stringSize.height
            )
            
            // Draw the text
            string.draw(in: stringRect, withAttributes: attributes)
        }
    }
    
    // If the screen saver changes size, update the font
    public override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        updateFont()
    }
    
    
    // MARK: - ScreenSaverView
    
    public override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    /// The screen saver engine calls this whenever it wants to display a new frame.
    public override func animateOneFrame() {
        setNeedsDisplay(bounds)
    }
    
    
    // MARK: - Private
    
    /// Setup
    private func initialize() {
        // Set to 15fps
        animationTimeInterval = 1.0 / 4.0
        updateFont()
    }
    
    /// Turn an integer into a 2 character string. `1` becomes "01". `12` becomes "12".
    private func pad(integer: Int) -> String {
        var string = String(integer)
        if string.characters.count == 1 { //.lengthOfBytes(using: String.Encoding.utf8) == 1 {
            string = "0" + string
        }
        return string
    }
    
    /// Get the value of a hex string from 0.0 to 1.0
    private func hexValue(string: String) -> CGFloat {
        let value = Double(strtoul(string, nil, 16))
        return CGFloat(value / 255.0)
    }
    
    /// Update the font for the current size
    private func updateFont() {
        font = fontWithSize(fontSize: bounds.size.width / 6.0)
    }
    
    /// Get a monospaced font
    private func fontWithSize(fontSize: CGFloat) -> NSFont {
        let font: NSFont
        if #available(OSX 10.11, *) {
            font = NSFont.systemFont(ofSize: fontSize, weight: NSFontWeightThin)
        } else {
            font = NSFont(name: "HelveticaNeue-Thin", size: fontSize)!
        }
        
        let fontDescriptor = font.fontDescriptor.addingAttributes([
            NSFontFeatureSettingsAttribute: [
                [
                    NSFontFeatureTypeIdentifierKey: kNumberSpacingType,
                    NSFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector
                ]
            ]
            ])
        return NSFont(descriptor: fontDescriptor, size: fontSize)!
    }
}





