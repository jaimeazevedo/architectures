import Combine
import UIKit

// MARK: - Database model

struct Item: Hashable, Equatable {
    let content: String
    let createdAt: Date
    let identifier: String
    
    init(content: String, createdAt: Date, identifier: String) {
        self.content = content
        self.createdAt = createdAt
        self.identifier = identifier
    }
}

// MARK: - Storage service
protocol StorageProvider {
    func fetchAllItems() -> Future<[Item], Error>
}

// MARK: - UIModel
enum Section: CaseIterable {
    case main
}

struct RowItemModel: Hashable, Equatable {
    let item: Item
    let title: String
    let detail: String
}

// MARK: - ViewController
final class ItemsListViewController: UICollectionViewController {
    enum SortOption {
        case byContent
        case byCreationDate
    }

    private lazy var segmentedControl = UISegmentedControl(items: <#T##[Any]?#>)
    private let storageProvider: StorageProvider
    
    private var sortOption: SortOption = .byContent
    private var subscriptions: Set<AnyCancellable> =  []
    
    @Published private var elements: [RowItemModel] = []

    // MARK: - Lifecycle
    deinit {
        subscriptions.forEach { $0.cancel() }
    }

    init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider

        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        super.init(collectionViewLayout: layout)
        
        fetchData(storageProvider: storageProvider, sortOption: sortOption)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private API
    private func bind() {
        let dataSource = buildDataSource()
        collectionView.dataSource = dataSource
        
        $elements
            .sink { elements in
                var snapshot = NSDiffableDataSourceSnapshot<Section, RowItemModel>()
                snapshot.appendSections(Section.allCases.map { $0 })
                snapshot.appendItems(elements)
                dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &subscriptions)
    }

    // MARK: - Private API - DataSource
    private func buildDataSource() -> UICollectionViewDiffableDataSource<Section, RowItemModel> {
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, RowItemModel> { cell, _, viewModel in
                var content = UIListContentConfiguration.cell()
                content.text = viewModel.title
                content.secondaryText = viewModel.detail

                cell.contentConfiguration = content
                cell.accessories = [.disclosureIndicator()]
            }

        return UICollectionViewDiffableDataSource<Section, RowItemModel>(
            collectionView: collectionView
        ) { collectionView, indexPath, object in
            switch object {
            case let viewModel:
                return collectionView
                    .dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: viewModel)
            }
        }
    }
    
    // MARK: - Private API - Fetching
    private func fetchData(storageProvider: StorageProvider) {
        storageProvider
            .fetchAllItems()
            .sink { error in
                // Handle and display error.
            } receiveValue: { [weak self] values in
                if let self = self {
                    self.sortData(values: values, sortOption: self.sortOption)
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private API - Sorting
    private func sortData(values: [Item], sortOption: SortOption) {
        self.elements = values
            .sorted {
                switch sortOption {
                case .byContent:
                    return $0.content > $1.content
                    
                case .byCreationDate:
                    return $0.createdAt > $1.createdAt
                }
            }
            .map { RowItemModel(item: $0, title: "\($0.content) @ \($0.createdAt)", detail: "\($0.createdAt)") }
    }
}
