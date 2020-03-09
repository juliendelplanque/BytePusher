Class {
	#name : #BPAddCarryFlagPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_CARY_FLAG_PAGE;
		yourself
]

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> startAddress [
	^ 16r50000 asBPAddress
]

{ #category : #generating }
BPAddCarryFlagPageBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ ((x + y) // 16rFF > 0) asBit
]
