//
//  TripleLevel.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/24/16.
//  Copyright © 2016 BinaryBastards. All rights reserved.
//

import Foundation

let NumColumns  = 9
let NumRows     = 9
let NumLevels   = 4

class Level {

    private var drinks = Array2D<Drink>(columns: NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    private var possibleSwaps   = Set<Swap>()
    var targetScore             = 0
    var maximumMoves            = 0
    private var comboMultiplier = 0

    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) else { return }
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        for (row, rowArray) in tilesArray.enumerate() {
            let tileRow = NumRows - row - 1
            for (column, value) in rowArray.enumerate() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
        targetScore = dictionary["targetScore"] as! Int
        maximumMoves = dictionary["moves"] as! Int
    }

    func shuffle() -> Set<Drink> {
        var set: Set<Drink>
        repeat {
            set = createInitialDrinks()
            detectPossibleSwaps()
        } while possibleSwaps.count == 0
        return set
    }

    private func createInitialDrinks() -> Set<Drink> {
        var set = Set<Drink>()
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tiles[column, row] != nil {
                    var drinkType: DrinkType
                    repeat {
                        drinkType = DrinkType.random()
                    } while
                        (column >= 2 &&
                            drinks[column - 1, row]?.drinkType == drinkType &&
                            drinks[column - 2, row]?.drinkType == drinkType) ||
                            (row >= 2 &&
                                drinks[column, row - 1]?.drinkType == drinkType &&
                                drinks[column, row - 2]?.drinkType == drinkType)
                    let drink = Drink(column: column, row: row, drinkType: drinkType)
                    drinks[column, row] = drink
                    set.insert(drink)
                }
            }
        }
        return set
    }

    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }

    func drinkAtColumn(column: Int, row: Int) -> Drink? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return drinks[column, row]
    }

    func isPossibleSwap(swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }

    private func hasChainAtColumn(column: Int, row: Int) -> Bool {
        let drinkType = drinks[column, row]!.drinkType
        var horzLength = 1
        var i = column - 1
        while i >= 0 && drinks[i, row]?.drinkType == drinkType {
            i -= 1
            horzLength += 1
        }
        i = column + 1
        while i < NumColumns && drinks[i, row]?.drinkType == drinkType {
            i += 1
            horzLength += 1
        }
        if horzLength >= 3 { return true }
        var vertLength = 1
        i = row - 1
        while i >= 0 && drinks[column, i]?.drinkType == drinkType {
            i -= 1
            vertLength += 1
        }
        i = row + 1
        while i < NumRows && drinks[column, i]?.drinkType == drinkType {
            i += 1
            vertLength += 1
        }
        return vertLength >= 3
    }

    func performSwap(swap: Swap) {
        let columnA = swap.drinkA.column
        let rowA = swap.drinkA.row
        let columnB = swap.drinkB.column
        let rowB = swap.drinkB.row
        drinks[columnA, rowA] = swap.drinkB
        swap.drinkB.column = columnA
        swap.drinkB.row = rowA
        drinks[columnB, rowB] = swap.drinkA
        swap.drinkA.column = columnB
        swap.drinkA.row = rowB
    }

    func detectPossibleSwaps() {
        var set = Set<Swap>()
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let drink = drinks[column, row] {
                    if column < NumColumns - 1 {
                        if let other = drinks[column + 1, row] {
                            drinks[column, row] = other
                            drinks[column + 1, row] = drink
                            if hasChainAtColumn(column + 1, row: row) ||
                                hasChainAtColumn(column, row: row) {
                                set.insert(Swap(drinkA: drink, drinkB: other))
                            }
                            drinks[column, row] = drink
                            drinks[column + 1, row] = other
                        }
                    }
                    if row < NumRows - 1 {
                        if let other = drinks[column, row + 1] {
                            drinks[column, row] = other
                            drinks[column, row + 1] = drink
                            if hasChainAtColumn(column, row: row + 1) ||
                                hasChainAtColumn(column, row: row) {
                                set.insert(Swap(drinkA: drink, drinkB: other))
                            }
                            drinks[column, row] = drink
                            drinks[column, row + 1] = other
                        }
                    }
                }
            }
        }
        possibleSwaps = set
    }

    private func calculateScores(chains: Set<Chain>) {
        for chain in chains {
            chain.score = 60 * (chain.length - 2) * comboMultiplier
            comboMultiplier += 1
        }
    }

    func resetComboMultiplier() {
        comboMultiplier = 1
    }

    private func detectHorizontalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        for row in 0..<NumRows {
            var column = 0
            while column < NumColumns-2 {
                if let drink = drinks[column, row] {
                    let matchType = drink.drinkType
                    if drinks[column + 1, row]?.drinkType == matchType &&
                        drinks[column + 2, row]?.drinkType == matchType {
                        let chain = Chain(chainType: .Horizontal)
                        repeat {
                            chain.addDrink(drinks[column, row]!)
                            column += 1
                        } while column < NumColumns && drinks[column, row]?.drinkType == matchType
                        set.insert(chain)
                        continue
                    }
                }
                column += 1
            }
        }
        return set
    }

    private func detectVerticalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        for column in 0..<NumColumns {
            var row = 0
            while row < NumRows-2 {
                if let drink = drinks[column, row] {
                    let matchType = drink.drinkType
                    if drinks[column, row + 1]?.drinkType == matchType &&
                        drinks[column, row + 2]?.drinkType == matchType {
                        let chain = Chain(chainType: .Vertical)
                        repeat {
                            chain.addDrink(drinks[column, row]!)
                            row += 1
                        } while row < NumRows && drinks[column, row]?.drinkType == matchType
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }

    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        removeDrinks(horizontalChains)
        removeDrinks(verticalChains)
        calculateScores(horizontalChains)
        calculateScores(verticalChains)
        return horizontalChains.union(verticalChains)
    }

    private func removeDrinks(chains: Set<Chain>) {
        for chain in chains {
            for drink in chain.drinks {
                drinks[drink.column, drink.row] = nil
            }
        }
    }

    func fillHoles() -> [[Drink]] {
        var columns = [[Drink]]()
        for column in 0..<NumColumns {
            var array = [Drink]()
            for row in 0..<NumRows {
                if tiles[column, row] != nil && drinks[column, row] == nil {
                    for lookup in (row + 1)..<NumRows {
                        if let drink = drinks[column, lookup] {
                            drinks[column, lookup] = nil
                            drinks[column, row] = drink
                            drink.row = row
                            array.append(drink)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }

    func topUpDrinks() -> [[Drink]] {
        var columns = [[Drink]]()
        var drinkType: DrinkType = .Unknown
        for column in 0..<NumColumns {
            var array = [Drink]()
            var row = NumRows - 1
            while row >= 0 && drinks[column, row] == nil {
                if tiles[column, row] != nil {
                    var newDrinkType: DrinkType
                    repeat {
                        newDrinkType = DrinkType.random()
                    } while newDrinkType == drinkType
                    drinkType = newDrinkType
                    let drink = Drink(column: column, row: row, drinkType: drinkType)
                    drinks[column, row] = drink
                    array.append(drink)
                }
                row -= 1
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
}