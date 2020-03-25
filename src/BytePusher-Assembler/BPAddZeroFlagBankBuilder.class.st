Class {
	#name : #BPAddZeroFlagBankBuilder,
	#superclass : #BPBankInitializer,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPAddZeroFlagBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_ZERO_FLAG_PAGE;
		yourself
]

{ #category : #generating }
BPAddZeroFlagBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ (x + y) % 16rFF = 0
		ifTrue: [ FALSE_VALUE ]
		ifFalse: [ TRUE_VALUE ]
]
