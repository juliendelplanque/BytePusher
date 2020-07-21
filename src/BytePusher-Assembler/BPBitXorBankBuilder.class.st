Class {
	#name : #BPBitXorBankBuilder,
	#superclass : #BPBankInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPBitXorBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #BIT_XOR_PAGE;
		yourself
]

{ #category : #generating }
BPBitXorBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ x bitXor: y
]
