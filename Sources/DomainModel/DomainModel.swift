struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String

    init(amount: Int, currency: String) {
        self.amount = max(0, amount)
        self.currency = ["USD", "GBP", "EUR", "CAN"].contains(currency) ? currency : "USD"
    }

    func convert(_ currency: String) -> Money {
        guard self.currency != currency else { return self }
        
        let usdAmount: Double = convertToUSD()
        
        switch currency {
        case "GBP":
            return Money(amount: Int(usdAmount * 0.5), currency: currency)
        case "EUR":
            return Money(amount: Int(usdAmount * 1.5), currency: currency)
        case "CAN":
            return Money(amount: Int(usdAmount * 1.25), currency: currency)
        case "USD":
            return Money(amount: Int(usdAmount), currency: currency)
        default:
            return self
        }
    }
    
    private func convertToUSD() -> Double {
        switch currency {
        case "GBP":
            return Double(amount) / 0.5
        case "EUR":
            return Double(amount) / 1.5
        case "CAN":
            return Double(amount) / 1.25
        default:
            return Double(amount)
        }
    }

    func add(_ money: Money) -> Money {
        let convertedMoney = self.convert(money.currency)
        return Money(amount: money.amount + convertedMoney.amount, currency: money.currency)
    }

    func subtract(_ money: Money) -> Money {
        let convertedMoney = self.convert(money.currency)
        return Money(amount: money.amount - convertedMoney.amount, currency: money.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public var title: String
    public var type: JobType

    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public func calculateIncome(_ hours: Int = 2000) -> UInt {
        switch self.type {
        case .Hourly(let wage):
            return UInt(Double(hours) * wage)
        case .Salary(let salary):
            return salary
        }
    }

    public func raise(byAmount amount: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = .Hourly(wage + amount)
        case .Salary(let salary):
            self.type = .Salary(salary + UInt(amount))
        }
    }

    public func raise(byPercent percentage: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = .Hourly(wage * (1 + percentage))
        case .Salary(let salary):
            self.type = .Salary(UInt(Double(salary) * (1 + percentage)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    private var _job: Job?
    private var _spouse: Person?

    var job: Job? {
        get { return _job }
        set { if age >= 16 { _job = newValue } }
    }

    var spouse: Person? {
        get { return _spouse }
        set { if age >= 18 { _spouse = newValue } }
    }
    
    public init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    func toString() -> String {
        let jobDescription = job != nil ? job!.title : "nil"
        let spouseName = spouse != nil ? spouse!.firstName : "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobDescription) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]

    public init(spouse1: Person, spouse2: Person) {
        spouse1.spouse?.spouse = nil
        spouse2.spouse?.spouse = nil
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }

    public func haveChild(_ child: Person) {
        self.members.append(child)
    }

    public func householdIncome() -> Int {
        return Int(members.reduce(0) { sum, person in
            sum + (person.job?.calculateIncome() ?? 0)
        })
    }
}
