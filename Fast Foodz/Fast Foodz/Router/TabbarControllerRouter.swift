//
//  TabbarControllerRouter.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import MERLin

class TabBarControllerRouter: Router {
    var viewControllersFactory: ViewControllersFactory?
    
    init(withFactory factory: ViewControllersFactory) {
        viewControllersFactory = factory
    }
    
    lazy var topViewController: UIViewController = {
        let launchSB = UIStoryboard(name: "LaunchScreen", bundle: nil)
        return launchSB.instantiateViewController(withIdentifier: "LaunchScreen")
    }()
    
    let topViewControllerReady = BehaviorRelay(value: false)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func rootViewController(forLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> UIViewController? {
        topViewController = UIViewController()
        guard let viewControllerFactory = viewControllersFactory else { return UIViewController() }
        
        let viewControllers = [ModuleRoutingStep.businessesPlaces(),
                               .businesses()]
            .map { PresentableRoutingStep(withStep: $0,
                                          presentationMode: .none) }
            .compactMap { self.route(to: $0) }
        
        let topTabBarContainer = ModuleRoutingStep.topTabBarContainer(viewControllers: viewControllers)
        let topTabBarViewController = viewControllerFactory.viewController(for: PresentableRoutingStep(withStep: topTabBarContainer,
                                                                                                       presentationMode: .none))
        
        let containerController = UINavigationController(rootViewController: topTabBarViewController)
        
        /// TODO: Add some kind of initial splash screen to follow this logic, could be A/B Tests
        AppDelegate.shared.window?.transitionToRootController(containerController)
        topViewController = containerController
        
        return containerController
    }
    
    func showLoadingView() {}
    func hideLoadingView() {}
    func handleShortcutItem(_ item: UIApplicationShortcutItem) {}
}

extension UIWindow {
    func transitionToRootController(_ viewController: UIViewController, completed: @escaping () -> Void = {}) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            let oldState = UIView.areAnimationsEnabled
            
            UIView.setAnimationsEnabled(false)
            
            self.rootViewController = viewController
            self.makeKeyAndVisible()
            
            UIView.setAnimationsEnabled(oldState)
        }) { finished in
            completed()
        }
    }
}
