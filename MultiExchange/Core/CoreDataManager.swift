import CoreData
import UIKit

protocol IFavoriteCurrencyManager {
    func incrementCurrency(cur: Currency, curComp: CurrencyComponent)
    func loadPickedList(for curComp: CurrencyComponent) -> [Currency]
    func deleteAll()
}

final class CoreDataManager {
    let context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
}

extension CoreDataManager: IFavoriteCurrencyManager {
    func incrementCurrency(cur: Currency, curComp: CurrencyComponent) {
        if self.loadPickedList(for: curComp).contains(cur) == false {
            let curCore = PickedCurrencyCore(context: self.context)
            curCore.name = cur.name
            curCore.code = cur.code
            curCore.fieldType = curComp.stringValue
            curCore.repeatCount = 1

            do {
                try self.context.save()
            } catch {
                print("LOG: Не удалось сохранить новую валюту")
            }
        } else {
            self.loadPickedCurrencyCore(for: curComp).forEach { curCore in
                if curCore.code == cur.code {
                    curCore.repeatCount += 1
                }
            }
            do {
                try self.context.save()
            } catch {
                print("LOG: счетчик валют не увеличен")
            }
        }
    }

    func loadPickedList(for curComp: CurrencyComponent) -> [Currency] {
        var pickedList = [Currency]()
        self.loadPickedCurrencyCore(for: curComp)
            .sorted { $0.repeatCount > $1.repeatCount }
            .forEach { curCor in
                if let code = curCor.code, let name = curCor.name {
                    pickedList.append(Currency(code: code, name: name ))
                }
            }

        return pickedList
    }
    func deleteAll() {
        self.loadPickedCurrencyCore(for: .first).forEach { self.context.delete($0) }
        self.loadPickedCurrencyCore(for: .second).forEach { self.context.delete($0) }
        try? self.context.save()
    }
}

private extension CoreDataManager {
    func loadPickedCurrencyCore(for curComp: CurrencyComponent) -> [PickedCurrencyCore] {
        let fetchRequest: NSFetchRequest<PickedCurrencyCore> = PickedCurrencyCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K >= %@ AND %K == %@", "repeatCount", "1", "fieldType", curComp.stringValue)
        var result = [PickedCurrencyCore]()
        do {
            result =  try self.context.fetch(fetchRequest)
        } catch {
            print("LOG: Загрузка из базы данных не удалась")
        }
        return result
    }
}

private extension CurrencyComponent {
    var stringValue: String {
        switch self {
        case .first:
            return   "left"
        case .second:
            return  "right"
        }
    }
}
