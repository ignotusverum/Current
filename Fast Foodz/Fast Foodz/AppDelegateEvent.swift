//
//  AppDelegateEvent.swift
//  Fast Foodz
//
//  Created by Vlad Z. on 1/30/20.
//

import MERLin
import RxSwift

enum AppDelegateEvent: EventProtocol {
    case willFinishLaunching(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

