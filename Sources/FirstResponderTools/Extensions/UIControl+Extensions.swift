//
//  UIControl+Extensions.swift
//  FirstResponderTools
//

#if canImport(UIKit)
import UIKit
import SwiftUI

@available(iOS 14.0, *)
extension UIControl {
    
    private func addAction(for controlEvents: UIControl.Event,_ closure: @escaping () -> Void) {
        addAction(UIAction { action in closure() }, for: controlEvents)
    }
    
    func isFocused(_ condition: Binding<Bool>) {
        addAction(for: [.editingDidBegin, .editingDidEnd]) {
            condition.wrappedValue = self.isFirstResponder
        }
        
        if condition.wrappedValue && !isFirstResponder {
            becomeFirstResponder()
        }
        else if !condition.wrappedValue && isFirstResponder {
            resignFirstResponder()
        }
    }
    
    func isFocused<Value: Hashable>(_ binding: Binding<Value?>, equals value: Value) {
        
        addAction(for: .editingDidEnd) {
            if binding.wrappedValue == value {
                binding.wrappedValue = nil
            }
        }
        
        addAction(for: .editingDidBegin) {
            if binding.wrappedValue != value {
                binding.wrappedValue = value
            }
        }
        
        if binding.wrappedValue == value && !isFirstResponder {
            becomeFirstResponder()
        }
        else if binding.wrappedValue != value && isFirstResponder {
            resignFirstResponder()
        }
    }
    
    func isFocused(_ condition: Binding<Bool>, tag: Int) {
        guard let textField = self as? UITextField else { return }
        
        textField.tag = tag
        
        let toolBar = createToolBar()
        textField.inputAccessoryView = toolBar
        
        addAction(for: [.editingDidBegin]) { [weak self] in
            guard let uiControl = self else { return }
            
            condition.wrappedValue = uiControl.isFirstResponder
            
            let previousUIControl = uiControl.superview?.superview?.viewWithTag(tag - 1) as? UIControl
            toolBar.items?[safe: 0]?.isEnabled = previousUIControl != nil
            
            let nextUIControl = uiControl.superview?.superview?.viewWithTag(tag + 1) as? UIControl
            toolBar.items?[safe: 1]?.isEnabled = nextUIControl != nil
            
            textField.inputAccessoryView = toolBar
        }
        
        addAction(for: .editingDidEnd) { [weak self] in
            guard let uiControl = self else { return }
            
            condition.wrappedValue = uiControl.isFirstResponder
        }
        
        if condition.wrappedValue && !isFirstResponder {
            becomeFirstResponder()
        }
        else if !condition.wrappedValue && isFirstResponder {
            resignFirstResponder()
        }
    }
    
    func isFocused<Value: Hashable>(_ binding: Binding<Value?>, equals value: Value, tag: Int) {
        guard let textField = self as? UITextField else { return }
        
        textField.tag = tag
        
        let toolBar = createToolBar()
        textField.inputAccessoryView = toolBar
        
        addAction(for: .editingDidEnd) {
            if binding.wrappedValue == value {
                binding.wrappedValue = nil
            }
        }
        
        addAction(for: .editingDidBegin) { [weak self] in
            if binding.wrappedValue != value {
                binding.wrappedValue = value
            }
            
            guard let uiControl = self else { return }
            
            let previousUIControl = uiControl.superview?.superview?.viewWithTag(tag - 1) as? UIControl
            toolBar.items?[0].isEnabled = previousUIControl != nil
            
            let nextUIControl = uiControl.superview?.superview?.viewWithTag(tag + 1) as? UIControl
            toolBar.items?[1].isEnabled = nextUIControl != nil
            
            textField.inputAccessoryView = toolBar
            
        }
        
        if binding.wrappedValue == value && !isFirstResponder {
            becomeFirstResponder()
        }
        else if binding.wrappedValue != value && isFirstResponder {
            resignFirstResponder()
        }
    }
    
    /// Creates a toolbar with up and down arrows
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        
        let toolBarDownItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain, target: self,
            action: #selector(goToNextTag(sender:))
        )
        
        let toolBarUpItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.up"),
            style: .plain, target: self,
            action: #selector(goToPreviousTag(sender:))
        )
        
        toolBar.items = [
            toolBarUpItem,
            toolBarDownItem,
            .init(systemItem: .flexibleSpace),
            .init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(sender:)))
        ]
        
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func goToNextTag(sender: UIControl) {
        let nextResponder = superview?.superview?.viewWithTag(tag + 1)
        nextResponder?.becomeFirstResponder()
    }
    
    @objc func goToPreviousTag(sender: UIControl) {
        let nextResponder = superview?.superview?.viewWithTag(tag - 1)
        nextResponder?.becomeFirstResponder()
    }
    
    @objc func doneButtonTapped(sender: UIControl) {
        resignFirstResponder()
    }
}

fileprivate extension Collection {
    
    /// Allows for safe array lookups when accessing by index
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#endif
