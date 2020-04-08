"
A BPDataZoneTest is a test class for testing the behavior of BPDataZone
"
Class {
	#name : #BPDataZoneTest,
	#superclass : #TestCase,
	#category : #'BytePusher-Assembler-Tests-Assembler'
}

{ #category : #test }
BPDataZoneTest >> testAdjustedByteArray [
	| dataZone |
	dataZone := BPDataZone new
						byteArray: #[1];
						yourself.
						
	self assert: dataZone adjustedByteArray equals: #[1 0 0 0 0 0 0 0 0]
]

{ #category : #test }
BPDataZoneTest >> testAdjustedByteArray2 [
	| dataZone |
	dataZone := BPDataZone new
						byteArray: #[1 2 3 4 5 6 7 8];
						yourself.
						
	self assert: dataZone adjustedByteArray equals: #[1 2 3 4 5 6 7 8 0]
]

{ #category : #test }
BPDataZoneTest >> testAdjustedByteArray3 [
	| dataZone |
	dataZone := BPDataZone new
						byteArray: #[1 2 3 4 5 6 7 8 9];
						yourself.
						
	self assert: dataZone adjustedByteArray equals: #[1 2 3 4 5 6 7 8 9]
]

{ #category : #test }
BPDataZoneTest >> testAdjustedByteArray4 [
	| dataZone |
	dataZone := BPDataZone new
						byteArray: #[1 2 3 4 5 6 7 8 9 10];
						yourself.
						
	self assert: dataZone adjustedByteArray equals: #[1 2 3 4 5 6 7 8 9 10 0 0 0 0 0 0 0 0]
]
