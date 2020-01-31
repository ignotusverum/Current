//
//  TopTabBarController.swift
//  CUIKit
//
//  Created by Vlad Z. on 1/30/20.
//

import UIKit

open class TopTabBarController: UIViewController {
    // MARK: - Views
    
    public private(set) var topTabBar: UIView = UIView()
    private var itemsStackView: UIStackView = UIStackView()
    private var childViewContainer: UIView = UIView()
    private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: -
    
    public private(set) var viewControllers: [UIViewController] = []
    private var viewControllerObservers: [NSKeyValueObservation] = []
    
    // MARK: - Appearance
    
    // MARK: Colors
    
    public var selectedItemBackgroundColor: UIColor = .white {
        didSet {
            guard let index = selectedIndex else { return }
            itemsStackView.arrangedSubviews[index].backgroundColor = selectedItemBackgroundColor
        }
    }
    
    public var unselectedItemBackgroundColor: UIColor = .clear {
        didSet {
            topTabBar.backgroundColor = unselectedItemBackgroundColor
            guard let index = selectedIndex else { return }
            itemsStackView.arrangedSubviews.enumerated()
                .filter { $0.offset != index }
                .map { $0.element }
                .forEach { $0.backgroundColor = unselectedItemBackgroundColor }
        }
    }
    
    // MARK: Strings
    
    public var selectedItemAttributes: [NSAttributedString.Key: Any]? {
        didSet {
            itemsStackView.arrangedSubviews
                .compactMap { $0 as? UIButton }
                .forEach {
                    let title = $0.attributedTitle(for: .selected)?.string ??
                        $0.title(for: .selected) ?? ""
                    $0.setAttributedTitle(
                        NSAttributedString(string: title,
                                           attributes: selectedItemAttributes),
                        for: .selected
                    )
                }
        }
    }
    
    public var unselectedItemAttributes: [NSAttributedString.Key: Any]? {
        didSet {
            itemsStackView.arrangedSubviews
                .compactMap { $0 as? UIButton }
                .forEach {
                    let title = $0.attributedTitle(for: .normal)?.string ??
                        $0.title(for: .normal) ?? ""
                    $0.setAttributedTitle(
                        NSAttributedString(string: title,
                                           attributes: unselectedItemAttributes),
                        for: .normal
                    )
                }
        }
    }
    
    // MARK: Behaviors
    
    public var hideBarIfOneOrNone: Bool = true
    
    // MARK: - Selection
    
    public private(set) var selectedViewController: UIViewController?
    public var selectedIndex: Int? {
        didSet {
            guard selectedIndex != oldValue else { return }
            guard let index = selectedIndex else {
                resetCurrentSelection()
                return
            }
            setSelectedViewController(at: index)
        }
    }
    
    // MARK: -
    
    // MARK: - Implementation
    
    public convenience init(viewControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    open override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        
        topTabBar.layer.cornerRadius = 10
        topTabBar.clipsToBounds = true
        
        let currentSubViews = topTabBar.subviews
        
        [(childViewContainer, view), (topTabBar, view), (itemsStackView, topTabBar)]
            .forEach { (view, superView) in
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = .clear
                superView?.addSubview(view)
            }
        itemsStackView.alignment = .fill
        itemsStackView.distribution = .fillEqually
        itemsStackView.axis = .horizontal
        
        bottomConstraint = topTabBar.bottomAnchor
            .constraint(equalTo: view.topAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            topTabBar.topAnchor.constraint(equalTo: view.topAnchor,
                                           constant: 32),
            topTabBar.leftAnchor.constraint(equalTo: view.leftAnchor,
                                            constant: 80),
            topTabBar.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: -80),
            bottomConstraint,
            
            childViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            childViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            childViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            childViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            itemsStackView.heightAnchor.constraint(equalToConstant: 40),
            itemsStackView.leftAnchor.constraint(equalTo: topTabBar.leftAnchor),
            itemsStackView.rightAnchor.constraint(equalTo: topTabBar.rightAnchor),
            itemsStackView.bottomAnchor.constraint(equalTo: topTabBar.bottomAnchor)
        ])
        setViewControllers(viewControllers)
        
        currentSubViews.forEach {
            topTabBar.bringSubviewToFront($0)
        }
    }
    
    // MARK: Selection
    
    open func resetCurrentSelection() {
        selectedIndex = nil
        guard let selected = itemsStackView.arrangedSubviews
            .firstIndex(where: { ($0 as? UIButton)?.isSelected == true }) else { return }
        viewControllers[selected].view.removeFromSuperview()
        (itemsStackView.arrangedSubviews[selected] as? UIButton)?.isSelected = false
        (itemsStackView.arrangedSubviews[selected] as? UIButton)?.backgroundColor = unselectedItemBackgroundColor
        title = ""
    }
    
    open func setSelectedViewController(at index: Int) {
        if let oldSelected = selectedIndex {
            viewControllers[oldSelected].view.removeFromSuperview()
            (itemsStackView.arrangedSubviews[oldSelected] as? UIButton)?.isSelected = false
            (itemsStackView.arrangedSubviews[oldSelected] as? UIButton)?.backgroundColor = unselectedItemBackgroundColor
        }
        
        let newSelectedVC = viewControllers[index]
        
        newSelectedVC.view.translatesAutoresizingMaskIntoConstraints = false
        childViewContainer.addSubview(newSelectedVC.view)
        
        NSLayoutConstraint.activate([
            newSelectedVC.view.topAnchor.constraint(equalTo: childViewContainer.topAnchor),
            newSelectedVC.view.rightAnchor.constraint(equalTo: childViewContainer.rightAnchor),
            newSelectedVC.view.bottomAnchor.constraint(equalTo: childViewContainer.bottomAnchor),
            newSelectedVC.view.leftAnchor.constraint(equalTo: childViewContainer.leftAnchor)
        ])
        
        selectedIndex = index
        (itemsStackView.arrangedSubviews[index] as? UIButton)?.isSelected = true
        (itemsStackView.arrangedSubviews[index] as? UIButton)?.backgroundColor = selectedItemBackgroundColor
        title = newSelectedVC.tabBarItem.title ?? newSelectedVC.title
    }
    
    // MARK: ViewControllers
    
    open func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        
        itemsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            itemsStackView.removeArrangedSubview($0)
        }
        
        viewControllerObservers.removeAll()
        
        self.viewControllers = viewControllers
        
        let titleSetter = { [weak self] (item: UITabBarItem, button: UIButton) in
            guard let self = self else { return }
            let title = [
                item.title,
                item.badgeValue
            ].compactMap { $0 }
                .joined(separator: " ")
            button.setAttributedTitle(NSAttributedString(string: title, attributes: self.unselectedItemAttributes), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: title, attributes: self.selectedItemAttributes), for: .selected)
            button.isSelected ? self.title = item.title : ()
        }
        
        viewControllers.forEach {
            addChild($0)
            $0.didMove(toParent: self)
            
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didSelect(_:)), for: .touchUpInside)
            button.backgroundColor = self.unselectedItemBackgroundColor
            
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            
            itemsStackView.addArrangedSubview(button)
            
            $0.loadViewIfNeeded()
            
            viewControllerObservers.append(contentsOf: [
                $0.tabBarItem.observe(\.title, options: [.initial, .new]) { [weak button] (item, _) in
                    guard let button = button else { return }
                    titleSetter(item, button)
                }, $0.tabBarItem.observe(\.badgeValue, options: [.initial, .new]) { [weak button] (item, _) in
                    guard let button = button else { return }
                    titleSetter(item, button)
                }
            ])
        }
        
        viewControllers.isEmpty ?
            resetCurrentSelection() :
            setSelectedViewController(at: 0)
        
        viewControllers.count < 2 && hideBarIfOneOrNone ?
            (bottomConstraint.constant = 0) :
            (bottomConstraint.constant = 72 + view.safeAreaInsets.top)
    }
    
    @objc
    private func didSelect(_ sender: UIButton?) {
        guard let index = itemsStackView.arrangedSubviews
            .firstIndex(where: { $0 === sender }) else { return }
        setSelectedViewController(at: index)
    }
}

