//
//  AppDelegate.swift
//  Fast Foodz
//

import UIKit
import MERLin
import CFoundation
import ThemeManager

@UIApplicationMain
class AppDelegate:
    UIResponder,
    EventsProducer,
    UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var router: TabBarControllerRouter!
    var moduleManager: BaseModuleManager!
    
    var window: UIWindow?
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var events: Observable<AppDelegateEvent> { return _events }
    private let _events = PublishSubject<AppDelegateEvent>()
    
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        window = UIWindow()
        
        // Configure networkign adapters
//        MatchesAdapter.configurator()
        
        // App Theme
        ThemeContainer.defaultTheme = GlobalTheme()
        
        /// Modules + Router
        moduleManager = BaseModuleManager()
        router = TabBarControllerRouter(withFactory: moduleManager)
        
        let eventsListeners: [AnyEventsListener] = [
            MainRoutingListenerAggregator(withRouter: router),
            AppDelegateRoutingEventsListener(withRouter: router)
        ]
        
        moduleManager.addEventsListeners(eventsListeners)
        eventsListeners.forEach { $0.listenEvents(from: self) }
        
        _events.onNext(.willFinishLaunching(application: application,
                                            launchOptions: launchOptions))
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

}

