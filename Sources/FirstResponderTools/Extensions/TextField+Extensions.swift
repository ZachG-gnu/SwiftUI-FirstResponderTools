//
//  TextField+Extensions.swift
//  FirstResponderTools
//

#if canImport(UIKit)
import UIKit
import SwiftUI

@available(iOS 13.0, *)
extension TextField {
    
    /// Customize a `TextField` by accessing its respective `UITextField`
    ///
    /// Injects a dummy view into the view hierarchy in order to access the `UITextField`
    ///
    /// - Parameters:
    ///     - customization: Returns a completion containing the `TextField's` respective `UITextField`
    public func customize(_ customization: @escaping (UITextField?) -> Void) -> some View {
        return self.background(
            UIViewRepresentableHelper(customization: customization)
        )
    }
}

@available(iOS 14.0, *)
extension TextField {
    
    /// Customize a `TextField's`  underlying `UITextField` and control its first responder status
    ///
    /// Use `customize(_:equals:_:)` for more advanced views where you need to control multiple textfields
    /// first responder status.
    ///
    /// - Parameters:
    ///     - isFoucsed: A `Binding` that controls the first responder status of the `TextField`
    ///     - customization: Returns a completion containing the `TextField's` respective `UITextField`
    public func customize(isFocused: Binding<Bool>, _ customization: @escaping (UITextField?) -> Void) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UITextField?) in
                guard let textField = textField else { return }
                textField.isFocused(isFocused)
                customization(textField)
            }
        )
    }
    
    /// Customize a `TextField's`  underlying `UITextField` and control multiple first responders status
    ///
    /// Use this for more advanced views where you need to control multiple textfields
    /// first responder status.
    ///
    /// - Parameters:
    ///     - binding: A `Binding` that controls the first responder status of the `TextField`
    ///     - value: The `value` to check against `binding`
    ///     - customization: Returns a completion containing the `TextField's` respective `UITextField`
    public func customize<Value: Hashable>(_ binding: Binding<Value?>, equals value: Value,_ customization: @escaping (UITextField?) -> Void) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UITextField?) in
                guard let textField = textField else { return }
                textField.isFocused(binding, equals: value)
                customization(textField)
            }
        )
    }
    
    /// Adds a toolbar above the keyboard for switching between first responder's
    ///
    /// The `tag` is used to reference the first responder by other first responder's. The next first responder's tag should be
    /// this `tag` + 1. By default SwiftUI tags views with 0, so the passed `tag` value should not be zero.
    ///
    /// - Parameters:
    ///     - isFoucsed: A `Binding` that controls the first responder status of the `TextField`
    ///     - tag: A positive Int that is not zero to tag the textfield with for reference by other first responder's.
    ///     - customization: Returns a completion containing the `TextField's` respective `UITextField`
    public func customize(isFocused: Binding<Bool>, tag: Int,_ customization: @escaping (UITextField?) -> Void) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UITextField?) in
                guard let textField = textField else { return }
                textField.isFocused(isFocused, tag: tag)
                customization(textField)
            }
        )
    }
    
    /// Adds a toolbar above the keyboard for switching between first responder's
    ///
    /// The `tag` is used to reference the first responder by other first responder's. The next first responder's tag should be
    /// `tag + 1`. By default SwiftUI tags views with 0, so the passed `tag` value should not be zero.
    ///
    /// - Parameters:
    ///     - binding: A `Binding` that controls the first responder status of the `TextField`
    ///     - value: The `value` to check against `binding`
    ///     - tag: A positive Int that is not zero to tag the textfield with for reference by other first responder's.
    ///     - customization: Returns a completion containing the `TextField's` respective `UITextField`
    public func customize<Value: Hashable>(_ binding: Binding<Value?>, equals value: Value, tag: Int, _ customization: @escaping (UITextField?) -> Void) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UITextField?) in
                guard let textField = textField else { return }
                textField.isFocused(binding, equals: value, tag: tag)
                customization(textField)
            }
        )
    }
    
    /// Binds the `condition` to the views first responder status
    ///
    /// - Parameters:
    ///     - condition: A `Bool` to bind to the view's first responder status
    public func isFocused(_ condition: Binding<Bool>) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UIControl?) in
                guard let textField = textField else { return }
                textField.isFocused(condition)
            }
        )
    }
    
    /// Binds the `Binding` to the views first responder status
    ///
    /// - Parameters:
    ///     - binding: A `Binding` that controls the first responder status of the `TextField`
    ///     - value: The `value` to check against `binding`
    public func isFocused<Value: Hashable>(_ binding: Binding<Value?>, equals value: Value) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UIControl?) in
                guard let textField = textField else { return }
                textField.isFocused(binding, equals: value)
            }
        )
    }
    
    /// Creates a first responder chain by binding the `condition` to the view's first responder status
    ///
    /// Adds a toolbar above the keyboard for switching between first responder's. The `tag` is used to
    /// reference the first responder by other first responder's. The next first responder's tag should be
    /// this `tag` + 1. By default SwiftUI tags views with 0, so the passed `tag` value should not be zero.
    ///
    /// - Parameters:
    ///     - condition: A `Bool` to bind to the view's first responder status
    ///     - tag: A positive Int that is not zero to tag the textfield with for reference by other first responder's.
    public func isFocused(_ condition: Binding<Bool>, tag: Int) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UIControl?) in
                guard let textField = textField else { return }
                textField.isFocused(condition, tag: tag)
            }
        )
    }
    
    /// Checks the `binding` against `value` to set the view's first responder status
    ///
    /// The `tag` is used to reference the first responder by other first responder's. The next first responder's tag should be
    /// this `tag` + 1. By default SwiftUI tags views with 0, so the passed `tag` value should not be zero.
    ///
    /// - Parameters:
    ///     - binding: A `Binding` that controls the first responder status of the `TextField`
    ///     - value: The `value` to check against `binding`
    ///     - tag: A positive Int that is not zero to tag the textfield with for reference by other first responder's.
    public func isFocused<Value: Hashable>(_ binding: Binding<Value?>, equals value: Value, tag: Int) -> some View {
        return self.background(
            UIViewRepresentableHelper { (textField: UIControl?) in
                guard let textField = textField else { return }
                textField.isFocused(binding, equals: value, tag: tag)
            }
        )
    }
}

#endif

