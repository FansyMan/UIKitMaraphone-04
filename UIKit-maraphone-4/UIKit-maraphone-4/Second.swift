import UIKit

struct Model: Hashable {
    let number: String
    var isSelected: Bool
}

enum Section {
    case first
}

final class SecondViewController: UIViewController {
    private var numbers = [Model]()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Section, Model>!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        title = "Task 4"
        
        createNumbers()
        addShuffleButton()
        setupTableView()
        setupSubviews()
        updateDataSource(animated: false)
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var itemToMove = numbers[indexPath.row]
        if !numbers[indexPath.row].isSelected {
            itemToMove.isSelected = true
            numbers.remove(at: indexPath.row)
            numbers.insert(itemToMove, at: 0)
            updateDataSource(animated: true)
        } else {
            numbers[indexPath.row].isSelected = false
            updateDataSource(animated: false)
        }
    }
}

private extension SecondViewController {
    @objc private func shuffleTapped() {
        numbers.shuffle()
        updateDataSource(animated: true)
    }
    
    func createNumbers() {
        for i in 1...30 {
            numbers.append(Model(number: "\(i)", isSelected: false))
        }
    }
    
    func addShuffleButton() {
        let shuffleButton = UIBarButtonItem()
        shuffleButton.title = "Shuffle"
        shuffleButton.target = self
        shuffleButton.action = #selector(shuffleTapped)
        navigationItem.rightBarButtonItem = shuffleButton
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.tableHeaderView = UIView()
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = self.numbers[indexPath.row].number
            if self.numbers[indexPath.row].isSelected {
                cell.accessoryType = .checkmark
            }
            return cell
        })
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.first])
        snapshot.appendItems(numbers)
        
        dataSource.apply(snapshot, animatingDifferences: animated, completion: nil)
    }
}


final class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = ""
        self.isSelected = false
        self.accessoryType = .none
    }
}
