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
        self.amount = amount
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
    
    // Helper method to convert any currency to USD
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
        let convertedMoney = money.convert(self.currency)
        return Money(amount: self.amount + convertedMoney.amount, currency: self.currency)
    }

    func subtract(_ money: Money) -> Money {
        let convertedMoney = money.convert(self.currency)
        return Money(amount: self.amount - convertedMoney.amount, currency: self.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
