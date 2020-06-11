Class {
	#name : #BPAddCarryFlagBankBuilder,
	#superclass : #BPBankInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPAddCarryFlagBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_CARRY_FLAG_PAGE;
		yourself
]

{ #category : #generating }
BPAddCarryFlagBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ ((x + y) // 16rFF > 0) asBit
]
