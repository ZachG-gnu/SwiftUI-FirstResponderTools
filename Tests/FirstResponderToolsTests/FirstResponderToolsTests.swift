#if canImport(UIKit)
import UIKit
import XCTest
import SwiftUI

@testable import FirstResponderTools

@available(iOS 13.0, *)
enum TestUtils {
    enum Constants {
        static let timeout: TimeInterval = 3
    }
    
    static func present<ViewType: View>(view: ViewType) {
        
        let hostingController = UIHostingController(rootView: view)
        
        let application = UIApplication.shared
        application.windows.forEach { window in
            if let presentedViewController = window.rootViewController?.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: nil)
            }
            window.isHidden = true
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.layer.speed = 10
        
        hostingController.beginAppearanceTransition(true, animated: false)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        hostingController.endAppearanceTransition()
    }
}

@available(iOS 13.0, *)
private struct TextFieldTestView: View {
    let spy1: (UITextField?) -> Void
    let spy2: (UITextField?) -> Void
    let spy3: (UITextField?) -> Void
    @State private var textFieldValue = ""
    
    let textField1Placeholder = "Text Field 1"
    let textField2Placeholder = "Text Field 2"
    let textField3Placeholder = "Text Field 3"
    
    var body: some View {
        VStack {
            TextField(textField1Placeholder, text: $textFieldValue)
                .customize { textField in
                    self.spy1(textField)
                }
            TextField(textField2Placeholder, text: $textFieldValue)
                .customize { textField in
                    self.spy2(textField)
                }
            TextField(textField3Placeholder, text: $textFieldValue)
                .customize { textField in
                    self.spy3(textField)
                }
        }
    }
}

@available(iOS 14.0, *)
private struct IsFocusedTestView: View {
    let spy: (UITextField?) -> Void
    
    @State private var textFieldValue = ""
    
    @State var isFocused: Bool = false
    
    let textFieldPlaceholder = "Text Field 1"
    
    var body: some View {
        VStack {
            TextField(textFieldPlaceholder, text: $textFieldValue)
                .customize(isFocused: $isFocused) {
                    self.spy($0)
                }
        }
    }
}

final class FirstResponderToolsTests: XCTestCase {
    
    func testTextField() throws {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let expectation3 = XCTestExpectation()
        
        var textField1: UITextField?
        var textField2: UITextField?
        var textField3: UITextField?
        
        let view = TextFieldTestView(
            spy1: {
                textField1 = $0
                expectation1.fulfill()
            },
            spy2: {
                textField2 = $0
                expectation2.fulfill()
            },
            spy3: {
                textField3 = $0
                expectation3.fulfill()
            }
        )
        
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2, expectation3], timeout: TestUtils.Constants.timeout)
        
        let unwrappedTextField1 = try XCTUnwrap(textField1)
        let unwrappedTextField2 = try XCTUnwrap(textField2)
        let unwrappedTextField3 = try XCTUnwrap(textField3)
        
        XCTAssertEqual(unwrappedTextField1.placeholder, view.textField1Placeholder)
        XCTAssertEqual(unwrappedTextField2.placeholder, view.textField2Placeholder)
        XCTAssertEqual(unwrappedTextField3.placeholder, view.textField3Placeholder)
    }
    
//    @available(iOS 14.0, *)
//    func testIsFocused() throws {
//
//        let expectation = XCTestExpectation()
//        var textField: UITextField?
//
//        let view = IsFocusedTestView(spy: {
//            textField = $0
//            expectation.fulfill()
//        })
//
//        TestUtils.present(view: view)
//        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
//
//        let unwrappedTextField = try XCTUnwrap(textField)
//        XCTAssertTrue(view.isFocused)
//    }
}

#endif
