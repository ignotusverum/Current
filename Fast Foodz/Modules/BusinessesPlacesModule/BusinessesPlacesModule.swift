//
//  BusinessPlacesModule.swift
//  BusinessesPlacesPlacesModule
//
//  Created by Vlad Z. on 1/31/20.
//

import MERLin
import CFoundation

public class BusinessesPlacesModuleContext: ModuleContextProtocol {
    public typealias ModuleType = BusinessesPlacesModules
    public var routingContext: String
    
    public init(routingContext: String) {
        self.routingContext = routingContext
    }
    
    public func make()-> (AnyModule, UIViewController) {
        let module = ModuleType(usingContext: self)
        return (module, module.prepareRootViewController())
    }
}

public enum BusinessesPlacesModuleEvents: EventProtocol {
    case businessSelected(Business)
}

public class BusinessesPlacesModules: ModuleProtocol, EventsProducer {
    public var events: Observable<BusinessesPlacesModuleEvents> { return _events.asObservable() }
    private var _events = PublishSubject<BusinessesPlacesModuleEvents>()
    
    public var context: BusinessesPlacesModuleContext
    
    public required init(usingContext buildContext: BusinessesPlacesModuleContext) {
        context = buildContext
    }
    
    public func unmanagedRootViewController() -> UIViewController {
        let model = BusinessesPlacesModel()
        let viewModel = BusinessesPlacesViewModel(model: model,
                                         events: _events)

        let view = BusinessesPlacesViewController(with: viewModel)

        return view
    }
}
