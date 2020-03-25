Class {
	#name : #BPBitAndBankBuilder,
	#superclass : #BPBankInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPBitAndBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #BIT_AND_PAGE;
		yourself
]

{ #category : #generating }
BPBitAndBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ x bitAnd: y
]
