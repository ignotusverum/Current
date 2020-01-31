//
//  BusinessDetailViewController.swift
//  BusinessDetailModule
//
//  Created by Vlad Z. on 1/30/20.
//

import CUIKit
import CFoundation

import OKImageDownloader

import MERLin
import RxDataSources

import MapKit

extension BusinessDetailsSection: IdentifiableType {
    public var identity: String { return title }
}

enum BusinessDetailCellType: IdentifiableType, Equatable {
    case header(title: String, imageURL: URL?)
    case map(coordinates: Coordinates)
    case numberButton(number: String)
    
    public var identity: String {
        switch self {
        case .header(let title, _): return title
        case .map(let coordinates): return "\(coordinates.latitude)-\(coordinates.longitude)"
        case .numberButton(let number): return number
        }
    }
}

class BusinessDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    let disposeBag = DisposeBag()
    var datasource: BusinessDetailsSection
    let viewModel: BusinessDetailsViewModel
    private let actions = PublishSubject<BusinessDetailsUIAction>()
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout()) <~ {
                                            let layout = UICollectionViewFlowLayout()

                                            layout.minimumLineSpacing = 0
                                            layout.minimumInteritemSpacing = 0
                                            
                                            $0.collectionViewLayout = layout
                                            $0.registerNib(MapCell.self)
                                            $0.registerNib(ButtonCell.self)
                                            $0.registerNib(ImageTitleCell.self)
                                            $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, BusinessDetailCellType>>!
    
    init(viewModel: BusinessDetailsViewModel,
         datasource: BusinessDetailsSection) {
        self.datasource = datasource
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        tabBarController?.tabBar.isHidden = true
        
        applyTheme()
        configureDatasource()
        bindViewModel()
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
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
                
        let states = viewModel.transform(input: actions).publish()
        
        states.capture(case: BusinessDetailsState.details)
            .asDriverIgnoreError()
            .map { [self.createAnimatableSection($0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
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
        let model = dataSource[indexPath]
        
        var size: CGSize
        switch model {
        case .header(_): size = CGSize(width: collectionView.frame.width, height: 230)
        case .map(_): size = CGSize(width: collectionView.frame.width, height: 340)
        case .numberButton(_): size = CGSize(width: collectionView.frame.width, height: 100)
        }
        
        return size
    }
    
    private func createAnimatableSection(_ model: BusinessDetailsSection)-> AnimatableSectionModel<String, BusinessDetailCellType> {
        
        let rows: [BusinessDetailCellType] = [.header(title: model.title,
                                                      imageURL: model.imageURL),
                                              .map(coordinates: model.coordinates),
                                              .numberButton(number: model.phoneNumber)]
        
        return AnimatableSectionModel(model: "",
                                      items: rows)
    }
}

extension BusinessDetailViewController {
    func configureCell(row: BusinessDetailCellType,
                       indexPath: IndexPath,
                       from collectionView: UICollectionView) -> UICollectionViewCell {
        
        switch row {
        case let .header(title, imageURL):
            let cell: ImageTitleCell = collectionView.dequeueReusableCell(for: indexPath)
            
            if let imageURL = imageURL {
                cell.imageView?.downloadImage(with: imageURL,
                                             completionHandler: { result, _ in
                                                switch result {
                                                case let .success(image):
                                                    cell.imageView?.image = image
                                                    
                                                case .failure:
                                                    cell.imageView?.image = UIImage()
                                                }})
            }
            
            cell.titleLabel?.text = title
            
            return cell
            
        case .map(let coordinates):
            let cell: MapCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinates.latitude),
                                                      longitude: CLLocationDegrees(coordinates.longitude))
            
            return cell
            
        case .numberButton(_):
            let cell: ButtonCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.button?.setTitle("Call Business", for: .normal)
            
            return cell
        }
    }
}
