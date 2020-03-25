Class {
	#name : #BPAddBankBuilder,
	#superclass : #BPBankInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPAddBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_PAGE;
		yourself
]

{ #category : #generating }
BPAddBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ (x + y) % 16rFF
]
