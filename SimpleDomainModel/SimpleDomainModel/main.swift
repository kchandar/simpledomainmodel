//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
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
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    switch (self.currency, to) {
        case (_, _) where self.currency == to:
            return self
        case ("USD", "GBP"):
            return Money(amount: self.amount / 2, currency: "GBP")
        case ("USD", "EUR"):
            return Money(amount: 3 * (self.amount / 2), currency: "EUR")
        case ("USD", "CAN"):
            return Money(amount: 5 * (self.amount / 4), currency: "CAN")
        case ("GBP", "USD"):
            return Money(amount: self.amount * 2 , currency: "USD")
        case ("GBP", "EUR"):
            return Money(amount: 9 * (self.amount / 8), currency: "EUR")
        case ("GBP", "CAN"):
            return Money(amount: 19 * (self.amount / 11), currency: "CAN")
        case ("EUR", "GBP"):
            return Money(amount: 8 * (self.amount / 9), currency: "GBP")
        case ("EUR", "USD"):
            return Money(amount: 2 * (self.amount / 3), currency: "USD")
        case ("EUR", "CAN"):
            return Money(amount: 3 * (self.amount / 2), currency: "CAN")
        case ("CAN", "GBP"):
            return Money(amount: 11 * (self.amount / 19), currency: "GBP")
        case ("CAN", "EUR"):
            return Money(amount: 2 * (self.amount / 3), currency: "EUR")
        case ("CAN", "USD"):
            return Money(amount: 4 * (self.amount / 5), currency: "USD")
        default:
            fatalError("Not acceptable currency")
    }
  }
  
  public func add(_ to: Money) -> Money {
    let converted = self.convert(to.currency)
    return Money(amount: converted.amount + to.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let converted = self.convert(from.currency)
    return Money(amount: converted.amount - from.amount, currency: from.currency)
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
        case .Hourly(let hourly): return Int(Double(hours) * hourly)
        case .Salary(let yearly): return yearly
    }
  }
  
  open func raise(_ amt : Double) {
        switch self.type {
            case .Hourly(let hourly):
                self.type = JobType.Hourly(hourly + amt)
            case .Salary(let yearly):
                self.type = JobType.Salary(Int(Double(yearly) + amt))
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

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if self.age > 15 {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if self.age > 17 {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title) spouse:\(spouse?.firstName)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    members.append(spouse1)
    members.append(spouse2)
    spouse1._spouse = spouse2
    spouse2._spouse = spouse1
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    return members.reduce(0, { (income, m) -> Int in
        if let total = m._job?.calculateIncome(2000) {
            return total + income
        } else {
            return income
        }
    })
  }
}





