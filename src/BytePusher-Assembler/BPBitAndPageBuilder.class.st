Class {
	#name : #BPBitAndPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPBitAndPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #BIT_AND_PAGE;
		yourself
]

{ #category : #accessing }
BPBitAndPageBuilder class >> startAddress [
	^ 16r80000 asBPAddress
]

{ #category : #generating }
BPBitAndPageBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ x bitAnd: y
]
