import UIKit

final class PreferencesViewController: UIViewController {
    var presenter: PreferencesPresenterInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.didLoadView()
    }
    
    @IBAction private func didCloseBarButtonTapped() {
        presenter?.didCloseEvent()
    }
    
    private var sections: [PreferencesPresenterSection]?
    
    @IBOutlet private var tableView: UITableView!
}

extension PreferencesViewController: PreferencesViewInput {
    func show(title: String) {
        navigationItem.title = title
    }
    
    func show(sections: [PreferencesPresenterSection]) {
        self.sections = sections
        tableView.reloadData()
    }
    
    func update(section: PreferencesPresenterSection) {
        guard let section = sections?.firstIndex(where: { $0.id == section.id }) else { return }
        
        tableView.reloadSections(IndexSet(integer: section), with: .none)
    }
}

extension PreferencesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[section].rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = sections?[indexPath.section].rows[indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: row.style.identifier)
            ?? UITableViewCell(style: row.style.style, reuseIdentifier: row.style.identifier)

        cell.textLabel?.text = row.title

        switch row.style {
        case .switcher:
            let switcher = UISwitch(frame: .zero, primaryAction: UIAction { [weak self] in
                let value = ($0.sender as? UISwitch)?.isOn == true
                self?.presenter?.didChange(value: value, at: indexPath)
            })
            switcher.isOn = (row.value as? Bool) == true
            cell.accessoryView = switcher
            cell.accessoryType = .none
            cell.selectionStyle = .none
        case .checkmark:
            cell.accessoryView = nil
            cell.accessoryType = ((row.value as? Bool) == true) ? .checkmark : .none
            cell.selectionStyle = .none
        }

        return cell
    }
}

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections?[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections?[section].subtitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = sections![indexPath.section].rows[indexPath.row]
        switch row.style {
        case .switcher:
            break
        case .checkmark:
            guard let value = (row.value as? Bool),
                  !value else {
                return
            }
            
            presenter?.didChange(value: true, at: indexPath)
        }
    }
}

private extension PreferencesPresenterRowStyle {
    var identifier: String {
        switch self {
        case .switcher,
             .checkmark:
            return UITableViewCell.reuseIdentifier
        }
    }

    var style: UITableViewCell.CellStyle {
        switch self {
        case .switcher: return .default
        case .checkmark: return .default
        }
    }
}
