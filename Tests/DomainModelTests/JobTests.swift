import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }

// New testing cases I add
    func testNegativeSalary() {
        let job = Job(title: "Engineer", type: .Salary(0))
        XCTAssert(job.calculateIncome() >= 0)
    }
    
    func testNegativeHourlyRate() {
        let job = Job(title: "Tutor", type: .Hourly(-20.0))
        switch job.type {
        case .Hourly(let hourlyRate):
            XCTAssert(hourlyRate >= 0)
        default:
            XCTFail("NegativeHourlyRate handling failed.")
        }
    }
    
    func testUndefinedJobType() {
        let job = Job(title: "Mystery Job", type: .Hourly(-1))
        switch job.type {
        case .Hourly(let rate):
            XCTAssert(rate >= 0)
        default:
            XCTFail("JobType handling failed.")
        }
    }
    
    func testExtremePercentageRaise() {
        let normalJob = Job(title: "Developer", type: .Salary(50000))
        normalJob.raise(byPercent: 10000) // Applying a 10000% raise
        switch normalJob.type {
        case .Salary(let salary):
            XCTAssert(salary > 50000 && salary < UInt.max)
        default:
            XCTFail("JobType handling for extreme percentage raise failed.")
        }

        let hourlyJob = Job(title: "Consultant", type: .Hourly(50.0))
        hourlyJob.raise(byPercent: 10000)
        switch hourlyJob.type {
        case .Hourly(let rate):
            XCTAssert(rate > 50.0 && rate < Double(UInt.max))
        default:
            XCTFail("JobType handling for extreme percentage raise failed.")
        }
    }
    
  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        ("testNegativeSalary", testNegativeSalary),
        ("testNegativeHourlyRate", testNegativeHourlyRate),
        ("testUndefinedJobType", testUndefinedJobType),
        ("testExtremePercentageRaise", testExtremePercentageRaise),
    ]
}
