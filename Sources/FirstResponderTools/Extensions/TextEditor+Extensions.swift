//
//  TextEditor+Extensions.swift
//  FirstResponderTools
//

#if canImport(UIKit)
import UIKit
import SwiftUI

@available(iOS 14.0, *)
extension TextEditor {
    
    /// Customize a `TextEditor` by accessing its respective `UITextView`
    ///
    /// - Parameters:
    ///      - customization: Returns a completion containing the `TextView's` respective `UITextView`
    public func customize(_ customization: @escaping (UITextView?) -> Void) -> some View {
        return self.background(
            UIViewRepresentableHelper(customization: customization)
        )
    }
}

#endif
