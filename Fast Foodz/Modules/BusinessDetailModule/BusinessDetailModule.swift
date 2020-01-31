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
    
    public var details: Business
    
    public init(details: Business,
                routingContext: String) {
        self.details = details
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
        let section = BusinessDetailsSection(model: context.details)
        let viewModel = BusinessDetailsViewModel(model: context.details,
                                                 events: _events)
        
        let controller = BusinessDetailViewController(viewModel: viewModel,
                                                      datasource: section)
        
        return controller
    }
}
