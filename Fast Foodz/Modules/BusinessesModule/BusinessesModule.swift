//
//  BusinessesModule.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

public class BusinessesModuleContext: ModuleContextProtocol {
    public typealias ModuleType = BusinessesModules
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make()-> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum BusinessesModuleEvents: EventProtocol {
    case businessIdSelected(String)
}

public class BusinessesModules: ModuleProtocol, EventsProducer {
    public var events: Observable<BusinessesModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<BusinessesModuleEvents>()
    
    public var context: BusinessesModuleContext
    
    public required init(usingContext buildContext: BusinessesModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        return UIViewController()
    }
}

