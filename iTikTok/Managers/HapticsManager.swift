//
//  HapticsManager.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit

/// Object that deals with haptics feedback
final class HapticsManager {
    
    /// Shared singleton instance
    static let shared = HapticsManager()
    /// Private constructor
    private init() {}
    
    //MARK: - Public
    /// Vibrate for light selection of item
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    /// Trigger feedback vibration based on event type
    /// - Parameter type: Success, Error, or Warning type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
