import Foundation
import CoreData

extension PickedCurrencyCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PickedCurrencyCore> {
        return NSFetchRequest<PickedCurrencyCore>(entityName: "PickedCurrencyCore")
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var fieldType: String?
    @NSManaged public var repeatCount: Int32

}

extension PickedCurrencyCore: Identifiable {

}
