//
//  UIApplication.swift
//  MemoApp
//
//  Created by ToshiPro01 on 2021/08/26.
//

import Foundation
import SwiftUI

extension UIApplication {
    // キーボードを閉じる
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
