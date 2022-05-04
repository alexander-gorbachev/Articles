import Foundation

enum PreferencesPresenterRowStyle {
    case switcher
    case checkmark
}

protocol PreferencesPresenterRow {
    var title: String { get }
    var style: PreferencesPresenterRowStyle { get }
    var value: Any? { get }
}

protocol PreferencesPresenterSection {
    var id: Int { get }
    var title: String { get }
    var subtitle: String? { get }
    var rows: [PreferencesPresenterRow] { get }
}
