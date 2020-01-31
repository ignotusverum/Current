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

                                            layout.minimumLineSpacing = 0
                                            layout.minimumInteritemSpacing = 0
                                            
                                            layout.sectionInset = UIEdgeInsets(top: 100,
                                                                               left: 0,
                                                                               bottom: 0,
                                                                               right: 0)
                                            
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
        
        title = "List"
        
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
                self.actions.onNext(.businessSelected(row.model))
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
        collectionView.backgroundColor = .color(forPalette: .white)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: 80)
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
        
        if let rowType = row.type {
            cell.imageView.image = UIImage(named: rowType.rawValue)
        }
        
        
        cell.titleLabel.text = row.title
        
        cell.applyTheme()
        
        let subtitleCopy = row.getSubtitleCopy(regularAttributes:
            [NSAttributedString.Key.foregroundColor: UIColor.color(forPalette: .lilacGrey)],
                                               priceAttributes: [NSAttributedString.Key.foregroundColor: UIColor.color(forPalette: .pickleGreen)])
        cell.subtitleLabel.attributedText = subtitleCopy
        
        return cell
    }
}


