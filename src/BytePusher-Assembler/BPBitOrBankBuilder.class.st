Class {
	#name : #BPBitOrBankBuilder,
	#superclass : #BPBankInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #'instance creation' }
BPBitOrBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #BIT_OR_PAGE;
		yourself
]

{ #category : #generating }
BPBitOrBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ x bitOr: y
]
