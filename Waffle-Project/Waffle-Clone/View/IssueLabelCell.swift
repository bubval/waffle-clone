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
            let issueColor = UIColor(hex: self.label.color)
            
            if let isLight = issueColor.isLight() {
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
    
    convenience init(hex: String) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        self.init(
            red: CGFloat((hexInt & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexInt & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hexInt & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
        
        let lightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (lightness > threshold)
    }
}
