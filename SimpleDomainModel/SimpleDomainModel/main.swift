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
        return Money(amount: self.amount + to.convert(self.currency).amount, currency: self.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        return Money(amount: self.amount - from.convert(self.currency).amount, currency: self.currency)
        //return self.amount - to.convert(self.currency)
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
        case let .Hourly(type):
            return Int(type) * hours
        case let .Salary(type):
            return type
        }
    }
    
    open func raise(_ amt: Double) {
        switch self.type {
        case .Hourly(let x):
            let total = x * (1.0 + amt)
            self.type = JobType.Hourly(total)
        case .Salary(let x):
            let total = Double(x) * (1.0 + amt)
            self.type = JobType.Salary(Int(total))
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
    
    fileprivate var _job: Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            if age >= 16 {
                self.job = value
            }
        }
    }
    
    fileprivate var _spouse: Person? = nil
    open var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if age >= 18 {
                self.spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName : String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        var result : String = "First Name: \(firstName) \nLast Name: \(lastName) \nAge: \(age)"
        if self.job != nil {
            result += "Job: \(job!.title)"
        } else {
            result += "Job: N/A"
        }
        if self.spouse != nil {
            result += "Spouse: \(spouse!.firstName) \(spouse!.lastName)"
        } else {
            result += "Spouse: N/A"
        }
        return result
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
            if let job = person.job {
                switch job.type {
                case .Hourly(let amt):
                    total += Int(amt)
                case .Salary(let amt):
                    total += amt
                }
            }
        }
        return total
    }
}
