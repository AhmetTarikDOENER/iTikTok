//
//  SwitchCellViewModel.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 8.02.2024.
//

import Foundation

struct SwitchCellViewModel {
    
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
