//
//  MatrixExtensions.swift
//  AIPlayground
//
//  Created by Eric Romrell on 3/23/19.
//

import Foundation

extension Array where Element == Array<Int> {
	func dot(vector: Array<Int>) -> Array<Int> {
		var result = Array<Int>(repeating: 0, count: vector.count)
		for (i, row) in self.enumerated() {
			result[i] = zip(row, vector).reduce(0) {
				return $0 + $1.0 * $1.1
			}
		}
		return result
	}
}

extension Array where Element == Int {
	func argmax() -> Int {
		if let max = self.max(), let argmax = firstIndex(of: max) {
			return argmax
		}
		return -1
	}
	
	func distribution(size: Int) -> Array<Int> {
		var playDistribution = Array(repeating: 0, count: size)
		self.forEach {
			playDistribution[$0] += 1
		}
		return playDistribution
	}
}
