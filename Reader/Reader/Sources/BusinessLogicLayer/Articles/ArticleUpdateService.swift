import Foundation

typealias ArticleUpdateServiceObserver = NSObjectProtocol

protocol ArticleUpdateServiceObservable {
    func subscribe(handler: @escaping () -> Void) -> ArticleUpdateServiceObserver
}

protocol ArticleUpdateService {
    func set(period: ArticlesUpdatePeriod)
}

final class ArticleUpdateServiceImpl: ArticleUpdateService, ArticleUpdateServiceObservable {
    func subscribe(handler: @escaping () -> Void) -> ArticleUpdateServiceObserver {
        return NotificationCenter.default.addObserver(
            forName: .articleDidUpdated,
            object: nil,
            queue: .main,
            using: { _ in
                handler()
            }
        )
    }
    
    func set(period: ArticlesUpdatePeriod) {
        scheduleTimer(period)
    }
    
    private func scheduleTimer(_ period: ArticlesUpdatePeriod) {
        let timeInterval: TimeInterval
        timer?.invalidate()
        
        switch period {
        case .never:
            return
        case .minute:
            timeInterval = 60
        case .fiveMinutes:
            timeInterval = 60 * 5
        case .tenMinutes:
            timeInterval = 60 * 10
        }
        
        timer?.invalidate()
        
        let timer = Timer(timeInterval: timeInterval, repeats: true) { _ in
            NotificationCenter.default.post(name: .articleDidUpdated, object: nil)
        }
        
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    private var timer: Timer?
}

private extension Notification.Name {
    static let articleDidUpdated = Notification.Name(rawValue: "reader.notification.article.updated")
}
