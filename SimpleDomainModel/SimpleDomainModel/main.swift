//
//  main.swift
//  SimpleDomainModel
//
//  Created by AT on 10/17/17.
//  Copyright © 2017 AT. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public enum Currency {
        case USD
        case GBP
        case EUR
        case CAN
    }
    
    public var amount : Int
    public var currency : Currency
    
    /*
    public init(amount : Double, currency : Currency) {
        self.amount = amount
        self.currency = currency
    }
 */
    
    public func convert(_ to: Currency) -> Money {
        switch self.currency {
        case .USD:
            switch to {
            case .GBP:
                return Money(amount: Int(Double(self.amount) * 0.5), currency: .GBP)
            case .EUR:
                return Money(amount: Int(Double(self.amount) * 1.5), currency: .EUR)
            case .CAN:
                return Money(amount: Int(Double(self.amount) * 1.25), currency: .CAN)
            default:
                break
            }
        case .GBP:
            switch to {
            case .USD:
                return Money(amount: self.amount * 2, currency: .USD)
            case .EUR:
                return Money(amount: self.amount * 3, currency: .EUR)
            case .CAN:
                return Money(amount: Int(Double(self.amount) * 2.5), currency: .CAN)
            default:
                break
            }
        case .EUR:
            switch to {
            case .USD:
                return Money(amount: Int(Double(self.amount) * (2.0/3.0)), currency: .USD)
            case .GBP:
                return Money(amount: Int(Double(self.amount) * (1.0/3.0)), currency: .GBP)
            case .CAN:
                return Money(amount: Int(Double(self.amount) * (5.0/6.0)), currency: .CAN)
            default:
                break
            }
        case .CAN:
            switch to {
            case .USD:
                return Money(amount: Int(Double(self.amount) * 0.8), currency: .USD)
            case .GBP:
                return Money(amount: Int(Double(self.amount) * 0.4), currency: .GBP)
            case .EUR:
                return Money(amount: Int(Double(self.amount) * 1.2), currency: .EUR)
            default:
                break
            }
        }
        return Money(amount: self.amount, currency: self.currency)
    }
    
    public func add(_ to: Money) -> Money {
        return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        return Money(amount: from.amount - self.convert(from.currency).amount, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let type):
            return Int(type * Double(hours))
        case .Salary(let type):
            return type
        }
    }
    
    open func raise(_ amt: Double) {
        switch self.type {
        case .Hourly(let x):
            self.type = JobType.Hourly(x + amt)
        case .Salary(let x):
            self.type = JobType.Salary(Int(Double(x) + amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    public init(firstName : String, lastName : String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    fileprivate var _job: Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            if self.age >= 16 {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse: Person? = nil
    open var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if self.age >= 18 {
                self._spouse = value
            }
        }
    }
    
    open func toString() -> String {
        var jobTitle : String
        if job == nil {
            jobTitle = "nil"
        } else {
            jobTitle = job!.title
        }
        var spouseName : String
        if spouse == nil {
            spouseName = "nil"
        } else {
            spouseName = spouse!.firstName
        }
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobTitle) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for person in members {
            if person.age >= 21 {
                members.append(Person(firstName : "", lastName : "", age : 0))
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var total = 0
        for person in members {
            if person.job != nil {
                total += person.job!.calculateIncome(2000)
            }
        }
        return total
    }
}
