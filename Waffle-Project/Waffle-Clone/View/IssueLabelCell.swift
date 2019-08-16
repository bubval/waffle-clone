//
//  IssueLabelCell.swift
//  Waffle-Clone
//
//  Created by Lubo on 15.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class IssueLabelCell: UICollectionViewCell {
    @IBOutlet weak var issueLabel: UILabel!
    private var label: LabelResponse! {
        didSet {
            issueLabel.text = self.label.name

            if let issueColor = UIColor.init(hex: "#" + self.label.color + "ff"),
                let isLight = issueColor.isLight(){
                self.backgroundColor = issueColor
                if isLight {
                    issueLabel.textColor = UIColor.black
                } else {
                    issueLabel.textColor = UIColor.white
                }
            } else {
                self.backgroundColor = UIColor.white
                issueLabel.textColor = UIColor.black
            }
        }
    }
    
    func setLabel(to label: LabelResponse) {
        self.label = label
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        // Toggle auto layout
        setNeedsLayout()
        layoutIfNeeded()
        
        // Fits contentView to the target size in layoutAttributes
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        // Calculates correct height of cell
        var frame = layoutAttributes.frame
        frame.size.width = ceil(size.width)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    // Threshold works good anywhere between 0.5 and 0.7
    // A nil value is returned if the lightness couldn't be determined.
    func isLight(threshold: Float = 0.5) -> Bool? {
        
        let originalCGColor = self.cgColor
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
