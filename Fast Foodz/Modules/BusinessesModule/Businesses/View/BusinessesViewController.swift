//
//  BusinessesViewController.swift
//  BusinessesModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CUIKit
import CFoundation

import OKImageDownloader

import MERLin
import RxDataSources

extension BusinessRow: IdentifiableType {
    public var identity: String { return title }
}


class BusinessesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    
    let viewModel: BusinessesViewModel
    private let actions = PublishSubject<BusinessesUIAction>()
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
                                            let layout = UICollectionViewFlowLayout()
                                            
                                            layout.sectionInset = UIEdgeInsets(top: 10,
                                                                               left: 7,
                                                                               bottom: 20,
                                                                               right: 7)
                                            
                                            layout.minimumLineSpacing = 20
                                            layout.minimumInteritemSpacing = 0
                                            
                                            $0.collectionViewLayout = layout
                                            $0.registerNib(BusinessCell.self)
                                            $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    let refreshControl = UIRefreshControl() <~ {
        $0.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, BusinessRow>>!
    
    init(with viewModel: BusinessesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fast Food Places"
        
        tabBarController?.tabBar.isHidden = true
        
        applyTheme()
        configureDatasource()
        bindViewModel()
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        collectionView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.actions.onNext(.reload)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let row = self.dataSource[indexPath]
                self.actions.onNext(.businessIdSelected(row.title))
            })
            .disposed(by: disposeBag)
        
        let states = viewModel.transform(input: actions).publish()
        
        states.capture(case: BusinessesState.pages)
            .asDriverIgnoreError()
            .map { [self.createAnimatableSection($0)] }
            .do(onNext: { [weak self] rows in
                self?.refreshControl.endRefreshing()
            })
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        states.capture(case: BusinessesState.error)
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] (error, _) in
                guard let self = self else { return }
                
                let alert = UIAlertController(title: "Whoops",
                                              message: "Something went wrong, please try again.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Reload",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                                                self.actions.onNext(.reload)
                }))
                
                self.present(alert,
                             animated: true,
                             completion: nil)
            })
            .disposed(by: disposeBag)
        
        states.capture(case: BusinessesState.loading).toVoid()
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] in
                self?.activityIndicator.startAnimating()
            }).disposed(by: disposeBag)
        
        states.exclude(case: BusinessesState.loading)
            .toVoid()
            .asDriverIgnoreError()
            .drive(onNext: { [weak self] in
                self?.activityIndicator.stopAnimating()
            }).disposed(by: disposeBag)
        
        /// TODO: Paging
        Observable.combineLatest(
            collectionView.rx.contentOffset.map { $0.y },
            collectionView.rx.observe(CGSize.self, "contentSize")
                .compactMap { $0?.height }
        ).map { [weak self] (y, h) in
            guard let self = self,
                (h - self.collectionView.bounds.height) >= (y - 100) else {
                    return false
            }
            return true
        }.distinctUntilChanged()
            .takeTrue()
            .asDriverIgnoreError()
            .drive(onNext: { _ in
                print("[DEBUG TODO] Implement paging by cursors")
            })
            .disposed(by: disposeBag)
        
        states.connect()
            .disposed(by: disposeBag)
    }
    
    private func configureDatasource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource(
            configureCell: { (_, collectionView, indexPath, row) -> UICollectionViewCell in
                self.configureCell(row: row,
                                   indexPath: indexPath,
                                   from: collectionView)
        })
    }
    
    func applyTheme() {
        collectionView.backgroundColor = .color(forPalette: .grey100)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width / 2 - 14 // 14 - padding from left/right
        let cellHeight = cellWidth * 1.75
        
        return CGSize(width: cellWidth,
                      height: cellHeight)
    }
    
    private func createAnimatableSection(_ rows: [BusinessRow])-> AnimatableSectionModel<String, BusinessRow> {
        return AnimatableSectionModel(model: "",
                                      items: rows)
    }
}

extension BusinessesViewController {
    func configureCell(row: BusinessRow,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        
        let cell: BusinessCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.titleLabel.text = row.title
        cell.applyTheme()
        
        return cell
    }
}


