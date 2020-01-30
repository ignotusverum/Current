//
//  ObservableType.swift
//  CFoundation
//
//  Created by Vlad Z. on 1/27/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import RxSwift
import Foundation

public extension ObservableType {
    func catchError<O: ObserverType>(sendTo errorObserver: O) -> Observable<Element> where O.Element == Error {
        return catchError {
            errorObserver.onNext($0)
            return .empty()
        }
    }
}

// Feedbacks
public typealias Feedback<State, Action> = (Observable<State>) -> Observable<Action>
public extension ObservableType where Element == Any {
    static func feedbackLoop<State, Action>(
        initialState: State,
        scheduler: ImmediateSchedulerType = MainScheduler.asyncInstance,
        reduce: @escaping (State, Action) -> State,
        feedback: [Feedback<State, Action>]
    ) -> Observable<State> {
        Observable<State>.deferred {
            let replaySubject = ReplaySubject<State>.create(bufferSize: 1)
            
            let events: Observable<Action> = Observable.merge(
                feedback.map { feedback in
                    feedback(replaySubject.asObservable())
                }
            ).observeOn(CurrentThreadScheduler.instance)
            
            return events.scan(initialState, accumulator: reduce)
                .do(
                    onNext: { output in
                        replaySubject.onNext(output)
                    }, onSubscribed: {
                        replaySubject.onNext(initialState)
                    }
                ).subscribeOn(scheduler)
                .startWith(initialState)
                .observeOn(scheduler)
        }
    }
    
    static func feedbackLoop<State, Action>(
        initialState: State,
        scheduler: ImmediateSchedulerType = MainScheduler.asyncInstance,
        reduce: @escaping (State, Action) -> State,
        feedback: Feedback<State, Action>...
    ) -> Observable<State> {
        feedbackLoop(initialState: initialState, scheduler: scheduler, reduce: reduce, feedback: feedback)
    }
}

public typealias SideEffect<State, Effect> = (Observable<State>) -> Observable<Effect>
public extension ObservableType {
    func sendSideEffects<Effect, O: ObserverType>(
        _ sideEffects: [SideEffect<Element, Effect>],
        to observer: O
    ) -> Observable<Element> where O.Element == Effect {
        let replaySubject = ReplaySubject<Element>.create(bufferSize: 1)
        
        let effects = Observable<Effect>.merge(
            sideEffects.map { $0(replaySubject.asObservable()) }
        ).do(onNext: observer.onNext)
        
        return Observable.merge(
            asObservable().do(
                onNext: { output in
                    replaySubject.onNext(output)
                }
            ),
            effects.flatMap { _ in Observable<Element>.empty() }
        )
    }
    
    func sendSideEffects<Effect>(
        _ sideEffects: SideEffect<Element, Effect>...,
        to observer: AnyObserver<Effect>
    ) -> Observable<Element> {
        sendSideEffects(sideEffects, to: observer)
    }
}

