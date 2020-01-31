//
//  TopTabBarContainerModule.swift
//  TopTabBarContainerModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CUIKit
import UIKit
import ThemeManager
import MERLin

public extension CGSize {
    static func > (_ lhs: CGSize,
                   _ rhs: CGSize) -> Bool {
        return lhs.width > rhs.width || lhs.height > rhs.height
    }
}


class ContainerTopTabBarController: TopTabBarController, Themed {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        
        let maxChildContentSize = viewControllers
            .map{ $0.preferredContentSize }
            .max(by: >)
        
        guard let maxContentSize = maxChildContentSize else {
            return
        }
        
        preferredContentSize = maxContentSize
    }
    
    func applyTheme() {
        selectedItemBackgroundColor = .color(forPalette: .white)
        unselectedItemBackgroundColor = .color(forPalette: .grey100)
        selectedItemAttributes = [
            .font: UIFont.font(forStyle: .title(attribute: .regular)),
            .foregroundColor: UIColor.color(forPalette: .black)
        ]
        
        unselectedItemAttributes = [
            .font: UIFont.font(forStyle: .title(attribute: .regular)),
            .foregroundColor: UIColor.color(forPalette: .grey300)
        ]
        hideBarIfOneOrNone = true
        topTabBar.setBorder(.bottom,
                            withColor: .color(forPalette: .grey100),
                            andThickness: 1)
    }
}

public class TopTabBarContainerContext: ModuleContextProtocol {
    public typealias ModuleType = TopTabBarContainerModule
    
    public var routingContext: String
    public var viewControllers: [UIViewController]
    
    public init(routingContext: String,
                viewControllers: [UIViewController]) {
        self.routingContext = routingContext
        self.viewControllers = viewControllers
    }
    
    public func make() -> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public class TopTabBarContainerModule:
    NSObject,
    ModuleProtocol {
    public var context: TopTabBarContainerContext
    public required init(usingContext buildContext: TopTabBarContainerContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        return ContainerTopTabBarController(viewControllers: context.viewControllers)
    }
}

