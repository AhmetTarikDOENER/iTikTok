//
//  Extensions.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 1.02.2024.
//

import UIKit

//MARK: - Framing
extension UIView {
    
    var width: CGFloat {
        frame.size.width
    }
    
    var height: CGFloat {
        frame.size.height
    }
    
    var left: CGFloat {
        frame.origin.x
    }
    
    var right: CGFloat {
        width + left
    }
    
    var top: CGFloat {
        frame.origin.y
    }
    
    var bottom: CGFloat {
        height + top
    }
}
//MARK: - AddSubviews
extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
//MARK: - DateFormatter
extension DateFormatter {
    
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
}
//MARK: - Date -> String Formatter
extension String {
    
    static func date(with date: Date) -> String {
        DateFormatter.defaultFormatter.string(from: date)
    }
}
