Class {
	#name : #BPCmpBankBuilder,
	#superclass : #BPBankInitializer,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPCmpBankBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #CMP_PAGE;
		yourself
]

{ #category : #generating }
BPCmpBankBuilder >> byteForAddress: anInteger [
	| x y |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	^ x = y
		ifTrue: [ TRUE_VALUE ]
		ifFalse: [ FALSE_VALUE ]
]
