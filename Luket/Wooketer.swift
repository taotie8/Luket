
import Foundation
import AdjustSdk
import FacebookCore
import Kterwfly

@objcMembers
final class Wooketer: NSObject {
    static func configureFromBundle() {
        KterwflyManager.shared.configure(kterwToken: "8jir89clyxs0", kterwInst: "rg7cwg", kterwPayt: "qh0rcq")
    }
}
