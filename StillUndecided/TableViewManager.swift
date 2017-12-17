

import UIKit

@objc protocol TableViewManagerDelegate: UIScrollViewDelegate {
    @objc optional func tableViewManager(_ manager: TableViewManager, headerViewForSection section: Int) -> UITableViewHeaderFooterView?
    @objc optional func tableViewManager(_ manager: TableViewManager, footerViewForSection section: Int) -> UITableViewHeaderFooterView?
    @objc optional func tableViewManager(_ manager: TableViewManager, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    @objc optional func tableViewManager(_ manager: TableViewManager, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    @objc optional func tableViewManager(_ manager: TableViewManager, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
}

class TableViewManager: NSObject {
    
    let tableView: UITableView
    weak var delegate: TableViewManagerDelegate?
    
    fileprivate var sections: [TableViewSection] = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func register(nibModels: [CellViewAnyModel.Type]) {
        for model in nibModels {
            let identifier = String(describing: model.cellAnyType)
            let nib = UINib(nibName: identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    func add(section: TableViewSection) {
        section.tableViewManager = self
        sections.append(section)
    }
    
    func insert(section: TableViewSection, index: Int) {
        section.tableViewManager = self
        sections.insert(section, at: index)
    }
    
    func remove(section: TableViewSection) {
        section.tableViewManager = nil
        if let index = sections.index(where: { $0 === section }) {
            sections.remove(at: index)
        }
    }
    
    func removeAllSections() {
        sections.removeAll()
    }
    
}

extension TableViewManager : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        delegate?.tableViewManager?(self, commit: editingStyle, forRowAt: indexPath)
//    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        return delegate?.tableViewManager?(self, leadingSwipeActionsConfigurationForRowAt: indexPath)
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        return delegate?.tableViewManager?(self, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = sections[indexPath.section].items[indexPath.row]
        let indetifier = String(describing: type(of: viewModel).cellAnyType)
        let cell = tableView.dequeueReusableCell(withIdentifier: indetifier, for: indexPath)
        
        viewModel.setupAny(cell: cell)
        return cell
    }
}

extension TableViewManager : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = sections[indexPath.section].items[indexPath.row]
        viewModel.didSelect()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = sections[indexPath.section].items[indexPath.row]
        if viewModel.cellHeight > 0.0 {
            return viewModel.cellHeight
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight
    }
    
    func tableView(_ tableView: UITableView, footerForHeaderInSection section: Int) -> CGFloat {
        return sections[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let viewModel = sections[indexPath.section].items[indexPath.row]
        return viewModel.enabled ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let viewModel = sections[indexPath.section].items[indexPath.row]
        return viewModel.enabled
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate?.tableViewManager?(self, headerViewForSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegate?.tableViewManager?(self, footerViewForSection: section)
    }
    
}

extension TableViewManager : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}



//MARK: - TableViewSection


class TableViewSection {
    weak var tableViewManager: TableViewManager?
    var headerHeight: CGFloat = 0
    var footerHeight: CGFloat = 0
    var index: Int? {
        get {
            return tableViewManager?.sections.index(where: { $0 === self})
        }
    }
    fileprivate var _items: [CellViewAnyModel] = []
    var items: [CellViewAnyModel] {
        get {
            return _items
        }
    }
    
    var title: String?
    
    func reload(animation: UITableViewRowAnimation) {
        if let tableView = tableViewManager?.tableView, let index = index {
            tableView.reloadSections([index], with: animation)
        }
    }
    
    func add(item: CellViewAnyModel) {
        item.section = self
        _items.append(item)
    }
    
    func add(items: [CellViewAnyModel]) {
        for item in items {
            item.section = self
        }
        _items.append(contentsOf: items)
    }
    
    func insert(item: CellViewAnyModel, index: Int) {
        item.section = self
        _items.insert(item, at: index)
    }
    
    func remove(item: CellViewAnyModel) {
        item.section = nil
        if let index = _items.index(where: { $0 === item }) {
            _items.remove(at: index)
        }
    }
    
    func removeAllItems() {
        _items.removeAll()
    }
}








//MARK: - CellViewAnyModel


protocol CellViewAnyModel: NSObjectProtocol {
    static var cellAnyType: UIView.Type { get }
    var indexPath: IndexPath? { get }
    var section: TableViewSection? { get set }
    var cellHeight: CGFloat { get set }
    var enabled: Bool { get set }
    func setupAny(cell: UIView)
    func didSelect()
    
    func select(animated: Bool)
    func deselect(animated: Bool)
    func reload(animation: UITableViewRowAnimation)
}

protocol CellViewModel: CellViewAnyModel {
    associatedtype CellType: UIView
    func setup(cell: CellType)
    var selectionHandler: ((_ model: Self) -> Void)? { get set }
}

extension CellViewModel {
    static var cellAnyType: UIView.Type {
        return CellType.self
    }
    
    var indexPath: IndexPath? {
        get {
            if let sectionIndex = section?.index, let rowIndex = section?.items.index(where: { $0 === self }) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
            return nil
        }
    }
    
    func setupAny(cell: UIView) {
        if let cell = cell as? CellType {
            setup(cell: cell)
        } else {
            assertionFailure("Wrong usage")
        }
    }
    
    func didSelect() {
        selectionHandler?(self)
    }
    
    func select(animated: Bool) {
        if let indexPath = self.indexPath, let tableView = section?.tableViewManager?.tableView {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func deselect(animated: Bool) {
        if let indexPath = self.indexPath, let tableView = section?.tableViewManager?.tableView {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func reload(animation: UITableViewRowAnimation) {
        if let indexPath = self.indexPath, let tableView = section?.tableViewManager?.tableView, tableView.cellForRow(at: indexPath) != nil {
            tableView.reloadRows(at: [indexPath], with: animation)
        }
    }
}


