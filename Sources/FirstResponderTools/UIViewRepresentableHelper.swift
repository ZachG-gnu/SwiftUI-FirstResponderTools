//
//  UIViewRepresentableHelper.swift
//  FirstResponderTools
//

#if canImport(UIKit)
import UIKit
import SwiftUI

final class UIViewHelper: UIView {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

struct UIViewRepresentableHelper<T: UIView>: UIViewRepresentable {
    let customization: (T?) -> Void
    private let tag = UUID().hashValue
    
    func makeUIView(context: Context) -> UIViewHelper {
        let helperView = UIViewHelper()
        helperView.tag = tag
        return helperView
    }
    
    func updateUIView(_ uiView: UIViewHelper, context: UIViewRepresentableContext<Self>) {
        DispatchQueue.main.async {
            let sibling = uiView.sibling() as? T
            customization(sibling)
        }
    }
}

extension UIViewHelper {
    
    /// Finds and returns the view's next sibling from the view hierarchy
    func sibling<T: UIView>() -> T? {
        guard let rootViews = self.superview?.superview?.subviews else {
            return nil
        }
        
        let index = rootViews.firstIndex(where: { $0.subviews.first?.tag == self.tag })
        guard var index = index?.advanced(by: 1) else { return nil }
        
        while index < rootViews.endIndex {
            if let sibling = rootViews[index].subviews.first as? T {
                return sibling
            }
            index = rootViews.index(after: index)
        }
        
        return nil
    }
}

#endif
