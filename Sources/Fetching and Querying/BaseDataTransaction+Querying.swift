//
//  BaseDataTransaction+Querying.swift
//  CoreStore
//
//  Copyright © 2015 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData


// MARK: - DataTransaction

public extension BaseDataTransaction {
    
    /**
     Fetches the `NSManagedObject` instance in the transaction's context from a reference created from a transaction or from a different managed object context.
     
     - parameter object: a reference to the object created/fetched outside the transaction
     - returns: the `NSManagedObject` instance if the object exists in the transaction, or `nil` if not found.
     */
    public func fetchExisting<T: NSManagedObject>(_ object: T) -> T? {
        
        do {
            
            return (try self.context.existingObject(with: object.objectID) as! T)
        }
        catch _ {
            
            return nil
        }
    }
    
    /**
     Fetches the `NSManagedObject` instance in the transaction's context from an `NSManagedObjectID`.
     
     - parameter objectID: the `NSManagedObjectID` for the object
     - returns: the `NSManagedObject` instance if the object exists in the transaction, or `nil` if not found.
     */
    public func fetchExisting<T: NSManagedObject>(_ objectID: NSManagedObjectID) -> T? {
        
        do {
            
            return (try self.context.existingObject(with: objectID) as! T)
        }
        catch _ {
            
            return nil
        }
    }
    
    /**
     Fetches the `NSManagedObject` instances in the transaction's context from references created from a transaction or from a different managed object context.
     
     - parameter objects: an array of `NSManagedObject`s created/fetched outside the transaction
     - returns: the `NSManagedObject` array for objects that exists in the transaction
     */
    public func fetchExisting<T: NSManagedObject, S: Sequence where S.Iterator.Element == T>(_ objects: S) -> [T] {
        
        return objects.flatMap { (try? self.context.existingObject(with: $0.objectID)) as? T }
    }
    
    /**
     Fetches the `NSManagedObject` instances in the transaction's context from a list of `NSManagedObjectID`.
     
     - parameter objectIDs: the `NSManagedObjectID` array for the objects
     - returns: the `NSManagedObject` array for objects that exists in the transaction
     */
    public func fetchExisting<T: NSManagedObject, S: Sequence where S.Iterator.Element == NSManagedObjectID>(_ objectIDs: S) -> [T] {
        
        return objectIDs.flatMap { (try? self.context.existingObject(with: $0)) as? T }
    }
    
    /**
     Fetches the first `NSManagedObject` instance that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the first `NSManagedObject` instance that satisfies the specified `FetchClause`s
     */
    public func fetchOne<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: FetchClause...) -> T? {
        
        return self.fetchOne(from, fetchClauses)
    }
    
    /**
     Fetches the first `NSManagedObject` instance that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the first `NSManagedObject` instance that satisfies the specified `FetchClause`s
     */
    public func fetchOne<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: [FetchClause]) -> T? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to fetch from a \(cs_typeName(self)) outside its designated queue."
        )
        return self.context.fetchOne(from, fetchClauses)
    }
    
    /**
     Fetches all `NSManagedObject` instances that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: all `NSManagedObject` instances that satisfy the specified `FetchClause`s
     */
    public func fetchAll<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: FetchClause...) -> [T]? {
        
        return self.fetchAll(from, fetchClauses)
    }
    
    /**
     Fetches all `NSManagedObject` instances that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: all `NSManagedObject` instances that satisfy the specified `FetchClause`s
     */
    public func fetchAll<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: [FetchClause]) -> [T]? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to fetch from a \(cs_typeName(self)) outside its designated queue."
        )
        return self.context.fetchAll(from, fetchClauses)
    }
    
    /**
     Fetches the number of `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the number `NSManagedObject`s that satisfy the specified `FetchClause`s
     */
    public func fetchCount<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: FetchClause...) -> Int? {
        
        return self.fetchCount(from, fetchClauses)
    }
    
    /**
     Fetches the number of `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the number `NSManagedObject`s that satisfy the specified `FetchClause`s
     */
    public func fetchCount<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: [FetchClause]) -> Int? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to fetch from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.fetchCount(from, fetchClauses)
    }
    
    /**
     Fetches the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s
     */
    public func fetchObjectID<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: FetchClause...) -> NSManagedObjectID? {
        
        return self.fetchObjectID(from, fetchClauses)
    }
    
    /**
     Fetches the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s
     */
    public func fetchObjectID<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: [FetchClause]) -> NSManagedObjectID? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to fetch from a \(cs_typeName(self)) outside its designated queue."
        )
        return self.context.fetchObjectID(from, fetchClauses)
    }
    
    /**
     Fetches the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s
     */
    public func fetchObjectIDs<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: FetchClause...) -> [NSManagedObjectID]? {
        
        return self.fetchObjectIDs(from, fetchClauses)
    }
    
    /**
     Fetches the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s
     */
    public func fetchObjectIDs<T: NSManagedObject>(_ from: From<T>, _ fetchClauses: [FetchClause]) -> [NSManagedObjectID]? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to fetch from a \(cs_typeName(self)) outside its designated queue."
        )
        return self.context.fetchObjectIDs(from, fetchClauses)
    }
    
    /**
     Deletes all `NSManagedObject`s that satisfy the specified `DeleteClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter deleteClauses: a series of `DeleteClause` instances for the delete request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the number of `NSManagedObject`s deleted
     */
    @discardableResult
    public func deleteAll<T: NSManagedObject>(_ from: From<T>, _ deleteClauses: DeleteClause...) -> Int? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to delete from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.deleteAll(from, deleteClauses)
    }
    
    /**
     Deletes all `NSManagedObject`s that satisfy the specified `DeleteClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter deleteClauses: a series of `DeleteClause` instances for the delete request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: the number of `NSManagedObject`s deleted
     */
    @discardableResult
    public func deleteAll<T: NSManagedObject>(_ from: From<T>, _ deleteClauses: [DeleteClause]) -> Int? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to delete from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.deleteAll(from, deleteClauses)
    }
    
    /**
     Queries aggregate values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     
     A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
     - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
     */
    public func queryValue<T: NSManagedObject, U: SelectValueResultType>(_ from: From<T>, _ selectClause: Select<U>, _ queryClauses: QueryClause...) -> U? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to query from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.queryValue(from, selectClause, queryClauses)
    }
    
    /**
     Queries aggregate values or aggregates as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     
     A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
     - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
     */
    public func queryValue<T: NSManagedObject, U: SelectValueResultType>(_ from: From<T>, _ selectClause: Select<U>, _ queryClauses: [QueryClause]) -> U? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to query from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.queryValue(from, selectClause, queryClauses)
    }
    
    /**
     Queries a dictionary of attribute values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     
     A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
     - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
     */
    public func queryAttributes<T: NSManagedObject>(_ from: From<T>, _ selectClause: Select<NSDictionary>, _ queryClauses: QueryClause...) -> [[NSString: AnyObject]]? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to query from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.queryAttributes(from, selectClause, queryClauses)
    }
    
    /**
     Queries a dictionary of attribute values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     
     A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
     - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
     - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
     */
    public func queryAttributes<T: NSManagedObject>(_ from: From<T>, _ selectClause: Select<NSDictionary>, _ queryClauses: [QueryClause]) -> [[NSString: AnyObject]]? {
        
        CoreStore.assert(
            self.isRunningInAllowedQueue(),
            "Attempted to query from a \(cs_typeName(self)) outside its designated queue."
        )
        
        return self.context.queryAttributes(from, selectClause, queryClauses)
    }
}
