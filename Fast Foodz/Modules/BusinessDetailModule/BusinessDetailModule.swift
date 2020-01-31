//
//  BusinessDetailModule.swift
//  BusinessDetailModule
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import CFoundation

public class BusinessDetailModuleContext: ModuleContextProtocol {
    public typealias ModuleType = BusinessDetailModules
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make()-> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum BusinessDetailsModuleEvents: EventProtocol {
    case callBusiness(String)
}

public class BusinessDetailModules: ModuleProtocol, EventsProducer {
    public var events: Observable<BusinessDetailsModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<BusinessDetailsModuleEvents>()
    
    public var context: BusinessDetailModuleContext
    
    public required init(usingContext buildContext: BusinessDetailModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        return UIViewController()
    }
}
