import SwiftUI

protocol BadgeNumberProvidable: AnyObject {
    var applicationIconBadgeNumber: Int { get set }
}

extension UIApplication: BadgeNumberProvidable {}

@available(iOS 13.0.0, *)
actor AppAlertBadgeManager {
    
    let application: BadgeNumberProvidable
    
    init(application: BadgeNumberProvidable) {
        self.application = application
    }
    
    
    @MainActor
    func setAlertBadge(number: Int) {
        application.applicationIconBadgeNumber = number
        UserDefaults.standard.set(number, forKey: "badgeCount")
    }
    
    @MainActor
    func resetAlertBadgeNumber() {
        application.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(0, forKey: "badgeCount")
    }
    
    @MainActor
    func addAlertBadge() {
        var num = UserDefaults.standard.integer(forKey: "badgeCount")
        num += 1
        UserDefaults.standard.set(num, forKey: "badgeCount")
        application.applicationIconBadgeNumber = num
    }
    
    
}
